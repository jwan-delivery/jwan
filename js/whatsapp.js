const ADMIN_WHATSAPP = "249964499266";

export const whatsappMessages = {
  contact: "السلام عليكم، أرغب في التواصل مع إدارة جوان للتوصيل بخصوص استفسار أو مساعدة.",
  jobs: "السلام عليكم، أرغب في التقديم على فرصة عمل لدى جوان للتوصيل. أرجو تزويدي بالوظائف المتاحة وطريقة التقديم.",
  forgot_password: "السلام عليكم، نسيت كلمة المرور الخاصة بحسابي في جوان للتوصيل وأرغب في المساعدة في استعادة الوصول إلى حسابي.",
  driver_activation: "السلام عليكم، أنا سائق في جوان للتوصيل وأرغب في تفعيل حسابي. سأرسل المستندات المطلوبة وإشعار تحويل مبلغ التفعيل.",
  topup: "السلام عليكم، أرسلت مبلغ شحن محفظتي في جوان للتوصيل. أرجو مراجعة التحويل وتحديث الرصيد.",
  order_issue: "السلام عليكم، أواجه مشكلة في أحد طلبات التوصيل وأحتاج إلى مساعدة من الإدارة.",
  withdrawal: "السلام عليكم، أرسلت طلب سحب من محفظتي في جوان للتوصيل وأرغب في متابعة حالة الطلب.",
  support: "السلام عليكم، أحتاج إلى مساعدة من دعم جوان للتوصيل.",
};

export function openWhatsApp(message = whatsappMessages.contact) {
  const text = typeof message === "function" ? message() : message;
  const url = `https://wa.me/${ADMIN_WHATSAPP}?text=${encodeURIComponent(text || whatsappMessages.contact)}`;
  window.open(url, "_blank", "noopener");
}

export function bindWhatsAppLinks(root = document) {
  root.querySelectorAll("[data-whatsapp], a[href*='wa.me/']").forEach((el) => {
    if (el.dataset.whatsappBound === "1") return;

    let kind = el.dataset.whatsapp || "";
    const label = (el.textContent || "").trim();

    if (!kind && /(^|:)\/\/(?:www\.)?wa\.me\//i.test(el.href)) {
      el.dataset.whatsappBound = "1";
      el.target = el.target || "_blank";
      el.rel = el.rel || "noopener noreferrer";
      return;
    }

    if (!kind) {
      if (/نسيت كلمة المرور/.test(label)) kind = "forgot_password";
      else if (/فرص التوظيف|توظيف|وظائف/.test(label)) kind = "jobs";
      else if (/تواصل معنا|واتساب الإدارة|الدعم/.test(label)) kind = "contact";
      else return;
    }

    el.dataset.whatsappBound = "1";
    el.href = "#";
    el.addEventListener("click", (event) => {
      event.preventDefault();
      let message = whatsappMessages[kind] || whatsappMessages.contact;

      if (kind === "forgot_password") {
        const phoneInput = document.querySelector("[name='phone']");
        const phone = phoneInput?.value?.trim();
        if (phone) message += ` رقم الهاتف: ${phone}`;
      }

      openWhatsApp(message);
    });
  });
}
