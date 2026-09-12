import { db } from "./firebase-config.js";

import {
  collection,
  doc,
  addDoc,
  updateDoc,
  onSnapshot,
  query,
  where,
  orderBy,
  limit,
  runTransaction,
  serverTimestamp,
  getDoc
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

import { driverCommission } from "./wallet.js";

export const ORDER_STATUSES = {
  PENDING: "pending",
  ACCEPTED: "accepted",
  PICKED_UP: "picked_up",
  DELIVERING: "delivering",
  AWAITING_CONFIRMATION: "awaiting_confirmation",
  NOT_DELIVERED: "not_delivered",
  COMPLETED: "completed",
  CANCELLED: "cancelled",
  REJECTED: "rejected"
};

export const PASSENGER_VEHICLES = [
  "car", "rickshaw", "bus", "amjad", "taxi", "limousine"
];

export const CARGO_VEHICLES = [
  "motorcycle", "tuk_tuk", "truck", "kreez", "tanker", "crane", "tow_truck", "lorry"
];

export function driverNet(deliveryFee) {
  const fee = Number(deliveryFee || 0);
  return Math.max(0, fee - driverCommission(fee));
}

export function driverCancellationPenalty(deliveryFee) {
  const fee = Number(deliveryFee || 0);
  return Number.isFinite(fee) && fee > 0 ? Math.round(fee * 0.10) : 0;
}

function cleanText(value, label, max = 1000) {
  const text = String(value ?? "").trim();
  if (!text) throw new Error(`${label} مطلوب`);
  if (text.length > max) throw new Error(`${label} طويل جدًا`);
  return text;
}

export async function createOrder(
  customerId,
  {
    vehicleType,
    passengerCount,
    hasLuggage,
    luggageDescription,
    cargoType,
    cargoDescription,
    description,
    origin,
    destination
  }
) {
  if (!customerId) throw new Error("حساب العميل غير صحيح");

  const vehicle = cleanText(vehicleType, "نوع المركبة", 40);
  const cleanOrigin = cleanText(origin, "مكان الاستلام", 250);
  const cleanDestination = cleanText(destination, "مكان التسليم", 250);
  const cleanDescription = String(description || "").trim().slice(0, 1000);

  if (cleanOrigin === cleanDestination) {
    throw new Error("مكان الاستلام والوجهة يجب أن يكونا مختلفين");
  }

  const passengerVehicle = PASSENGER_VEHICLES.includes(vehicle);
  const cargoVehicle = CARGO_VEHICLES.includes(vehicle);

  if (!passengerVehicle && !cargoVehicle) {
    throw new Error("نوع المركبة غير صحيح");
  }

  let cleanPassengerCount = null;
  let cleanHasLuggage = null;
  let cleanLuggageDescription = null;
  let cleanCargoType = null;
  let cleanCargoDescription = null;

  if (passengerVehicle) {
    cleanPassengerCount = Number(passengerCount);
    if (!Number.isInteger(cleanPassengerCount) || cleanPassengerCount < 1 || cleanPassengerCount > 100) {
      throw new Error("عدد الركاب يجب أن يكون بين 1 و100");
    }

    cleanHasLuggage = Boolean(hasLuggage);

    if (cleanHasLuggage) {
      cleanLuggageDescription = cleanText(luggageDescription, "وصف الأمتعة", 500);
    }
  } else {
    cleanCargoType = cleanText(cargoType, "نوع البضاعة", 120);
    cleanCargoDescription = cleanText(cargoDescription, "وصف البضاعة", 1000);
  }

  const customerSnap = await getDoc(doc(db, "users", customerId));
  if (!customerSnap.exists()) throw new Error("حساب العميل غير موجود");
  const customer = customerSnap.data();

  if (customer.role !== "customer" || customer.status !== "active") {
    throw new Error("حساب العميل غير نشط");
  }
  if (!customer.state) throw new Error("الولاية غير محددة في حسابك");

  const ref = await addDoc(collection(db, "orders"), {
    customerId,
    driverId: null,

    state: customer.state,

    vehicleType: vehicle,
    serviceCategory: passengerVehicle ? "passenger" : "cargo",

    passengerCount: cleanPassengerCount,
    hasLuggage: cleanHasLuggage,
    luggageDescription: cleanLuggageDescription,

    cargoType: cleanCargoType,
    cargoDescription: cleanCargoDescription,

    description: cleanDescription,

    origin: cleanOrigin,
    destination: cleanDestination,

    deliveryFee: null,
    agreedFee: null,

    status: ORDER_STATUSES.PENDING,
    negotiationStatus: "none",

    commissionCharged: false,
    cancellationPenaltyCharged: false,

    createdAt: serverTimestamp(),
    acceptedAt: null,
    pickedUpAt: null,
    startedAt: null,
    deliveredAt: null,
    customerConfirmedAt: null,
    notDeliveredAt: null,
    driverConfirmedAt: null,
    completedAt: null,
    cancelledAt: null,
    agreedAt: null,
    agreedBy: null,

    cancelReason: null,
    driverComment: null
  });

  return ref.id;
}

export function listenAvailableOrders(state, callback) {
  const cleanState = String(state || "").trim();
  if (!cleanState) {
    callback([]);
    return () => {};
  }

  const q = query(
    collection(db, "orders"),
    where("state", "==", cleanState),
    where("status", "==", ORDER_STATUSES.PENDING),
    where("driverId", "==", null),
    orderBy("createdAt", "desc")
  );

  return onSnapshot(q, (snap) => {
    callback(snap.docs.map((d) => ({ id: d.id, ...d.data() })));
  });
}

export function listenMyOrders(role, uid, callback) {
  const field = role === "driver" ? "driverId" : "customerId";
  const q = query(
    collection(db, "orders"),
    where(field, "==", uid),
    orderBy("createdAt", "desc")
  );

  return onSnapshot(q, (snap) => {
    callback(snap.docs.map((d) => ({ id: d.id, ...d.data() })));
  });
}

export function listenAllOrders(callback, max = 200) {
  const q = query(
    collection(db, "orders"),
    orderBy("createdAt", "desc"),
    limit(max)
  );

  return onSnapshot(q, (snap) => {
    callback(snap.docs.map((d) => ({ id: d.id, ...d.data() })));
  });
}

export async function acceptOrder(orderId, driverId) {
  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const negotiationRef = doc(db, "priceNegotiations", orderId);

    const orderSnap = await tx.get(orderRef);
    if (!orderSnap.exists()) throw new Error("الطلب غير موجود");

    const order = orderSnap.data();

    if (
      order.status !== ORDER_STATUSES.PENDING ||
      order.driverId !== null
    ) {
      throw new Error("تم قبول هذا الطلب من سائق آخر");
    }

    if (!order.state) throw new Error("الولاية غير موجودة في الطلب");

    const driverSnap = await tx.get(doc(db, "users", driverId));
    if (!driverSnap.exists()) throw new Error("حساب السائق غير موجود");

    const driver = driverSnap.data();
    if (
      driver.role !== "driver" ||
      driver.status !== "active" ||
      driver.state !== order.state
    ) {
      throw new Error("لا يمكنك قبول طلب خارج ولايتك");
    }

    const walletRef = doc(db, "wallets", driverId);
    const walletSnap = await tx.get(walletRef);

    if (!walletSnap.exists()) {
      throw new Error("محفظتك غير مهيأة. اشحن رصيدك أولًا ثم حاول قبول الطلب.");
    }

    const walletBalance = Number(walletSnap.data()?.balance || 0);

    if (walletBalance <= 0) {
      throw new Error("رصيدك صفر حاليًا 😊 اشحن المحفظة قليلًا ثم ارجع لنا، والطلبات تنتظرك.");
    }

    tx.update(orderRef, {
      driverId,
      status: ORDER_STATUSES.ACCEPTED,
      acceptedAt: serverTimestamp(),
      negotiationStatus: "open"
    });

    tx.set(negotiationRef, {
      orderId,
      customerId: order.customerId,
      driverId,
      customerName: null,
      driverName: driver.name || "السائق",
      currentOffer: null,
      offeredBy: null,
      status: "open",
      expiresAt: null,
      updatedAt: serverTimestamp(),
      lastAction: "accepted",
      lastMessageId: null
    });
  });
}

export async function pickupOrder(orderId) {
  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const snap = await tx.get(orderRef);
    if (!snap.exists()) throw new Error("الطلب غير موجود");
    const order = snap.data();

    if (
      order.negotiationStatus !== "agreed" ||
      !Number(order.agreedFee || 0)
    ) {
      throw new Error("لا يمكن استلام الطلب قبل الاتفاق على السعر");
    }

    tx.update(orderRef, {
      status: ORDER_STATUSES.PICKED_UP,
      pickedUpAt: serverTimestamp()
    });
  });
}

export async function startDelivering(orderId) {
  await updateDoc(doc(db, "orders", orderId), {
    status: ORDER_STATUSES.DELIVERING,
    startedAt: serverTimestamp()
  });
}

export async function markDelivered(orderId) {
  await updateDoc(doc(db, "orders", orderId), {
    status: ORDER_STATUSES.AWAITING_CONFIRMATION,
    deliveredAt: serverTimestamp()
  });
}

export async function customerConfirmDelivery(orderId) {
  await updateDoc(doc(db, "orders", orderId), {
    customerConfirmedAt: serverTimestamp()
  });
}

export async function customerReportNotDelivered(orderId, customerId) {
  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const snap = await tx.get(orderRef);
    if (!snap.exists()) throw new Error("الطلب غير موجود");

    const order = snap.data();
    if (order.customerId !== customerId) throw new Error("ليس لديك صلاحية لهذا الطلب");
    if (order.status !== ORDER_STATUSES.AWAITING_CONFIRMATION) {
      throw new Error("الطلب ليس في مرحلة تأكيد التوصيل");
    }
    if (order.customerConfirmedAt) throw new Error("تم تأكيد استلام الطلب بالفعل");

    const createdAt = order.createdAt;
    if (!createdAt || typeof createdAt.toMillis !== "function") {
      throw new Error("وقت إنشاء الطلب غير متوفر");
    }

    if (Date.now() - createdAt.toMillis() < 60 * 60 * 1000) {
      throw new Error("يمكنك الإبلاغ عن عدم وصول الطلب بعد مرور ساعة من إنشاء الطلب");
    }

    tx.update(orderRef, {
      status: ORDER_STATUSES.NOT_DELIVERED,
      notDeliveredAt: serverTimestamp()
    });
  });
}

export async function driverFinalizeOrder(orderId, driverId) {
  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const walletRef = doc(db, "wallets", driverId);

    const orderSnap = await tx.get(orderRef);
    if (!orderSnap.exists()) throw new Error("الطلب غير موجود");

    const order = orderSnap.data();

    if (order.driverId !== driverId) throw new Error("هذا الطلب ليس لديك");
    if (order.status !== ORDER_STATUSES.AWAITING_CONFIRMATION) {
      throw new Error("الطلب ليس جاهزًا للإغلاق");
    }
    if (order.negotiationStatus !== "agreed" || !Number(order.deliveryFee || 0)) {
      throw new Error("سعر الطلب المتفق عليه غير موجود");
    }
    if (!order.customerConfirmedAt) throw new Error("بانتظار تأكيد العميل أولًا");
    if (order.commissionCharged === true) throw new Error("تم احتساب عمولة هذا الطلب مسبقًا");

    const walletSnap = await tx.get(walletRef);
    if (!walletSnap.exists()) throw new Error("محفظتك غير مهيأة، تواصل مع الإدارة");

    const wallet = walletSnap.data();
    const commission = driverCommission(order.deliveryFee);
    const balanceBefore = Number(wallet.balance || 0);

    if (balanceBefore < commission) {
      throw new Error("رصيد المحفظة لا يكفي للعمولة");
    }

    const balanceAfter = balanceBefore - commission;

    tx.update(orderRef, {
      status: ORDER_STATUSES.COMPLETED,
      driverConfirmedAt: serverTimestamp(),
      completedAt: serverTimestamp(),
      commissionCharged: true
    });

    tx.update(walletRef, {
      balance: balanceAfter,
      totalCommission: Number(wallet.totalCommission || 0) + commission,
      updatedAt: serverTimestamp(),
      lastCommissionOrderId: orderId
    });

    const txRef = doc(collection(db, "walletTransactions"));
    tx.set(txRef, {
      userId: driverId,
      type: "commission",
      amount: -commission,
      balanceBefore,
      balanceAfter,
      orderId,
      topupRequestId: null,
      withdrawalRequestId: null,
      createdAt: serverTimestamp(),
      createdBy: driverId
    });
  });
}

export async function driverCancelOrder(orderId, driverId, cancelReason) {
  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const walletRef = doc(db, "wallets", driverId);

    const orderSnap = await tx.get(orderRef);
    if (!orderSnap.exists()) throw new Error("الطلب غير موجود");

    const order = orderSnap.data();

    if (order.driverId !== driverId) throw new Error("هذا الطلب ليس لديك");
    if (![ORDER_STATUSES.ACCEPTED, ORDER_STATUSES.PICKED_UP].includes(order.status)) {
      throw new Error("لا يمكن إلغاء الطلب في هذه المرحلة");
    }

    if (order.cancellationPenaltyCharged === true) {
      throw new Error("تم احتساب غرامة الإلغاء مسبقًا");
    }

    const common = {
      status: ORDER_STATUSES.CANCELLED,
      cancelledAt: serverTimestamp(),
      cancelReason: String(cancelReason || "إلغاء بواسطة السائق").slice(0, 300)
    };

    if (order.negotiationStatus !== "agreed") {
      tx.update(orderRef, { ...common, cancellationPenaltyCharged: false });
      return;
    }

    const penalty = driverCancellationPenalty(order.deliveryFee);
    if (penalty <= 0) throw new Error("قيمة غرامة الإلغاء غير صحيحة");

    const walletSnap = await tx.get(walletRef);
    if (!walletSnap.exists()) throw new Error("محفظة السائق غير موجودة");

    const wallet = walletSnap.data();
    const balanceBefore = Number(wallet.balance || 0);
    if (balanceBefore < penalty) throw new Error("رصيد المحفظة لا يكفي لتغطية غرامة الإلغاء");

    const balanceAfter = balanceBefore - penalty;

    tx.update(orderRef, {
      ...common,
      cancellationPenaltyCharged: true
    });

    tx.update(walletRef, {
      balance: balanceAfter,
      totalCancellationPenalties:
        Number(wallet.totalCancellationPenalties || 0) + penalty,
      updatedAt: serverTimestamp(),
      lastCancellationOrderId: orderId
    });

    const transactionRef = doc(collection(db, "walletTransactions"));
    tx.set(transactionRef, {
      userId: driverId,
      type: "cancellation_penalty",
      amount: -penalty,
      balanceBefore,
      balanceAfter,
      orderId,
      topupRequestId: null,
      withdrawalRequestId: null,
      createdAt: serverTimestamp(),
      createdBy: driverId
    });
  });
}

export async function customerCancelOrder(orderId, customerId, cancelReason) {
  const orderRef = doc(db, "orders", orderId);

  await runTransaction(db, async (tx) => {
    const snap = await tx.get(orderRef);

    if (!snap.exists()) {
      throw new Error("الطلب غير موجود.");
    }

    const order = snap.data();

    if (order.customerId !== customerId) {
      throw new Error("لا يمكنك إلغاء هذا الطلب.");
    }

    // Customer cancellation is allowed only at the very beginning:
    // pending + no driver + no negotiation.
    if (
      order.status !== ORDER_STATUSES.PENDING ||
      order.driverId != null ||
      (order.negotiationStatus && order.negotiationStatus !== "none")
    ) {
      throw new Error("لا يمكن إلغاء الطلب بعد بدء التفاوض أو تعيين سائق.");
    }

    const reason = String(cancelReason || "").trim();
    if (!reason) {
      throw new Error("يجب اختيار سبب الإلغاء.");
    }

    tx.update(orderRef, {
      status: ORDER_STATUSES.CANCELLED,
      cancelledAt: serverTimestamp(),
      cancelReason: reason.slice(0, 300),
      cancellationPenaltyCharged: false,
      driverId: null,
      negotiationStatus: "none"
    });
  });
}

export async function cancelOrder(orderId, cancelReason) {
  await updateDoc(doc(db, "orders", orderId), {
    status: ORDER_STATUSES.CANCELLED,
    cancelledAt: serverTimestamp(),
    cancelReason: cancelReason || null
  });
}
