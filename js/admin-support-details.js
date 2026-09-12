(() => {
  async function init() {
    const title = document.getElementById("pageTitle");
    if (!title || title.textContent.trim() !== "صندوق الدعم") return;

    try {
      const { auth, db } = await import("./firebase-config.js");
      const { getCurrentUserData } = await import("./auth.js");
      const { collection, getDocs, doc, getDoc, query, orderBy } =
        await import("https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js");

      const me = auth.currentUser;
      if (!me) return;
      const meData = await getCurrentUserData(me.uid).catch(() => null);
      if (!meData || !["admin","super_admin"].includes(meData.role)) return;

      const list = document.getElementById("threadList");
      if (!list) return;

      const esc = v => String(v ?? "")
        .replace(/&/g,"&amp;").replace(/</g,"&lt;")
        .replace(/>/g,"&gt;").replace(/"/g,"&quot;")
        .replace(/'/g,"&#039;");

      async function enhance() {
        const snap = await getDocs(
          query(collection(db, "supportMessages"), orderBy("createdAt","desc"))
        );

        for (const item of snap.docs) {
          const m = item.data() || {};
          if (!m.userId) continue;

          const row = list.querySelector(`[data-id="${CSS.escape(item.id)}"]`);
          if (!row) continue;

          const userSnap = await getDoc(doc(db, "users", m.userId));
          const p = userSnap.exists() ? userSnap.data() : {};

          let card = row.querySelector(".support-admin-user-card");
          if (!card) {
            card = document.createElement("div");
            card.className = "support-admin-user-card";
            row.appendChild(card);
          }

          card.innerHTML = `
            <div style="font-weight:800;margin-bottom:6px">بيانات صاحب الرسالة</div>
            <div class="support-admin-user-grid">
              <div><strong>الاسم:</strong> ${esc(p.name || "—")}</div>
              <div><strong>الهاتف:</strong> ${esc(p.phone || "—")}</div>
              <div><strong>الدور:</strong> ${esc(p.role || m.role || "—")}</div>
              <div><strong>الحالة:</strong> ${esc(p.status || "—")}</div>
              <div><strong>الولاية:</strong> ${esc(p.state || "—")}</div>
              <div><strong>العنوان:</strong> ${esc(p.address || "—")}</div>
              <div><strong>العمر:</strong> ${esc(p.age ?? "—")}</div>
              <div><strong>المركبة:</strong> ${esc(p.vehicleType || "—")}</div>
              <div style="grid-column:1/-1"><strong>UID:</strong> ${esc(m.userId)}</div>
            </div>
          `;
        }
      }

      await enhance();
      new MutationObserver(() => enhance().catch(() => {}))
        .observe(list, { childList:true, subtree:true });
    } catch (e) {
      console.warn("Jawan support details unavailable:", e);
    }
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init, { once:true });
  } else {
    init();
  }
})();
