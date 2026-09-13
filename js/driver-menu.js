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
