#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$ROOT" ]; then
  echo "نفّذ السكربت من داخل مستودع Jawan."
  exit 1
fi
cd "$ROOT"

TS="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR=".jawan-backups/$TS"

git switch -c "fix/mobile-production-$TS" 2>/dev/null || git switch "fix/mobile-production-$TS" || true

mkdir -p "$BACKUP_DIR"
for f in css/style.css js/app.js js/auth.js js/driver-menu.js js/jawan-ai.js \
  pages/admin.html pages/admin-orders.html pages/admin-users.html \
  pages/admin-topups.html pages/admin-withdrawals.html \
  pages/admin-analytics.html pages/admin-managers.html pages/support.html
do
  [ -f "$f" ] && cp -a "$f" "$BACKUP_DIR/"
done

cat >> css/style.css <<'CSS'

/* ===== JAWAN MOBILE POLISH ===== */
html, body, body * {
  -webkit-user-select: none;
  user-select: none;
  -webkit-touch-callout: none;
}
input, textarea, select, option, [contenteditable="true"] {
  -webkit-user-select: text !important;
  user-select: text !important;
  -webkit-touch-callout: default !important;
}
html {
  -webkit-text-size-adjust: 100%;
  text-size-adjust: 100%;
  overscroll-behavior-y: contain;
}
body {
  overscroll-behavior-y: contain;
  -webkit-tap-highlight-color: transparent;
}
button, a, .btn {
  -webkit-tap-highlight-color: transparent;
  touch-action: manipulation;
}
#jawan-offline-banner {
  position: fixed;
  top: max(10px, env(safe-area-inset-top, 0px));
  left: 12px;
  right: 12px;
  z-index: 2147483647;
  display: none;
  align-items: center;
  gap: 10px;
  padding: 12px 14px;
  background: #7f1d1d;
  color: #fff;
  border-radius: 14px;
  box-shadow: 0 12px 30px rgba(0,0,0,.25);
  font-size: 13px;
  font-weight: 800;
  direction: rtl;
}
#jawan-offline-banner.is-visible { display:flex; }

.has-jawan-driver-menu .jawan-driver-fixedbar {
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  right: 0 !important;
  z-index: 2147483000 !important;
  min-height: 58px;
  padding-top: env(safe-area-inset-top, 0px);
  padding-left: 14px;
  padding-right: 14px;
  background: #111827;
  color: #fff;
}
.has-jawan-driver-menu .app-shell { padding-top: 64px; }

.driver-menu-backdrop {
  position: fixed !important;
  inset: 0 !important;
  background: rgba(0,0,0,.45);
  opacity: 0;
  visibility: hidden;
  pointer-events: none;
  z-index: 2147483001 !important;
  transition: opacity .18s ease, visibility .18s ease;
}
.driver-menu-backdrop.open {
  opacity: 1;
  visibility: visible;
  pointer-events: auto;
}
.driver-menu {
  position: fixed !important;
  top: 0 !important;
  right: 0 !important;
  bottom: 0 !important;
  width: min(86vw,340px) !important;
  padding-top: max(10px,env(safe-area-inset-top,0px));
  padding-bottom: env(safe-area-inset-bottom,0px);
  z-index: 2147483002 !important;
  background: #111827;
  color: #fff;
  transform: translateX(105%);
  transition: transform .2s ease;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
  direction: rtl;
}
.driver-menu.open { transform: translateX(0); }
.driver-menu a {
  display:flex !important;
  align-items:center;
  gap:10px;
  min-height:54px;
  padding:12px 16px;
  color:#fff !important;
  text-decoration:none !important;
  border-bottom:1px solid rgba(255,255,255,.08);
}
body.menu-locked { overflow:hidden !important; }

body.admin-page { padding-top: calc(58px + env(safe-area-inset-top,0px)); }
body.admin-page .content { padding-top: 10px; }
.admin-mobilebar {
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  right: 0 !important;
  z-index: 2147482000 !important;
  min-height:58px;
  padding-top:env(safe-area-inset-top,0px);
  background:#111827;
}
.admin-mobilebar .admin-menu-btn {
  width:46px !important;
  height:46px !important;
  margin:6px !important;
  border:0 !important;
  background:transparent !important;
  color:#fff !important;
}
.admin-menu-overlay { z-index:2147482001 !important; }
.admin-hamburger { z-index:2147482002 !important; }

.support-admin-user-card {
  margin-top:8px;
  padding:12px;
  border:1px solid #e5e7eb;
  border-radius:14px;
  background:#f9fafb;
  line-height:1.8;
  font-size:13px;
}
.support-admin-user-grid {
  display:grid;
  grid-template-columns:repeat(2,minmax(0,1fr));
  gap:6px 12px;
}
@media (max-width:600px) {
  .support-admin-user-grid { grid-template-columns:1fr; }
}
CSS

cat > js/admin-menu.js <<'JS'
(() => {
  const ADMIN_PAGES = new Set([
    "admin.html",
    "admin-orders.html",
    "admin-users.html",
    "admin-topups.html",
    "admin-withdrawals.html",
    "admin-analytics.html",
    "admin-managers.html"
  ]);

  const currentPage = location.pathname.split("/").pop() || "index.html";
  if (!ADMIN_PAGES.has(currentPage)) return;

  document.body.classList.add("admin-page");

  function init() {
    if (document.getElementById("jawanAdminMobileBar")) return;

    document.querySelectorAll("body > header.mobilebar").forEach(el => el.remove());

    const bar = document.createElement("header");
    bar.id = "jawanAdminMobileBar";
    bar.className = "admin-mobilebar";
    bar.innerHTML = `
      <div class="admin-mobile-brand">
        <div class="brand-mark">
          <img src="/assets/branding/logo-external.png" alt="جوان للتوصيل">
        </div>
        <strong>جوان — الإدارة</strong>
      </div>
      <button type="button" class="admin-menu-btn"
              id="jawanAdminMenuBtn"
              aria-label="فتح قائمة الإدارة"
              aria-expanded="false">
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <path d="M4 6h16M4 12h16M4 18h16" fill="none"
                stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
        </svg>
      </button>
    `;

    const overlay = document.createElement("div");
    overlay.id = "jawanAdminMenuOverlay";
    overlay.className = "admin-menu-overlay";

    const menu = document.createElement("aside");
    menu.id = "jawanAdminMenu";
    menu.className = "admin-hamburger";
    menu.setAttribute("aria-hidden", "true");
    menu.innerHTML = `
      <div class="admin-menu-header">
        <div class="brand-mark">
          <img src="/assets/branding/logo-external.png" alt="جوان للتوصيل">
        </div>
        <div>
          <strong>جوان للتوصيل</strong>
          <small>الإدارة</small>
        </div>
      </div>

      <div class="admin-menu-head">
        <strong>قائمة الإدارة</strong>
        <button type="button" id="jawanAdminMenuClose"
                class="icon-btn" aria-label="إغلاق">×</button>
      </div>

      <div class="admin-menu-links">
        <a href="admin.html">لوحة الإدارة</a>
        <a href="admin-orders.html">كل الطلبات</a>
        <a href="admin-users.html">المستخدمون والسائقون</a>
        <a href="admin-topups.html">شحن المحافظ</a>
        <a href="admin-withdrawals.html">السحوبات</a>
        <a href="admin-analytics.html">التحليلات</a>
        <a href="admin-managers.html">إدارة المدراء</a>
        <a href="support.html">الدعم</a>
      </div>

      <div class="admin-menu-footer">
        <button type="button" id="jawanAdminLogout">تسجيل الخروج</button>
      </div>
    `;

    document.body.prepend(bar);
    document.body.appendChild(overlay);
    document.body.appendChild(menu);

    const btn = document.getElementById("jawanAdminMenuBtn");
    const closeBtn = document.getElementById("jawanAdminMenuClose");

    function closeMenu() {
      menu.classList.remove("open");
      overlay.classList.remove("open");
      menu.setAttribute("aria-hidden", "true");
      btn?.setAttribute("aria-expanded", "false");
      document.body.classList.remove("admin-menu-open");
    }

    function openMenu() {
      menu.classList.add("open");
      overlay.classList.add("open");
      menu.setAttribute("aria-hidden", "false");
      btn?.setAttribute("aria-expanded", "true");
      document.body.classList.add("admin-menu-open");
    }

    btn?.addEventListener("click", e => {
      e.preventDefault();
      e.stopPropagation();
      menu.classList.contains("open") ? closeMenu() : openMenu();
    });
    closeBtn?.addEventListener("click", closeMenu);
    overlay.addEventListener("click", closeMenu);
    menu.querySelectorAll("a").forEach(a => a.addEventListener("click", closeMenu));
    document.addEventListener("keydown", e => {
      if (e.key === "Escape") closeMenu();
    });

    document.getElementById("jawanAdminLogout")?.addEventListener("click", async () => {
      try {
        const { logoutUser } = await import("./auth.js");
        await logoutUser();
      } finally {
        location.href = "login.html";
      }
    });

    const active = menu.querySelector(`a[href="${currentPage}"]`);
    if (active) active.classList.add("active");
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init, { once:true });
  } else {
    init();
  }
})();
JS

cat > js/driver-menu.js <<'JS'
(() => {
  function initDriverMenu() {
    if (document.querySelector("[data-jawan-driver-menu]")) return;

    const header = document.createElement("header");
    header.className = "mobilebar jawan-driver-fixedbar";
    header.dataset.jawanDriverMenu = "1";
    header.innerHTML = `
      <strong>جوان</strong>
      <button id="driverMenuBtn" class="icon-btn" type="button"
              aria-label="فتح قائمة السائق" aria-expanded="false">
        <svg class="driver-menu-icon" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round">
          <path d="M4 6h16"></path>
          <path d="M4 12h16"></path>
          <path d="M4 18h16"></path>
        </svg>
      </button>
    `;

    const backdrop = document.createElement("div");
    backdrop.id = "driverMenuBackdrop";
    backdrop.className = "driver-menu-backdrop";

    const menu = document.createElement("aside");
    menu.id = "driverMenu";
    menu.className = "driver-menu";
    menu.setAttribute("aria-hidden", "true");
    menu.innerHTML = `
      <div class="driver-menu-head">
        <strong>قائمة السائق</strong>
        <button id="driverMenuClose" class="icon-btn" type="button"
                aria-label="إغلاق">×</button>
      </div>
      <a href="driver.html">لوحتي</a>
      <a href="driver-orders.html">طلباتي السابقة</a>
      <a href="driver-analytics.html">تحليلاتي</a>
      <a href="wallet.html">شحن المحفظة</a>
      <a href="support.html">الدعم داخل التطبيق</a>
      <a href="change-password.html">تغيير كلمة المرور</a>
      <a href="driver-profile.html">ملفي وبياناتي</a>
      <a data-whatsapp="contact" href="#">راسلنا على واتساب</a>
    `;

    document.body.insertBefore(header, document.body.firstChild);
    document.body.appendChild(backdrop);
    document.body.appendChild(menu);
    document.body.classList.add("has-jawan-driver-menu");

    const btn = document.getElementById("driverMenuBtn");
    const closeBtn = document.getElementById("driverMenuClose");

    const setOpen = open => {
      menu.classList.toggle("open", open);
      backdrop.classList.toggle("open", open);
      menu.setAttribute("aria-hidden", String(!open));
      btn?.setAttribute("aria-expanded", String(open));
      document.body.classList.toggle("menu-locked", open);
    };

    btn?.addEventListener("click", e => {
      e.preventDefault();
      e.stopPropagation();
      setOpen(!menu.classList.contains("open"));
    });
    closeBtn?.addEventListener("click", () => setOpen(false));
    backdrop.addEventListener("click", () => setOpen(false));
    menu.querySelectorAll("a").forEach(a => a.addEventListener("click", () => setOpen(false)));
    document.addEventListener("keydown", e => {
      if (e.key === "Escape") setOpen(false);
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initDriverMenu, { once:true });
  } else {
    initDriverMenu();
  }
})();
JS

cat >> js/app.js <<'JS'

/* ===== JWAN CONNECTIVITY + ROLE RESTORE ===== */
(() => {
  function initOfflineBanner() {
    if (document.getElementById("jawan-offline-banner")) return;
    const banner = document.createElement("div");
    banner.id = "jawan-offline-banner";
    banner.innerHTML = `
      <span class="offline-icon">⚠️</span>
      <span>أنت غير متصل بالإنترنت. بعض وظائف جوان لن تعمل حتى يعود الاتصال.</span>
    `;
    document.body.appendChild(banner);

    const update = () => banner.classList.toggle("is-visible", !navigator.onLine);
    window.addEventListener("online", update, { passive:true });
    window.addEventListener("offline", update, { passive:true });
    update();
  }

  async function restoreRolePage() {
    const file = location.pathname.split("/").pop() || "index.html";
    if (!["", "index.html", "login.html"].includes(file)) return;

    try {
      const { auth } = await import("./firebase-config.js");
      const { getCurrentUserData, roleHome } = await import("./auth.js");
      auth.onAuthStateChanged(async user => {
        if (!user) return;
        const data = await getCurrentUserData(user.uid).catch(() => null);
        if (!data) return;
        const home = roleHome(data.role);
        if (!home) return;

        localStorage.setItem("jawan:lastRole", data.role);
        localStorage.setItem("jawan:lastRoleHome", home);

        const target = home.split("/").pop();
        if (target !== file) location.replace(home);
      });
    } catch (e) {
      console.warn("Jawan role restore skipped:", e);
    }
  }

  const start = () => {
    initOfflineBanner();
    restoreRolePage();
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", start, { once:true });
  } else {
    start();
  }
})();
JS

python3 - <<'PY'
from pathlib import Path
p = Path("js/jawan-ai.js")
s = p.read_text(encoding="utf-8")
old = '''    addMessage(
      "تعذر الاتصال بـ Gemini حاليًا.\\n\\n" +
      "السبب: " +
      (error?.message || "خطأ غير معروف"),
      "bot"
    );'''
new = '''    const rawMessage = String(error?.message || "");
    let friendly = "تعذر تشغيل الذكاء الاصطناعي حاليًا.";

    if (!navigator.onLine) {
      friendly = "لا يوجد اتصال بالإنترنت حاليًا. اتصل بالإنترنت ثم حاول مرة أخرى.";
    } else if (
      rawMessage.includes("appCheck/recaptcha-error") ||
      rawMessage.includes("AppCheck") ||
      rawMessage.includes("reCAPTCHA")
    ) {
      friendly =
        "ميزة AI تحتاج تحققًا أمنيًا من Firebase. إذا استمرت المشكلة، يحتاج إعداد App Check لتطبيق الهاتف إلى الضبط الصحيح.";
    } else if (
      rawMessage.includes("permission-denied") ||
      rawMessage.includes("403")
    ) {
      friendly =
        "ميزة AI محمية حاليًا بواسطة Firebase App Check ولم يتم قبول هذا التطبيق بعد.";
    }

    addMessage(friendly, "bot");'''
if old in s:
    s = s.replace(old, new, 1)
else:
    print("AI block not found; skipped")
p.write_text(s, encoding="utf-8")
PY

python3 - <<'PY'
from pathlib import Path
pages = [
    "admin.html","admin-orders.html","admin-users.html",
    "admin-topups.html","admin-withdrawals.html",
    "admin-analytics.html","admin-managers.html"
]
for name in pages:
    p = Path("pages")/name
    if not p.exists(): continue
    s = p.read_text(encoding="utf-8")
    s = s.replace("<body>", '<body class="admin-page">', 1)
    tag = '<script src="../js/admin-menu.js"></script>'
    if tag not in s:
        marker = '<script type="module" src="../js/app.js"></script>'
        if marker in s:
            s = s.replace(marker, marker + "\n" + tag, 1)
        else:
            s = s.replace("</body>", tag + "\n</body>", 1)
    p.write_text(s, encoding="utf-8")
PY

cat > js/admin-order-delete.js <<'JS'
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
JS

python3 - <<'PY'
from pathlib import Path
p = Path("pages/admin-orders.html")
if p.exists():
    s = p.read_text(encoding="utf-8")
    tag = '<script src="../js/admin-order-delete.js"></script>'
    if tag not in s:
        s = s.replace("</body>", tag + "\n</body>", 1)
    p.write_text(s, encoding="utf-8")
PY

cat > js/admin-support-details.js <<'JS'
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
JS

python3 - <<'PY'
from pathlib import Path
p = Path("pages/support.html")
if p.exists():
    s = p.read_text(encoding="utf-8")
    tag = '<script src="../js/admin-support-details.js"></script>'
    if tag not in s:
        s = s.replace("</body>", tag + "\n</body>", 1)
    p.write_text(s, encoding="utf-8")
PY

# Remove duplicate driver menu code from driver.html
python3 - <<'PY'
from pathlib import Path
p=Path("pages/driver.html")
if p.exists():
    s=p.read_text(encoding="utf-8")
    start='const driverMenuBtn = document.getElementById("driverMenuBtn");'
    end='driverMenu?.querySelectorAll(".a").forEach(a=>a.addEventListener("click",()=>setDriverMenu(false)));'
    # Current file uses selector "a", so find by prefix and end at exact statement.
    a=s.find(start)
    if a!=-1:
        marker='driverMenu?.querySelectorAll("a").forEach(a=>a.addEventListener("click",()=>setDriverMenu(false)));'
        b=s.find(marker,a)
        if b!=-1:
            b+=len(marker)
            s=s[:a]+s[b:]
    p.write_text(s,encoding="utf-8")
PY

# Prepare Android icon source
if [ -f assets/branding/logo-external.png ]; then
  mkdir -p mobile-app/resources
  cp -f assets/branding/logo-external.png mobile-app/resources/icon.png
  echo "Logo copied to mobile-app/resources/icon.png"
fi

if command -v node >/dev/null 2>&1; then
  for f in js/app.js js/admin-menu.js js/driver-menu.js js/admin-order-delete.js js/admin-support-details.js js/jawan-ai.js; do
    node --check "$f"
  done
fi

echo
echo "تمت التعديلات المحلية."
echo "النسخة الاحتياطية: $BACKUP_DIR"
echo
echo "راجع:"
echo "  git status"
echo "  git diff --stat"
echo
echo "ثم:"
echo "  git add ."
echo "  git commit -m 'Polish mobile app and admin experience'"
echo "  git push -u origin HEAD"
