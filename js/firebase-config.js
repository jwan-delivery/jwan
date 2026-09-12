/* Firebase configuration for Jawan Delivery */

import { initializeApp } from "https://www.gstatic.com/firebasejs/12.18.0/firebase-app.js";

import {
  initializeAppCheck,
  ReCaptchaEnterpriseProvider
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-app-check.js";

import {
  getFirestore
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

import {
  getAuth
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-auth.js";

const firebaseConfig = {
  apiKey: "AIzaSyDQKVdQ7laLfNyZyIdtHbS91wVtSd1QeuM",
  authDomain: "jwan-delivery-c930d-72911.firebaseapp.com",
  projectId: "jwan-delivery-c930d-72911",
  storageBucket: "jwan-delivery-c930d-72911.firebasestorage.app",
  messagingSenderId: "22978141935",
  appId: "1:22978141935:web:cea2a66dd01f5bec04051a",
  measurementId: "G-MHHKVQ12B2"
};

const APP_CHECK_SITE_KEY =
  "6LfElLYtAAAAABBT6LsRSC3WChMjajNApuK8pHTb";

const app = initializeApp(firebaseConfig);

/*
 * App Check MUST be initialized before using Firebase services.
 */
let appCheck = null;

try {
  appCheck = initializeAppCheck(app, {
    provider: new ReCaptchaEnterpriseProvider(APP_CHECK_SITE_KEY),
    isTokenAutoRefreshEnabled: true
  });

  console.log("Jwan: App Check initialized");
} catch (error) {
  console.error("Jwan: App Check initialization failed", error);
}

const db = getFirestore(app);
const auth = getAuth(app);

export {
  app,
  db,
  auth,
  appCheck,
  firebaseConfig
};
