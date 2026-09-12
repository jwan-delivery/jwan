const fs = require('fs');
const path = require('path');
const assert = require('assert');

const {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} = require('@firebase/rules-unit-testing');

const {
  doc,
  setDoc,
  updateDoc,
  getDoc,
} = require('firebase/firestore');

const PROJECT_ID = 'jwan-delivery-c930d-72911';
const RULES_PATH = path.resolve(__dirname, '..', 'firestore.rules');

let testEnv;

const USERS = {
  customer: 'test-customer-001',
  driver: 'test-driver-001',
  admin: 'test-admin-001',
};

function ctx(uid) {
  return testEnv.authenticatedContext(uid);
}

function db(uid) {
  return ctx(uid).firestore();
}

async function seed() {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const database = context.firestore();

    await setDoc(doc(database, 'users', USERS.customer), {
      role: 'customer',
      status: 'active',
      name: 'Test Customer',
      phone: '0911111111',
    });

    await setDoc(doc(database, 'users', USERS.driver), {
      role: 'driver',
      status: 'active',
      name: 'Test Driver',
      phone: '0922222222',
    });

    await setDoc(doc(database, 'users', USERS.admin), {
      role: 'admin',
      status: 'active',
      name: 'Test Admin',
      phone: '0933333333',
    });

    await setDoc(doc(database, 'wallets', USERS.driver), {
      balance: 10000,
      totalCommission: 0,
      totalPenalties: 0,
      updatedAt: new Date(),
    });
  });
}

describe('JWΑN Firestore Security Rules', function () {
  this.timeout(30000);

  before(async () => {
    testEnv = await initializeTestEnvironment({
      projectId: PROJECT_ID,
      firestore: {
        rules: fs.readFileSync(RULES_PATH, 'utf8'),
        host: '127.0.0.1',
        port: 8080,
      },
    });

    await seed();
  });

  after(async () => {
    if (testEnv) {
      await testEnv.cleanup();
    }
  });

  it('1. driver cannot directly change wallet balance', async () => {
    const driverDb = db(USERS.driver);
    const wallet = doc(driverDb, 'wallets', USERS.driver);

    await assertFails(
      updateDoc(wallet, {
        balance: 999999,
      })
    );
  });

  it('2. customer cannot create notifications', async () => {
    const customerDb = db(USERS.customer);

    await assertFails(
      setDoc(doc(customerDb, 'notifications', 'test-notification'), {
        userId: USERS.customer,
        title: 'Fake notification',
        body: 'Should fail',
      })
    );
  });

  it('3. driver cannot create audit logs', async () => {
    const driverDb = db(USERS.driver);

    await assertFails(
      setDoc(doc(driverDb, 'auditLogs', 'fake-log'), {
        actorUid: USERS.driver,
        actorRole: 'driver',
        action: 'fake',
        createdAt: new Date(),
      })
    );
  });

  it('4. customer cannot write settings', async () => {
    const customerDb = db(USERS.customer);

    await assertFails(
      setDoc(doc(customerDb, 'settings', 'test'), {
        anything: 'malicious',
      })
    );
  });

  it('5. driver cannot approve their own topup request', async () => {
    const driverDb = db(USERS.driver);
    const request = doc(driverDb, 'topupRequests', 'topup-test');

    await setDoc(request, {
      driverId: USERS.driver,
      amount: 5000,
      paymentMethod: 'بنكك',
      status: 'pending',
      submittedAt: new Date(),
    });

    await assertFails(
      updateDoc(request, {
        status: 'approved',
        reviewedBy: USERS.driver,
      })
    );
  });

  it('7. customer cannot directly change delivery fee on an order', async () => {
    const adminDb = db(USERS.admin);
    const customerDb = db(USERS.customer);

    const order = doc(adminDb, 'orders', 'security-order-001');

    await setDoc(order, {
      customerId: USERS.customer,
      driverId: null,
      status: 'pending',
      state: 'Khartoum',
      category: 'package',
      vehicleType: 'car',
      passengerCount: 1,
      cargoDescription: 'security test',
      deliveryFee: null,
      commission: 0,
      commissionCharged: false,
      cancellationPenalty: 0,
      cancellationPenaltyCharged: false,
      createdAt: new Date(),
    });

    await assertRejects(
      updateDoc(doc(customerDb, 'orders', 'security-order-001'), {
        deliveryFee: 999999
      })
    );
  });

  it('8. driver cannot change the agreed delivery fee directly', async () => {
    const adminDb = db(USERS.admin);
    const driverDb = db(USERS.driver);

    const order = doc(adminDb, 'orders', 'security-order-002');

    await setDoc(order, {
      customerId: USERS.customer,
      driverId: USERS.driver,
      status: 'accepted',
      state: 'Khartoum',
      category: 'package',
      vehicleType: 'car',
      passengerCount: 1,
      cargoDescription: 'security test',
      deliveryFee: 5000,
      commission: 250,
      commissionCharged: false,
      cancellationPenalty: 0,
      cancellationPenaltyCharged: false,
      createdAt: new Date(),
    });

    await assertRejects(
      updateDoc(doc(driverDb, 'orders', 'security-order-002'), {
        deliveryFee: 1
      })
    );
  });

  it('9. driver cannot forge commission transaction balanceBefore', async () => {
    const driverDb = db(USERS.driver);

    await assertRejects(
      setDoc(doc(driverDb, 'walletTransactions', 'security-fake-commission-001'), {
        driverId: USERS.driver,
        userId: USERS.driver,
        walletId: USERS.driver,
        type: 'commission',
        amount: -250,
        balanceBefore: 999999,
        balanceAfter: 9750,
        orderId: 'nonexistent-order',
        createdAt: new Date(),
      })
    );
  });

  it('10. driver cannot forge commission transaction balanceAfter', async () => {
    const driverDb = db(USERS.driver);

    await assertRejects(
      setDoc(doc(driverDb, 'walletTransactions', 'security-fake-commission-002'), {
        driverId: USERS.driver,
        userId: USERS.driver,
        walletId: USERS.driver,
        type: 'commission',
        amount: -250,
        balanceBefore: 10000,
        balanceAfter: 1,
        orderId: 'nonexistent-order',
        createdAt: new Date(),
      })
    );
  });

  it('11. driver cannot create a topup transaction without an approved request', async () => {
    const driverDb = db(USERS.driver);

    await assertRejects(
      setDoc(doc(driverDb, 'walletTransactions', 'security-fake-topup-002'), {
        driverId: USERS.driver,
        userId: USERS.driver,
        walletId: USERS.driver,
        type: 'topup',
        amount: 5000,
        balanceBefore: 10000,
        balanceAfter: 15000,
        topupRequestId: 'missing-topup-request',
        createdAt: new Date(),
      })
    );
  });

  it('12. driver cannot create a withdrawal transaction by itself', async () => {
    const driverDb = db(USERS.driver);

    await assertRejects(
      setDoc(doc(driverDb, 'walletTransactions', 'security-fake-withdrawal-001'), {
        driverId: USERS.driver,
        userId: USERS.driver,
        walletId: USERS.driver,
        type: 'withdrawal',
        amount: -5000,
        balanceBefore: 10000,
        balanceAfter: 5000,
        withdrawalRequestId: 'missing-withdrawal-request',
        createdAt: new Date(),
      })
    );
  });


  it('6. driver cannot create a fake generic topup wallet transaction', async () => {
    const driverDb = db(USERS.driver);

    await assertFails(
      setDoc(doc(driverDb, 'walletTransactions', 'fake-topup'), {
        driverId: USERS.driver,
        userId: USERS.driver,
        type: 'topup',
        amount: 999999,
        balanceBefore: 10000,
        balanceAfter: 1000999,
        createdAt: new Date(),
      })
    );
  });
});
