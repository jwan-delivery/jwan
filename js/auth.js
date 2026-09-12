import { auth, db } from "./firebase-config.js";

import {
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  signInWithPopup,
  linkWithPopup,
  GoogleAuthProvider,
  signOut,
  onAuthStateChanged
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-auth.js";

import {
  doc,
  setDoc,
  getDoc,
  updateDoc,
  serverTimestamp
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

function phoneToEmail(phone) {
  return `${phone}@jawan.app`;
}

export function validatePhone(phone) {
  return /^\d{10}$/.test(String(phone || ""));
}

export function validatePassword(password) {
  return String(password || "").length >= 6;
}

export const VEHICLE_TYPES = {
  car: "سيارة",
  rickshaw: "ركشة",
  motorcycle: "موتر",
  tuk_tuk: "تكتك",
  truck: "دفار",
  bus: "حافلة",
  amjad: "أمجاد",
  kreez: "كريز",
  taxi: "تاكسي",
  tanker: "تنكر",
  crane: "كرين",
  tow_truck: "رافعة",
  lorry: "لوري",
  limousine: "ليموزين"
};

export const SUDAN_STATES = [
  "الخرطوم",
  "الجزيرة",
  "القضارف",
  "كسلا",
  "البحر الأحمر",
  "نهر النيل",
  "الشمالية",
  "النيل الأبيض",
  "النيل الأزرق",
  "سنار",
  "شمال كردفان",
  "جنوب كردفان",
  "غرب كردفان",
  "شمال دارفور",
  "جنوب دارفور",
  "غرب دارفور",
  "وسط دارفور",
  "شرق دارفور"
];

export function roleHome(role) {
  if (role === "admin" || role === "super_admin") {
    return "/pages/admin.html";
  }

  if (role === "driver") {
    return "/pages/driver.html";
  }

  if (role === "customer") {
    return "/pages/customer.html";
  }

  return null;
}

export async function registerUser(
  name,
  phone,
  password,
  role,
  address,
  acceptedPolicies,
  state,
  age,
  vehicleType = null
) {
  const cleanName = String(name || "").trim();
  const cleanPhone = String(phone || "").trim();
  const cleanAddress = String(address || "").trim();
  const cleanState = String(state || "").trim();
  const numericAge = Number(age);
  const cleanVehicleType = vehicleType == null
    ? null
    : String(vehicleType).trim();

  if (!cleanName) {
    throw new Error("الاسم الكامل مطلوب");
  }

  if (!validatePhone(cleanPhone)) {
    throw new Error("رقم الهاتف يجب أن يكون 10 أرقام فقط");
  }

  if (!validatePassword(password)) {
    throw new Error("كلمة المرور يجب أن تكون 6 أحرف على الأقل");
  }

  if (!["customer", "driver"].includes(role)) {
    throw new Error("نوع الحساب غير صحيح");
  }

  if (!SUDAN_STATES.includes(cleanState)) {
    throw new Error("اختر الولاية");
  }

  if (!cleanAddress) {
    throw new Error("مكان السكن مطلوب");
  }

  if (!acceptedPolicies) {
    throw new Error("يجب الموافقة على سياسة الخصوصية والشروط والأحكام");
  }

  if (role === "driver") {
    if (!Number.isInteger(numericAge) || numericAge < 18 || numericAge > 100) {
      throw new Error("يجب أن يكون عمر السائق 18 سنة على الأقل");
    }

    if (!Object.prototype.hasOwnProperty.call(VEHICLE_TYPES, cleanVehicleType)) {
      throw new Error("اختر نوع المركبة");
    }
  }

  const email = phoneToEmail(cleanPhone);

  const userCredential = await createUserWithEmailAndPassword(
    auth,
    email,
    password
  );

  const user = userCredential.user;

  await setDoc(doc(db, "users", user.uid), {
    role,
    name: cleanName,
    phone: cleanPhone,
    address: cleanAddress,
    state: cleanState,

    age: role === "driver" ? numericAge : null,
    vehicleType: role === "driver" ? cleanVehicleType : null,

    status: role === "customer" ? "active" : "pending",
    privacyAccepted: true,
    termsAccepted: true,

    createdAt: serverTimestamp(),
    lastActiveAt: serverTimestamp()
  });

  return user;
}

export async function loginUser(phone, password) {
  if (!validatePhone(phone)) {
    throw new Error("رقم الهاتف يجب أن يكون 10 أرقام فقط");
  }

  const credential = await signInWithEmailAndPassword(
    auth,
    phoneToEmail(phone),
    password
  );

  updateDoc(
    doc(db, "users", credential.user.uid),
    {
      lastActiveAt: serverTimestamp()
    }
  ).catch(() => {});

  return credential;
}

export async function getCurrentUserData(uid) {
  const snapshot = await getDoc(doc(db, "users", uid));

  if (!snapshot.exists()) {
    return null;
  }

  return snapshot.data();
}

export async function logoutUser() {
  return signOut(auth);
}

export function watchAuth(callback) {
  return onAuthStateChanged(auth, callback);
}

export function guardPage(allowedRoles) {
  return new Promise((resolve) => {
    const stop = watchAuth(async (user) => {
      stop();

      if (!user) {
        location.href = "/pages/login.html";
        return;
      }

      try {
        const data = await getCurrentUserData(user.uid);

        if (!data) {
          console.error(
            "Jawan: no Firestore user profile found for UID",
            user.uid
          );

          await logoutUser();
          location.href = "/pages/login.html?profile=missing";
          return;
        }

        if (!allowedRoles.includes(data.role)) {
          console.error(
            "Jawan: role not allowed on this page",
            {
              role: data.role,
              allowedRoles
            }
          );

          location.href = "/pages/login.html?role=denied";
          return;
        }

        if (
          data.status === "suspended" ||
          data.status === "rejected"
        ) {
          await logoutUser();
          location.href = "/pages/login.html?blocked=1";
          return;
        }

        resolve({
          user,
          data
        });
      } catch (error) {
        console.error(
          "Jawan: failed to load user profile",
          error
        );

        await logoutUser().catch(() => {});
        location.href = "/pages/login.html?profile=error";
      }
    });
  });
}

export function setupLogoutButtons() {
  document.querySelectorAll("[data-logout]").forEach((button) => {
    if (button.dataset.logoutReady === "1") {
      return;
    }

    button.dataset.logoutReady = "1";

    button.addEventListener("click", async () => {
      button.disabled = true;

      try {
        await logoutUser();
        location.href = "/pages/login.html";
      } catch (error) {
        console.error(
          "Jawan: logout failed",
          error
        );

        button.disabled = false;

        alert(
          "تعذر تسجيل الخروج، حاول مرة أخرى."
        );
      }
    });
  });
}


export async function signInWithGoogle() {
  const provider = new GoogleAuthProvider();
  return signInWithPopup(auth, provider);
}

export function getAuthProviderIds(user = auth.currentUser) {
  return (user?.providerData || []).map((provider) => provider.providerId);
}

export async function linkGoogleAccount() {
  if (!auth.currentUser) throw new Error("سجّل الدخول أولًا.");
  const provider = new GoogleAuthProvider();
  return linkWithPopup(auth.currentUser, provider);
}
