import { normalizePhone } from "./common.js";
import { bindWhatsAppLinks } from "./whatsapp.js";
import { initPushNotifications, enablePushNotifications } from "./notifications.js";
import { auth } from "./firebase-config.js";

// نقطة تهيئة مشتركة للصفحات.
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-phone]").forEach(input => {
    input.maxLength = 10;
    input.inputMode = "numeric";
    input.addEventListener("input", () => {
      input.value = normalizePhone(input.value);
    });
  });

  bindWhatsAppLinks(document);

  if ("serviceWorker" in navigator) {
    navigator.serviceWorker.register("/sw.js")
      .then(() => initPushNotifications())
      .catch(() => {});
  }
});


function initLandingHamburger() {
  if (!document.body.classList.contains("landing")) return;

  const header = document.querySelector(".topbar");
  if (!header) return;

  let button = document.querySelector(".jawan-hamburger, .menu-toggle, .menu-btn, #menuBtn, #menuToggle, #hamburgerBtn");
  if (!button) {
    button = document.createElement("button");
    button.type = "button";
    button.setAttribute("aria-label", "فتح القائمة");
    button.setAttribute("aria-expanded", "false");
    button.className = "jawan-hamburger";
    header.insertBefore(button, header.firstChild);
  }

  button.classList.add("jawan-hamburger");
  button.setAttribute("aria-label", "فتح القائمة");
  button.innerHTML = "<span></span><span></span><span></span>";

  let backdrop = document.querySelector(".jawan-drawer-backdrop");
  let drawer = document.querySelector(".jawan-drawer, .drawer, .side-drawer");

  if (!drawer) {
    backdrop = backdrop || document.createElement("div");
    backdrop.className = "jawan-drawer-backdrop";
    document.body.appendChild(backdrop);

    drawer = document.createElement("aside");
    drawer.className = "jawan-drawer";
    drawer.setAttribute("aria-hidden", "true");
    drawer.innerHTML = `
      <button class="drawer-close" type="button" aria-label="إغلاق القائمة">×</button>
      <a href="index.html">الرئيسية</a>
      <a href="pages/terms.html">الشروط والأحكام</a>
      <a href="pages/privacy.html">سياسة الخصوصية</a>
      <a data-whatsapp="contact" href="#">تواصل معنا</a>
      <a data-whatsapp="jobs" href="#">فرص التوظيف</a>
      <a href="pages/register.html">إنشاء حساب</a>
      <a href="pages/login.html">تسجيل الدخول</a>`;
    document.body.appendChild(drawer);
    backdrop.addEventListener("click", closeDrawer);
    drawer.querySelector(".drawer-close").addEventListener("click", closeDrawer);
  }

  function openDrawer() {
    drawer.classList.add("is-open");
    backdrop?.classList.add("is-open");
    drawer.setAttribute("aria-hidden", "false");
    button.setAttribute("aria-expanded", "true");
  }
  function closeDrawer() {
    drawer.classList.remove("is-open");
    backdrop?.classList.remove("is-open");
    drawer.setAttribute("aria-hidden", "true");
    button.setAttribute("aria-expanded", "false");
  }

  button.addEventListener("click", () => {
    drawer.classList.contains("is-open") ? closeDrawer() : openDrawer();
  });

  drawer.querySelectorAll("a").forEach((a) => a.addEventListener("click", closeDrawer));
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initLandingHamburger, { once: true });
} else {
  initLandingHamburger();
}


// Final navigation polish: prefetch local pages and use a tiny exit transition.
(function initJawanNavigationPolish(){
  const prefetched = new Set();
  const prefetch = (href) => {
    if (!href || prefetched.has(href)) return;
    try { const u = new URL(href, location.href); if (u.origin !== location.origin) return; if (!u.pathname.endsWith('.html') && u.pathname !== '/') return; } catch { return; }
    prefetched.add(href);
    fetch(href, { credentials: 'same-origin' }).catch(() => {});
  };
  document.addEventListener('pointerover', (e) => {
    const a = e.target.closest?.('a[href]');
    if (a) prefetch(a.href);
  }, { passive:true });
  document.addEventListener('click', (e) => {
    const a = e.target.closest?.('a[href]');
    if (!a || e.defaultPrevented) return;
    if (a.target === '_blank' || a.hasAttribute('download') || a.href.startsWith('javascript:')) return;
    const u = new URL(a.href, location.href);
    if (u.origin !== location.origin || u.hash && u.pathname === location.pathname) return;
    e.preventDefault();
    document.body.classList.add('jawan-page-exit');
    setTimeout(() => { location.href = a.href; }, 150);
  }, { capture:true });
})();


// ============================================================
// JWAN - Friendly Push Notification Alert
// ============================================================

function showJwanNotificationAlert() {
  if (!document.body) return;
  if (document.getElementById("jwan-notification-alert")) return;

  if (!("Notification" in window)) return;

  // Already allowed -> no need to show the alert
  if (Notification.permission === "granted") return;

  // User already denied -> don't keep annoying them
  if (Notification.permission === "denied") return;

  const box = document.createElement("div");

  box.id = "jwan-notification-alert";

  box.innerHTML = `
    <div class="jwan-notification-icon">🔔</div>

    <div class="jwan-notification-content">
      <div class="jwan-notification-title">
        فعّل إشعارات JWAN
      </div>

      <div class="jwan-notification-text">
        عشان ما يفوتك طلب جديد أو تحديث مهم على طلبك.
      </div>

      <div class="jwan-notification-actions">
        <button id="jwan-notification-enable">
          تفعيل الآن
        </button>

        <button id="jwan-notification-later">
          لاحقًا
        </button>
      </div>
    </div>

    <button id="jwan-notification-close"
            aria-label="إغلاق">
      ×
    </button>
  `;

  const style = document.createElement("style");

  style.textContent = `
    #jwan-notification-alert {
      position: fixed;
      left: 16px;
      right: 16px;
      bottom: 18px;
      z-index: 2147483647;

      display: flex;
      align-items: flex-start;
      gap: 12px;

      padding: 16px;

      background: rgba(255,255,255,.98);
      color: #111827;

      border: 1px solid rgba(17,24,39,.08);
      border-radius: 18px;

      box-shadow:
        0 12px 35px rgba(0,0,0,.18);

      font-family:
        system-ui,
        -apple-system,
        BlinkMacSystemFont,
        "Segoe UI",
        sans-serif;

      direction: rtl;

      animation: jwanNotificationIn .35s ease-out;
    }

    #jwan-notification-alert .jwan-notification-icon {
      width: 44px;
      height: 44px;

      flex: 0 0 44px;

      display: flex;
      align-items: center;
      justify-content: center;

      border-radius: 14px;
      background: #f3f4f6;

      font-size: 23px;
    }

    #jwan-notification-alert .jwan-notification-content {
      flex: 1;
      min-width: 0;
    }

    #jwan-notification-alert .jwan-notification-title {
      font-size: 16px;
      font-weight: 800;
      margin-bottom: 4px;
    }

    #jwan-notification-alert .jwan-notification-text {
      font-size: 13px;
      line-height: 1.6;
      color: #6b7280;
    }

    #jwan-notification-alert .jwan-notification-actions {
      display: flex;
      gap: 8px;
      margin-top: 12px;
    }

    #jwan-notification-enable {
      border: 0;
      border-radius: 10px;
      padding: 9px 15px;

      background: #111827;
      color: white;

      font-size: 13px;
      font-weight: 700;

      cursor: pointer;
    }

    #jwan-notification-enable:disabled {
      opacity: .6;
      cursor: wait;
    }

    #jwan-notification-later {
      border: 0;
      background: transparent;

      color: #6b7280;

      padding: 9px 10px;
      font-size: 13px;

      cursor: pointer;
    }

    #jwan-notification-close {
      border: 0;
      background: transparent;

      color: #9ca3af;

      font-size: 22px;
      line-height: 1;

      cursor: pointer;
      padding: 0 4px;
    }

    @keyframes jwanNotificationIn {
      from {
        opacity: 0;
        transform: translateY(20px);
      }

      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    @media (min-width: 700px) {
      #jwan-notification-alert {
        left: auto;
        right: 24px;
        width: 390px;
      }
    }
  `;

  document.head.appendChild(style);
  document.body.appendChild(box);

  const close = () => {
    box.style.opacity = "0";
    box.style.transform = "translateY(20px)";

    setTimeout(() => {
      box.remove();
      style.remove();
    }, 200);
  };

  document
    .getElementById("jwan-notification-close")
    .addEventListener("click", close);

  document
    .getElementById("jwan-notification-later")
    .addEventListener("click", close);

  document
    .getElementById("jwan-notification-enable")
    .addEventListener("click", async () => {

      const button =
        document.getElementById("jwan-notification-enable");

      button.disabled = true;
      button.textContent = "⏳ جاري التفعيل...";

      const result =
        await enablePushNotifications();

      if (result.success) {
        button.textContent = "✅ تم التفعيل";

        setTimeout(close, 800);
      } else {
        console.error(
          "JW​AN notification permission error:",
          result.error
        );

        button.disabled = false;
        button.textContent = "تفعيل الآن";

        const msg =
          result?.error?.message ||
          String(result?.error) ||
          "خطأ غير معروف";

        alert(
          "فشل تفعيل الإشعارات:\n\n" + msg
        );
      }
    });
}

// Show the friendly alert shortly after the page is ready.
function scheduleJwanNotificationAlert() {
  if (!("Notification" in window)) return;

  if (Notification.permission === "granted") return;
  if (Notification.permission === "denied") return;

  setTimeout(() => {
    // الإشعارات مرتبطة بحساب المستخدم، لذلك لا تظهر للزائر.
    if (!auth.currentUser) return;

    showJwanNotificationAlert();
  }, 1800);
}

// ننتظر تسجيل الدخول ثم نعرض التنبيه للمستخدم المسجل فقط.
auth.onAuthStateChanged((user) => {
  if (!user) return;

  if (Notification.permission === "granted") return;
  if (Notification.permission === "denied") return;

  scheduleJwanNotificationAlert();
});
