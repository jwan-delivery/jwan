export function showToast(message) {
  let el = document.querySelector(".toast");
  if (!el) {
    el = document.createElement("div");
    el.className = "toast";
    document.body.appendChild(el);
  }
  el.textContent = message;
  el.classList.add("show");
  clearTimeout(window.__toastTimer);
  window.__toastTimer = setTimeout(() => el.classList.remove("show"), 2600);
}

export function normalizePhone(value) {
  return String(value || "").replace(/\D/g, "").slice(0, 10);
}

export function formatMoney(value) {
  return Number(value || 0).toLocaleString("ar-SD") + " ج.س";
}

export function statusLabel(status) {
  const map = {
    pending: "بانتظار سائق",
    accepted: "تم قبول الطلب",
    delivering: "قيد التوصيل",
    awaiting_confirmation: "بانتظار التأكيد",
    completed: "مكتمل",
    cancelled: "ملغي",
    rejected: "مرفوض"
  };
  return map[status] || status;
}

export function statusBadgeClass(status) {
  if (["completed", "active", "approved", "paid", "answered"].includes(status)) return "badge badge-ok";
  if (["cancelled", "rejected", "suspended"].includes(status)) return "badge badge-danger";
  if (["pending", "open"].includes(status)) return "badge badge-pending";
  return "badge badge-info";
}

export function accountStatusLabel(status) {
  const map = {
    pending: "بانتظار المراجعة",
    active: "مفعّل",
    suspended: "موقوف",
    rejected: "مرفوض"
  };
  return map[status] || status;
}

// يمنع أي نص قادم من المستخدم (اسم، وصف طلب، رسالة دعم...) من التحول
// إلى HTML عند إدراجه داخل الصفحة عبر innerHTML.
export function escapeHtml(value) {
  return String(value ?? "").replace(/[&<>"']/g, (ch) => ({
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#39;"
  }[ch]));
}

export function formatDate(value) {
  const date = value && typeof value.toDate === "function" ? value.toDate() : value;
  if (!(date instanceof Date) || isNaN(date)) return "—";
  return date.toLocaleString("ar-SD", { dateStyle: "short", timeStyle: "short" });
}

export function openWhatsApp(message = "") {
  const encoded = encodeURIComponent(message);
  window.open(`https://wa.me/249964499266?text=${encoded}`, "_blank", "noopener");
}
