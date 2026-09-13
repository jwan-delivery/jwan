#!/data/data/com.termux/files/usr/bin/bash
set -e

ROOT="$HOME/downloads/jwan_v1"
cd "$ROOT"

mkdir -p .jawan-backups

cp functions/index.js ".jawan-backups/index.js.before-order-delete"
cp js/admin-order-delete.js ".jawan-backups/admin-order-delete.js.before-order-delete"
cp firestore.rules ".jawan-backups/firestore.rules.before-order-delete"

python3 <<'PY'
from pathlib import Path

root = Path.home() / "downloads" / "jwan_v1"

# ---------------------------------------------------------
# 1) إضافة Cloud Function لحذف الطلب ومعلوماته المرتبطة
# ---------------------------------------------------------

p = root / "functions" / "index.js"
text = p.read_text(encoding="utf-8")

marker = 'exports.adminDeleteOrder = onCall('

if marker not in text:
    addition = r'''

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
'''

    text = text.rstrip() + "\n" + addition + "\n"
    p.write_text(text, encoding="utf-8")


# ---------------------------------------------------------
# 2) استبدال كود الحذف المباشر من الواجهة
# ---------------------------------------------------------

p = root / "js" / "admin-order-delete.js"

new_js = r'''(() => {
  async function init() {
    try {
      const { auth, db } =
        await import("./firebase-config.js");

      const { getCurrentUserData } =
        await import("./auth.js");

      const {
        getFunctions,
        httpsCallable
      } =
        await import(
          "https://www.gstatic.com/firebasejs/12.18.0/firebase-functions.js"
        );

      /*
       * db موجود في firebase-config.js.
       * نستخدمه فقط للتحقق من الجلسة من جهة الواجهة.
       */
      void db;

      auth.onAuthStateChanged(async (user) => {
        if (!user) return;

        const data =
          await getCurrentUserData(user.uid).catch(() => null);

        if (
          !data ||
          !["admin", "super_admin"].includes(data.role)
        ) {
          return;
        }

        const list =
          document.getElementById("ordersList");

        if (!list) return;

        const functions = getFunctions();
        const deleteOrder = httpsCallable(
          functions,
          "adminDeleteOrder"
        );

        const enhance = () => {
          list
            .querySelectorAll(".order-row[data-id]")
            .forEach((row) => {
              if (
                row.querySelector(
                  ".jawan-delete-order-btn"
                )
              ) {
                return;
              }

              const btn =
                document.createElement("button");

              btn.type = "button";
              btn.className =
                "btn btn-danger btn-sm jawan-delete-order-btn";
              btn.textContent = "حذف السجل";
              btn.style.marginTop = "8px";

              btn.addEventListener(
                "click",
                async () => {
                  const id =
                    row.dataset.id;

                  if (!id) return;

                  const confirmed =
                    confirm(
                      "هل أنت متأكد من حذف هذا الطلب نهائيًا؟\n\nسيتم حذف الطلب والبيانات المرتبطة به، ولا يمكن التراجع عن العملية."
                    );

                  if (!confirmed) return;

                  btn.disabled = true;
                  btn.textContent = "جاري الحذف...";

                  try {
                    const result =
                      await deleteOrder({
                        orderId: id
                      });

                    if (
                      !result?.data?.success
                    ) {
                      throw new Error(
                        "لم يتم تأكيد حذف الطلب."
                      );
                    }

                    row.remove();

                    alert(
                      "تم حذف الطلب والسجلات المرتبطة به."
                    );
                  } catch (e) {
                    console.error(
                      "Jawan admin delete order:",
                      e
                    );

                    alert(
                      e?.message ||
                      e?.details?.message ||
                      "تعذر حذف الطلب."
                    );

                    btn.disabled = false;
                    btn.textContent = "حذف السجل";
                  }
                }
              );

              const right =
                row.querySelector(
                  ":scope > div:last-child"
                );

              if (right) {
                right.appendChild(btn);
              }
            });
        };

        enhance();

        new MutationObserver(enhance)
          .observe(list, {
            childList: true,
            subtree: true
          });
      });
    } catch (e) {
      console.warn(
        "Jawan order delete unavailable:",
        e
      );
    }
  }

  if (
    document.readyState === "loading"
  ) {
    document.addEventListener(
      "DOMContentLoaded",
      init,
      { once: true }
    );
  } else {
    init();
  }
})();
'''

p.write_text(new_js, encoding="utf-8")


# ---------------------------------------------------------
# 3) منع الحذف المباشر للطلب من Firestore Rules
# ---------------------------------------------------------

p = root / "firestore.rules"
text = p.read_text(encoding="utf-8")

old = "      allow delete: if isAdmin();"

# هذا السطر الأول الخاص بـ orders هو المطلوب استبداله.
needle = "    match /orders/{orderId} {"

start = text.find(needle)

if start == -1:
    raise SystemExit("لم يتم العثور على match /orders/{orderId}")

pos = text.find(old, start)

if pos == -1:
    raise SystemExit(
        "لم يتم العثور على allow delete الخاص بالطلبات."
    )

text = (
    text[:pos]
    + "      // حذف الطلبات يتم فقط عبر Cloud Function adminDeleteOrder.\n"
      "      allow delete: if false;"
    + text[pos + len(old):]
)

p.write_text(text, encoding="utf-8")

print("تم تطبيق إصلاح حذف الطلبات.")
PY

echo
echo "=== فحص Cloud Function ==="
grep -n "exports.adminDeleteOrder" functions/index.js

echo
echo "=== فحص واجهة الحذف ==="
grep -n "adminDeleteOrder\|httpsCallable\|حذف السجل" js/admin-order-delete.js

echo
echo "=== فحص Firestore Rules ==="
grep -n -A4 "match /orders/{orderId}" firestore.rules | tail -n 8

echo
echo "=== الحالة ==="
git status --short
