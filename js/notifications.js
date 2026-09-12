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

const FCM_VAPID_KEY =
  "BJi2lxS0joWxpmBthsYEpRBxOtc3T1scWdQzACWZQFEE1Pr_QqI2YwUWrL2lvG8D3AS6seU3mPWxS2wYOYGybNo";

let messagingInstance = null;
let foregroundListenerBound = false;

async function getMessagingInstance() {
  if (!messagingInstance) {
    messagingInstance = getMessaging();
  }
  return messagingInstance;
}

export async function initPushNotifications() {
  try {
    if (!("Notification" in window)) {
      return {
        success: false,
        supported: false
      };
    }

    const supported = await isSupported();

    if (!supported) {
      console.warn("Jwan: Firebase Messaging غير مدعوم.");
      return {
        success: false,
        supported: false
      };
    }

    const messaging = await getMessagingInstance();

    if (!foregroundListenerBound) {
      onMessage(messaging, (payload) => {
        console.log("Jwan foreground notification:", payload);

        const notification = payload?.notification || {};
        const data = payload?.data || {};

        if (Notification.permission !== "granted") {
          return;
        }

        try {
          new Notification(
            notification.title || "جوان",
            {
              body:
                notification.body ||
                "لديك إشعار جديد من جوان.",
              icon: "/assets/branding/logo-external.png",
              badge: "/assets/branding/logo-external.png",
              data
            }
          );
        } catch (error) {
          console.warn(
            "Jwan foreground notification display failed:",
            error
          );
        }
      });

      foregroundListenerBound = true;
    }

    return {
      success: true,
      supported: true
    };

  } catch (error) {
    console.warn(
      "Jwan push initialization skipped:",
      error
    );

    return {
      success: false,
      error
    };
  }
}

export async function enablePushNotifications() {
  try {
    if (!auth.currentUser) {
      throw new Error("يجب تسجيل الدخول أولًا.");
    }

    if (!("Notification" in window)) {
      throw new Error("الجهاز لا يدعم إشعارات النظام.");
    }

    if (!window.isSecureContext) {
      throw new Error(
        "الإشعارات تحتاج HTTPS أو localhost."
      );
    }

    let permission = Notification.permission;

    if (permission !== "granted") {
      permission = await Notification.requestPermission();
    }

    console.log(
      "JWAN notification permission:",
      permission
    );

    if (permission !== "granted") {
      throw new Error(
        "لم يتم السماح بالإشعارات. حالة الإذن: " +
        permission
      );
    }

    const supported = await isSupported();

    if (!supported) {
      throw new Error(
        "Firebase Messaging غير مدعوم في هذا المتصفح."
      );
    }

    await initPushNotifications();

    const messaging = await getMessagingInstance();

    if (!("serviceWorker" in navigator)) {
      throw new Error(
        "Service Worker غير مدعوم في هذا الجهاز."
      );
    }

    const registration =
      await navigator.serviceWorker.register("/sw.js");

    await navigator.serviceWorker.ready;

    const token = await getToken(messaging, {
      vapidKey: FCM_VAPID_KEY,
      serviceWorkerRegistration: registration
    });

    if (!token) {
      throw new Error(
        "تم السماح بالإشعارات لكن تعذر الحصول على FCM token."
      );
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
      {
        merge: true
      }
    );

    console.log(
      "Jwan FCM token registered:",
      token.slice(0, 18) + "..."
    );

    return {
      success: true,
      token
    };

  } catch (error) {
    console.error(
      "Jwan FCM error:",
      error
    );

    return {
      success: false,
      error
    };
  }
}

export async function createNotification(
  userId,
  type,
  title,
  body,
  createdBy
) {
  if (!userId) {
    throw new Error("userId مطلوب.");
  }

  if (!NOTIFICATION_TYPES.includes(type)) {
    throw new Error("نوع الإشعار غير معروف.");
  }

  return addDoc(
    collection(db, "notifications"),
    {
      userId,
      type,
      title,
      body,
      read: false,
      createdAt: serverTimestamp(),
      createdBy: createdBy || null
    }
  );
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

  return onSnapshot(
    q,
    (snap) => {
      callback(
        snap.docs.map((d) => ({
          id: d.id,
          ...d.data()
        }))
      );
    },
    (error) => {
      console.error(
        "Jwan notifications listener error:",
        error
      );
    }
  );
}

export async function markNotificationRead(id) {
  if (!id) return;

  await updateDoc(
    doc(db, "notifications", id),
    {
      read: true
    }
  );
}
