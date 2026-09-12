# اختبار جوان للتوصيل

## 1) تجهيز Firebase

في Firebase Console للمشروع الموجود في `js/firebase-config.js`:

1. فعّل Authentication > Sign-in method > Email/Password.
2. فعّل Cloud Firestore.
3. ضع محتوى `firestore.rules` في تبويب Firestore > Rules ثم Publish.
4. انشر `firestore.indexes.json` أو نفّذ `firebase deploy --only firestore` من جهاز فيه Firebase CLI.
5. أنشئ أول حساب إدارة عليا ثم أنشئ مستند `users/{UID}` في Firestore بهذه القيم الأساسية:

```text
role: "super_admin"
status: "active"
name: "Super Admin"
phone: "XXXXXXXXXX"
```

أكمل بقية الحقول الموجودة في مستند المستخدم القياسي عند الحاجة.

## 2) تشغيل نسخة الويب محليًا

من مجلد `jawan-delivery`:

```bash
python3 -m http.server 8080
```

ثم افتح:

```text
http://127.0.0.1:8080
```

لا تفتح `index.html` مباشرة بـ `file://` لأن التطبيق يستخدم ES Modules وFirebase Web SDK.

## 3) حسابات الاختبار

أنشئ ثلاثة حسابات:

- Super Admin: `super_admin`
- Driver: بعد التسجيل فعّل الحساب من لوحة الإدارة.
- Customer: بعد التسجيل فعّل الحساب من لوحة الإدارة.

## 4) اختبار الطلب الكامل

```text
Customer
  ↓
إنشاء طلب بسعر أو بدون سعر
  ↓
Admin
  ↓
تسعير الطلب إذا كان السعر فارغًا
  ↓
Driver
  ↓
قبول الطلب
  ↓
بدء التوصيل
  ↓
تم التسليم
  ↓
Customer
  ↓
تأكيد الاستلام
  ↓
Driver
  ↓
تأكيد وإغلاق الطلب
  ↓
خصم 5% + تسجيل حركة المحفظة
```

## 5) اختبارات أمنية مهمة

### العميل
- حاول تعديل `deliveryFee` لطلب موجود من Console أو كود JavaScript: يجب أن يفشل.
- حاول تغيير `driverId` أو `customerId`: يجب أن يفشل.
- حاول تغيير الطلب مباشرة إلى `completed`: يجب أن يفشل.

### السائق
- حاول قبول طلب لا يكفي رصيده لعمولته: يجب أن يفشل.
- حاول تغيير سعر الطلب: يجب أن يفشل.
- بعد إغلاق الطلب مرة واحدة، حاول خصم العمولة مرة ثانية: يجب أن يفشل.

### الإدارة
- المدير العادي يجب ألا يستطيع تحويل حسابه أو حساب مدير آخر إلى `super_admin`.
- الإدارة العليا تستطيع تغيير دور مدير آخر.
- السحب يجب ألا يتم إذا كان الرصيد أقل من المبلغ.
- اعتماد شحن/سحب يجب أن يغير الطلب والمحفظة وسجل الحركة معًا داخل Transaction.

### التقييم
- يمكن للعميل تقييم الطلب المكتمل فقط.
- لا يمكن إنشاء تقييم ثانٍ لنفس العميل ونفس الطلب.

## 6) اختبار APK

من داخل `mobile-app`:

```bash
npm ci
npm run sync
npx cap sync android
cd android
./gradlew assembleDebug --no-daemon
```

الناتج:

```text
mobile-app/android/app/build/outputs/apk/debug/app-debug.apk
```

لا تعدّل الملفات داخل `mobile-app/www` مباشرة؛ `npm run sync-web` يعيد إنشاءها من ملفات الموقع الأصلية.
