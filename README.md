# جوان للتوصيل — Jawan Delivery

تطبيق ويب/PWA لتوصيل الطلبات داخل بورتسودان، مع غلاف Android عبر Capacitor. النسخة الحالية موصولة فعليًا بـ Firebase Web SDK؛ لا توجد Cloud Functions في هذه النسخة.

## ما يعمل حاليًا

- واجهة عربية RTL ومتجاوبة.
- تسجيل ودخول العميل والسائق عبر رقم هاتف + كلمة مرور باستخدام Firebase Email/Password مع مُعرّف داخلي بصيغة `phone@jawan.app`.
- صفحات العميل والسائق والإدارة.
- إنشاء الطلب وتتبع دورة الحالة.
- تسعير الطلب من الإدارة عند ترك السعر فارغًا.
- قبول الطلب من السائق مع فحص رصيد العمولة.
- تأكيد العميل ثم إغلاق السائق للطلب.
- عمولة جوان 5% من قيمة التوصيل.
- محفظة السائق، الشحن والسحب ومراجعة الإدارة.
- طرق الشحن: بنكك، فوري، أوكاش، ماي كاشي.
- تقييم الطلب بعد اكتماله، مع منع التقييم المكرر لنفس العميل والطلب.
- الدعم والإشعارات وسجل التدقيق.
- Service Worker/PWA.
- مشروع Android داخل `mobile-app/` مبني بـ Capacitor.

## الأمان في هذه النسخة

قواعد Firestore تمنع العميل أو السائق من تغيير الحقول الحساسة للطلب، مثل السعر أو هوية العميل/السائق أو الانتقال غير المسموح في الحالة.

خصم العمولة وربطه بالطلب يتمان داخل Firestore Transaction واحدة. القاعدة تتحقق من أن الطلب انتقل من `awaiting_confirmation` إلى `completed` وأن الخصم يساوي 5% من السعر، ولا يمكن إعادة احتساب نفس الطلب.

شحن وسحب المحفظة لا يغيّران الرصيد مباشرة من واجهة السائق. تعديل الرصيد في عمليات الإدارة يجب أن يكون مرتبطًا بطلب شحن/سحب تتم مراجعته داخل نفس الـTransaction.

صلاحيات `role` و`status` في `users` مقيدة؛ المستخدم لا يستطيع ترقية نفسه، والإدارة العليا فقط تستطيع تغيير صلاحيات المدراء الآخرين.

هذه الحماية تعتمد على Firestore Security Rules وTransactions، لكنها لا تلغي الحاجة إلى Backend/Cloud Functions عند إضافة عمليات مالية أكثر تعقيدًا أو تكاملات دفع حقيقية.

## إعداد Firebase

1. أنشئ/استخدم مشروع Firebase.
2. فعّل Authentication ثم فعّل **Email/Password**.
3. فعّل Firestore.
4. راجع `js/firebase-config.js` وتأكد أن المشروع المقصود هو مشروعك.
5. طبّق القواعد والفهارس:

```bash
firebase deploy --only firestore
```

6. انشر الموقع:

```bash
firebase deploy --only hosting
```

ملحوظة: `firebase.json` يستثني `mobile-app/` و`.github/` وملفات التوثيق وملفات Firestore من Hosting، لذلك لن تتحول ملفات Android أو القواعد إلى ملفات ويب عامة.

## إنشاء أول Super Admin

تسجيل المستخدم العادي لا يسمح بإنشاء `admin` أو `super_admin`. أنشئ حساب الإدارة العليا بطريقة آمنة ثم أضف مستند المستخدم المقابل في `users/{uid}` بقيمة `role: "super_admin"` و`status: "active"` قبل استخدام لوحة الإدارة.

## تجربة السيناريو الكامل

يفضل استخدام حسابين على الأقل: عميل وسائق، بالإضافة إلى حساب إدارة.

السيناريو الأساسي:

```text
Customer: تسجيل → إنشاء طلب
Admin:    تفعيل المستخدم + تسعير الطلب إن لزم
Driver:   قبول → بدء التوصيل → تم التسليم
Customer: تأكيد الاستلام
Driver:   إغلاق الطلب
System:   خصم 5% من محفظة السائق وتسجيل العملية
```

## Android

داخل `mobile-app/`:

```bash
npm ci
npm run sync
npx cap open android
```

وللبناء من سطر الأوامر:

```bash
cd mobile-app/android
./gradlew assembleDebug --no-daemon
```

الناتج:

`mobile-app/android/app/build/outputs/apk/debug/app-debug.apk`

## حدود معروفة

- لا توجد Cloud Functions أو Backend مخصص.
- إشعارات FCM تحتاج VAPID key عند تفعيلها للويب.
- الدفع والتحويلات البنكية ما زالت إجراءات مراجعة يدوية؛ التطبيق لا يتحقق تلقائيًا من تحويل بنكي حقيقي.
- الاتصال الفعلي بين السائق والعميل ما زال مبنيًا على صفحات التطبيق والإشعارات، ولا توجد خرائط أو تتبع GPS.

## Firebase project used by this package

This package is preconfigured for Firebase project `jwan-delivery-c930d-72911`.
See `FIREBASE_SETUP_AR.md` for the exact Firebase services and deployment commands.
