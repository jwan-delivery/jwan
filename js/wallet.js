import { db } from "./firebase-config.js";
import {
  collection,
  doc,
  addDoc,
  onSnapshot,
  query,
  where,
  orderBy,
  serverTimestamp
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

export const PAYMENT_METHODS = ["بنكك", "فوري", "أوكاش", "ماي كاشي"];

export function driverCommission(deliveryFee) {
  return Math.round(Number(deliveryFee || 0) * 0.05);
}

export function canAcceptOrder(driverWalletBalance, deliveryFee) {
  return Number(driverWalletBalance || 0) >= driverCommission(deliveryFee);
}

export function topUpAmount(amount) {
  return Math.max(0, Number(amount || 0));
}

export function listenWallet(uid, callback) {
  return onSnapshot(doc(db, "wallets", uid), (snap) => {
    callback(snap.exists() ? snap.data() : null);
  });
}

export function listenWalletTransactions(uid, callback) {
  const q = query(
    collection(db, "walletTransactions"),
    where("userId", "==", uid),
    orderBy("createdAt", "desc")
  );
  return onSnapshot(q, (snap) => {
    callback(snap.docs.map((d) => ({ id: d.id, ...d.data() })));
  });
}

export async function createTopupRequest(driverId, amount, paymentMethod) {
  const value = topUpAmount(amount);
  if (value <= 0) throw new Error("أدخل مبلغًا صحيحًا");
  if (!PAYMENT_METHODS.includes(paymentMethod)) throw new Error("اختر طريقة تحويل صحيحة");

  await addDoc(collection(db, "topupRequests"), {
    driverId,
    amount: value,
    paymentMethod,
    status: "pending",
    submittedAt: serverTimestamp(),
    reviewedAt: null,
    reviewedBy: null,
    reviewNote: null,
    whatsappVerified: false
  });
}

export function listenMyTopupRequests(uid, callback) {
  const q = query(
    collection(db, "topupRequests"),
    where("driverId", "==", uid),
    orderBy("submittedAt", "desc")
  );
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}

export async function createWithdrawalRequest(driverId, amount, paymentMethod, accountReference) {
  const value = topUpAmount(amount);
  if (value <= 0) throw new Error("أدخل مبلغًا صحيحًا");
  if (!PAYMENT_METHODS.includes(paymentMethod)) throw new Error("اختر طريقة تحويل صحيحة");
  if (!accountReference || !String(accountReference).trim()) throw new Error("أدخل رقم الحساب/المحفظة المستلمة");

  await addDoc(collection(db, "withdrawalRequests"), {
    driverId,
    amount: value,
    paymentMethod,
    accountReference,
    status: "pending",
    createdAt: serverTimestamp(),
    reviewedAt: null,
    reviewedBy: null
  });
}

export function listenMyWithdrawalRequests(uid, callback) {
  const q = query(
    collection(db, "withdrawalRequests"),
    where("driverId", "==", uid),
    orderBy("createdAt", "desc")
  );
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}
