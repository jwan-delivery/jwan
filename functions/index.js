const admin = require("firebase-admin");
const {
  onCall,
  HttpsError
} = require("firebase-functions/v2/https");

const {
  onDocumentCreated,
  onDocumentUpdated
} = require("firebase-functions/v2/firestore");

admin.initializeApp();

const db = admin.firestore();

/*
 * إرسال Push تلقائي عند إنشاء notifications/{notificationId}
 */
exports.sendNotificationPush = onDocumentCreated(
  "notifications/{notificationId}",
  async (event) => {
    const snap = event.data;

    if (!snap) {
      return;
    }

    const notification = snap.data();

    if (!notification?.userId) {
      console.warn(
        "Jwan push: notification بدون userId"
      );
      return;
    }

    /*
     * حماية من إعادة الإرسال في حال إعادة تشغيل الحدث.
     */
    if (notification.pushSentAt) {
      return;
    }

    const tokenSnap = await db
      .collection("fcmTokens")
      .where(
        "uid",
        "==",
        String(notification.userId)
      )
      .get();

    if (tokenSnap.empty) {
      console.log(
        "Jwan push: لا توجد أجهزة مسجلة للمستخدم",
        notification.userId
      );
      return;
    }

    const tokens = tokenSnap.docs
      .map((doc) => doc.get("token"))
      .filter(Boolean);

    if (!tokens.length) {
      return;
    }

    const response =
      await admin.messaging().sendEachForMulticast({
        tokens,
        notification: {
          title:
            String(notification.title || "جوان"),
          body:
            String(
              notification.body ||
              "لديك إشعار جديد من جوان."
            )
        },
        data: {
          notificationId: String(
            event.params.notificationId
          ),
          type: String(
            notification.type || "system"
          ),
          url: String(
            notification.url || "/"
          )
        },
        webpush: {
          fcmOptions: {
            link: String(
              notification.url || "/"
            )
          }
        }
      });

    const batch = db.batch();

    response.responses.forEach((result, index) => {
      if (!result.success) {
        const tokenDoc = tokenSnap.docs[index];
        const code = result.error?.code || "";

        /*
         * حذف التوكنات التي لم تعد صالحة.
         */
        if (
          code.includes("registration-token-not-registered") ||
          code.includes("invalid-registration-token")
        ) {
          batch.delete(tokenDoc.ref);
        }
      }
    });

    batch.update(
      snap.ref,
      {
        pushSentAt:
          admin.firestore.FieldValue.serverTimestamp(),
        pushSuccessCount:
          response.successCount,
        pushFailureCount:
          response.failureCount
      }
    );

    await batch.commit();

    console.log(
      "Jwan push result:",
      {
        notificationId:
          event.params.notificationId,
        successCount:
          response.successCount,
        failureCount:
          response.failureCount
      }
    );
  }
);


/*
 * حذف مستخدم بواسطة الإدارة.
 */
exports.adminDeleteUser = onCall(
  async (request) => {

    const callerUid =
      request.auth?.uid;

    if (!callerUid) {
      throw new HttpsError(
        "unauthenticated",
        "يجب تسجيل الدخول كمسؤول."
      );
    }

    const targetUid =
      String(
        request.data?.uid || ""
      ).trim();

    if (!targetUid) {
      throw new HttpsError(
        "invalid-argument",
        "لم يتم تحديد المستخدم."
      );
    }

    if (targetUid === callerUid) {
      throw new HttpsError(
        "failed-precondition",
        "لا يمكنك حذف حساب الإدارة الذي تستخدمه حاليًا."
      );
    }

    const callerRef =
      db.collection("users")
        .doc(callerUid);

    const callerSnap =
      await callerRef.get();

    if (!callerSnap.exists) {
      throw new HttpsError(
        "permission-denied",
        "حساب المسؤول غير موجود."
      );
    }

    const caller =
      callerSnap.data();

    if (
      !["admin", "super_admin"].includes(
        caller.role
      ) ||
      caller.status !== "active"
    ) {
      throw new HttpsError(
        "permission-denied",
        "ليس لديك صلاحية حذف المستخدمين."
      );
    }

    const targetRef =
      db.collection("users")
        .doc(targetUid);

    const targetSnap =
      await targetRef.get();

    if (!targetSnap.exists) {
      throw new HttpsError(
        "not-found",
        "ملف المستخدم غير موجود في Firestore."
      );
    }

    const target =
      targetSnap.data();

    if (
      target.role === "super_admin"
    ) {
      throw new HttpsError(
        "permission-denied",
        "لا يمكن حذف حساب super_admin."
      );
    }

    if (
      caller.role !== "super_admin" &&
      target.role === "admin"
    ) {
      throw new HttpsError(
        "permission-denied",
        "لا يملك هذا المسؤول صلاحية حذف مدير آخر."
      );
    }

    try {
      await admin
        .auth()
        .deleteUser(targetUid);

    } catch (error) {

      if (
        error?.code !==
        "auth/user-not-found"
      ) {
        console.error(
          "Firebase Auth delete error:",
          error
        );

        throw new HttpsError(
          "internal",
          "تعذر حذف حساب المستخدم من Firebase Authentication."
        );
      }
    }

    await targetRef.delete();

    await db
      .collection("wallets")
      .doc(targetUid)
      .delete()
      .catch(() => {});

    await db
      .collection("auditLogs")
      .add({
        actorUid: callerUid,
        actorRole: caller.role,
        action: "delete_user",
        targetType: "user",
        targetId: targetUid,
        metadata: {
          deletedRole:
            target.role || null,
          deletedName:
            target.name || null,
          deletedPhone:
            target.phone || null
        },
        createdAt:
          admin.firestore.FieldValue.serverTimestamp()
      });

    return {
      success: true,
      uid: targetUid
    };
  }
);


/*
 * حذف طلب بواسطة الإدارة.
 *
 * الحذف يتم من الخادم فقط حتى لا تعتمد العملية
 * على صلاحيات المتصفح المباشرة.
 */
exports.adminDeleteOrder = onCall(
  async (request) => {
    const callerUid = request.auth?.uid;

    if (!callerUid) {
      throw new HttpsError(
        "unauthenticated",
        "يجب تسجيل الدخول كمسؤول."
      );
    }

    const orderId = String(
      request.data?.orderId || ""
    ).trim();

    if (!orderId) {
      throw new HttpsError(
        "invalid-argument",
        "لم يتم تحديد الطلب."
      );
    }

    const callerSnap = await db
      .collection("users")
      .doc(callerUid)
      .get();

    if (!callerSnap.exists) {
      throw new HttpsError(
        "permission-denied",
        "حساب المسؤول غير موجود."
      );
    }

    const caller = callerSnap.data();

    if (
      !["admin", "super_admin"].includes(caller.role) ||
      caller.status !== "active"
    ) {
      throw new HttpsError(
        "permission-denied",
        "ليس لديك صلاحية حذف الطلبات."
      );
    }

    const orderRef = db
      .collection("orders")
      .doc(orderId);

    const orderSnap = await orderRef.get();

    if (!orderSnap.exists) {
      throw new HttpsError(
        "not-found",
        "الطلب غير موجود."
      );
    }

    const order = orderSnap.data() || {};

    /*
     * نحفظ الحد الأدنى من معلومات الطلب في سجل التدقيق
     * قبل الحذف النهائي.
     */
    const metadata = {
      customerId: order.customerId || null,
      driverId: order.driverId || null,
      status: order.status || null,
      agreedFee: order.agreedFee ?? null,
      deliveryFee: order.deliveryFee ?? null,
      state: order.state || null
    };

    const refs = [];

    /*
     * وثائق مباشرة مرتبطة بنفس رقم الطلب.
     */
    refs.push(
      db.collection("priceNegotiations").doc(orderId),
      db.collection("orderContacts").doc(orderId)
    );

    /*
     * مجموعات تستخدم orderId داخل الوثيقة.
     */
    const querySpecs = [
      ["ratings", "orderId"],
      ["walletTransactions", "orderId"],
      ["notifications", "orderId"]
    ];

    for (const [collectionName, fieldName] of querySpecs) {
      const snap = await db
        .collection(collectionName)
        .where(fieldName, "==", orderId)
        .get();

      snap.docs.forEach((docSnap) => {
        refs.push(docSnap.ref);
      });
    }

    /*
     * Firestore batch حدّه 500 عملية.
     * نستخدم 400 كحد آمن لكل دفعة.
     */
    for (let i = 0; i < refs.length; i += 400) {
      const batch = db.batch();

      refs
        .slice(i, i + 400)
        .forEach((ref) => batch.delete(ref));

      await batch.commit();
    }

    await orderRef.delete();

    await db.collection("auditLogs").add({
      actorUid: callerUid,
      actorRole: caller.role,
      action: "delete_order",
      targetType: "order",
      targetId: orderId,
      metadata,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    return {
      success: true,
      orderId
    };
  }
);

/* Shared notification writer: creates in-app notifications from trusted Firestore events. */
async function writeOrderNotificationsOnce(event, notifications) {
  const eventId = String(event.id || "unknown-event").replaceAll("/", "_");
  const markerRef = db.collection("notificationEvents").doc(eventId);
  const entries = (notifications || []).filter((item) => item && item.userId).slice(0, 400);
  const refs = entries.map(() => db.collection("notifications").doc());
  await db.runTransaction(async (tx) => {
    const marker = await tx.get(markerRef);
    if (marker.exists) return;
    entries.forEach((entry, index) => {
      tx.set(refs[index], {
        userId: String(entry.userId),
        type: entry.type || "order_status",
        title: String(entry.title || "تحديث من عايز").slice(0, 120),
        body: String(entry.body || "لديك تحديث جديد في طلبك.").slice(0, 1000),
        orderId: entry.orderId || null, state: entry.state || null,
        read: false, createdAt: admin.firestore.FieldValue.serverTimestamp(),
        createdBy: "system", sourceEventId: eventId
      });
    });
    tx.create(markerRef, {
      eventType: event.type || "firestore",
      orderId: (event.params && event.params.orderId) || null,
      notificationCount: entries.length,
      processedAt: admin.firestore.FieldValue.serverTimestamp()
    });
  });
}

function orderStatusLabel(status) {
  const labels = { pending: "بانتظار كابتن", accepted: "تم قبول الطلب", picked_up: "استلم الكابتن الطلب", delivering: "بدأ التوصيل", awaiting_confirmation: "الطلب بانتظار تأكيد الاستلام", not_delivered: "تم الإبلاغ عن عدم وصول الطلب", completed: "اكتمل التوصيل", cancelled: "أُلغي الطلب", rejected: "رُفض الطلب" };
  return labels[status] || "تحدّثت حالة الطلب";
}

exports.notifyDriversOfNewOrder = onDocumentCreated("orders/{orderId}", async (event) => {
  const snap = event.data;
  if (!snap) return;
  const order = snap.data() || {};
  if (order.status !== "pending" || order.driverId != null || !order.state) return;
  const driversSnap = await db.collection("users").where("role", "==", "driver").where("status", "==", "active").where("state", "==", order.state).limit(400).get();
  const entries = driversSnap.docs.map((driverSnap) => ({
    userId: driverSnap.id, type: "new_order", title: "يوجد طلب جديد في ولايتك",
    body: "طلب " + (order.vehicleType || "توصيل") + " متاح في ولاية " + order.state + ". افتح عايز لمراجعته وقبوله.",
    orderId: snap.id, state: order.state
  }));
  if (order.customerId) entries.push({
    userId: order.customerId, type: "order_status", title: "تم إنشاء طلبك",
    body: "تم تسجيل طلبك بنجاح، وسيتم إشعارك عند قبول أحد الكباتن له.", orderId: snap.id, state: order.state
  });
  await writeOrderNotificationsOnce({ id: event.id, type: "order-created", params: { orderId: snap.id } }, entries);
});

exports.notifyParticipantsOnOrderUpdate = onDocumentUpdated("orders/{orderId}", async (event) => {
  const beforeSnap = event.data && event.data.before;
  const afterSnap = event.data && event.data.after;
  if (!beforeSnap || !afterSnap) return;
  const before = beforeSnap.data() || {};
  const after = afterSnap.data() || {};
  const orderId = afterSnap.id;
  const statusChanged = before.status !== after.status;
  const driverChanged = before.driverId !== after.driverId;
  const customerConfirmed = !before.customerConfirmedAt && !!after.customerConfirmedAt;
  if (!statusChanged && !driverChanged && !customerConfirmed) return;
  const recipients = new Set([after.customerId, after.driverId, before.driverId].filter(Boolean));
  const entries = [];
  for (const userId of recipients) {
    if (userId === after.driverId && userId !== after.customerId && customerConfirmed) {
      entries.push({ userId, type: "order_status", title: "أكد العميل استلام الطلب", body: "أكد العميل الاستلام. يمكنك متابعة إنهاء الطلب من عايز.", orderId, state: after.state });
      continue;
    }
    if (driverChanged && after.driverId && userId === after.customerId) {
      const driverSnap = await db.collection("users").doc(after.driverId).get();
      const driver = driverSnap.data() || {};
      entries.push({ userId, type: "order_accepted", title: "قبل كابتن طلبك", body: "قبل الكابتن " + (driver.name || "طلبك") + " الطلب. يمكنك متابعة الاتفاق على السعر داخل التطبيق.", orderId, state: after.state });
    } else if (driverChanged && after.driverId && userId === after.driverId) {
      entries.push({ userId, type: "order_accepted", title: "أصبح الطلب ضمن مهامك", body: "تم تسجيل قبولك للطلب. تابع تفاصيله واتفق على السعر مع العميل.", orderId, state: after.state });
    } else if (statusChanged) {
      entries.push({ userId, type: after.status === "accepted" ? "order_accepted" : "order_status", title: orderStatusLabel(after.status), body: "تم تحديث حالة الطلب رقم " + orderId + " إلى: " + orderStatusLabel(after.status) + ".", orderId, state: after.state });
    }
  }
  await writeOrderNotificationsOnce({ id: event.id, type: "order-updated", params: { orderId } }, entries);
});

exports.notifyParticipantsOnNegotiation = onDocumentUpdated("priceNegotiations/{orderId}", async (event) => {
  const beforeSnap = event.data && event.data.before;
  const afterSnap = event.data && event.data.after;
  if (!beforeSnap || !afterSnap) return;
  const before = beforeSnap.data() || {};
  const after = afterSnap.data() || {};
  const offerChanged = before.currentOffer !== after.currentOffer && after.currentOffer != null;
  const newlyAgreed = before.status !== "agreed" && after.status === "agreed";
  if (!offerChanged && !newlyAgreed) return;
  const orderId = event.params.orderId;
  const orderSnap = await db.collection("orders").doc(orderId).get();
  const order = orderSnap.data() || {};
  const entries = [];
  if (newlyAgreed) {
    for (const userId of [after.customerId, after.driverId].filter(Boolean)) {
      entries.push({ userId, type: "order_status", title: "تم الاتفاق على سعر الطلب", body: "تم الاتفاق على مبلغ " + (after.currentOffer || order.deliveryFee || "") + " ج.س. تابع الطلب في عايز.", orderId, state: order.state });
    }
  } else if (offerChanged && after.offeredBy) {
    const recipient = after.offeredBy === after.driverId ? after.customerId : after.driverId;
    if (recipient) entries.push({ userId: recipient, type: "order_status", title: "وصلك عرض سعر جديد", body: "قدم الطرف الآخر عرضًا بقيمة " + after.currentOffer + " ج.س. افتح صفحة الطلب للرد.", orderId, state: order.state });
  }
  await writeOrderNotificationsOnce({ id: event.id, type: "price-negotiation-updated", params: { orderId } }, entries);
});
