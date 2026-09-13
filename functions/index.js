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
