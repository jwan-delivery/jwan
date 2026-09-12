import { db } from "./firebase-config.js";
import {
  collection,
  doc,
  setDoc,
  getDocs,
  query,
  where,
  serverTimestamp
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

export async function submitRating(orderId, customerId, driverId, rating, comment) {
  const value = Math.min(5, Math.max(1, Math.round(Number(rating))));
  await setDoc(doc(db, "ratings", `${orderId}_${customerId}`), {
    orderId,
    customerId,
    driverId,
    rating: value,
    comment: comment ? String(comment).trim() : null,
    createdAt: serverTimestamp()
  });
}

// أرقام الطلبات التي قيّمها هذا العميل مسبقًا، لإخفاء نموذج التقييم عنها.
export async function fetchRatedOrderIds(customerId) {
  const q = query(collection(db, "ratings"), where("customerId", "==", customerId));
  const snap = await getDocs(q);
  return new Set(snap.docs.map((d) => d.data().orderId));
}
