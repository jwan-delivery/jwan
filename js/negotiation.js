import { db } from "./firebase-config.js";
import {
  collection,
  doc,
  getDoc,
  onSnapshot,
  query,
  orderBy,
  runTransaction,
  serverTimestamp,
  Timestamp
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

export const NEGOTIATION_MINUTES = 30;
export const NEGOTIATION_DURATION_MS = NEGOTIATION_MINUTES * 60 * 1000;
export const MAX_NEGOTIATION_AMOUNT = 100000000;

function cleanAmount(value) {
  const n = Math.round(Number(value));
  if (!Number.isFinite(n) || n <= 0) throw new Error("أدخل مبلغًا صحيحًا.");
  if (n > MAX_NEGOTIATION_AMOUNT) throw new Error("المبلغ كبير جدًا.");
  return n;
}

function isParticipant(order, uid, role) {
  return role === "customer"
    ? order.customerId === uid
    : order.driverId === uid;
}

function toMillis(value) {
  if (!value) return 0;
  if (typeof value.toMillis === "function") return value.toMillis();
  const d = value instanceof Date ? value : new Date(value);
  return Number.isFinite(d.getTime()) ? d.getTime() : 0;
}

function checkOpen(order, negotiation, uid, role) {
  if (!order || order.status !== "accepted") {
    throw new Error("التفاوض متاح بعد قبول السائق وقبل بدء التوصيل فقط.");
  }
  if (!isParticipant(order, uid, role)) {
    throw new Error("ليس لديك صلاحية على هذا الطلب.");
  }
  if (!negotiation || negotiation.status !== "open") {
    throw new Error("لا توجد مفاوضة مفتوحة لهذا الطلب.");
  }
  if (negotiation.expiresAt && toMillis(negotiation.expiresAt) <= Date.now()) {
    throw new Error("انتهت مدة التفاوض.");
  }
}

export function listenNegotiation(orderId, callback) {
  const negotiationRef = doc(db, "priceNegotiations", orderId);
  const messagesRef = collection(db, "priceNegotiations", orderId, "messages");
  const messagesQuery = query(messagesRef, orderBy("createdAt", "asc"));
  let state = { negotiation: null, messages: [] };

  const emit = () => callback({ ...state });

  const unsubNegotiation = onSnapshot(negotiationRef, (snap) => {
    state = {
      ...state,
      negotiation: snap.exists() ? snap.data() : null
    };
    emit();
  });

  const unsubMessages = onSnapshot(messagesQuery, (snap) => {
    state = {
      ...state,
      messages: snap.docs.map((d) => ({ id: d.id, ...d.data() }))
    };
    emit();
  });

  return () => {
    unsubNegotiation();
    unsubMessages();
  };
}

export async function startNegotiation({ orderId, userId, role, name, amount }) {
  if (role !== "customer") {
    throw new Error("العرض الأول يرسله العميل فقط.");
  }
  const value = cleanAmount(amount);

  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const negRef = doc(db, "priceNegotiations", orderId);
    const orderSnap = await tx.get(orderRef);
    if (!orderSnap.exists()) throw new Error("الطلب غير موجود.");

    const order = orderSnap.data();

    if (
      order.status !== "accepted" ||
      !isParticipant(order, userId, role) ||
      (order.negotiationStatus || "none") === "agreed"
    ) {
      throw new Error("التفاوض غير متاح في هذه المرحلة.");
    }

    const negSnap = await tx.get(negRef);
    if (!negSnap.exists()) {
      throw new Error("محادثة التفاوض غير مهيأة.");
    }

    const neg = negSnap.data();
    if (neg.status !== "open") throw new Error("لا توجد مفاوضة مفتوحة.");
    if (neg.currentOffer != null) {
      throw new Error("يوجد عرض حالي بالفعل؛ يمكنك قبوله أو رفضه أو تقديم عرض مقابل.");
    }

    const expiresAt = Timestamp.fromMillis(
      Date.now() + NEGOTIATION_DURATION_MS
    );
    const messageRef = doc(collection(negRef, "messages"));
    const messageId = messageRef.id;

    const patch = {
      currentOffer: value,
      offeredBy: userId,
      expiresAt,
      updatedAt: serverTimestamp(),
      lastAction: "offer",
      lastMessageId: messageId
    };

    if (role === "customer") {
      patch.customerName = String(name || "العميل").slice(0, 120);
    }

    const customerOffers = Number(neg.customerOffers || 0);
    const driverOffers = Number(neg.driverOffers || 0);
    if (customerOffers >= 4) {
      throw new Error("وصل العميل إلى الحد الأقصى من 4 عروض.");
    }
    patch.customerOffers = customerOffers + 1;
    patch.driverOffers = driverOffers;

    tx.update(negRef, patch);
    tx.set(messageRef, {
      orderId,
      amount: value,
      action: "offer",
      senderId: userId,
      senderRole: role,
      senderName: String(name || (role === "driver" ? "السائق" : "العميل")).slice(0, 120),
      createdAt: serverTimestamp(),
      expiresAt
    });
  });
}

export async function proposePrice({ orderId, userId, role, name, amount }) {
  const value = cleanAmount(amount);

  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const negRef = doc(db, "priceNegotiations", orderId);
    const orderSnap = await tx.get(orderRef);
    const negSnap = await tx.get(negRef);

    if (!orderSnap.exists() || !negSnap.exists()) {
      throw new Error("لا توجد مفاوضة.");
    }

    const order = orderSnap.data();
    const negotiation = negSnap.data();
    checkOpen(order, negotiation, userId, role);

    if (negotiation.offeredBy === userId && negotiation.currentOffer != null) {
      throw new Error("انتظر الطرف الآخر للرد على عرضك الحالي.");
    }

    const customerOffers = Number(negotiation.customerOffers || 0);
    const driverOffers = Number(negotiation.driverOffers || 0);
    if (role === "customer" && customerOffers >= 4) {
      throw new Error("وصلت إلى الحد الأقصى من 4 عروض.");
    }
    if (role === "driver" && driverOffers >= 4) {
      throw new Error("وصلت إلى الحد الأقصى من 4 عروض.");
    }

    const messageRef = doc(collection(negRef, "messages"));
    const messageId = messageRef.id;

    const patch = {
      currentOffer: value,
      offeredBy: userId,
      updatedAt: serverTimestamp(),
      lastAction: "offer",
      lastMessageId: messageId,
      customerOffers: customerOffers + (role === "customer" ? 1 : 0),
      driverOffers: driverOffers + (role === "driver" ? 1 : 0)
    };

    if (role === "driver") patch.driverName = String(name || "السائق").slice(0, 120);
    if (role === "customer") patch.customerName = String(name || "العميل").slice(0, 120);

    tx.update(negRef, patch);
    tx.set(messageRef, {
      orderId,
      amount: value,
      action: "offer",
      senderId: userId,
      senderRole: role,
      senderName: String(name || (role === "driver" ? "السائق" : "العميل")).slice(0, 120),
      createdAt: serverTimestamp(),
      expiresAt: negotiation.expiresAt || null
    });
  });
}

export async function respondToOffer({ orderId, userId, role, name, action }) {
  if (!["accept", "reject"].includes(action)) {
    throw new Error("إجراء غير صحيح.");
  }

  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const negRef = doc(db, "priceNegotiations", orderId);

    // READS FIRST
    const orderSnap = await tx.get(orderRef);
    const negSnap = await tx.get(negRef);

    if (!orderSnap.exists() || !negSnap.exists()) {
      throw new Error("لا توجد مفاوضة.");
    }

    const order = orderSnap.data();
    const negotiation = negSnap.data();

    checkOpen(order, negotiation, userId, role);

    if (negotiation.offeredBy === userId) {
      throw new Error("لا يمكنك قبول أو رفض عرضك أنت.");
    }

    if (
      negotiation.expiresAt &&
      toMillis(negotiation.expiresAt) <= Date.now()
    ) {
      throw new Error("انتهت مدة التفاوض.");
    }

    const amount = cleanAmount(negotiation.currentOffer);
    const messageRef = doc(collection(negRef, "messages"));
    const messageId = messageRef.id;

    let customer = null;
    let driver = null;

    // For ACCEPT only, read everything needed before any write.
    if (action === "accept") {
      const customerRef = doc(db, "users", order.customerId);
      const driverRef = doc(db, "users", order.driverId);

      const customerSnap = await tx.get(customerRef);
      const driverSnap = await tx.get(driverRef);

      if (!customerSnap.exists() || !driverSnap.exists()) {
        throw new Error("بيانات أحد الطرفين غير موجودة.");
      }

      customer = customerSnap.data();
      driver = driverSnap.data();

      const walletRef = doc(db, "wallets", order.driverId);
      const walletSnap = await tx.get(walletRef);

      if (!walletSnap.exists()) {
        throw new Error("محفظة السائق غير مهيأة. يجب شحن المحفظة أولًا.");
      }

      const walletData = walletSnap.data();
      const balance = Number(walletData?.balance || 0);
      const commission = Math.round(amount * 0.05);

      if (balance < commission) {
        throw new Error(
          `رصيد السائق لا يكفي لعمولة هذا الطلب (${commission} ج.س). يجب شحن المحفظة أولًا.`
        );
      }
    }

    // WRITES START HERE — after ALL reads
    tx.set(messageRef, {
      orderId,
      amount,
      action,
      senderId: userId,
      senderRole: role,
      senderName: String(
        name ||
        (role === "driver"
          ? negotiation.driverName || "السائق"
          : negotiation.customerName || "العميل")
      ).slice(0, 120),
      createdAt: serverTimestamp(),
      expiresAt: negotiation.expiresAt || null
    });

    if (action === "reject") {
      const rejectingPartyOffers =
        role === "customer"
          ? Number(negotiation.customerOffers || 0)
          : Number(negotiation.driverOffers || 0);

      if (rejectingPartyOffers >= 4) {
        tx.update(orderRef, {
          driverId: null,
          status: "pending",
          negotiationStatus: "none"
        });
        tx.update(negRef, {
          currentOffer: null,
          offeredBy: null,
          status: "closed",
          updatedAt: serverTimestamp(),
          lastAction: "republished_after_limit",
          lastMessageId: messageId
        });
      } else {
        tx.update(negRef, {
          currentOffer: null,
          offeredBy: null,
          updatedAt: serverTimestamp(),
          lastAction: "counter_required",
          lastMessageId: messageId
        });
      }
      return;
    }

    const contactRef = doc(db, "orderContacts", orderId);

    const commission = Math.round(amount * 0.05);
    const walletData = walletSnap.data();
    const balanceBefore = Number(walletData?.balance || 0);
    const balanceAfter = balanceBefore - commission;
    const walletTransactionRef = doc(collection(db, "walletTransactions"));

    tx.update(orderRef, {
      deliveryFee: amount,
      agreedFee: amount,
      commissionCharged: true,
      commissionRate: 0.05,
      commissionAmount: commission,
      driverNetAmount: Math.max(0, amount - commission),
      negotiationStatus: "agreed",
      agreedAt: serverTimestamp(),
      agreedBy: userId
    });

    tx.update(walletRef, {
      balance: balanceAfter,
      totalCommissions: Number(walletData?.totalCommissions || 0) + commission,
      updatedAt: serverTimestamp(),
      lastCommissionOrderId: orderId
    });

    tx.set(walletTransactionRef, {
      userId: order.driverId,
      type: "commission",
      amount: -commission,
      balanceBefore,
      balanceAfter,
      orderId,
      topupRequestId: null,
      withdrawalRequestId: null,
      commissionRate: 0.05,
      createdAt: serverTimestamp(),
      createdBy: "system"
    });

    tx.update(negRef, {
      status: "agreed",
      currentOffer: amount,
      updatedAt: serverTimestamp(),
      agreedAt: serverTimestamp(),
      agreedBy: userId,
      lastAction: "accept",
      lastMessageId: messageId
    });

    tx.set(contactRef, {
      orderId,
      customerId: order.customerId,
      driverId: order.driverId,
      customerPhone: String(customer.phone || ""),
      driverPhone: String(driver.phone || ""),
      createdAt: serverTimestamp()
    });
  });
}

export async function saveOwnContact({ orderId }) {
  const snap = await getDoc(doc(db, "orders", orderId));
  if (!snap.exists() || snap.data().negotiationStatus !== "agreed") {
    throw new Error("تظهر أرقام الهاتف بعد الاتفاق فقط.");
  }
  return true;
}

export function listenOrderContacts(orderId, callback) {
  const ref = doc(db, "orderContacts", orderId);
  return onSnapshot(ref, (snap) => {
    callback(snap.exists() ? { id: snap.id, ...snap.data() } : null);
  });
}
