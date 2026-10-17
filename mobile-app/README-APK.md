# بناء تطبيق أندرويد — عايز

المسار الحالي لتطبيق Android هو **Flutter Native** داخل هذا المجلد، وواجهة التطبيق المقصودة تبدأ من `lib/main_native.dart`. توجد بعض ملفات Capacitor القديمة في المجلد، لكنها ليست طريقة بناء نسخة Flutter الحالية.

## إنشاء APK تجريبي على جهازك

تحتاج إلى Flutter SDK وAndroid SDK مثبتين. من جذر المستودع نفّذ:

```bash
cd mobile-app
flutter --version
flutter pub get
flutter analyze
flutter test
flutter build apk --debug --target lib/main_native.dart
```

سيكون ملف APK الناتج هنا:

```
mobile-app/build/app/outputs/flutter-apk/app-debug.apk
```

يمكن تثبيت هذا الملف على هاتف Android للاختبار. اختبر تسجيل العميل والسائق، إنشاء الطلب، التفاوض، حالات الطلب، المحفظة والإشعارات قبل الاعتماد عليه.

## بناء إصدار Release

لا تستخدم إصدار Release للتوزيع العام قبل إعداد مفتاح توقيع إنتاجي آمن والتحقق من تسجيل Android app الصحيح في Firebase. احفظ بيانات التوقيع محلياً أو في Secrets موثوقة فقط؛ لا تضع ملف keystore أو كلمات المرور في Git ولا ترسلها في المحادثة.

بعد إعداد التوقيع وفحص إعدادات Firebase، ابنِ النسخة المقصودة صراحةً:

```bash
flutter build apk --release --target lib/main_native.dart
flutter build appbundle --release --target lib/main_native.dart
```

لا يعني نجاح البناء وحده أن التطبيق جاهز للإطلاق؛ يلزم اختبار الوظائف والصلاحيات وقواعد Firestore وFCM على جهاز Android حقيقي.

## ملاحظة حول البناء الآلي

لا يوجد حالياً ملف workflow داخل `.github/workflows/` في هذا المستودع. لذلك لن يظهر APK تلقائياً في تبويب Actions بعد كل تحديث. هذه التعليمات للبناء المحلي إلى أن يُتخذ قرار منفصل بشأن إعادة تفعيل البناء الآلي.
