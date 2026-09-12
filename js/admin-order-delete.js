(() => {
  async function init() {
    try {
      const { auth, db } = await import("./firebase-config.js");
      const { getCurrentUserData } = await import("./auth.js");
      const { doc, deleteDoc } =
        await import("https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js");

      auth.onAuthStateChanged(async user => {
        if (!user) return;
        const data = await getCurrentUserData(user.uid).catch(() => null);
        if (!data || !["admin","super_admin"].includes(data.role)) return;

        const list = document.getElementById("ordersList");
        if (!list) return;

        const enhance = () => {
          list.querySelectorAll(".order-row[data-id]").forEach(row => {
            if (row.querySelector(".jawan-delete-order-btn")) return;

            const btn = document.createElement("button");
            btn.type = "button";
            btn.className = "btn btn-danger btn-sm jawan-delete-order-btn";
            btn.textContent = "حذف السجل";
            btn.style.marginTop = "8px";

            btn.addEventListener("click", async () => {
              const id = row.dataset.id;
              if (!id) return;
              if (!confirm("هل أنت متأكد من حذف هذا الطلب نهائيًا؟")) return;

              btn.disabled = true;
              btn.textContent = "جاري الحذف...";

              try {
                await deleteDoc(doc(db, "orders", id));
                row.remove();
              } catch (e) {
                alert(e?.message || "تعذر حذف الطلب. تحقق من صلاحيات الإدارة.");
                btn.disabled = false;
                btn.textContent = "حذف السجل";
              }
            });

            const right = row.querySelector(":scope > div:last-child");
            if (right) right.appendChild(btn);
          });
        };

        enhance();
        new MutationObserver(enhance).observe(list, { childList:true, subtree:true });
      });
    } catch (e) {
      console.warn("Jawan order delete unavailable:", e);
    }
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init, { once:true });
  } else {
    init();
  }
})();
