# إعداد Firebase — جوان للتوصيل

هذه النسخة مهيأة لمشروع Firebase التالي:

- Project ID: `jwan-delivery-c930d-72911`
- Web App: `Jwan Web`
- App ID: `1:22978141935:web:cea2a66dd01f5bec04051a`
- Hosting site: `jwan-delivery-c930d-72911`
- الخطة الظاهرة في Firebase: Spark

## 1. Authentication

من Firebase Console:

Authentication → Sign-in method → Email/Password → Enable

التطبيق يحوّل رقم الهاتف داخليًا إلى معرّف مثل:

`249XXXXXXXXX@jawan.app`

ولا يحتاج التطبيق إلى Google Login أو OTP حسب التصميم الحالي.

## 2. Firestore

أنشئ Cloud Firestore Database ثم طبّق:

```bash
firebase use jwan-delivery-c930d-72911
firebase deploy --only firestore:rules,firestore:indexes
```

إذا لم تكن مسجّلًا في Firebase CLI:

```bash
firebase login
```

## 3. Hosting

للنشر:

```bash
firebase use jwan-delivery-c930d-72911
firebase deploy --only hosting
```

## 4. الإشعارات

الإشعارات داخل التطبيق تعمل عبر Firestore.

إشعارات Push الحقيقية عبر Firebase Cloud Messaging تحتاج إعداد Web Push/VAPID، وHTTPS. لا تضع أي service-account JSON داخل المشروع.

## 5. Super Admin

أنشئ مستخدمًا من Authentication ثم خذ UID الخاص به.

بعدها أنشئ يدويًا في Firestore:

`users/{UID}`

بالقيم الأساسية:

```json
{
  "role": "super_admin",
  "status": "active"
}
```

مع بقية الحقول المطلوبة الموجودة في نموذج المستخدم.

## 6. ما لا يجب وضعه في المشروع

لا تضع:

- Firebase Admin SDK service-account JSON
- private keys
- private API credentials
- كلمات مرور الحسابات

Firebase Web API key الموجودة في `js/firebase-config.js` هي إعداد عميل وليست service-account secret. الحماية الحقيقية للبيانات تعتمد على Authentication وFirestore Security Rules.

## 7. الخدمات المطلوبة حاليًا

المشروع الحالي يحتاج أساسًا:

- Firebase Authentication — Email/Password
- Cloud Firestore
- Firebase Hosting

Cloud Messaging اختياري لتفعيل Push Notifications.

Cloud Storage غير مطلوب للنسخة الحالية من التطبيق ما لم نقرر رفع صور إثبات التحويل أو ملفات أخرى.

## 8. مهم قبل الإنتاج

بعد ربط المشروع، اختبر السيناريو كاملًا:

عميل → إنشاء طلب → إدارة تسعّر الطلب عند الحاجة → سائق يقبل → يبدأ التوصيل → يعلن التسليم → العميل يؤكد → السائق يغلق → خصم 5%.

لا تستخدم وضع Test Mode في Firestore عند النشر.
