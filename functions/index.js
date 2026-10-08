const admin = require("firebase-admin");
const {
  onCall,
  HttpsError
} = require("firebase-functions/v2/https");

const {
  onDocumentCreated
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

/*
 * Central negotiation controller.
 * Customer starts, each party gets at most 4 offers, and the 5% platform
 * commission is charged immediately when an offer is accepted.
 * Wallet mutations happen here with Admin SDK, never from the client.
 */
exports.negotiationAction = onCall(async (request) => {
  const callerUid = request.auth?.uid;
  if (!callerUid) throw new HttpsError("unauthenticated", "يجب تسجيل الدخول.");

  const orderId = String(request.data?.orderId || "").trim();
  const action = String(request.data?.action || "").trim();
  const rawAmount = request.data?.amount;
  if (!orderId || !["offer", "accept", "reject"].includes(action)) {
    throw new HttpsError("invalid-argument", "بيانات التفاوض غير صحيحة.");
  }

  let amount = null;
  if (action === "offer") {
    amount = Math.round(Number(rawAmount));
    if (!Number.isFinite(amount) || amount <= 0 || amount > 100000000) {
      throw new HttpsError("invalid-argument", "أدخل مبلغًا صحيحًا.");
    }
  }

  return await db.runTransaction(async (tx) => {
    const orderRef = db.collection("orders").doc(orderId);
    const negRef = db.collection("priceNegotiations").doc(orderId);
    const callerRef = db.collection("users").doc(callerUid);

    const orderSnap = await tx.get(orderRef);
    const negSnap = await tx.get(negRef);
    const callerSnap = await tx.get(callerRef);
    if (!orderSnap.exists || !negSnap.exists || !callerSnap.exists) {
      throw new HttpsError("not-found", "الطلب أو محادثة التفاوض غير موجودة.");
    }

    const order = orderSnap.data() || {};
    const negotiation = negSnap.data() || {};
    const caller = callerSnap.data() || {};
    const role = caller.role;

    if (!["customer", "driver"].includes(role) || caller.status !== "active") {
      throw new HttpsError("permission-denied", "الحساب غير مخوّل للتفاوض.");
    }
    if (order.status !== "accepted" || order.negotiationStatus !== "open") {
      throw new HttpsError("failed-precondition", "التفاوض متاح فقط بعد قبول السائق وقبل بدء الرحلة.");
    }
    if (role === "customer" && order.customerId !== callerUid) {
      throw new HttpsError("permission-denied", "هذا الطلب لا يخصك.");
    }
    if (role === "driver" && order.driverId !== callerUid) {
      throw new HttpsError("permission-denied", "هذا الطلب لا يخصك.");
    }
    if (negotiation.status !== "open") {
      throw new HttpsError("failed-precondition", "محادثة التفاوض مغلقة.");
    }

    const currentOffer = negotiation.currentOffer == null ? null : Math.round(Number(negotiation.currentOffer));
    const currentOfferer = negotiation.offeredBy || null;
    const turnRole = negotiation.turnRole || "customer";
    const messageRef = db.collection("priceNegotiations").doc(orderId).collection("messages").doc();
    const now = admin.firestore.FieldValue.serverTimestamp();
    const expiresAt = admin.firestore.Timestamp.fromMillis(Date.now() + 30 * 60 * 1000);
    const callerName = String(caller.name || (role === "driver" ? "السائق" : "العميل")).slice(0, 120);

    if (action === "offer") {
      if (currentOffer != null) {
        throw new HttpsError("failed-precondition", "يوجد عرض حالي. يجب الرد عليه أولًا.");
      }
      if (turnRole !== role) {
        throw new HttpsError("failed-precondition", role === "customer" ? "انتظر رد الكابتن قبل تقديم عرض جديد." : "انتظر عرض العميل.");
      }
      const customerOffers = Number(negotiation.customerOffers || 0);
      const driverOffers = Number(negotiation.driverOffers || 0);
      if (role === "customer" && customerOffers >= 4) throw new HttpsError("failed-precondition", "وصل العميل إلى 4 عروض.");
      if (role === "driver" && driverOffers >= 4) throw new HttpsError("failed-precondition", "وصل الكابتن إلى 4 عروض.");

      tx.update(negRef, {
        currentOffer: amount,
        offeredBy: callerUid,
        turnRole: role === "customer" ? "driver" : "customer",
        customerOffers: customerOffers + (role === "customer" ? 1 : 0),
        driverOffers: driverOffers + (role === "driver" ? 1 : 0),
        expiresAt,
        updatedAt: now,
        lastAction: "offer",
        lastMessageId: messageRef.id
      });
      tx.set(messageRef, {
        orderId,
        amount,
        action: "offer",
        senderId: callerUid,
        senderRole: role,
        senderName: callerName,
        createdAt: now,
        expiresAt
      });

      const notifyUid = role === "customer" ? order.driverId : order.customerId;
      tx.create(db.collection("notifications").doc(), {
        userId: notifyUid,
        type: "order_status",
        title: "عرض سعر جديد",
        body: callerName + " أرسل عرضًا بقيمة " + amount + " ج.س للطلب " + orderId + ".",
        createdAt: now,
        read: false,
        createdBy: "system"
      });
      return { status: "offered", amount };
    }

    if (currentOffer == null || !currentOfferer) {
      throw new HttpsError("failed-precondition", "لا يوجد عرض حالي للرد عليه.");
    }
    if (currentOfferer === callerUid) {
      throw new HttpsError("failed-precondition", "لا يمكنك الرد على عرضك أنت.");
    }
    if (!Number.isFinite(currentOffer) || currentOffer <= 0) {
      throw new HttpsError("failed-precondition", "قيمة العرض غير صالحة.");
    }
    if (negotiation.expiresAt?.toMillis && negotiation.expiresAt.toMillis() <= Date.now()) {
      throw new HttpsError("deadline-exceeded", "انتهت مدة هذا العرض.");
    }

    if (action === "reject") {
      const offererRole = currentOfferer === order.customerId ? "customer" : "driver";
      const offererCount = offererRole === "customer"
        ? Number(negotiation.customerOffers || 0)
        : Number(negotiation.driverOffers || 0);

      tx.set(messageRef, {
        orderId,
        amount: currentOffer,
        action: "reject",
        senderId: callerUid,
        senderRole: role,
        senderName: callerName,
        createdAt: now,
        expiresAt: negotiation.expiresAt || null
      });

      if (offererCount >= 4) {
        tx.update(orderRef, {
          driverId: null,
          status: "pending",
          negotiationStatus: "none",
          acceptedAt: null,
          deliveryFee: null,
          agreedFee: null
        });
        tx.update(negRef, {
          currentOffer: null,
          offeredBy: null,
          turnRole: "customer",
          status: "closed",
          updatedAt: now,
          lastAction: "republished_after_limit",
          lastMessageId: messageRef.id
        });
        for (const uid of [order.customerId, order.driverId]) {
          if (!uid) continue;
          tx.create(db.collection("notifications").doc(), {
            userId: uid,
            type: "order_status",
            title: "عاد الطلب للنشر",
            body: "لم يتم الاتفاق بعد 4 عروض للطرف صاحب آخر عرض. عاد الطلب " + orderId + " للنشر.",
            createdAt: now,
            read: false,
            createdBy: "system"
          });
        }
        return { status: "republished" };
      }

      tx.update(negRef, {
        currentOffer: null,
        offeredBy: null,
        turnRole: role,
        updatedAt: now,
        lastAction: "reject",
        lastMessageId: messageRef.id
      });
      tx.create(db.collection("notifications").doc(), {
        userId: role === "customer" ? order.driverId : order.customerId,
        type: "order_status",
        title: "تم رفض العرض",
        body: "تم رفض العرض " + currentOffer + " ج.س. حان دور الطرف الآخر لإرسال السعر المقابل.",
        createdAt: now,
        read: false,
        createdBy: "system"
      });
      return { status: "counter_required" };
    }

    // ACCEPT: 5% is charged immediately and atomically from the driver's wallet.
    const walletRef = db.collection("wallets").doc(order.driverId);
    const customerRef = db.collection("users").doc(order.customerId);
    const driverRef = db.collection("users").doc(order.driverId);
    const walletSnap = await tx.get(walletRef);
    const customerSnap = await tx.get(customerRef);
    const driverSnap = await tx.get(driverRef);
    if (!walletSnap.exists || !customerSnap.exists || !driverSnap.exists) {
      throw new HttpsError("failed-precondition", "بيانات المحفظة أو أحد الطرفين غير موجودة.");
    }
    const wallet = walletSnap.data() || {};
    const customer = customerSnap.data() || {};
    const driver = driverSnap.data() || {};
    const commission = Math.round(currentOffer * 0.05);
    const balanceBefore = Number(wallet.balance || 0);
    if (balanceBefore < commission) {
      throw new HttpsError("failed-precondition", "رصيد محفظة السائق لا يكفي لعمولة عايز 5% (" + commission + " ج.س).");
    }
    const balanceAfter = balanceBefore - commission;
    const walletTxRef = db.collection("walletTransactions").doc();
    const contactRef = db.collection("orderContacts").doc(orderId);

    tx.set(messageRef, {
      orderId,
      amount: currentOffer,
      action: "accept",
      senderId: callerUid,
      senderRole: role,
      senderName: callerName,
      createdAt: now,
      expiresAt: negotiation.expiresAt || null
    });
    tx.update(orderRef, {
      deliveryFee: currentOffer,
      agreedFee: currentOffer,
      commissionCharged: true,
      commissionRate: 0.05,
      commissionAmount: commission,
      driverNetAmount: Math.max(0, currentOffer - commission),
      negotiationStatus: "agreed",
      agreedAt: now,
      agreedBy: callerUid
    });
    tx.update(negRef, {
      status: "agreed",
      currentOffer,
      offeredBy: currentOfferer,
      turnRole: null,
      updatedAt: now,
      agreedAt: now,
      agreedBy: callerUid,
      lastAction: "accept",
      lastMessageId: messageRef.id
    });
    tx.update(walletRef, {
      balance: balanceAfter,
      totalCommission: Number(wallet.totalCommission || 0) + commission,
      updatedAt: now,
      lastCommissionOrderId: orderId
    });
    tx.set(walletTxRef, {
      userId: order.driverId,
      type: "commission",
      amount: -commission,
      balanceBefore,
      balanceAfter,
      orderId,
      topupRequestId: null,
      withdrawalRequestId: null,
      commissionRate: 0.05,
      createdAt: now,
      createdBy: "system"
    });
    tx.set(contactRef, {
      orderId,
      customerId: order.customerId,
      driverId: order.driverId,
      customerPhone: String(customer.phone || ""),
      driverPhone: String(driver.phone || ""),
      createdAt: now
    });
    for (const uid of [order.customerId, order.driverId]) {
      if (!uid) continue;
      tx.create(db.collection("notifications").doc(), {
        userId: uid,
        type: "order_status",
        title: "تم الاتفاق على السعر",
        body: "تم الاتفاق على " + currentOffer + " ج.س، وتم خصم عمولة عايز 5% من محفظة السائق.",
        createdAt: now,
        read: false,
        createdBy: "system"
      });
    }
    return { status: "agreed", amount: currentOffer, commission };
  });
});

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
