(() => {
  const DRIVER_PAGES = new Set([
    "driver.html",
    "driver-orders.html",
    "driver-analytics.html"
  ]);

  const currentPage =
    location.pathname.split("/").pop() || "index.html";

  if (!DRIVER_PAGES.has(currentPage)) return;

  function initDriverMenu() {
    if (document.getElementById("jawanDriverMobileBar")) return;

    const oldBars = document.querySelectorAll(
      "body > header.mobilebar, body > header.driver-mobilebar"
    );

    oldBars.forEach((el) => el.remove());

    const header = document.createElement("header");
    header.id = "jawanDriverMobileBar";
    header.className = "jawan-driver-fixedbar";

    header.innerHTML = `
      <div class="driver-mobile-brand">
        <strong>جوان</strong>
        <span>السائق</span>
      </div>

      <button
        id="driverMenuBtn"
        class="driver-menu-btn"
        type="button"
        aria-label="فتح قائمة السائق"
        aria-expanded="false"
      >
        <svg viewBox="0 0 24 24" fill="none"
             stroke="currentColor"
             stroke-width="2"
             stroke-linecap="round">
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
        <div>
          <strong>قائمة السائق</strong>
          <small>جوان للتوصيل</small>
        </div>

        <button
          id="driverMenuClose"
          class="icon-btn"
          type="button"
          aria-label="إغلاق"
        >×</button>
      </div>

      <nav class="driver-menu-links">

        <a href="driver.html">
          <span>لوحتي</span>
        </a>

        <a href="driver-orders.html">
          <span>طلباتي السابقة</span>
        </a>

        <a href="driver-analytics.html">
          <span>تحليلاتي</span>
        </a>

        <a href="wallet.html">
          <span>المحفظة</span>
        </a>

        <a href="support.html">
          <span>الدعم داخل التطبيق</span>
        </a>

        <a href="change-password.html">
          <span>تغيير كلمة المرور</span>
        </a>

        <a href="driver-profile.html">
          <span>ملفي وبياناتي</span>
        </a>

        <a
          data-whatsapp="contact"
          href="#"
        >
          <span>راسلنا على واتساب</span>
        </a>

      </nav>
    `;

    document.body.prepend(header);
    document.body.appendChild(backdrop);
    document.body.appendChild(menu);

    document.body.classList.add("has-jawan-driver-menu");

    const btn =
      document.getElementById("driverMenuBtn");

    const closeBtn =
      document.getElementById("driverMenuClose");

    function closeMenu() {
      menu.classList.remove("open");
      backdrop.classList.remove("open");

      menu.setAttribute(
        "aria-hidden",
        "true"
      );

      btn?.setAttribute(
        "aria-expanded",
        "false"
      );

      document.body.classList.remove(
        "driver-menu-open"
      );
    }

    function openMenu() {
      menu.classList.add("open");
      backdrop.classList.add("open");

      menu.setAttribute(
        "aria-hidden",
        "false"
      );

      btn?.setAttribute(
        "aria-expanded",
        "true"
      );

      document.body.classList.add(
        "driver-menu-open"
      );
    }

    btn?.addEventListener(
      "click",
      (event) => {
        event.preventDefault();
        event.stopPropagation();

        if (menu.classList.contains("open")) {
          closeMenu();
        } else {
          openMenu();
        }
      }
    );

    closeBtn?.addEventListener(
      "click",
      closeMenu
    );

    backdrop.addEventListener(
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

    const active =
      menu.querySelector(
        `a[href="${currentPage}"]`
      );

    active?.classList.add("active");
  }

  if (
    document.readyState === "loading"
  ) {
    document.addEventListener(
      "DOMContentLoaded",
      initDriverMenu,
      { once: true }
    );
  } else {
    initDriverMenu();
  }
})();
