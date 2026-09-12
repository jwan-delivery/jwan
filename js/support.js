import { db } from "./firebase-config.js";
import {
  collection,
  doc,
  addDoc,
  updateDoc,
  onSnapshot,
  query,
  where,
  orderBy,
  serverTimestamp
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

export async function sendSupportMessage(userId, role, message) {
  const text = String(message || "").trim();
  if (!text) throw new Error("اكتب رسالتك أولًا");

  await addDoc(collection(db, "supportMessages"), {
    userId,
    role,
    message: text,
    reply: null,
    status: "open",
    createdAt: serverTimestamp(),
    repliedAt: null,
    repliedBy: null
  });
}

export function listenMySupportMessages(uid, callback) {
  const q = query(collection(db, "supportMessages"), where("userId", "==", uid), orderBy("createdAt", "desc"));
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}

// كل الرسائل، للإدارة.
export function listenAllSupportMessages(callback) {
  const q = query(collection(db, "supportMessages"), orderBy("createdAt", "desc"));
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}

export async function replySupportMessage(id, adminUid, reply) {
  const text = String(reply || "").trim();
  if (!text) throw new Error("اكتب الرد أولًا");

  await updateDoc(doc(db, "supportMessages", id), {
    reply: text,
    status: "answered",
    repliedAt: serverTimestamp(),
    repliedBy: adminUid
  });
}
