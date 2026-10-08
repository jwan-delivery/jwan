import { db } from "./firebase-config.js";
import { getFunctions, httpsCallable } from "https://www.gstatic.com/firebasejs/12.18.0/firebase-functions.js";
import {
  collection,
  doc,
  onSnapshot,
  query,
  orderBy
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

export const NEGOTIATION_MINUTES = 30;
export const NEGOTIATION_DURATION_MS = NEGOTIATION_MINUTES * 60 * 1000;
export const MAX_NEGOTIATION_AMOUNT = 100000000;

const functions = getFunctions(undefined, "us-central1");
const negotiationAction = httpsCallable(functions, "negotiationAction");

function cleanAmount(value) {
  const n = Math.round(Number(value));
  if (!Number.isFinite(n) || n <= 0 || n > MAX_NEGOTIATION_AMOUNT) {
    throw new Error("أدخل مبلغًا صحيحًا.");
  }
  return n;
}

async function callNegotiation(orderId, action, amount) {
  const payload = { orderId, action };
  if (action === "offer") payload.amount = cleanAmount(amount);
  const result = await negotiationAction(payload);
  return result?.data || {};
}

export async function startNegotiation({ orderId, amount }) {
  return callNegotiation(orderId, "offer", amount);
}

export async function proposePrice({ orderId, amount }) {
  return callNegotiation(orderId, "offer", amount);
}

export async function respondToOffer({ orderId, action }) {
  if (!["accept", "reject"].includes(action)) {
    throw new Error("إجراء غير صحيح.");
  }
  return callNegotiation(orderId, action);
}

export function listenNegotiation(orderId, callback) {
  const negotiationRef = doc(db, "priceNegotiations", orderId);
  const messagesRef = collection(db, "priceNegotiations", orderId, "messages");
  const messagesQuery = query(messagesRef, orderBy("createdAt", "asc"));
  let state = { negotiation: null, messages: [] };

  const emit = () => callback({ ...state });

  const unsubNegotiation = onSnapshot(
    negotiationRef,
    (snap) => {
      state = {
        ...state,
        negotiation: snap.exists() ? { id: snap.id, ...snap.data() } : null
      };
      emit();
    },
    (error) => callback({ ...state, error })
  );

  const unsubMessages = onSnapshot(
    messagesQuery,
    (snap) => {
      state = {
        ...state,
        messages: snap.docs.map((d) => ({ id: d.id, ...d.data() }))
      };
      emit();
    },
    (error) => callback({ ...state, error })
  );

  return () => {
    unsubNegotiation();
    unsubMessages();
  };
}

export function listenOrderContacts(orderId, callback) {
  const ref = doc(db, "orderContacts", orderId);
  return onSnapshot(ref, (snap) => {
    callback(snap.exists() ? { id: snap.id, ...snap.data() } : null);
  });
}
