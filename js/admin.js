import { db, firebaseConfig } from "./firebase-config.js";
import {
  initializeApp,
  deleteApp
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-app.js";
import {
  getAuth,
  createUserWithEmailAndPassword,
  signOut
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-auth.js";
import {
  collection,
  doc,
  addDoc,
  getDoc,
  setDoc,
  updateDoc,
  deleteDoc,
  runTransaction,
  onSnapshot,
  query,
  where,
  orderBy,
  serverTimestamp
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";
import { validatePhone, validatePassword } from "./auth.js";

const DRIVER_ACTIVATION_BALANCE = 10000;

export async function writeAuditLog(admin, action, targetType, targetId, metadata = {}) {
  await addDoc(collection(db, "auditLogs"), {
    actorUid: admin.uid,
    actorRole: admin.role,
    action,
    targetType,
    targetId,
    metadata,
    createdAt: serverTimestamp()
  });
}

export function listenUsersByRole(role, callback) {
  const q = query(collection(db, "users"), where("role", "==", role));
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}

// موافقة على حساب معلّق. عند تفعيل سائق لأول مرة تُنشأ محفظته برصيد التفعيل،
// أما إن كانت محفظته موجودة أصلًا (إعادة تفعيل بعد إيقاف) فلا تُصفَّر.
export async function approveUser(admin, targetUser) {
  await updateDoc(doc(db, "users", targetUser.id), { status: "active" });

  if (targetUser.role === "driver") {
    const walletRef = doc(db, "wallets", targetUser.id);
    const existing = await getDoc(walletRef);
    if (!existing.exists()) {
      await setDoc(walletRef, {
        balance: DRIVER_ACTIVATION_BALANCE,
        totalCommission: 0,
        totalTopups: 0,
        totalWithdrawals: 0,
        totalCancellationPenalties: 0,
        updatedAt: serverTimestamp()
      });
    }
  }

  await writeAuditLog(admin, "approve_user", "user", targetUser.id, { role: targetUser.role });
}


// ============================================================
// الحذف المجاني من لوحة الإدارة
// يحذف ملف Firestore والمحفظة فقط.
// لا يحذف Firebase Authentication ولا الطلبات التاريخية.
// ============================================================
export async function deleteUserByAdmin(admin, targetUser) {
  if (!admin?.uid) {
    throw new Error("جلسة الإدارة غير صالحة.");
  }

  if (!targetUser?.id) {
    throw new Error("لم يتم تحديد المستخدم.");
  }

  if (targetUser.id === admin.uid) {
    throw new Error("لا يمكنك حذف حساب الإدارة الحالي.");
  }

  if (targetUser.role === "super_admin") {
    throw new Error("لا يمكن حذف حساب super_admin.");
  }

  if (
    admin.role !== "super_admin" &&
    targetUser.role === "admin"
  ) {
    throw new Error("لا يملك هذا المسؤول صلاحية حذف مدير آخر.");
  }

  await deleteDoc(doc(db, "users", targetUser.id));

  // حذف المحفظة إن وجدت.
  await deleteDoc(doc(db, "wallets", targetUser.id)).catch(() => {});

  await writeAuditLog(admin, "delete_user_firestore_only", "user", targetUser.id, {
    deletedRole: targetUser.role || null,
    deletedName: targetUser.name || null,
    deletedPhone: targetUser.phone || null,
    authenticationDeleted: false,
    ordersDeleted: false
  });

  return {
    success: true,
    uid: targetUser.id
  };
}

// ============================================================
// طلب إجبار المستخدم على تغيير كلمة المرور.
// لا يغيّر Firebase Authentication مباشرة.
// ============================================================
export async function requestPasswordChange(admin, targetUser) {
  if (!admin?.uid) {
    throw new Error("جلسة الإدارة غير صالحة.");
  }

  if (!targetUser?.id) {
    throw new Error("لم يتم تحديد المستخدم.");
  }

  if (targetUser.id === admin.uid) {
    throw new Error("لا يمكن تنفيذ هذا الإجراء على حسابك الحالي.");
  }

  if (targetUser.role === "super_admin") {
    throw new Error("لا يمكن تعديل حساب super_admin.");
  }

  if (
    admin.role !== "super_admin" &&
    targetUser.role === "admin"
  ) {
    throw new Error("لا يملك هذا المسؤول صلاحية تعديل مدير آخر.");
  }

  await updateDoc(doc(db, "users", targetUser.id), {
    mustChangePassword: true,
    passwordChangeRequestedAt: serverTimestamp(),
    passwordChangeRequestedBy: admin.uid
  });

  await writeAuditLog(
    admin,
    "request_password_change",
    "user",
    targetUser.id,
    {
      targetRole: targetUser.role || null,
      targetName: targetUser.name || null
    }
  );

  return { success: true, uid: targetUser.id };
}


// ============================================================
// الحذف المجاني من لوحة الإدارة
// يحذف ملف Firestore والمحفظة فقط.
// لا يحذف Firebase Authentication ولا الطلبات التاريخية.
// ============================================================
export async function deleteUserByAdmin(admin, targetUser) {
  if (!admin?.uid) {
    throw new Error("جلسة الإدارة غير صالحة.");
  }

  if (!targetUser?.id) {
    throw new Error("لم يتم تحديد المستخدم.");
  }

  if (targetUser.id === admin.uid) {
    throw new Error("لا يمكنك حذف حساب الإدارة الحالي.");
  }

  if (targetUser.role === "super_admin") {
    throw new Error("لا يمكن حذف حساب super_admin.");
  }

  if (
    admin.role !== "super_admin" &&
    targetUser.role === "admin"
  ) {
    throw new Error("لا يملك هذا المسؤول صلاحية حذف مدير آخر.");
  }

  await deleteDoc(doc(db, "users", targetUser.id));

  // حذف المحفظة إن وجدت.
  await deleteDoc(doc(db, "wallets", targetUser.id)).catch(() => {});

  await writeAuditLog(admin, "delete_user_firestore_only", "user", targetUser.id, {
    deletedRole: targetUser.role || null,
    deletedName: targetUser.name || null,
    deletedPhone: targetUser.phone || null,
    authenticationDeleted: false,
    ordersDeleted: false
  });

  return {
    success: true,
    uid: targetUser.id
  };
}

// ============================================================
// طلب إجبار المستخدم على تغيير كلمة المرور.
// لا يغيّر Firebase Authentication مباشرة.
// ============================================================
export async function requestPasswordChange(admin, targetUser) {
  if (!admin?.uid) {
    throw new Error("جلسة الإدارة غير صالحة.");
  }

  if (!targetUser?.id) {
    throw new Error("لم يتم تحديد المستخدم.");
  }

  if (targetUser.id === admin.uid) {
    throw new Error("لا يمكن تنفيذ هذا الإجراء على حسابك الحالي.");
  }

  if (targetUser.role === "super_admin") {
    throw new Error("لا يمكن تعديل حساب super_admin.");
  }

  if (
    admin.role !== "super_admin" &&
    targetUser.role === "admin"
  ) {
    throw new Error("لا يملك هذا المسؤول صلاحية تعديل مدير آخر.");
  }

  await updateDoc(doc(db, "users", targetUser.id), {
    mustChangePassword: true,
    passwordChangeRequestedAt: serverTimestamp(),
    passwordChangeRequestedBy: admin.uid
  });

  await writeAuditLog(
    admin,
    "request_password_change",
    "user",
    targetUser.id,
    {
      targetRole: targetUser.role || null,
      targetName: targetUser.name || null
    }
  );

  return { success: true, uid: targetUser.id };
}

export function listenAllTopupRequests(callback) {
  const q = query(collection(db, "topupRequests"), orderBy("submittedAt", "desc"));
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}

export async function reviewTopupRequest(admin, requestId, approve, note) {
  await runTransaction(db, async (tx) => {
    const reqRef = doc(db, "topupRequests", requestId);
    const reqSnap = await tx.get(reqRef);
    if (!reqSnap.exists()) throw new Error("الطلب غير موجود");
    const request = reqSnap.data();
    if (request.status !== "pending") throw new Error("تمت مراجعة هذا الطلب مسبقًا");

    tx.update(reqRef, {
      status: approve ? "approved" : "rejected",
      reviewedAt: serverTimestamp(),
      reviewedBy: admin.uid,
      reviewNote: note || null
    });

    if (approve) {
      const walletRef = doc(db, "wallets", request.driverId);
      const walletSnap = await tx.get(walletRef);
      const wallet = walletSnap.exists() ? walletSnap.data() : { balance: 0, totalTopups: 0 };
      const before = Number(wallet.balance || 0);
      const after = before + Number(request.amount || 0);

      tx.update(walletRef, {
        balance: after,
        totalTopups: Number(wallet.totalTopups || 0) + Number(request.amount || 0),
        updatedAt: serverTimestamp(),
        lastTopupRequestId: requestId
      });

      const txRef = doc(collection(db, "walletTransactions"));
      tx.set(txRef, {
        userId: request.driverId,
        type: "topup",
        amount: request.amount,
        balanceBefore: before,
        balanceAfter: after,
        orderId: null,
        topupRequestId: requestId,
        createdAt: serverTimestamp(),
        createdBy: admin.uid
      });
    }
  });

  await writeAuditLog(admin, `review_topup:${approve ? "approve" : "reject"}`, "topupRequest", requestId, {});
}


// شحن مباشر لمحفظة سائق من لوحة الإدارة.
// يتم تحديث المحفظة وتسجيل الحركة المالية داخل Transaction واحدة.
export async function manualTopupDriver(admin, driverId, amount, note = "") {
  const numericAmount = Number(amount);

  if (!driverId) throw new Error("يجب اختيار السائق");
  if (!Number.isFinite(numericAmount) || numericAmount <= 0) {
    throw new Error("مبلغ الشحن غير صحيح");
  }

  await runTransaction(db, async (tx) => {
    const userRef = doc(db, "users", driverId);
    const walletRef = doc(db, "wallets", driverId);
    const transactionRef = doc(collection(db, "walletTransactions"));

    const userSnap = await tx.get(userRef);
    if (!userSnap.exists()) throw new Error("السائق غير موجود");

    const driver = userSnap.data();
    if (driver.role !== "driver") throw new Error("الحساب المحدد ليس سائقًا");
    if (driver.status !== "active") throw new Error("لا يمكن شحن سائق غير نشط");

    const walletSnap = await tx.get(walletRef);
    if (!walletSnap.exists()) throw new Error("محفظة السائق غير موجودة");

    const wallet = walletSnap.data();
    const before = Number(wallet.balance || 0);
    const after = before + numericAmount;

    tx.update(walletRef, {
      balance: after,
      totalTopups: Number(wallet.totalTopups || 0) + numericAmount,
      updatedAt: serverTimestamp(),
      lastManualTopupId: transactionRef.id
    });

    tx.set(transactionRef, {
      userId: driverId,
      type: "manual_topup",
      amount: numericAmount,
      balanceBefore: before,
      balanceAfter: after,
      orderId: null,
      topupRequestId: null,
      withdrawalRequestId: null,
      manualTopupId: transactionRef.id,
      note: String(note || ""),
      createdAt: serverTimestamp(),
      createdBy: admin.uid
    });
  });

  await writeAuditLog(admin, "manual_topup", "wallet", driverId, {
    amount: numericAmount,
    note: String(note || "")
  });
}

export function listenAllWithdrawalRequests(callback) {
  const q = query(collection(db, "withdrawalRequests"), orderBy("createdAt", "desc"));
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}

export async function reviewWithdrawalRequest(admin, requestId, status) {
  await runTransaction(db, async (tx) => {
    const reqRef = doc(db, "withdrawalRequests", requestId);
    const reqSnap = await tx.get(reqRef);
    if (!reqSnap.exists()) throw new Error("الطلب غير موجود");
    const request = reqSnap.data();
    if (request.status !== "pending") throw new Error("تمت مراجعة هذا الطلب مسبقًا");

    tx.update(reqRef, {
      status,
      reviewedAt: serverTimestamp(),
      reviewedBy: admin.uid
    });

    if (status === "paid") {
      const walletRef = doc(db, "wallets", request.driverId);
      const walletSnap = await tx.get(walletRef);
      const wallet = walletSnap.exists() ? walletSnap.data() : { balance: 0, totalWithdrawals: 0 };
      const before = Number(wallet.balance || 0);
      const amount = Number(request.amount || 0);
      if (before < amount) throw new Error("الرصيد غير كافٍ لتنفيذ السحب");
      const after = before - amount;

      tx.update(walletRef, {
        balance: after,
        totalWithdrawals: Number(wallet.totalWithdrawals || 0) + amount,
        updatedAt: serverTimestamp(),
        lastWithdrawalRequestId: requestId
      });

      const txRef = doc(collection(db, "walletTransactions"));
      tx.set(txRef, {
        userId: request.driverId,
        type: "withdrawal",
        amount: -request.amount,
        balanceBefore: before,
        balanceAfter: after,
        orderId: null,
        topupRequestId: null,
        withdrawalRequestId: requestId,
        createdAt: serverTimestamp(),
        createdBy: admin.uid
      });
    }
  });

  await writeAuditLog(admin, `review_withdrawal:${status}`, "withdrawalRequest", requestId, {});
}

export function listenManagers(callback) {
  const q = query(collection(db, "users"), where("role", "in", ["admin", "super_admin"]));
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}

// إنشاء حساب مدير جديد بواسطة الإدارة العليا، بدون تسجيل خروج الحساب الحالي.
// يُستخدم تطبيق Firebase ثانوي مؤقت فقط لإنشاء حساب الدخول، ثم يُحذف فورًا.
export async function createManager(superAdmin, name, phone, password) {
  if (!validatePhone(phone)) throw new Error("رقم الهاتف يجب أن يكون 10 أرقام فقط");
  if (!validatePassword(password)) throw new Error("كلمة المرور يجب أن تكون 6 أحرف على الأقل");

  const secondaryApp = initializeApp(firebaseConfig, `manager-creation-${Date.now()}`);
  const secondaryAuth = getAuth(secondaryApp);

  try {
    const credential = await createUserWithEmailAndPassword(secondaryAuth, `${phone}@jawan.app`, password);
    const uid = credential.user.uid;
    await signOut(secondaryAuth);

    await setDoc(doc(db, "users", uid), {
      role: "admin",
      name,
      phone,
      address: null,
      status: "active",
      privacyAccepted: true,
      termsAccepted: true,
      createdAt: serverTimestamp(),
      lastActiveAt: serverTimestamp()
    });

    await writeAuditLog(superAdmin, "create_manager", "user", uid, { phone });
    return uid;
  } finally {
    await deleteApp(secondaryApp).catch(() => {});
  }
}

export async function setManagerRole(superAdmin, targetUser, newRole) {
  if (targetUser.id === superAdmin.uid) throw new Error("لا يمكنك تعديل صلاحيتك الخاصة");
  await updateDoc(doc(db, "users", targetUser.id), { role: newRole });
  await writeAuditLog(superAdmin, `set_manager_role:${newRole}`, "user", targetUser.id, {});
}

export async function suspendManager(superAdmin, targetUser) {
  if (targetUser.id === superAdmin.uid) throw new Error("لا يمكنك إيقاف حسابك الخاص");
  await setUserStatus(superAdmin, targetUser, "suspended");
}

// تحليلات مبنية على الطلبات المحمّلة أصلاً في لوحة الإدارة، بدون قراءات إضافية.
export function computeAnalytics(orders, users) {
  const completed = orders.filter((o) => o.status === "completed");
  const byDriver = {};
  const byCustomer = {};
  let totalMinutes = 0;
  let timedOrders = 0;
  const driverActiveDays = {};

  for (const o of completed) {
    if (o.driverId) {
      byDriver[o.driverId] = byDriver[o.driverId] || { count: 0, totalMinutes: 0, timed: 0 };
      byDriver[o.driverId].count += 1;

      if (o.acceptedAt?.toDate && o.completedAt?.toDate) {
        const minutes = (o.completedAt.toDate() - o.acceptedAt.toDate()) / 60000;
        if (minutes >= 0) {
          byDriver[o.driverId].totalMinutes += minutes;
          byDriver[o.driverId].timed += 1;
          totalMinutes += minutes;
          timedOrders += 1;
        }
      }

      if (o.completedAt?.toDate) {
        const day = o.completedAt.toDate().toISOString().slice(0, 10);
        driverActiveDays[o.driverId] = driverActiveDays[o.driverId] || new Set();
        driverActiveDays[o.driverId].add(day);
      }
    }

    if (o.customerId) {
      byCustomer[o.customerId] = byCustomer[o.customerId] || { count: 0, spent: 0 };
      byCustomer[o.customerId].count += 1;
      byCustomer[o.customerId].spent += Number(o.deliveryFee || 0);
    }
  }

  const nameOf = (uid) => users.find((u) => u.id === uid)?.name || "—";

  const topDriverEntry = Object.entries(byDriver).sort((a, b) => b[1].count - a[1].count)[0];
  const fastestDriverEntry = Object.entries(byDriver)
    .filter(([, v]) => v.timed > 0)
    .sort((a, b) => a[1].totalMinutes / a[1].timed - b[1].totalMinutes / b[1].timed)[0];
  const topCustomerByCountEntry = Object.entries(byCustomer).sort((a, b) => b[1].count - a[1].count)[0];
  const topCustomerBySpendEntry = Object.entries(byCustomer).sort((a, b) => b[1].spent - a[1].spent)[0];

  return {
    topDriver: topDriverEntry ? { name: nameOf(topDriverEntry[0]), count: topDriverEntry[1].count } : null,
    fastestDriver: fastestDriverEntry
      ? { name: nameOf(fastestDriverEntry[0]), minutes: Math.round(fastestDriverEntry[1].totalMinutes / fastestDriverEntry[1].timed) }
      : null,
    topCustomerByOrders: topCustomerByCountEntry
      ? { name: nameOf(topCustomerByCountEntry[0]), count: topCustomerByCountEntry[1].count }
      : null,
    topCustomerBySpend: topCustomerBySpendEntry
      ? { name: nameOf(topCustomerBySpendEntry[0]), spent: topCustomerBySpendEntry[1].spent }
      : null,
    avgDeliveryMinutes: timedOrders ? Math.round(totalMinutes / timedOrders) : null,
    driverActiveDays: Object.fromEntries(
      Object.entries(driverActiveDays).map(([uid, days]) => [nameOf(uid), days.size])
    )
  };
}
