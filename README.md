# عايز — Ayez

منصة توصيل ونقل سودانية، لها نسخة Web/PWA ونسخة Android مبنية بـ Flutter داخل `mobile-app/`.

## الهدف الحالي

المطلوب ليس إنشاء تطبيق جديد من الصفر.

المطلوب هو **إكمال تطبيق Flutter الموجود حاليًا** ليصبح نسخة Android كاملة من وظائف الويب، باستخدام نفس Firebase/Firestore والحسابات والطلبات والمحافظ والإشعارات والقواعد، ثم إخراجه كنسخة Release قابلة للاستخدام.

المبدأ الأساسي:

```text
Web / PWA ───────┐
                 ├── Firebase / Firestore / Auth / FCM / Functions
Flutter Android ─┘
```

## قبل أن تبدأ

أي Agent أو مطور جديد يجب أن يقرأ بهذا الترتيب:

1. `AGENTS.md`
2. `DEVELOPMENT_PLAYBOOK_AR.md`
3. `AYEZ_FLUTTER_STATUS_AR.md`
4. `firestore.rules` و `firestore.indexes.json`
5. ملفات الويب المرتبطة بالميزة
6. ملفات Flutter داخل `mobile-app/`
7. الاختبارات وGitHub Actions

**لا تعتبر أي تقرير قديم مصدرًا نهائيًا إذا تعارض مع الكود الحالي أو الاختبار الحالي.**

## مصدر الحقيقة

عند تنفيذ أو مراجعة أي ميزة، استخدم هذا الترتيب:

### 1) Security Rules والعقد الأمني
المصدر الأعلى للصلاحيات وشروط الكتابة والعمليات الحساسة هو:

- `firestore.rules`
- `firestore.indexes.json`
- Cloud Functions المرتبطة بالعملية

### 2) سلوك الويب الحالي
الويب هو المرجع الوظيفي لما يجب أن تفعله المنصة، خاصة:

- `pages/`
- `js/`
- `functions/`
- `css/`

لا تنسخ الواجهة حرفيًا؛ انقل **السلوك والعقود وحالات العمل** إلى تجربة Mobile مناسبة.

### 3) نموذج البيانات والتوثيق
استخدم:

- `DATA_MODEL.md`
- `MIGRATION_CONTRACT.md`
- أي توثيق أحدث في المستودع

### 4) Flutter الحالي
تطبيق Flutter موجود فعليًا داخل `mobile-app/` ويحتوي حاليًا على Firebase وبعض الخدمات والشاشات والتدفقات.

من الملفات الموجودة حاليًا مثل:

- `mobile-app/lib/main.dart`
- `mobile-app/lib/main_native.dart`
- `mobile-app/lib/native_entry.dart`
- `mobile-app/lib/ayez_app_shell.dart`
- `mobile-app/lib/admin_center_page.dart`
- `mobile-app/lib/services/`
- `mobile-app/lib/firebase_options.dart`

و`pubspec.yaml` يتضمن Firebase Core/Auth/Firestore/Messaging/App Check وCloud Functions وغيرها.

**لا تعيد بناء هذه الأجزاء من الصفر قبل فحصها.**

## كيف يجب أن يعمل التطوير

كل ميزة يجب أن تمر بهذه الحلقة:

```text
افهم ميزة الويب
      ↓
افحص Rules + Data Model
      ↓
افحص Flutter الحالي
      ↓
شغّل التطبيق/الاختبارات
      ↓
لاحظ السلوك الفعلي والمشكلة
      ↓
عدّل الكود
      ↓
flutter analyze + flutter test
      ↓
Integration / Emulator / Android test عند الحاجة
      ↓
أعد التجربة
      ↓
حدّث التوثيق وسجّل ما تم التحقق منه
```

**لا تعتبر المهمة منتهية لأن الكود "يبدو صحيحًا".**

## مبدأ Runtime First

عندما يكون السؤال عن واجهة أو تدفق أو مشكلة تظهر عند التشغيل، يجب أن يكون القرار مبنيًا على:

1. ما يحدث فعليًا عند التشغيل.
2. Logs / test output / screenshots إن توفرت.
3. قواعد Firestore والـbackend.
4. الكود.
5. التوثيق.

ولا تستخدم التوثيق وحده لإثبات أن ميزة تعمل.

## ما الذي يجب إكماله

### P0 — Feature Parity

- Authentication والـsession وحالات المستخدم.
- واجهات العميل كاملة.
- واجهات السائق كاملة.
- دورة الطلب من الإنشاء حتى الإغلاق.
- التفاوض والمهل والحالات.
- المحفظة والشحن والسحب والسجل والعمولات والغرامات.
- التقييمات.
- الإشعارات داخل التطبيق وFCM foreground/background.
- الدعم.
- RBAC وguards.
- loading / empty / error / offline states.

### P1 — Production Quality

- services/repositories/models/state management بشكل منظم.
- lifecycle وstreams بدون تسريبات.
- pagination والاستعلامات المناسبة.
- offline/cache بسلوك واضح.
- Unit / Widget / Integration tests.
- Firestore Rules / Emulator tests.
- crash/error reporting.
- GitHub Actions للتحقق والبناء.

### P2 — Release

- الاسم النهائي: `عايز`.
- تثبيت application ID.
- Firebase Android configuration الصحيحة.
- FCM native configuration.
- Release signing عبر GitHub Secrets.
- APK للاختبار وAAB للإصدار.
- versioning وCHANGELOG.

## تعريف "مكتمل"

لا يكفي أن:

```bash
flutter build apk --release
```

يمر بنجاح.

الميزة أو الإصدار يعتبر مكتملًا عندما:

- يعمل على Android.
- يتعامل مع Firebase الحقيقي.
- يطابق سلوك الويب والعقد الحالي.
- يحترم Firestore Rules.
- يغطي الحالات الطبيعية وحالات الخطأ.
- ينجح في الاختبارات المناسبة.
- لا يكسر تدفقًا آخر.
- تم توثيق ما تم اختباره وما لم يتم اختباره.

## بناء Flutter

من داخل `mobile-app/`:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release --target lib/main_native.dart
flutter build appbundle --release --target lib/main_native.dart
```

GitHub Actions الموجودة في `.github/workflows/` هي المرجع العملي لعملية CI الحالية.

## Firebase

المشروع الحالي:

```text
jwan-delivery-c930d-72911
```

لا تنشئ Firebase project جديدًا لمجرد إصلاح مشكلة في Flutter.

## الأمان

- لا تضع secrets أو keystore داخل Git.
- لا تغيّر Firestore Rules لتجاوز فشل Flutter.
- لا تعدّل البيانات المالية مباشرة من العميل إذا كان العقد يمنع ذلك.
- لا تنشئ collections بديلة لنفس الكيانات دون سبب موثق.
- لا تستخدم mock data لإخفاء عدم اكتمال التدفق.

## سجل العمل

بعد أي تغيير جوهري، حدّث:

`AYEZ_FLUTTER_STATUS_AR.md`

وسجّل:

- التاريخ.
- المشكلة أو الميزة.
- ما تم تغييره.
- الملفات المتأثرة.
- الاختبارات التي شُغّلت.
- ما تم التحقق منه فعليًا.
- ما بقي.
- أي خطوة خارج GitHub مطلوبة.

## ملاحظة للـAgents

إذا وجدت تعارضًا بين:

- تقرير قديم،
- الكود الحالي،
- قواعد Firestore،
- أو نتيجة تشغيل فعلية،

فلا تتجاهله. **تحقق منه أولًا، ثم حدّث التوثيق ليعكس الحالة الحالية.**
