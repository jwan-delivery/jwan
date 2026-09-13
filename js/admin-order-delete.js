(() => {
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
