const CACHE = "jawan-v16";

const STATIC_ASSETS = [
  "/",
  "/index.html",
  "/manifest.webmanifest",

  "/css/style.css",

  "/js/app.js",
  "/js/firebase-config.js",
  "/js/auth.js",
  "/js/common.js",
  "/js/admin.js",
  "/js/notifications.js",
  "/js/orders.js",
  "/js/ratings.js",
  "/js/support.js",
  "/js/wallet.js",
  "/js/jawan-ai.js",

  "/assets/icons/icon-192.svg",
  "/assets/icons/icon-512.svg",

  "/pages/login.html",
  "/pages/register.html",
  "/pages/customer.html",
  "/pages/driver.html",
  "/pages/wallet.html",
  "/pages/create-order.html",
  "/pages/support.html",
  "/pages/negotiation.html",
  "/pages/driver-orders.html",
  "/pages/driver-analytics.html",
  "/pages/driver-profile.html",
  "/pages/change-password.html",
  "/pages/privacy.html",
  "/pages/terms.html",

  "/pages/admin.html",
  "/pages/admin-users.html",
  "/pages/admin-topups.html",
  "/pages/admin-withdrawals.html",
  "/pages/admin-orders.html",
  "/pages/admin-analytics.html",
  "/pages/admin-managers.html"
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE).then((cache) => cache.addAll(STATIC_ASSETS))
  );

  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) =>
        Promise.all(
          keys
            .filter((key) => key !== CACHE)
            .map((key) => caches.delete(key))
        )
      )
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", (event) => {
  if (event.request.method !== "GET") return;

  const url = new URL(event.request.url);

  // لا نتدخل في طلبات Firebase أو الخدمات الخارجية.
  if (url.origin !== self.location.origin) return;

  // ملفات التطبيق: الشبكة أولًا، ثم الكاش عند انقطاع الشبكة.
  if (
    url.pathname.endsWith(".js") ||
    url.pathname.endsWith(".html") ||
    url.pathname.endsWith(".css") ||
    url.pathname.endsWith(".webmanifest")
  ) {
    event.respondWith(
      fetch(event.request)
        .then((response) => {
          if (response.ok) {
            const copy = response.clone();

            caches.open(CACHE).then((cache) => {
              cache.put(event.request, copy);
            });
          }

          return response;
        })
        .catch(() => caches.match(event.request))
    );

    return;
  }

  // بقية الملفات: الكاش أولًا ثم الشبكة.
  event.respondWith(
    caches.match(event.request)
      .then((cached) => cached || fetch(event.request))
  );
});


/*
 * Firebase Cloud Messaging
 */
importScripts(
  "https://www.gstatic.com/firebasejs/12.18.0/firebase-app-compat.js"
);

importScripts(
  "https://www.gstatic.com/firebasejs/12.18.0/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyDQKVd7QlaLfNyZyIdtHbS91wVtSd1QeuM",
  authDomain: "jwan-delivery-c930d-72911.firebaseapp.com",
  projectId: "jwan-delivery-c930d-72911",
  storageBucket: "jwan-delivery-c930d-72911.firebasestorage.app",
  messagingSenderId: "22978141935",
  appId: "1:22978141935:web:cea2a66dd01f5bec04051a"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log(
    "[Jwan] Background message",
    payload
  );

  const notification =
    payload.notification || {};

  const title =
    notification.title || "Jwan";

  const options = {
    body:
      notification.body ||
      "لديك إشعار جديد من جوان.",
    icon: "/assets/icons/icon-192.svg",
    badge: "/assets/icons/icon-192.svg",
    data: payload.data || {}
  };

  self.registration.showNotification(
    title,
    options
  );
});

self.addEventListener(
  "notificationclick",
  (event) => {
    event.notification.close();

    const target =
      event.notification?.data?.url ||
      "/";

    event.waitUntil(
      clients.matchAll({
        type: "window",
        includeUncontrolled: true
      }).then((clientList) => {

        for (const client of clientList) {
          if ("focus" in client) {
            client.navigate(target);
            return client.focus();
          }
        }

        if (clients.openWindow) {
          return clients.openWindow(target);
        }

      })
    );
  }
);
