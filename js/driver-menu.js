// Jawan — shared driver hamburger menu.
(() => {
  function initDriverMenu() {
    // This file owns the only driver mobile menu.
    document.querySelectorAll('[data-jawan-driver-menu]').forEach((el, i) => {
      if (i > 0) el.remove();
    });
    if (document.querySelector('[data-jawan-driver-menu]')) return;

    const header = document.createElement('header');
    header.className = 'mobilebar jawan-driver-fixedbar';
    header.dataset.jawanDriverMenu = '1';
    header.innerHTML = `
      <strong>جوان</strong>
      <button id="driverMenuBtn" class="icon-btn" type="button" aria-label="فتح قائمة السائق" aria-expanded="false">
        <svg class="driver-menu-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true">
          <path d="M4 6h16"></path>
          <path d="M4 12h16"></path>
          <path d="M4 18h16"></path>
        </svg>
      </button>`;

    const backdrop = document.createElement('div');
    backdrop.id = 'driverMenuBackdrop';
    backdrop.className = 'driver-menu-backdrop';

    const menu = document.createElement('aside');
    menu.id = 'driverMenu';
    menu.className = 'driver-menu';
    menu.setAttribute('aria-hidden', 'true');
    menu.innerHTML = `
      <div class="driver-menu-head">
        <strong>قائمة السائق</strong>
        <button id="driverMenuClose" class="icon-btn" type="button" aria-label="إغلاق">×</button>
      </div>
      <a href="driver.html"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 12l8-8 8 8"></path><path d="M6 10v10h12V10"></path></svg>لوحتي</a>
      <a href="driver-orders.html"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 5h14v14H5z"></path><path d="M8 9h8M8 13h8M8 17h5"></path></svg>طلباتي السابقة</a>
      <a href="driver-analytics.html"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 20V10M12 20V4M19 20v-7"></path></svg>تحليلاتي</a>
      <a href="wallet.html"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 6h16v14H4z"></path><path d="M16 12h4"></path><path d="M7 6V4h10v2"></path></svg>شحن المحفظة</a>
      <a href="support.html"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 5h16v11H8l-4 4z"></path><path d="M8 9h8M8 12h5"></path></svg>الدعم داخل التطبيق</a>
      <a href="change-password.html"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="5" y="10" width="14" height="10" rx="2"></rect><path d="M8 10V7a4 4 0 0 1 8 0v3"></path><path d="M12 14v2"></path></svg>تغيير كلمة المرور</a>
      <a href="driver-profile.html"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="3"></circle><path d="M5 20a7 7 0 0 1 14 0"></path></svg>ملفي وبياناتي</a>
      <a data-whatsapp="contact" href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 11.5a8.4 8.4 0 0 1-12.4 7.4L4 20l1.1-4.2A8.4 8.4 0 1 1 21 11.5Z"></path><path d="M8.5 9.2c.3 1.8 2.4 3.7 4.2 4.1l1.4-1.1 1.3 1.2c.4.4.4 1-.1 1.3-3.1 1.6-7.9-3-6.4-6.1.2-.4.9-.5 1.2-.1l1.2 1.3-1 1.4c-.4-.2-1.5-1-1.8-1.9Z"></path></svg>راسلنا على واتساب</a>`;

    document.body.insertBefore(header, document.body.firstChild);
    document.body.appendChild(backdrop);
    document.body.appendChild(menu);
    document.body.classList.add('has-jawan-driver-menu');

    const btn = document.getElementById('driverMenuBtn');
    const closeBtn = document.getElementById('driverMenuClose');

    const setOpen = (open) => {
      menu.classList.toggle('open', open);
      backdrop.classList.toggle('open', open);
      menu.setAttribute('aria-hidden', String(!open));
      btn.setAttribute('aria-expanded', String(open));
      document.body.classList.toggle('menu-locked', open);
    };

    btn.addEventListener('click', () => setOpen(!menu.classList.contains('open')));
    closeBtn.addEventListener('click', () => setOpen(false));
    backdrop.addEventListener('click', () => setOpen(false));
    menu.querySelectorAll('a').forEach(a => a.addEventListener('click', () => setOpen(false)));
    document.addEventListener('keydown', e => { if (e.key === 'Escape') setOpen(false); });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initDriverMenu, { once: true });
  } else {
    initDriverMenu();
  }
})();
