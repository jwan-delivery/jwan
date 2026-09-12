const admin = require("firebase-admin");
const { onCall, HttpsError } = require("firebase-functions/v2/https");

admin.initializeApp();

const db = admin.firestore();

/*
 * حذف مستخدم بواسطة الإدارة.
 *
 * يحذف:
 * 1) Firebase Authentication
 * 2) users/{uid}
 * 3) wallets/{uid} إذا كانت موجودة
 *
 * لا يحذف الطلبات أو السجلات التاريخية.
 *
 * الحماية:
 * - لا يمكن حذف حسابك الإداري الحالي.
 * - لا يمكن حذف super_admin.
 * - admin لا يستطيع حذف admin.
 * - super_admin يستطيع حذف admin/customer/driver.
 */
exports.adminDeleteUser = onCall(async (request) => {

  const callerUid = request.auth?.uid;

  if (!callerUid) {
    throw new HttpsError(
      "unauthenticated",
      "يجب تسجيل الدخول كمسؤول."
    );
  }

  const targetUid = String(request.data?.uid || "").trim();

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

  const callerRef = db.collection("users").doc(callerUid);
  const callerSnap = await callerRef.get();

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
      "ليس لديك صلاحية حذف المستخدمين."
    );
  }

  const targetRef = db.collection("users").doc(targetUid);
  const targetSnap = await targetRef.get();

  if (!targetSnap.exists) {
    throw new HttpsError(
      "not-found",
      "ملف المستخدم غير موجود في Firestore."
    );
  }

  const target = targetSnap.data();

  if (target.role === "super_admin") {
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

  /*
   * حذف Authentication.
   */
  try {
    await admin.auth().deleteUser(targetUid);
  } catch (error) {

    /*
     * إذا كان الملف موجودًا في Firestore
     * لكن الحساب غير موجود في Authentication،
     * نكمل تنظيف Firestore.
     */
    if (error?.code !== "auth/user-not-found") {
      console.error("Firebase Auth delete error:", error);

      throw new HttpsError(
        "internal",
        "تعذر حذف حساب المستخدم من Firebase Authentication."
      );
    }
  }

  /*
   * حذف ملف المستخدم.
   */
  await targetRef.delete();

  /*
   * حذف محفظة المستخدم إن كانت موجودة.
   * هذا ينطبق خصوصًا على السائق.
   */
  await db
    .collection("wallets")
    .doc(targetUid)
    .delete()
    .catch(() => {});

  /*
   * الاحتفاظ بسجل العملية.
   */
  await db.collection("auditLogs").add({
    actorUid: callerUid,
    actorRole: caller.role,
    action: "delete_user",
    targetType: "user",
    targetId: targetUid,
    metadata: {
      deletedRole: target.role || null,
      deletedName: target.name || null,
      deletedPhone: target.phone || null
    },
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  });

  return {
    success: true,
    uid: targetUid
  };
});
