# AGENTS.md — عايز (Ayez)

هذا الملف هو دستور العمل لأي Agent أو مطور يعمل على المستودع.

## 1. المهمة

أكمل **تطبيق Flutter الموجود** داخل `mobile-app/` حتى يصبح تطبيق Android كاملًا ومتوافقًا مع وظائف Web/PWA.

لا تبدأ من الصفر ولا تنشئ Backend أو Firebase project جديدًا إلا إذا وجدت حاجة معمارية موثقة.

الهدف:

```text
Web/PWA ───────┐
               ├── نفس Firebase/Firestore/Functions/FCM
Flutter ───────┘
```

## 2. ترتيب مصادر الحقيقة

عند وجود تعارض، اتبع هذا الترتيب:

1. **Runtime evidence**: تشغيل فعلي، logs، test output، screenshots، integration tests.
2. **Security/Backend contract**: `firestore.rules`, `firestore.indexes.json`, Cloud Functions.
3. **Web behavior**: `pages/`, `js/`, `functions/`.
4. **Data contracts**: `DATA_MODEL.md`, `MIGRATION_CONTRACT.md`.
5. **Flutter implementation**: `mobile-app/lib/` و`pubspec.yaml`.
6. **CI configuration**: `.github/workflows/`.
7. **Historical reports**: تستخدم للسياق فقط، وليس لإثبات أن الميزة ما زالت كذلك.

### قاعدة

**وجود كود ليس دليلًا على أن الميزة تعمل، ووجود تقرير ليس دليلًا على أن الكود ما زال كذلك.**

إذا قال تقرير إن ملفًا "فارغ" بينما الملف الحالي يحتوي على implementation، صدّق الحالة الحالية بعد التحقق والاختبار، ثم أصلح التقرير.

## 3. قبل تعديل أي ميزة

لأي Feature:

### A. افهم الهدف من الويب

حدد:

- أين تبدأ الميزة في الويب.
- ما الحالات التي تمر بها.
- ما collections / fields التي تستخدمها.
- ما الأخطاء والصلاحيات.
- ما الذي يراه العميل.
- ما الذي يراه السائق أو الإدارة.
- ما الذي يحدث لحظيًا.

### B. افحص Security Rules

تحقق من:

- من يستطيع القراءة.
- من يستطيع الكتابة.
- الحقول المسموح تغييرها.
- التغييرات المالية.
- الـtransactions.
- الشروط الخاصة بالحالات.

لا تفترض صلاحية عملية لمجرد أنها موجودة في واجهة الويب.

### C. افحص Flutter الحالي

ابحث أولًا عن implementation موجود:

- `mobile-app/lib/`
- `mobile-app/pubspec.yaml`
- الخدمات
- models
- routing
- state
- widgets
- native configuration

ثم وسّع الموجود بدل إنشاء نسخة ثانية متعارضة.

## 4. حلقة التطوير المطلوبة

لكل تغيير مهم:

```text
1. Reproduce
2. Observe
3. Compare
4. Patch
5. Analyze/Test
6. Run again
7. Record evidence
```

### Reproduce

أعد إنتاج المشكلة أو التدفق بدل التخمين.

### Observe

اجمع ما يمكن من:

- شاشة التطبيق.
- logs.
- Firestore changes.
- exceptions.
- FCM events.
- test output.

### Compare

قارن السلوك مع الويب والعقد الأمني.

### Patch

غيّر أقل قدر لازم، ولا تكسر منطقًا موجودًا.

### Verify

شغّل:

```bash
flutter analyze
flutter test
```

وللتغييرات الكبيرة استخدم Integration/Emulator/Android runtime tests عندما تكون متاحة.

### Record

سجّل ما تم التحقق منه في `AYEZ_FLUTTER_STATUS_AR.md`.

## 5. Runtime testing

عند توفر Android emulator أو جهاز حقيقي أو CI emulator، اختبر التدفقات حرِفيًا، مثل:

### Customer
- فتح التطبيق.
- إنشاء حساب/تسجيل الدخول.
- إنشاء طلب.
- مشاهدة حالة الطلب.
- استلام/التفاعل مع التفاوض.
- الإشعارات.
- التأكيد بعد التسليم.
- التقييم.

### Driver
- تسجيل الدخول.
- ظهور الطلبات المناسبة.
- قبول الطلب.
- التفاوض.
- تحديث الحالات.
- رؤية المحفظة.
- طلب الشحن/السحب.
- تلقي الإشعارات.

### Admin
- فتح مركز الإدارة.
- مراجعة المستخدمين.
- مراجعة طلبات المحفظة.
- متابعة الطلبات/السجلات حسب صلاحيات الويب.

**لا تستخدم نجاح build كبديل عن اختبار هذه التدفقات.**

## 6. عندما لا تتوفر بيئة تشغيل تفاعلية

إذا لم يتوفر جهاز أو emulator:

- لا تدّعِ أنك اختبرت واجهة التطبيق.
- استخدم `flutter analyze`, `flutter test`, Rules Emulator، وCI build.
- ضع الحالة في التقرير على أنها **غير متحققة runtime**.
- لا تغيّر UI بناءً على التخمين وحده عندما يكون السؤال بصريًا أو تفاعليًا.

## 7. Firestore

أي تغيير في Rules أو schema يجب أن يتبعه:

1. مراجعة أثره على Web وFlutter.
2. تحديث `DATA_MODEL.md` عند تغيّر العقد.
3. تحديث `firestore.indexes.json` إذا لزم.
4. اختبار Rules/Emulator.
5. توثيق migration إذا كانت هناك بيانات قديمة.

لا تضع bypass خاصًا بالتطبيق المحمول.

## 8. Flutter architecture

يفضل، كلما كان ذلك مناسبًا:

```text
screens/widgets
      ↓
state/controller
      ↓
repository/service
      ↓
Firebase / platform
```

لا تضع منطق Firebase الحساس داخل Widgets عندما يمكن عزله.

## 9. الأمان والبيانات

لا:

- تضع secrets داخل Git.
- تضيف keystore إلى المستودع.
- تسجل كلمات المرور أو tokens في logs.
- تعدل حقول الرصيد مباشرة إذا كان العقد يمنع ذلك.
- تستخدم mock data وتعتبرها نجاحًا.
- تغيّر Rules فقط لكي ينجح الاختبار.

## 10. Definition of Done

أي Feature مكتملة يجب أن تحقق:

- behavior مطابق للعقد.
- UI مناسب للـmobile.
- success path يعمل.
- error/empty/loading/offline states موجودة عند الحاجة.
- Rules تسمح بالعملية وتمنع العمليات غير المسموح بها.
- اختبار مناسب مرّ، أو سبب موثق لعدم إمكانية اختباره.
- لا regression معروف في تدفق آخر.
- التوثيق محدث.

## 11. Release gate

قبل اعتبار Android Release جاهزًا:

```bash
cd mobile-app
flutter pub get
flutter analyze
flutter test
flutter build apk --release --target lib/main_native.dart
flutter build appbundle --release --target lib/main_native.dart
```

ثم تحقّق من:

- package/application ID.
- Firebase Android app.
- FCM.
- signing.
- versioning.
- artifact checksums.
- GitHub Actions status.

## 12. سياسة Git

يفضل أن تكون تغييرات كبيرة في branch منفصل مع PR واضح.

صيغة commit مقترحة:

```text
feat(flutter): complete driver wallet flow
fix(flutter): handle negotiation expiry
test(firebase): cover wallet rule regression
docs(ayez): update runtime verification status
```

## 13. ما يجب أن يقرأه Agent عند بداية جلسة جديدة

ابدأ دائمًا بـ:

1. `AGENTS.md`
2. `DEVELOPMENT_PLAYBOOK_AR.md`
3. `README.md`
4. `AYEZ_FLUTTER_STATUS_AR.md`
5. Rules/Data Model للميزة
6. Web implementation
7. Flutter implementation
8. CI/tests

ثم حدّد بوضوح:

- ما الموجود.
- ما المفقود.
- ما الذي تم اختباره.
- ما الذي يحتاج runtime verification.
- ما الذي ستغيّره ولماذا.
