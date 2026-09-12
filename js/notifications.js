import { db, auth } from "./firebase-config.js";

import {
  collection,
  doc,
  addDoc,
  updateDoc,
  onSnapshot,
  query,
  where,
  orderBy,
  limit,
  serverTimestamp,
  setDoc
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

import {
  getMessaging,
  getToken,
  onMessage,
  isSupported
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-messaging.js";

export const NOTIFICATION_TYPES = [
  "new_order",
  "order_accepted",
  "order_status",
  "topup_review",
  "support_message",
  "system"
];

/*
 * Firebase Console:
 * Project settings
 * -> Cloud Messaging
 * -> Web Push certificates
 */
const FCM_VAPID_KEY =
  "BJi2lxS0joWxpmBthsYEpRBxOtc3T1scWdQzACWZQFEE1Pr_QqI2YwUWrL2lvG8D3AS6seU3mPWxS2wYOYGybNo";

let messagingInstance = null;

export async function enablePushNotifications() {
  try {
    if (!auth.currentUser) {
      throw new Error("يجب تسجيل الدخول أولًا.");
    }

    if (!("Notification" in window)) {
      throw new Error("المتصفح لا يدعم إشعارات النظام.");
    }

    if (!window.isSecureContext) {
      throw new Error(
        "الإشعارات تحتاج HTTPS أو localhost."
      );
    }

    // مهم جدًا:
    // نطلب إذن الإشعارات أولًا قبل فحص Firebase Messaging.
    let permission = Notification.permission;

    if (permission !== "granted") {
      permission = await Notification.requestPermission();
    }

    console.log("JW​AN notification permission:", permission);

    if (permission !== "granted") {
      throw new Error(
        "لم يتم السماح بالإشعارات. حالة الإذن: " + permission
      );
    }

    // بعد الموافقة فقط نبدأ فحص Firebase Messaging.
    const supported = await isSupported();

    console.log("JW​AN FCM supported:", supported);
    console.log("JW​AN secure context:", window.isSecureContext);
    console.log("JW​AN service worker:", "serviceWorker" in navigator);

    if (!supported) {
      throw new Error(
        "تم السماح بالإشعارات، لكن Firebase Messaging غير مدعوم في هذا المتصفح."
      );
    }

    if (!messagingInstance) {
      messagingInstance = getMessaging();
    }

    const registration =
      await navigator.serviceWorker.register("/sw.js");

    const token = await getToken(messagingInstance, {
      vapidKey: FCM_VAPID_KEY,
      serviceWorkerRegistration: registration
    });

    if (!token) {
      throw new Error("تم السماح بالإشعارات لكن تعذر الحصول على FCM token.");
    }

    const uid = auth.currentUser.uid;

    await setDoc(
      doc(db, "fcmTokens", token),
      {
        uid,
        token,
        platform: "web",
        userAgent: navigator.userAgent,
        updatedAt: serverTimestamp()
      },
      { merge: true }
    );

    console.log("Jwan FCM token registered");

    return {
      success: true,
      token
    };

  } catch (error) {
    console.error("Jwan FCM error:", error);

    return {
      success: false,
      error
    };
  }
}

export async function initPushNotifications() {
  try {
    if (!auth.currentUser) return;

    const supported = await isSupported();

    if (!supported) return;

    if (!messagingInstance) {
      messagingInstance = getMessaging();
    }

    onMessage(messagingInstance, (payload) => {
      console.log("Jwan foreground notification:", payload);

      const notification = payload.notification || {};

      if (Notification.permission === "granted") {
        new Notification(
          notification.title || "Jwan",
          {
            body:
              notification.body ||
              "لديك إشعار جديد من جوان.",
            icon: "/assets/icons/icon-192.svg",
            data: payload.data || {}
          }
        );
      }
    });

  } catch (error) {
    console.warn(
      "Jwan push initialization skipped:",
      error
    );
  }
}

export async function createNotification(
  userId,
  type,
  title,
  body,
  createdBy
) {
  await addDoc(collection(db, "notifications"), {
    userId,
    type,
    title,
    body,
    read: false,
    createdAt: serverTimestamp(),
    createdBy: createdBy || null
  });
}

export function listenNotifications(
  uid,
  callback,
  max = 30
) {
  const q = query(
    collection(db, "notifications"),
    where("userId", "==", uid),
    orderBy("createdAt", "desc"),
    limit(max)
  );

  return onSnapshot(q, (snap) =>
    callback(
      snap.docs.map((d) => ({
        id: d.id,
        ...d.data()
      }))
    )
  );
}

export async function markNotificationRead(id) {
  await updateDoc(
    doc(db, "notifications", id),
    { read: true }
  );
}
