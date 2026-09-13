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

  const currentPage =
    location.pathname.split("/").pop() || "index.html";

  if (!ADMIN_PAGES.has(currentPage)) return;

  function init() {
    if (
      document.getElementById(
        "jawanAdminMobileBar"
      )
    ) {
      return;
    }

    /*
     * إزالة أي قائمة إدارية قديمة
     * حتى لا توجد قائمتان فوق بعضهما.
     */

    document
      .querySelectorAll(
        "#adminMenuBtn," +
        "#adminMenuOverlay," +
        "#adminHamburger"
      )
      .forEach((el) => {
        if (
          el.closest("body")
        ) {
          const parent =
            el.closest(
              "header,nav,div"
            );

          if (
            parent &&
            (
              parent.id ===
                "adminHamburger" ||
              parent.id ===
                "adminMenuOverlay"
            )
          ) {
            parent.remove();
          } else {
            el.remove();
          }
        }
      });

    const oldHeader =
      document.querySelector(
        "body > header.mobilebar"
      );

    oldHeader?.remove();

    const bar =
      document.createElement("header");

    bar.id =
      "jawanAdminMobileBar";

    bar.className =
      "admin-mobilebar";

    bar.innerHTML = `
      <div class="admin-mobile-brand">
        <div class="brand-mark">
          <img
            src="/assets/branding/logo-external.png"
            alt="جوان للتوصيل"
          >
        </div>

        <strong>
          جوان — الإدارة
        </strong>
      </div>

      <button
        type="button"
        class="admin-menu-btn"
        id="jawanAdminMenuBtn"
        aria-label="فتح قائمة الإدارة"
        aria-expanded="false"
      >
        <svg viewBox="0 0 24 24">
          <path
            d="M4 6h16M4 12h16M4 18h16"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
          />
        </svg>
      </button>
    `;

    const overlay =
      document.createElement("div");

    overlay.id =
      "jawanAdminMenuOverlay";

    overlay.className =
      "admin-menu-overlay";

    const menu =
      document.createElement("aside");

    menu.id =
      "jawanAdminMenu";

    menu.className =
      "admin-hamburger";

    menu.setAttribute(
      "aria-hidden",
      "true"
    );

    menu.innerHTML = `
      <div class="admin-menu-header">

        <div class="brand-mark">
          <img
            src="/assets/branding/logo-external.png"
            alt="جوان للتوصيل"
          >
        </div>

        <div>
          <strong>
            جوان للتوصيل
          </strong>

          <small>
            الإدارة
          </small>
        </div>

      </div>

      <div class="admin-menu-head">

        <strong>
          قائمة الإدارة
        </strong>

        <button
          type="button"
          id="jawanAdminMenuClose"
          class="icon-btn"
          aria-label="إغلاق"
        >×</button>

      </div>

      <div class="admin-menu-links">

        <a href="admin.html">
          لوحة الإدارة
        </a>

        <a href="admin-orders.html">
          كل الطلبات
        </a>

        <a href="admin-users.html">
          المستخدمون والسائقون
        </a>

        <a href="admin-topups.html">
          شحن المحافظ
        </a>

        <a href="admin-withdrawals.html">
          السحوبات
        </a>

        <a href="admin-analytics.html">
          التحليلات
        </a>

        <a href="admin-managers.html">
          إدارة المدراء
        </a>

        <a href="support.html">
          الدعم
        </a>

      </div>

      <div class="admin-menu-footer">

        <button
          type="button"
          id="jawanAdminLogout"
        >
          تسجيل الخروج
        </button>

      </div>
    `;

    document.body.prepend(bar);
    document.body.appendChild(overlay);
    document.body.appendChild(menu);

    const btn =
      document.getElementById(
        "jawanAdminMenuBtn"
      );

    const closeBtn =
      document.getElementById(
        "jawanAdminMenuClose"
      );

    function closeMenu() {

      menu.classList.remove("open");

      overlay.classList.remove("open");

      menu.setAttribute(
        "aria-hidden",
        "true"
      );

      btn?.setAttribute(
        "aria-expanded",
        "false"
      );

      document.body.classList.remove(
        "admin-menu-open"
      );
    }

    function openMenu() {

      menu.classList.add("open");

      overlay.classList.add("open");

      menu.setAttribute(
        "aria-hidden",
        "false"
      );

      btn?.setAttribute(
        "aria-expanded",
        "true"
      );

      document.body.classList.add(
        "admin-menu-open"
      );
    }

    btn?.addEventListener(
      "click",
      (event) => {

        event.preventDefault();
        event.stopPropagation();

        menu.classList.contains("open")
          ? closeMenu()
          : openMenu();
      }
    );

    closeBtn?.addEventListener(
      "click",
      closeMenu
    );

    overlay.addEventListener(
      "click",
      closeMenu
    );

    menu
      .querySelectorAll("a")
      .forEach((link) => {
        link.addEventListener(
          "click",
          closeMenu
        );
      });

    document.addEventListener(
      "keydown",
      (event) => {
        if (event.key === "Escape") {
          closeMenu();
        }
      }
    );

    document
      .getElementById(
        "jawanAdminLogout"
      )
      ?.addEventListener(
        "click",
        async () => {

          try {

            const {
              logoutUser
            } = await import(
              "./auth.js"
            );

            await logoutUser();

          } finally {

            location.href =
              "login.html";
          }
        }
      );

    const active =
      menu.querySelector(
        `a[href="${currentPage}"]`
      );

    active?.classList.add(
      "active"
    );
  }

  if (
    document.readyState ===
    "loading"
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
