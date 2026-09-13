# Jawan Flutter Migration Audit

**Generated:** Sun Sep 13 14:37:45 CAT 2026

## 1. Git status
```text
## flutter-native-20260913...origin/flutter-native-20260913
?? CHANGELOG.md
?? JWAN_MIGRATION_AUDIT.md
?? git_audit.zip
?? git_mobile_history.txt
?? make_audit.sh
?? script.sh
```

## 2. Recent commits
```text
f439d6b (HEAD -> flutter-native-20260913, origin/flutter-native-20260913) fix: close order details scaffold
b348fbd ci: fix dart-define shell escaping, add url_launcher queries
c29df10 ci: pass Firebase dart-defines to release builds
c604533 fix: add url launcher dependency
aa93e81 fix: repair Flutter analyze errors
06657b0 feat: complete Flutter app improvements
ebc169d fix: correct Flutter vehicle label test
5a5d93c feat: build production Flutter foundation
21727ed (origin/main, origin/HEAD) Merge pull request #2 from jwan-delivery/flutter-native-20260913
90b2625 Merge pull request #1 from jwan-delivery/fix/mobile-production-20260912-223220
d6d1843 test: add initial Flutter widget test
da2e3a5 fix: prepare Flutter Android CI build
cd5e9ec fix: preserve Flutter application source during CI bootstrap
f5c5444 feat: bootstrap native Flutter Android app
4b9b56c (origin/fix/mobile-production-20260912-223220, fix/mobile-production-20260912-223220) fix: secure admin order deletion
e248a49 fix: update mobile admin driver and AI flows
36bcbcd fix: complete push notification flow
15c9347 (main, fix/mobile-production-20260912-222928) Add Android APK build workflow
48a2ffe Initial Jwan Delivery project with Android CI
```

## 3. All commits affecting mobile-app
```text
f439d6b (HEAD -> flutter-native-20260913, origin/flutter-native-20260913) fix: close order details scaffold
c604533 fix: add url launcher dependency
aa93e81 fix: repair Flutter analyze errors
06657b0 feat: complete Flutter app improvements
ebc169d fix: correct Flutter vehicle label test
5a5d93c feat: build production Flutter foundation
d6d1843 test: add initial Flutter widget test
da2e3a5 fix: prepare Flutter Android CI build
f5c5444 feat: bootstrap native Flutter Android app
e248a49 fix: update mobile admin driver and AI flows
48a2ffe Initial Jwan Delivery project with Android CI
```

## 4. Mobile-app file history
```text
--- f439d6bbfcc836f2209287cecfc37629400b91b6 fix: close order details scaffold

M	mobile-app/lib/main.dart
--- c6045339519a2c935c370cf961c071217763cd02 fix: add url launcher dependency

M	mobile-app/pubspec.yaml
--- aa93e810d6f1f4d1182064049fe923fb3bae3d2f fix: repair Flutter analyze errors

M	mobile-app/lib/main.dart
--- 06657b094a04b8523f04c1f26bd6ad0486f7b9b1 feat: complete Flutter app improvements

M	mobile-app/lib/main.dart
--- ebc169d50151422073e18d6d827cd36e9ff9aa21 fix: correct Flutter vehicle label test

M	mobile-app/test/widget_test.dart
--- 5a5d93cdeab0d8351b7c769f86a57674b194c87e feat: build production Flutter foundation

A	mobile-app/lib/firebase_options.dart
M	mobile-app/lib/main.dart
M	mobile-app/pubspec.yaml
M	mobile-app/test/widget_test.dart
--- d6d18439a33144b87b2575e56bcbba2cd67bbe73 test: add initial Flutter widget test

A	mobile-app/test/widget_test.dart
--- da2e3a575bcdbc8abecdc5f04dd32585f4a52b5c fix: prepare Flutter Android CI build

R100	mobile-app/flutter_spec.yaml	mobile-app/pubspec.yaml
--- f5c54442b12f09c624f5587f281e4233b24d8256 feat: bootstrap native Flutter Android app

A	mobile-app/flutter_spec.yaml
A	mobile-app/lib/main.dart
--- e248a496a9f88c731764220e2caf979428307efe fix: update mobile admin driver and AI flows

A	mobile-app/resources/icon.png
--- 48a2ffec4f21537ac6c6bdd846db0f8b2a6ff636 Initial Jwan Delivery project with Android CI

A	mobile-app/.gitignore
A	mobile-app/README-APK.md
A	mobile-app/android/.gitignore
A	mobile-app/android/app/.gitignore
A	mobile-app/android/app/build.gradle
A	mobile-app/android/app/build.gradle.before-apk-fix
A	mobile-app/android/app/capacitor.build.gradle
A	mobile-app/android/app/proguard-rules.pro
A	mobile-app/android/app/src/androidTest/java/com/getcapacitor/myapp/ExampleInstrumentedTest.java
A	mobile-app/android/app/src/main/AndroidManifest.xml
A	mobile-app/android/app/src/main/java/sd/jawan/delivery/MainActivity.java
A	mobile-app/android/app/src/main/res/drawable-land-hdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-land-ldpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-land-mdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-land-night-hdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-land-night-ldpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-land-night-mdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-land-night-xhdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-land-night-xxhdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-land-night-xxxhdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-land-xhdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-land-xxhdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-land-xxxhdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-night/splash.png
A	mobile-app/android/app/src/main/res/drawable-port-hdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-port-ldpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-port-mdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-port-night-hdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-port-night-ldpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-port-night-mdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-port-night-xhdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-port-night-xxhdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-port-night-xxxhdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-port-xhdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-port-xxhdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-port-xxxhdpi/splash.png
A	mobile-app/android/app/src/main/res/drawable-v24/ic_launcher_foreground.xml
A	mobile-app/android/app/src/main/res/drawable/ic_launcher_background.xml
A	mobile-app/android/app/src/main/res/drawable/splash.png
A	mobile-app/android/app/src/main/res/layout/activity_main.xml
A	mobile-app/android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml
A	mobile-app/android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml
A	mobile-app/android/app/src/main/res/mipmap-hdpi/ic_launcher.png
A	mobile-app/android/app/src/main/res/mipmap-hdpi/ic_launcher_background.png
A	mobile-app/android/app/src/main/res/mipmap-hdpi/ic_launcher_foreground.png
A	mobile-app/android/app/src/main/res/mipmap-hdpi/ic_launcher_round.png
A	mobile-app/android/app/src/main/res/mipmap-ldpi/ic_launcher.png
A	mobile-app/android/app/src/main/res/mipmap-ldpi/ic_launcher_background.png
A	mobile-app/android/app/src/main/res/mipmap-ldpi/ic_launcher_foreground.png
A	mobile-app/android/app/src/main/res/mipmap-ldpi/ic_launcher_round.png
A	mobile-app/android/app/src/main/res/mipmap-mdpi/ic_launcher.png
A	mobile-app/android/app/src/main/res/mipmap-mdpi/ic_launcher_background.png
A	mobile-app/android/app/src/main/res/mipmap-mdpi/ic_launcher_foreground.png
A	mobile-app/android/app/src/main/res/mipmap-mdpi/ic_launcher_round.png
A	mobile-app/android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
A	mobile-app/android/app/src/main/res/mipmap-xhdpi/ic_launcher_background.png
A	mobile-app/android/app/src/main/res/mipmap-xhdpi/ic_launcher_foreground.png
A	mobile-app/android/app/src/main/res/mipmap-xhdpi/ic_launcher_round.png
A	mobile-app/android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
A	mobile-app/android/app/src/main/res/mipmap-xxhdpi/ic_launcher_background.png
A	mobile-app/android/app/src/main/res/mipmap-xxhdpi/ic_launcher_foreground.png
A	mobile-app/android/app/src/main/res/mipmap-xxhdpi/ic_launcher_round.png
A	mobile-app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
A	mobile-app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_background.png
A	mobile-app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png
A	mobile-app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_round.png
A	mobile-app/android/app/src/main/res/values/ic_launcher_background.xml
A	mobile-app/android/app/src/main/res/values/strings.xml
A	mobile-app/android/app/src/main/res/values/styles.xml
A	mobile-app/android/app/src/main/res/xml/file_paths.xml
A	mobile-app/android/app/src/test/java/com/getcapacitor/myapp/ExampleUnitTest.java
A	mobile-app/android/build.gradle
A	mobile-app/android/capacitor.settings.gradle
A	mobile-app/android/gradle.properties
A	mobile-app/android/gradle/wrapper/gradle-wrapper.jar
A	mobile-app/android/gradle/wrapper/gradle-wrapper.properties
A	mobile-app/android/gradlew
A	mobile-app/android/gradlew.bat
A	mobile-app/android/settings.gradle
A	mobile-app/android/variables.gradle
A	mobile-app/capacitor.config.ts
A	mobile-app/logo-backup/ic_launcher.png
A	mobile-app/logo-backup/ic_launcher_round.png
A	mobile-app/package-lock.json
A	mobile-app/package.json
A	mobile-app/sync-web.sh
```

## 5. Mobile-app statistics
```text
--- f439d6bbfcc836f2209287cecfc37629400b91b6 fix: close order details scaffold

 mobile-app/lib/main.dart | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
--- c6045339519a2c935c370cf961c071217763cd02 fix: add url launcher dependency

 mobile-app/pubspec.yaml | 1 +
 1 file changed, 1 insertion(+)
--- aa93e810d6f1f4d1182064049fe923fb3bae3d2f fix: repair Flutter analyze errors

 mobile-app/lib/main.dart | 59 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 52 insertions(+), 7 deletions(-)
--- 06657b094a04b8523f04c1f26bd6ad0486f7b9b1 feat: complete Flutter app improvements

 mobile-app/lib/main.dart | 203 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 198 insertions(+), 5 deletions(-)
--- ebc169d50151422073e18d6d827cd36e9ff9aa21 fix: correct Flutter vehicle label test

 mobile-app/test/widget_test.dart | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
--- 5a5d93cdeab0d8351b7c769f86a57674b194c87e feat: build production Flutter foundation

 mobile-app/lib/firebase_options.dart |  19 +
 mobile-app/lib/main.dart             | 832 +++++++++++++++++++++++++++--------
 mobile-app/pubspec.yaml              |   9 +-
 mobile-app/test/widget_test.dart     |  12 +-
 4 files changed, 689 insertions(+), 183 deletions(-)
--- d6d18439a33144b87b2575e56bcbba2cd67bbe73 test: add initial Flutter widget test

 mobile-app/test/widget_test.dart | 10 ++++++++++
 1 file changed, 10 insertions(+)
--- da2e3a575bcdbc8abecdc5f04dd32585f4a52b5c fix: prepare Flutter Android CI build

 mobile-app/{flutter_spec.yaml => pubspec.yaml} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
--- f5c54442b12f09c624f5587f281e4233b24d8256 feat: bootstrap native Flutter Android app

 mobile-app/flutter_spec.yaml |  22 +++++
 mobile-app/lib/main.dart     | 210 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 232 insertions(+)
--- e248a496a9f88c731764220e2caf979428307efe fix: update mobile admin driver and AI flows

 mobile-app/resources/icon.png | Bin 0 -> 1240182 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
--- 48a2ffec4f21537ac6c6bdd846db0f8b2a6ff636 Initial Jwan Delivery project with Android CI

 mobile-app/.gitignore                              |    8 +
 mobile-app/README-APK.md                           |   37 +
 mobile-app/android/.gitignore                      |  101 +
 mobile-app/android/app/.gitignore                  |    2 +
 mobile-app/android/app/build.gradle                |   55 +
 mobile-app/android/app/build.gradle.before-apk-fix |   54 +
 mobile-app/android/app/capacitor.build.gradle      |   19 +
 mobile-app/android/app/proguard-rules.pro          |   21 +
 .../myapp/ExampleInstrumentedTest.java             |   26 +
 .../android/app/src/main/AndroidManifest.xml       |   35 +
 .../main/java/sd/jawan/delivery/MainActivity.java  |    5 +
 .../app/src/main/res/drawable-land-hdpi/splash.png |  Bin 0 -> 11003 bytes
 .../app/src/main/res/drawable-land-ldpi/splash.png |  Bin 0 -> 3794 bytes
 .../app/src/main/res/drawable-land-mdpi/splash.png |  Bin 0 -> 6149 bytes
 .../main/res/drawable-land-night-hdpi/splash.png   |  Bin 0 -> 16428 bytes
 .../main/res/drawable-land-night-ldpi/splash.png   |  Bin 0 -> 4669 bytes
 .../main/res/drawable-land-night-mdpi/splash.png   |  Bin 0 -> 8234 bytes
 .../main/res/drawable-land-night-xhdpi/splash.png  |  Bin 0 -> 30814 bytes
 .../main/res/drawable-land-night-xxhdpi/splash.png |  Bin 0 -> 47081 bytes
 .../res/drawable-land-night-xxxhdpi/splash.png     |  Bin 0 -> 68624 bytes
 .../src/main/res/drawable-land-xhdpi/splash.png    |  Bin 0 -> 18701 bytes
 .../src/main/res/drawable-land-xxhdpi/splash.png   |  Bin 0 -> 25914 bytes
 .../src/main/res/drawable-land-xxxhdpi/splash.png  |  Bin 0 -> 34431 bytes
 .../app/src/main/res/drawable-night/splash.png     |  Bin 0 -> 4669 bytes
 .../app/src/main/res/drawable-port-hdpi/splash.png |  Bin 0 -> 8108 bytes
 .../app/src/main/res/drawable-port-ldpi/splash.png |  Bin 0 -> 3244 bytes
 .../app/src/main/res/drawable-port-mdpi/splash.png |  Bin 0 -> 4656 bytes
 .../main/res/drawable-port-night-hdpi/splash.png   |  Bin 0 -> 14351 bytes
 .../main/res/drawable-port-night-ldpi/splash.png   |  Bin 0 -> 4206 bytes
 .../main/res/drawable-port-night-mdpi/splash.png   |  Bin 0 -> 6663 bytes
 .../main/res/drawable-port-night-xhdpi/splash.png  |  Bin 0 -> 29086 bytes
 .../main/res/drawable-port-night-xxhdpi/splash.png |  Bin 0 -> 42010 bytes
 .../res/drawable-port-night-xxxhdpi/splash.png     |  Bin 0 -> 63269 bytes
 .../src/main/res/drawable-port-xhdpi/splash.png    |  Bin 0 -> 13785 bytes
 .../src/main/res/drawable-port-xxhdpi/splash.png   |  Bin 0 -> 19548 bytes
 .../src/main/res/drawable-port-xxxhdpi/splash.png  |  Bin 0 -> 27292 bytes
 .../res/drawable-v24/ic_launcher_foreground.xml    |   34 +
 .../main/res/drawable/ic_launcher_background.xml   |  170 ++
 .../android/app/src/main/res/drawable/splash.png   |  Bin 0 -> 4656 bytes
 .../app/src/main/res/layout/activity_main.xml      |   12 +
 .../src/main/res/mipmap-anydpi-v26/ic_launcher.xml |    9 +
 .../res/mipmap-anydpi-v26/ic_launcher_round.xml    |    9 +
 .../app/src/main/res/mipmap-hdpi/ic_launcher.png   |  Bin 0 -> 2490 bytes
 .../res/mipmap-hdpi/ic_launcher_background.png     |  Bin 0 -> 213 bytes
 .../res/mipmap-hdpi/ic_launcher_foreground.png     |  Bin 0 -> 2809 bytes
 .../src/main/res/mipmap-hdpi/ic_launcher_round.png |  Bin 0 -> 2690 bytes
 .../app/src/main/res/mipmap-ldpi/ic_launcher.png   |  Bin 0 -> 771 bytes
 .../res/mipmap-ldpi/ic_launcher_background.png     |  Bin 0 -> 147 bytes
 .../res/mipmap-ldpi/ic_launcher_foreground.png     |  Bin 0 -> 1297 bytes
 .../src/main/res/mipmap-ldpi/ic_launcher_round.png |  Bin 0 -> 1301 bytes
 .../app/src/main/res/mipmap-mdpi/ic_launcher.png   |  Bin 0 -> 1306 bytes
 .../res/mipmap-mdpi/ic_launcher_background.png     |  Bin 0 -> 176 bytes
 .../res/mipmap-mdpi/ic_launcher_foreground.png     |  Bin 0 -> 1819 bytes
 .../src/main/res/mipmap-mdpi/ic_launcher_round.png |  Bin 0 -> 1776 bytes
 .../app/src/main/res/mipmap-xhdpi/ic_launcher.png  |  Bin 0 -> 3618 bytes
 .../res/mipmap-xhdpi/ic_launcher_background.png    |  Bin 0 -> 285 bytes
 .../res/mipmap-xhdpi/ic_launcher_foreground.png    |  Bin 0 -> 3791 bytes
 .../main/res/mipmap-xhdpi/ic_launcher_round.png    |  Bin 0 -> 3614 bytes
 .../app/src/main/res/mipmap-xxhdpi/ic_launcher.png |  Bin 0 -> 6544 bytes
 .../res/mipmap-xxhdpi/ic_launcher_background.png   |  Bin 0 -> 432 bytes
 .../res/mipmap-xxhdpi/ic_launcher_foreground.png   |  Bin 0 -> 5879 bytes
 .../main/res/mipmap-xxhdpi/ic_launcher_round.png   |  Bin 0 -> 5449 bytes
 .../src/main/res/mipmap-xxxhdpi/ic_launcher.png    |  Bin 0 -> 9314 bytes
 .../res/mipmap-xxxhdpi/ic_launcher_background.png  |  Bin 0 -> 559 bytes
 .../res/mipmap-xxxhdpi/ic_launcher_foreground.png  |  Bin 0 -> 7993 bytes
 .../main/res/mipmap-xxxhdpi/ic_launcher_round.png  |  Bin 0 -> 7610 bytes
 .../src/main/res/values/ic_launcher_background.xml |    4 +
 .../android/app/src/main/res/values/strings.xml    |    7 +
 .../android/app/src/main/res/values/styles.xml     |   22 +
 .../android/app/src/main/res/xml/file_paths.xml    |    5 +
 .../com/getcapacitor/myapp/ExampleUnitTest.java    |   18 +
 mobile-app/android/build.gradle                    |   30 +
 mobile-app/android/capacitor.settings.gradle       |    3 +
 mobile-app/android/gradle.properties               |   24 +
 .../android/gradle/wrapper/gradle-wrapper.jar      |  Bin 0 -> 43764 bytes
 .../gradle/wrapper/gradle-wrapper.properties       |    7 +
 mobile-app/android/gradlew                         |  251 ++
 mobile-app/android/gradlew.bat                     |   94 +
 mobile-app/android/settings.gradle                 |    5 +
 mobile-app/android/variables.gradle                |   16 +
 mobile-app/capacitor.config.ts                     |   14 +
 mobile-app/logo-backup/ic_launcher.png             |  Bin 0 -> 2490 bytes
 mobile-app/logo-backup/ic_launcher_round.png       |  Bin 0 -> 2690 bytes
 mobile-app/package-lock.json                       | 3111 ++++++++++++++++++++
 mobile-app/package.json                            |   20 +
 mobile-app/sync-web.sh                             |    9 +
 86 files changed, 4237 insertions(+)
```

## 6. Current mobile-app tree
```text
mobile-app/.gitignore
mobile-app/README-APK.md
mobile-app/android/.gitignore
mobile-app/android/.gradle/8.14.3/gc.properties
mobile-app/android/.gradle/buildOutputCleanup/buildOutputCleanup.lock
mobile-app/android/.gradle/buildOutputCleanup/cache.properties
mobile-app/android/.gradle/vcs-1/gc.properties
mobile-app/android/app/.gitignore
mobile-app/android/app/build.gradle
mobile-app/android/app/build.gradle.before-apk-fix
mobile-app/android/app/capacitor.build.gradle
mobile-app/android/app/google-services.json
mobile-app/android/app/proguard-rules.pro
mobile-app/android/build.gradle
mobile-app/android/build.gradle.backup-before-btfix
mobile-app/android/capacitor-cordova-android-plugins/build.gradle
mobile-app/android/capacitor-cordova-android-plugins/cordova.variables.gradle
mobile-app/android/capacitor.settings.gradle
mobile-app/android/gradle.properties
mobile-app/android/gradle/wrapper/gradle-wrapper.jar
mobile-app/android/gradle/wrapper/gradle-wrapper.properties
mobile-app/android/gradlew
mobile-app/android/gradlew.bat
mobile-app/android/local.properties
mobile-app/android/settings.gradle
mobile-app/android/variables.gradle
mobile-app/capacitor.config.ts
mobile-app/lib/firebase_options.dart
mobile-app/lib/firebase_options.dart.backup-20260913-132039
mobile-app/lib/firebase_options.dart.backup-20260913-132254
mobile-app/lib/main.dart
mobile-app/lib/main.dart.backup-20260913-112825
mobile-app/lib/main.dart.backup-20260913-132039
mobile-app/lib/main.dart.backup-20260913-132254
mobile-app/logo-backup/ic_launcher.png
mobile-app/logo-backup/ic_launcher_round.png
mobile-app/node_modules/.package-lock.json
mobile-app/node_modules/@capacitor/android/LICENSE
mobile-app/node_modules/@capacitor/android/package.json
mobile-app/node_modules/@capacitor/assets/LICENSE
mobile-app/node_modules/@capacitor/assets/README.md
mobile-app/node_modules/@capacitor/assets/package.json
mobile-app/node_modules/@capacitor/cli/LICENSE
mobile-app/node_modules/@capacitor/cli/README.md
mobile-app/node_modules/@capacitor/cli/package.json
mobile-app/node_modules/@capacitor/core/LICENSE
mobile-app/node_modules/@capacitor/core/README.md
mobile-app/node_modules/@capacitor/core/cookies.md
mobile-app/node_modules/@capacitor/core/cordova.js
mobile-app/node_modules/@capacitor/core/http.md
mobile-app/node_modules/@capacitor/core/package.json
mobile-app/node_modules/@capacitor/core/system-bars.md
mobile-app/node_modules/@ionic/cli-framework-output/LICENSE
mobile-app/node_modules/@ionic/cli-framework-output/README.md
mobile-app/node_modules/@ionic/cli-framework-output/package.json
mobile-app/node_modules/@ionic/utils-array/CHANGELOG.md
mobile-app/node_modules/@ionic/utils-array/LICENSE
mobile-app/node_modules/@ionic/utils-array/README.md
mobile-app/node_modules/@ionic/utils-array/package.json
mobile-app/node_modules/@ionic/utils-fs/CHANGELOG.md
mobile-app/node_modules/@ionic/utils-fs/LICENSE
mobile-app/node_modules/@ionic/utils-fs/README.md
mobile-app/node_modules/@ionic/utils-fs/package.json
mobile-app/node_modules/@ionic/utils-object/CHANGELOG.md
mobile-app/node_modules/@ionic/utils-object/LICENSE
mobile-app/node_modules/@ionic/utils-object/README.md
mobile-app/node_modules/@ionic/utils-object/package.json
mobile-app/node_modules/@ionic/utils-process/LICENSE
mobile-app/node_modules/@ionic/utils-process/README.md
mobile-app/node_modules/@ionic/utils-process/package.json
mobile-app/node_modules/@ionic/utils-stream/LICENSE
mobile-app/node_modules/@ionic/utils-stream/README.md
mobile-app/node_modules/@ionic/utils-stream/package.json
mobile-app/node_modules/@ionic/utils-subprocess/LICENSE
mobile-app/node_modules/@ionic/utils-subprocess/README.md
mobile-app/node_modules/@ionic/utils-subprocess/package.json
mobile-app/node_modules/@ionic/utils-terminal/LICENSE
mobile-app/node_modules/@ionic/utils-terminal/README.md
mobile-app/node_modules/@ionic/utils-terminal/package.json
mobile-app/node_modules/@isaacs/fs-minipass/LICENSE
mobile-app/node_modules/@isaacs/fs-minipass/README.md
mobile-app/node_modules/@isaacs/fs-minipass/package.json
mobile-app/node_modules/@prettier/plugin-xml/CHANGELOG.md
mobile-app/node_modules/@prettier/plugin-xml/LICENSE
mobile-app/node_modules/@prettier/plugin-xml/README.md
mobile-app/node_modules/@prettier/plugin-xml/package.json
mobile-app/node_modules/@prettier/plugin-xml/tsconfig.build.json
mobile-app/node_modules/@prettier/plugin-xml/tsconfig.json
mobile-app/node_modules/@trapezedev/gradle-parse/LICENSE
mobile-app/node_modules/@trapezedev/gradle-parse/capacitor-gradle-parse.jar
mobile-app/node_modules/@trapezedev/gradle-parse/index.js
mobile-app/node_modules/@trapezedev/gradle-parse/package.json
mobile-app/node_modules/@trapezedev/project/LICENSE
mobile-app/node_modules/@trapezedev/project/package.json
mobile-app/node_modules/@types/fs-extra/LICENSE
mobile-app/node_modules/@types/fs-extra/README.md
mobile-app/node_modules/@types/fs-extra/index.d.ts
mobile-app/node_modules/@types/fs-extra/package.json
mobile-app/node_modules/@types/node/LICENSE
mobile-app/node_modules/@types/node/README.md
mobile-app/node_modules/@types/node/assert.d.ts
mobile-app/node_modules/@types/node/async_hooks.d.ts
mobile-app/node_modules/@types/node/buffer.buffer.d.ts
mobile-app/node_modules/@types/node/buffer.d.ts
mobile-app/node_modules/@types/node/child_process.d.ts
mobile-app/node_modules/@types/node/cluster.d.ts
mobile-app/node_modules/@types/node/console.d.ts
mobile-app/node_modules/@types/node/constants.d.ts
mobile-app/node_modules/@types/node/crypto.d.ts
mobile-app/node_modules/@types/node/dgram.d.ts
mobile-app/node_modules/@types/node/diagnostics_channel.d.ts
mobile-app/node_modules/@types/node/dns.d.ts
mobile-app/node_modules/@types/node/domain.d.ts
mobile-app/node_modules/@types/node/events.d.ts
mobile-app/node_modules/@types/node/ffi.d.ts
mobile-app/node_modules/@types/node/fs.d.ts
mobile-app/node_modules/@types/node/globals.d.ts
mobile-app/node_modules/@types/node/globals.typedarray.d.ts
mobile-app/node_modules/@types/node/http.d.ts
mobile-app/node_modules/@types/node/http2.d.ts
mobile-app/node_modules/@types/node/https.d.ts
mobile-app/node_modules/@types/node/index.d.ts
mobile-app/node_modules/@types/node/inspector.d.ts
mobile-app/node_modules/@types/node/inspector.generated.d.ts
mobile-app/node_modules/@types/node/module.d.ts
mobile-app/node_modules/@types/node/net.d.ts
mobile-app/node_modules/@types/node/os.d.ts
mobile-app/node_modules/@types/node/package.json
mobile-app/node_modules/@types/node/path.d.ts
mobile-app/node_modules/@types/node/perf_hooks.d.ts
mobile-app/node_modules/@types/node/process.d.ts
mobile-app/node_modules/@types/node/punycode.d.ts
mobile-app/node_modules/@types/node/querystring.d.ts
mobile-app/node_modules/@types/node/quic.d.ts
mobile-app/node_modules/@types/node/readline.d.ts
mobile-app/node_modules/@types/node/repl.d.ts
mobile-app/node_modules/@types/node/sea.d.ts
mobile-app/node_modules/@types/node/sqlite.d.ts
mobile-app/node_modules/@types/node/stream.d.ts
mobile-app/node_modules/@types/node/string_decoder.d.ts
mobile-app/node_modules/@types/node/test.d.ts
mobile-app/node_modules/@types/node/timers.d.ts
mobile-app/node_modules/@types/node/tls.d.ts
mobile-app/node_modules/@types/node/trace_events.d.ts
mobile-app/node_modules/@types/node/tty.d.ts
mobile-app/node_modules/@types/node/url.d.ts
mobile-app/node_modules/@types/node/util.d.ts
mobile-app/node_modules/@types/node/v8.d.ts
mobile-app/node_modules/@types/node/vfs.d.ts
mobile-app/node_modules/@types/node/vm.d.ts
mobile-app/node_modules/@types/node/wasi.d.ts
mobile-app/node_modules/@types/node/worker_threads.d.ts
mobile-app/node_modules/@types/node/zlib.d.ts
mobile-app/node_modules/@types/slice-ansi/LICENSE
mobile-app/node_modules/@types/slice-ansi/README.md
mobile-app/node_modules/@types/slice-ansi/index.d.ts
mobile-app/node_modules/@types/slice-ansi/package.json
mobile-app/node_modules/@xml-tools/parser/LICENSE
mobile-app/node_modules/@xml-tools/parser/README.md
mobile-app/node_modules/@xml-tools/parser/api.d.ts
mobile-app/node_modules/@xml-tools/parser/package.json
mobile-app/node_modules/@xmldom/xmldom/CHANGELOG.md
mobile-app/node_modules/@xmldom/xmldom/LICENSE
mobile-app/node_modules/@xmldom/xmldom/SECURITY.md
mobile-app/node_modules/@xmldom/xmldom/index.d.ts
mobile-app/node_modules/@xmldom/xmldom/package.json
mobile-app/node_modules/@xmldom/xmldom/readme.md
mobile-app/node_modules/ansi-regex/index.d.ts
mobile-app/node_modules/ansi-regex/index.js
mobile-app/node_modules/ansi-regex/license
mobile-app/node_modules/ansi-regex/package.json
mobile-app/node_modules/ansi-regex/readme.md
mobile-app/node_modules/ansi-styles/index.d.ts
mobile-app/node_modules/ansi-styles/index.js
mobile-app/node_modules/ansi-styles/license
mobile-app/node_modules/ansi-styles/package.json
mobile-app/node_modules/ansi-styles/readme.md
mobile-app/node_modules/astral-regex/index.d.ts
mobile-app/node_modules/astral-regex/index.js
mobile-app/node_modules/astral-regex/license
mobile-app/node_modules/astral-regex/package.json
mobile-app/node_modules/astral-regex/readme.md
mobile-app/node_modules/at-least-node/LICENSE
mobile-app/node_modules/at-least-node/README.md
mobile-app/node_modules/at-least-node/index.js
mobile-app/node_modules/at-least-node/package.json
mobile-app/node_modules/b4a/LICENSE
mobile-app/node_modules/b4a/README.md
mobile-app/node_modules/b4a/browser.js
mobile-app/node_modules/b4a/index.js
mobile-app/node_modules/b4a/lib/ascii.js
mobile-app/node_modules/b4a/lib/base64.js
mobile-app/node_modules/b4a/lib/hex.js
mobile-app/node_modules/b4a/lib/latin1.js
mobile-app/node_modules/b4a/lib/utf16le.js
mobile-app/node_modules/b4a/lib/utf8.js
mobile-app/node_modules/b4a/package.json
mobile-app/node_modules/b4a/react-native.js
mobile-app/node_modules/balanced-match/LICENSE.md
mobile-app/node_modules/balanced-match/README.md
mobile-app/node_modules/balanced-match/package.json
mobile-app/node_modules/bare-events/LICENSE
mobile-app/node_modules/bare-events/README.md
mobile-app/node_modules/bare-events/global.d.ts
mobile-app/node_modules/bare-events/global.js
mobile-app/node_modules/bare-events/index.d.ts
mobile-app/node_modules/bare-events/index.js
mobile-app/node_modules/bare-events/lib/errors.js
mobile-app/node_modules/bare-events/package.json
mobile-app/node_modules/bare-events/web.d.ts
mobile-app/node_modules/bare-events/web.js
mobile-app/node_modules/bare-fs/CMakeLists.txt
mobile-app/node_modules/bare-fs/LICENSE
mobile-app/node_modules/bare-fs/README.md
mobile-app/node_modules/bare-fs/binding.c
mobile-app/node_modules/bare-fs/binding.js
mobile-app/node_modules/bare-fs/index.d.ts
mobile-app/node_modules/bare-fs/index.js
mobile-app/node_modules/bare-fs/lib/constants.d.ts
mobile-app/node_modules/bare-fs/lib/constants.js
mobile-app/node_modules/bare-fs/lib/errors.d.ts
mobile-app/node_modules/bare-fs/lib/errors.js
mobile-app/node_modules/bare-fs/package.json
mobile-app/node_modules/bare-fs/promises.d.ts
mobile-app/node_modules/bare-fs/promises.js
mobile-app/node_modules/bare-path/CMakeLists.txt
mobile-app/node_modules/bare-path/LICENSE
mobile-app/node_modules/bare-path/NOTICE
mobile-app/node_modules/bare-path/README.md
mobile-app/node_modules/bare-path/binding.c
mobile-app/node_modules/bare-path/binding.js
mobile-app/node_modules/bare-path/index.d.ts
mobile-app/node_modules/bare-path/index.js
mobile-app/node_modules/bare-path/lib/constants.js
mobile-app/node_modules/bare-path/lib/posix.js
mobile-app/node_modules/bare-path/lib/shared.js
mobile-app/node_modules/bare-path/lib/win32.js
mobile-app/node_modules/bare-path/package.json
mobile-app/node_modules/bare-stream/LICENSE
mobile-app/node_modules/bare-stream/README.md
mobile-app/node_modules/bare-stream/global.d.ts
mobile-app/node_modules/bare-stream/global.js
mobile-app/node_modules/bare-stream/index.d.ts
mobile-app/node_modules/bare-stream/index.js
mobile-app/node_modules/bare-stream/package.json
mobile-app/node_modules/bare-stream/promises.js
mobile-app/node_modules/bare-stream/web.d.ts
mobile-app/node_modules/bare-stream/web.js
mobile-app/node_modules/bare-url/CMakeLists.txt
mobile-app/node_modules/bare-url/LICENSE
mobile-app/node_modules/bare-url/README.md
mobile-app/node_modules/bare-url/binding.c
mobile-app/node_modules/bare-url/binding.js
mobile-app/node_modules/bare-url/global.d.ts
mobile-app/node_modules/bare-url/global.js
mobile-app/node_modules/bare-url/index.d.ts
mobile-app/node_modules/bare-url/index.js
mobile-app/node_modules/bare-url/lib/errors.d.ts
mobile-app/node_modules/bare-url/lib/errors.js
mobile-app/node_modules/bare-url/lib/url-search-params.d.ts
mobile-app/node_modules/bare-url/lib/url-search-params.js
mobile-app/node_modules/bare-url/package.json
mobile-app/node_modules/base64-js/LICENSE
mobile-app/node_modules/base64-js/README.md
mobile-app/node_modules/base64-js/base64js.min.js
mobile-app/node_modules/base64-js/index.d.ts
mobile-app/node_modules/base64-js/index.js
mobile-app/node_modules/base64-js/package.json
mobile-app/node_modules/big-integer/BigInteger.d.ts
mobile-app/node_modules/big-integer/BigInteger.js
mobile-app/node_modules/big-integer/BigInteger.min.js
mobile-app/node_modules/big-integer/LICENSE
mobile-app/node_modules/big-integer/README.md
mobile-app/node_modules/big-integer/bower.json
mobile-app/node_modules/big-integer/package.json
mobile-app/node_modules/big-integer/tsconfig.json
mobile-app/node_modules/bl/.travis.yml
mobile-app/node_modules/bl/BufferList.js
mobile-app/node_modules/bl/LICENSE.md
mobile-app/node_modules/bl/README.md
mobile-app/node_modules/bl/bl.js
mobile-app/node_modules/bl/package.json
mobile-app/node_modules/bl/test/convert.js
mobile-app/node_modules/bl/test/indexOf.js
mobile-app/node_modules/bl/test/isBufferList.js
mobile-app/node_modules/bl/test/test.js
mobile-app/node_modules/boolbase/README.md
mobile-app/node_modules/boolbase/index.js
mobile-app/node_modules/boolbase/package.json
mobile-app/node_modules/bplist-creator/LICENSE
mobile-app/node_modules/bplist-creator/README.md
mobile-app/node_modules/bplist-creator/bplistCreator.js
mobile-app/node_modules/bplist-creator/package.json
mobile-app/node_modules/bplist-creator/test/airplay.bplist
mobile-app/node_modules/bplist-creator/test/binaryData.bplist
mobile-app/node_modules/bplist-creator/test/creatorTest.js
mobile-app/node_modules/bplist-creator/test/iTunes-small.bplist
mobile-app/node_modules/bplist-creator/test/integers.bplist
mobile-app/node_modules/bplist-creator/test/sample1.bplist
mobile-app/node_modules/bplist-creator/test/sample2.bplist
mobile-app/node_modules/bplist-creator/test/uid.bplist
mobile-app/node_modules/bplist-creator/test/utf16.bplist
mobile-app/node_modules/bplist-parser/.editorconfig
mobile-app/node_modules/bplist-parser/.eslintignore
mobile-app/node_modules/bplist-parser/.eslintrc.js
mobile-app/node_modules/bplist-parser/README.md
mobile-app/node_modules/bplist-parser/bplistParser.d.ts
mobile-app/node_modules/bplist-parser/bplistParser.js
mobile-app/node_modules/bplist-parser/package.json
mobile-app/node_modules/brace-expansion/LICENSE
mobile-app/node_modules/brace-expansion/README.md
mobile-app/node_modules/brace-expansion/package.json
mobile-app/node_modules/buffer-crc32/LICENSE
mobile-app/node_modules/buffer-crc32/README.md
mobile-app/node_modules/buffer-crc32/index.js
mobile-app/node_modules/buffer-crc32/package.json
mobile-app/node_modules/buffer/AUTHORS.md
mobile-app/node_modules/buffer/LICENSE
mobile-app/node_modules/buffer/README.md
mobile-app/node_modules/buffer/index.d.ts
mobile-app/node_modules/buffer/index.js
mobile-app/node_modules/buffer/package.json
mobile-app/node_modules/chevrotain/CHANGELOG.md
mobile-app/node_modules/chevrotain/LICENSE.txt
mobile-app/node_modules/chevrotain/README.md
mobile-app/node_modules/chevrotain/diagrams/README.md
mobile-app/node_modules/chevrotain/diagrams/diagrams.css
mobile-app/node_modules/chevrotain/lib/chevrotain.d.ts
mobile-app/node_modules/chevrotain/lib/chevrotain.js
mobile-app/node_modules/chevrotain/lib/chevrotain.min.js
mobile-app/node_modules/chevrotain/package.json
mobile-app/node_modules/chevrotain/src/api.ts
mobile-app/node_modules/chevrotain/src/version.ts
mobile-app/node_modules/chownr/LICENSE.md
mobile-app/node_modules/chownr/README.md
mobile-app/node_modules/chownr/package.json
mobile-app/node_modules/cliui/CHANGELOG.md
mobile-app/node_modules/cliui/LICENSE.txt
mobile-app/node_modules/cliui/README.md
mobile-app/node_modules/cliui/index.mjs
mobile-app/node_modules/cliui/package.json
mobile-app/node_modules/color-convert/CHANGELOG.md
mobile-app/node_modules/color-convert/LICENSE
mobile-app/node_modules/color-convert/README.md
mobile-app/node_modules/color-convert/conversions.js
mobile-app/node_modules/color-convert/index.js
mobile-app/node_modules/color-convert/package.json
mobile-app/node_modules/color-convert/route.js
mobile-app/node_modules/color-name/LICENSE
mobile-app/node_modules/color-name/README.md
mobile-app/node_modules/color-name/index.js
mobile-app/node_modules/color-name/package.json
mobile-app/node_modules/color-string/LICENSE
mobile-app/node_modules/color-string/README.md
mobile-app/node_modules/color-string/index.js
mobile-app/node_modules/color-string/package.json
mobile-app/node_modules/color/LICENSE
mobile-app/node_modules/color/README.md
mobile-app/node_modules/color/index.js
mobile-app/node_modules/color/package.json
mobile-app/node_modules/commander/LICENSE
mobile-app/node_modules/commander/Readme.md
mobile-app/node_modules/commander/esm.mjs
mobile-app/node_modules/commander/index.js
mobile-app/node_modules/commander/lib/argument.js
mobile-app/node_modules/commander/lib/command.js
mobile-app/node_modules/commander/lib/error.js
mobile-app/node_modules/commander/lib/help.js
mobile-app/node_modules/commander/lib/option.js
mobile-app/node_modules/commander/lib/suggestSimilar.js
mobile-app/node_modules/commander/package-support.json
mobile-app/node_modules/commander/package.json
mobile-app/node_modules/commander/typings/esm.d.mts
mobile-app/node_modules/commander/typings/index.d.ts
mobile-app/node_modules/cross-spawn/LICENSE
mobile-app/node_modules/cross-spawn/README.md
mobile-app/node_modules/cross-spawn/index.js
mobile-app/node_modules/cross-spawn/lib/enoent.js
mobile-app/node_modules/cross-spawn/lib/parse.js
mobile-app/node_modules/cross-spawn/package.json
mobile-app/node_modules/css-select/LICENSE
mobile-app/node_modules/css-select/README.md
mobile-app/node_modules/css-select/lib/attributes.d.ts
mobile-app/node_modules/css-select/lib/attributes.d.ts.map
mobile-app/node_modules/css-select/lib/attributes.js
mobile-app/node_modules/css-select/lib/compile.d.ts
mobile-app/node_modules/css-select/lib/compile.d.ts.map
mobile-app/node_modules/css-select/lib/compile.js
mobile-app/node_modules/css-select/lib/general.d.ts
mobile-app/node_modules/css-select/lib/general.d.ts.map
mobile-app/node_modules/css-select/lib/general.js
mobile-app/node_modules/css-select/lib/index.d.ts
mobile-app/node_modules/css-select/lib/index.d.ts.map
mobile-app/node_modules/css-select/lib/index.js
mobile-app/node_modules/css-select/lib/procedure.d.ts
mobile-app/node_modules/css-select/lib/procedure.d.ts.map
mobile-app/node_modules/css-select/lib/procedure.js
mobile-app/node_modules/css-select/lib/sort.d.ts
mobile-app/node_modules/css-select/lib/sort.d.ts.map
mobile-app/node_modules/css-select/lib/sort.js
mobile-app/node_modules/css-select/lib/types.d.ts
mobile-app/node_modules/css-select/lib/types.d.ts.map
mobile-app/node_modules/css-select/lib/types.js
mobile-app/node_modules/css-select/package.json
mobile-app/node_modules/css-what/LICENSE
mobile-app/node_modules/css-what/package.json
mobile-app/node_modules/css-what/readme.md
mobile-app/node_modules/debug/LICENSE
mobile-app/node_modules/debug/README.md
mobile-app/node_modules/debug/package.json
mobile-app/node_modules/debug/src/browser.js
mobile-app/node_modules/debug/src/common.js
mobile-app/node_modules/debug/src/index.js
mobile-app/node_modules/debug/src/node.js
mobile-app/node_modules/decompress-response/index.d.ts
mobile-app/node_modules/decompress-response/index.js
mobile-app/node_modules/decompress-response/license
mobile-app/node_modules/decompress-response/package.json
mobile-app/node_modules/decompress-response/readme.md
mobile-app/node_modules/deep-extend/CHANGELOG.md
mobile-app/node_modules/deep-extend/LICENSE
mobile-app/node_modules/deep-extend/README.md
mobile-app/node_modules/deep-extend/index.js
mobile-app/node_modules/deep-extend/lib/deep-extend.js
mobile-app/node_modules/deep-extend/package.json
mobile-app/node_modules/define-lazy-prop/index.d.ts
mobile-app/node_modules/define-lazy-prop/index.js
mobile-app/node_modules/define-lazy-prop/license
mobile-app/node_modules/define-lazy-prop/package.json
mobile-app/node_modules/define-lazy-prop/readme.md
mobile-app/node_modules/detect-libc/LICENSE
mobile-app/node_modules/detect-libc/README.md
mobile-app/node_modules/detect-libc/index.d.ts
mobile-app/node_modules/detect-libc/lib/detect-libc.js
mobile-app/node_modules/detect-libc/lib/elf.js
mobile-app/node_modules/detect-libc/lib/filesystem.js
mobile-app/node_modules/detect-libc/lib/process.js
mobile-app/node_modules/detect-libc/package.json
mobile-app/node_modules/diff/CONTRIBUTING.md
mobile-app/node_modules/diff/LICENSE
mobile-app/node_modules/diff/README.md
mobile-app/node_modules/diff/dist/diff.js
mobile-app/node_modules/diff/dist/diff.min.js
mobile-app/node_modules/diff/lib/index.es6.js
mobile-app/node_modules/diff/lib/index.js
mobile-app/node_modules/diff/lib/index.mjs
mobile-app/node_modules/diff/package.json
mobile-app/node_modules/diff/release-notes.md
mobile-app/node_modules/diff/runtime.js
mobile-app/node_modules/dom-serializer/LICENSE
mobile-app/node_modules/dom-serializer/README.md
mobile-app/node_modules/dom-serializer/lib/foreignNames.d.ts
mobile-app/node_modules/dom-serializer/lib/foreignNames.d.ts.map
mobile-app/node_modules/dom-serializer/lib/foreignNames.js
mobile-app/node_modules/dom-serializer/lib/index.d.ts
mobile-app/node_modules/dom-serializer/lib/index.d.ts.map
mobile-app/node_modules/dom-serializer/lib/index.js
mobile-app/node_modules/dom-serializer/package.json
mobile-app/node_modules/domelementtype/LICENSE
mobile-app/node_modules/domelementtype/lib/index.d.ts
mobile-app/node_modules/domelementtype/lib/index.d.ts.map
mobile-app/node_modules/domelementtype/lib/index.js
mobile-app/node_modules/domelementtype/package.json
mobile-app/node_modules/domelementtype/readme.md
mobile-app/node_modules/domhandler/LICENSE
mobile-app/node_modules/domhandler/lib/index.d.ts
mobile-app/node_modules/domhandler/lib/index.d.ts.map
mobile-app/node_modules/domhandler/lib/index.js
mobile-app/node_modules/domhandler/lib/node.d.ts
mobile-app/node_modules/domhandler/lib/node.d.ts.map
mobile-app/node_modules/domhandler/lib/node.js
mobile-app/node_modules/domhandler/package.json
mobile-app/node_modules/domhandler/readme.md
mobile-app/node_modules/domutils/LICENSE
mobile-app/node_modules/domutils/lib/feeds.d.ts
mobile-app/node_modules/domutils/lib/feeds.d.ts.map
mobile-app/node_modules/domutils/lib/feeds.js
mobile-app/node_modules/domutils/lib/helpers.d.ts
mobile-app/node_modules/domutils/lib/helpers.d.ts.map
mobile-app/node_modules/domutils/lib/helpers.js
mobile-app/node_modules/domutils/lib/index.d.ts
mobile-app/node_modules/domutils/lib/index.d.ts.map
mobile-app/node_modules/domutils/lib/index.js
mobile-app/node_modules/domutils/lib/legacy.d.ts
mobile-app/node_modules/domutils/lib/legacy.d.ts.map
mobile-app/node_modules/domutils/lib/legacy.js
mobile-app/node_modules/domutils/lib/manipulation.d.ts
mobile-app/node_modules/domutils/lib/manipulation.d.ts.map
mobile-app/node_modules/domutils/lib/manipulation.js
mobile-app/node_modules/domutils/lib/querying.d.ts
mobile-app/node_modules/domutils/lib/querying.d.ts.map
mobile-app/node_modules/domutils/lib/querying.js
mobile-app/node_modules/domutils/lib/stringify.d.ts
mobile-app/node_modules/domutils/lib/stringify.d.ts.map
mobile-app/node_modules/domutils/lib/stringify.js
mobile-app/node_modules/domutils/lib/traversal.d.ts
mobile-app/node_modules/domutils/lib/traversal.d.ts.map
mobile-app/node_modules/domutils/lib/traversal.js
mobile-app/node_modules/domutils/package.json
mobile-app/node_modules/domutils/readme.md
mobile-app/node_modules/elementtree/.npmignore
mobile-app/node_modules/elementtree/.travis.yml
mobile-app/node_modules/elementtree/CHANGES.md
mobile-app/node_modules/elementtree/LICENSE.txt
mobile-app/node_modules/elementtree/Makefile
mobile-app/node_modules/elementtree/NOTICE
mobile-app/node_modules/elementtree/README.md
mobile-app/node_modules/elementtree/lib/constants.js
mobile-app/node_modules/elementtree/lib/elementpath.js
mobile-app/node_modules/elementtree/lib/elementtree.js
mobile-app/node_modules/elementtree/lib/errors.js
mobile-app/node_modules/elementtree/lib/parser.js
mobile-app/node_modules/elementtree/lib/sprintf.js
mobile-app/node_modules/elementtree/lib/treebuilder.js
mobile-app/node_modules/elementtree/lib/utils.js
mobile-app/node_modules/elementtree/package.json
mobile-app/node_modules/elementtree/tests/test-simple.js
mobile-app/node_modules/emoji-regex/LICENSE-MIT.txt
mobile-app/node_modules/emoji-regex/README.md
mobile-app/node_modules/emoji-regex/es2015/index.js
mobile-app/node_modules/emoji-regex/es2015/text.js
mobile-app/node_modules/emoji-regex/index.d.ts
mobile-app/node_modules/emoji-regex/index.js
mobile-app/node_modules/emoji-regex/package.json
mobile-app/node_modules/emoji-regex/text.js
mobile-app/node_modules/end-of-stream/LICENSE
mobile-app/node_modules/end-of-stream/README.md
mobile-app/node_modules/end-of-stream/index.js
mobile-app/node_modules/end-of-stream/package.json
mobile-app/node_modules/entities/LICENSE
mobile-app/node_modules/entities/lib/decode.d.ts
mobile-app/node_modules/entities/lib/decode.d.ts.map
mobile-app/node_modules/entities/lib/decode.js
mobile-app/node_modules/entities/lib/decode_codepoint.d.ts
mobile-app/node_modules/entities/lib/decode_codepoint.d.ts.map
mobile-app/node_modules/entities/lib/decode_codepoint.js
mobile-app/node_modules/entities/lib/encode.d.ts
mobile-app/node_modules/entities/lib/encode.d.ts.map
mobile-app/node_modules/entities/lib/encode.js
mobile-app/node_modules/entities/lib/index.d.ts
mobile-app/node_modules/entities/lib/index.d.ts.map
mobile-app/node_modules/entities/lib/index.js
mobile-app/node_modules/entities/package.json
mobile-app/node_modules/entities/readme.md
mobile-app/node_modules/env-paths/index.d.ts
mobile-app/node_modules/env-paths/index.js
mobile-app/node_modules/env-paths/license
mobile-app/node_modules/env-paths/package.json
mobile-app/node_modules/env-paths/readme.md
mobile-app/node_modules/escalade/dist/index.js
mobile-app/node_modules/escalade/dist/index.mjs
mobile-app/node_modules/escalade/index.d.mts
mobile-app/node_modules/escalade/index.d.ts
mobile-app/node_modules/escalade/license
mobile-app/node_modules/escalade/package.json
mobile-app/node_modules/escalade/readme.md
mobile-app/node_modules/escalade/sync/index.d.mts
mobile-app/node_modules/escalade/sync/index.d.ts
mobile-app/node_modules/escalade/sync/index.js
mobile-app/node_modules/escalade/sync/index.mjs
mobile-app/node_modules/events-universal/LICENSE
mobile-app/node_modules/events-universal/README.md
mobile-app/node_modules/events-universal/bare.js
mobile-app/node_modules/events-universal/default.js
mobile-app/node_modules/events-universal/index.js
mobile-app/node_modules/events-universal/package.json
mobile-app/node_modules/events-universal/react-native.js
mobile-app/node_modules/expand-template/.travis.yml
mobile-app/node_modules/expand-template/LICENSE
mobile-app/node_modules/expand-template/README.md
mobile-app/node_modules/expand-template/index.js
mobile-app/node_modules/expand-template/package.json
mobile-app/node_modules/expand-template/test.js
mobile-app/node_modules/fast-fifo/LICENSE
mobile-app/node_modules/fast-fifo/README.md
mobile-app/node_modules/fast-fifo/fixed-size.js
mobile-app/node_modules/fast-fifo/index.js
mobile-app/node_modules/fast-fifo/package.json
mobile-app/node_modules/fd-slicer/.npmignore
mobile-app/node_modules/fd-slicer/.travis.yml
mobile-app/node_modules/fd-slicer/CHANGELOG.md
mobile-app/node_modules/fd-slicer/LICENSE
mobile-app/node_modules/fd-slicer/README.md
mobile-app/node_modules/fd-slicer/index.js
mobile-app/node_modules/fd-slicer/package.json
mobile-app/node_modules/fd-slicer/test/test.js
mobile-app/node_modules/fs-constants/LICENSE
mobile-app/node_modules/fs-constants/README.md
mobile-app/node_modules/fs-constants/browser.js
mobile-app/node_modules/fs-constants/index.js
mobile-app/node_modules/fs-constants/package.json
mobile-app/node_modules/fs-extra/LICENSE
mobile-app/node_modules/fs-extra/README.md
mobile-app/node_modules/fs-extra/lib/esm.mjs
mobile-app/node_modules/fs-extra/lib/index.js
mobile-app/node_modules/fs-extra/package.json
mobile-app/node_modules/fs-minipass/LICENSE
mobile-app/node_modules/fs-minipass/README.md
mobile-app/node_modules/fs-minipass/index.js
mobile-app/node_modules/fs-minipass/package.json
mobile-app/node_modules/fs.realpath/LICENSE
mobile-app/node_modules/fs.realpath/README.md
mobile-app/node_modules/fs.realpath/index.js
mobile-app/node_modules/fs.realpath/old.js
mobile-app/node_modules/fs.realpath/package.json
mobile-app/node_modules/get-caller-file/LICENSE.md
mobile-app/node_modules/get-caller-file/README.md
mobile-app/node_modules/get-caller-file/index.d.ts
mobile-app/node_modules/get-caller-file/index.js
mobile-app/node_modules/get-caller-file/index.js.map
mobile-app/node_modules/get-caller-file/package.json
mobile-app/node_modules/github-from-package/.travis.yml
mobile-app/node_modules/github-from-package/LICENSE
mobile-app/node_modules/github-from-package/example/package.json
mobile-app/node_modules/github-from-package/example/url.js
mobile-app/node_modules/github-from-package/index.js
mobile-app/node_modules/github-from-package/package.json
mobile-app/node_modules/github-from-package/readme.markdown
mobile-app/node_modules/github-from-package/test/a.json
mobile-app/node_modules/github-from-package/test/b.json
mobile-app/node_modules/github-from-package/test/c.json
mobile-app/node_modules/github-from-package/test/d.json
mobile-app/node_modules/github-from-package/test/e.json
mobile-app/node_modules/github-from-package/test/url.js
mobile-app/node_modules/glob/LICENSE.md
mobile-app/node_modules/glob/README.md
mobile-app/node_modules/glob/package.json
mobile-app/node_modules/graceful-fs/LICENSE
mobile-app/node_modules/graceful-fs/README.md
mobile-app/node_modules/graceful-fs/clone.js
mobile-app/node_modules/graceful-fs/graceful-fs.js
mobile-app/node_modules/graceful-fs/legacy-streams.js
mobile-app/node_modules/graceful-fs/package.json
mobile-app/node_modules/graceful-fs/polyfills.js
mobile-app/node_modules/gradle-to-js/LICENSE
mobile-app/node_modules/gradle-to-js/README.md
mobile-app/node_modules/gradle-to-js/cli.js
mobile-app/node_modules/gradle-to-js/lib/parser.js
mobile-app/node_modules/gradle-to-js/package.json
mobile-app/node_modules/he/LICENSE-MIT.txt
mobile-app/node_modules/he/README.md
mobile-app/node_modules/he/bin/he
mobile-app/node_modules/he/he.js
mobile-app/node_modules/he/man/he.1
mobile-app/node_modules/he/package.json
mobile-app/node_modules/ieee754/LICENSE
mobile-app/node_modules/ieee754/README.md
mobile-app/node_modules/ieee754/index.d.ts
mobile-app/node_modules/ieee754/index.js
mobile-app/node_modules/ieee754/package.json
mobile-app/node_modules/inherits/LICENSE
mobile-app/node_modules/inherits/README.md
mobile-app/node_modules/inherits/inherits.js
mobile-app/node_modules/inherits/inherits_browser.js
mobile-app/node_modules/inherits/package.json
mobile-app/node_modules/ini/LICENSE
mobile-app/node_modules/ini/README.md
mobile-app/node_modules/ini/lib/ini.js
mobile-app/node_modules/ini/package.json
mobile-app/node_modules/is-arrayish/LICENSE
mobile-app/node_modules/is-arrayish/README.md
mobile-app/node_modules/is-arrayish/index.js
mobile-app/node_modules/is-arrayish/package.json
mobile-app/node_modules/is-docker/cli.js
mobile-app/node_modules/is-docker/index.d.ts
mobile-app/node_modules/is-docker/index.js
mobile-app/node_modules/is-docker/license
mobile-app/node_modules/is-docker/package.json
mobile-app/node_modules/is-docker/readme.md
mobile-app/node_modules/is-fullwidth-code-point/index.d.ts
mobile-app/node_modules/is-fullwidth-code-point/index.js
mobile-app/node_modules/is-fullwidth-code-point/license
mobile-app/node_modules/is-fullwidth-code-point/package.json
mobile-app/node_modules/is-fullwidth-code-point/readme.md
mobile-app/node_modules/is-wsl/index.d.ts
mobile-app/node_modules/is-wsl/index.js
mobile-app/node_modules/is-wsl/license
mobile-app/node_modules/is-wsl/package.json
mobile-app/node_modules/is-wsl/readme.md
mobile-app/node_modules/isexe/.npmignore
mobile-app/node_modules/isexe/LICENSE
mobile-app/node_modules/isexe/README.md
mobile-app/node_modules/isexe/index.js
mobile-app/node_modules/isexe/mode.js
mobile-app/node_modules/isexe/package.json
mobile-app/node_modules/isexe/test/basic.js
mobile-app/node_modules/isexe/windows.js
mobile-app/node_modules/jsonfile/LICENSE
mobile-app/node_modules/jsonfile/README.md
mobile-app/node_modules/jsonfile/index.js
mobile-app/node_modules/jsonfile/package.json
mobile-app/node_modules/jsonfile/utils.js
mobile-app/node_modules/kleur/colors.d.ts
mobile-app/node_modules/kleur/colors.js
mobile-app/node_modules/kleur/colors.mjs
mobile-app/node_modules/kleur/index.d.ts
mobile-app/node_modules/kleur/index.js
mobile-app/node_modules/kleur/index.mjs
mobile-app/node_modules/kleur/license
mobile-app/node_modules/kleur/package.json
mobile-app/node_modules/kleur/readme.md
mobile-app/node_modules/lodash.merge/LICENSE
mobile-app/node_modules/lodash.merge/README.md
mobile-app/node_modules/lodash.merge/index.js
mobile-app/node_modules/lodash.merge/package.json
mobile-app/node_modules/lodash/LICENSE
mobile-app/node_modules/lodash/README.md
mobile-app/node_modules/lodash/_DataView.js
mobile-app/node_modules/lodash/_Hash.js
mobile-app/node_modules/lodash/_LazyWrapper.js
mobile-app/node_modules/lodash/_ListCache.js
mobile-app/node_modules/lodash/_LodashWrapper.js
mobile-app/node_modules/lodash/_Map.js
mobile-app/node_modules/lodash/_MapCache.js
mobile-app/node_modules/lodash/_Promise.js
mobile-app/node_modules/lodash/_Set.js
mobile-app/node_modules/lodash/_SetCache.js
mobile-app/node_modules/lodash/_Stack.js
mobile-app/node_modules/lodash/_Symbol.js
mobile-app/node_modules/lodash/_Uint8Array.js
mobile-app/node_modules/lodash/_WeakMap.js
mobile-app/node_modules/lodash/_apply.js
mobile-app/node_modules/lodash/_arrayAggregator.js
mobile-app/node_modules/lodash/_arrayEach.js
mobile-app/node_modules/lodash/_arrayEachRight.js
mobile-app/node_modules/lodash/_arrayEvery.js
mobile-app/node_modules/lodash/_arrayFilter.js
mobile-app/node_modules/lodash/_arrayIncludes.js
mobile-app/node_modules/lodash/_arrayIncludesWith.js
mobile-app/node_modules/lodash/_arrayLikeKeys.js
mobile-app/node_modules/lodash/_arrayMap.js
mobile-app/node_modules/lodash/_arrayPush.js
mobile-app/node_modules/lodash/_arrayReduce.js
mobile-app/node_modules/lodash/_arrayReduceRight.js
mobile-app/node_modules/lodash/_arraySample.js
mobile-app/node_modules/lodash/_arraySampleSize.js
mobile-app/node_modules/lodash/_arrayShuffle.js
mobile-app/node_modules/lodash/_arraySome.js
mobile-app/node_modules/lodash/_asciiSize.js
mobile-app/node_modules/lodash/_asciiToArray.js
mobile-app/node_modules/lodash/_asciiWords.js
mobile-app/node_modules/lodash/_assignMergeValue.js
mobile-app/node_modules/lodash/_assignValue.js
mobile-app/node_modules/lodash/_assocIndexOf.js
mobile-app/node_modules/lodash/_baseAggregator.js
mobile-app/node_modules/lodash/_baseAssign.js
mobile-app/node_modules/lodash/_baseAssignIn.js
mobile-app/node_modules/lodash/_baseAssignValue.js
mobile-app/node_modules/lodash/_baseAt.js
mobile-app/node_modules/lodash/_baseClamp.js
mobile-app/node_modules/lodash/_baseClone.js
mobile-app/node_modules/lodash/_baseConforms.js
mobile-app/node_modules/lodash/_baseConformsTo.js
mobile-app/node_modules/lodash/_baseCreate.js
mobile-app/node_modules/lodash/_baseDelay.js
mobile-app/node_modules/lodash/_baseDifference.js
mobile-app/node_modules/lodash/_baseEach.js
mobile-app/node_modules/lodash/_baseEachRight.js
mobile-app/node_modules/lodash/_baseEvery.js
mobile-app/node_modules/lodash/_baseExtremum.js
mobile-app/node_modules/lodash/_baseFill.js
mobile-app/node_modules/lodash/_baseFilter.js
mobile-app/node_modules/lodash/_baseFindIndex.js
mobile-app/node_modules/lodash/_baseFindKey.js
mobile-app/node_modules/lodash/_baseFlatten.js
mobile-app/node_modules/lodash/_baseFor.js
mobile-app/node_modules/lodash/_baseForOwn.js
mobile-app/node_modules/lodash/_baseForOwnRight.js
mobile-app/node_modules/lodash/_baseForRight.js
mobile-app/node_modules/lodash/_baseFunctions.js
mobile-app/node_modules/lodash/_baseGet.js
mobile-app/node_modules/lodash/_baseGetAllKeys.js
mobile-app/node_modules/lodash/_baseGetTag.js
mobile-app/node_modules/lodash/_baseGt.js
mobile-app/node_modules/lodash/_baseHas.js
mobile-app/node_modules/lodash/_baseHasIn.js
mobile-app/node_modules/lodash/_baseInRange.js
mobile-app/node_modules/lodash/_baseIndexOf.js
mobile-app/node_modules/lodash/_baseIndexOfWith.js
mobile-app/node_modules/lodash/_baseIntersection.js
mobile-app/node_modules/lodash/_baseInverter.js
mobile-app/node_modules/lodash/_baseInvoke.js
mobile-app/node_modules/lodash/_baseIsArguments.js
mobile-app/node_modules/lodash/_baseIsArrayBuffer.js
mobile-app/node_modules/lodash/_baseIsDate.js
mobile-app/node_modules/lodash/_baseIsEqual.js
mobile-app/node_modules/lodash/_baseIsEqualDeep.js
mobile-app/node_modules/lodash/_baseIsMap.js
mobile-app/node_modules/lodash/_baseIsMatch.js
mobile-app/node_modules/lodash/_baseIsNaN.js
mobile-app/node_modules/lodash/_baseIsNative.js
mobile-app/node_modules/lodash/_baseIsRegExp.js
mobile-app/node_modules/lodash/_baseIsSet.js
mobile-app/node_modules/lodash/_baseIsTypedArray.js
mobile-app/node_modules/lodash/_baseIteratee.js
mobile-app/node_modules/lodash/_baseKeys.js
mobile-app/node_modules/lodash/_baseKeysIn.js
mobile-app/node_modules/lodash/_baseLodash.js
mobile-app/node_modules/lodash/_baseLt.js
mobile-app/node_modules/lodash/_baseMap.js
mobile-app/node_modules/lodash/_baseMatches.js
mobile-app/node_modules/lodash/_baseMatchesProperty.js
mobile-app/node_modules/lodash/_baseMean.js
mobile-app/node_modules/lodash/_baseMerge.js
mobile-app/node_modules/lodash/_baseMergeDeep.js
mobile-app/node_modules/lodash/_baseNth.js
mobile-app/node_modules/lodash/_baseOrderBy.js
mobile-app/node_modules/lodash/_basePick.js
mobile-app/node_modules/lodash/_basePickBy.js
mobile-app/node_modules/lodash/_baseProperty.js
mobile-app/node_modules/lodash/_basePropertyDeep.js
mobile-app/node_modules/lodash/_basePropertyOf.js
mobile-app/node_modules/lodash/_basePullAll.js
mobile-app/node_modules/lodash/_basePullAt.js
mobile-app/node_modules/lodash/_baseRandom.js
mobile-app/node_modules/lodash/_baseRange.js
mobile-app/node_modules/lodash/_baseReduce.js
mobile-app/node_modules/lodash/_baseRepeat.js
mobile-app/node_modules/lodash/_baseRest.js
mobile-app/node_modules/lodash/_baseSample.js
mobile-app/node_modules/lodash/_baseSampleSize.js
mobile-app/node_modules/lodash/_baseSet.js
mobile-app/node_modules/lodash/_baseSetData.js
mobile-app/node_modules/lodash/_baseSetToString.js
mobile-app/node_modules/lodash/_baseShuffle.js
mobile-app/node_modules/lodash/_baseSlice.js
mobile-app/node_modules/lodash/_baseSome.js
mobile-app/node_modules/lodash/_baseSortBy.js
mobile-app/node_modules/lodash/_baseSortedIndex.js
mobile-app/node_modules/lodash/_baseSortedIndexBy.js
mobile-app/node_modules/lodash/_baseSortedUniq.js
mobile-app/node_modules/lodash/_baseSum.js
mobile-app/node_modules/lodash/_baseTimes.js
mobile-app/node_modules/lodash/_baseToNumber.js
mobile-app/node_modules/lodash/_baseToPairs.js
mobile-app/node_modules/lodash/_baseToString.js
mobile-app/node_modules/lodash/_baseTrim.js
mobile-app/node_modules/lodash/_baseUnary.js
mobile-app/node_modules/lodash/_baseUniq.js
mobile-app/node_modules/lodash/_baseUnset.js
mobile-app/node_modules/lodash/_baseUpdate.js
mobile-app/node_modules/lodash/_baseValues.js
mobile-app/node_modules/lodash/_baseWhile.js
mobile-app/node_modules/lodash/_baseWrapperValue.js
mobile-app/node_modules/lodash/_baseXor.js
mobile-app/node_modules/lodash/_baseZipObject.js
mobile-app/node_modules/lodash/_cacheHas.js
mobile-app/node_modules/lodash/_castArrayLikeObject.js
mobile-app/node_modules/lodash/_castFunction.js
mobile-app/node_modules/lodash/_castPath.js
mobile-app/node_modules/lodash/_castRest.js
mobile-app/node_modules/lodash/_castSlice.js
mobile-app/node_modules/lodash/_charsEndIndex.js
mobile-app/node_modules/lodash/_charsStartIndex.js
mobile-app/node_modules/lodash/_cloneArrayBuffer.js
mobile-app/node_modules/lodash/_cloneBuffer.js
mobile-app/node_modules/lodash/_cloneDataView.js
mobile-app/node_modules/lodash/_cloneRegExp.js
mobile-app/node_modules/lodash/_cloneSymbol.js
mobile-app/node_modules/lodash/_cloneTypedArray.js
mobile-app/node_modules/lodash/_compareAscending.js
mobile-app/node_modules/lodash/_compareMultiple.js
mobile-app/node_modules/lodash/_composeArgs.js
mobile-app/node_modules/lodash/_composeArgsRight.js
mobile-app/node_modules/lodash/_copyArray.js
mobile-app/node_modules/lodash/_copyObject.js
mobile-app/node_modules/lodash/_copySymbols.js
mobile-app/node_modules/lodash/_copySymbolsIn.js
mobile-app/node_modules/lodash/_coreJsData.js
mobile-app/node_modules/lodash/_countHolders.js
mobile-app/node_modules/lodash/_createAggregator.js
mobile-app/node_modules/lodash/_createAssigner.js
mobile-app/node_modules/lodash/_createBaseEach.js
mobile-app/node_modules/lodash/_createBaseFor.js
mobile-app/node_modules/lodash/_createBind.js
mobile-app/node_modules/lodash/_createCaseFirst.js
mobile-app/node_modules/lodash/_createCompounder.js
mobile-app/node_modules/lodash/_createCtor.js
mobile-app/node_modules/lodash/_createCurry.js
mobile-app/node_modules/lodash/_createFind.js
mobile-app/node_modules/lodash/_createFlow.js
mobile-app/node_modules/lodash/_createHybrid.js
mobile-app/node_modules/lodash/_createInverter.js
mobile-app/node_modules/lodash/_createMathOperation.js
mobile-app/node_modules/lodash/_createOver.js
mobile-app/node_modules/lodash/_createPadding.js
mobile-app/node_modules/lodash/_createPartial.js
mobile-app/node_modules/lodash/_createRange.js
mobile-app/node_modules/lodash/_createRecurry.js
mobile-app/node_modules/lodash/_createRelationalOperation.js
mobile-app/node_modules/lodash/_createRound.js
mobile-app/node_modules/lodash/_createSet.js
mobile-app/node_modules/lodash/_createToPairs.js
mobile-app/node_modules/lodash/_createWrap.js
mobile-app/node_modules/lodash/_customDefaultsAssignIn.js
mobile-app/node_modules/lodash/_customDefaultsMerge.js
mobile-app/node_modules/lodash/_customOmitClone.js
mobile-app/node_modules/lodash/_deburrLetter.js
mobile-app/node_modules/lodash/_defineProperty.js
mobile-app/node_modules/lodash/_equalArrays.js
mobile-app/node_modules/lodash/_equalByTag.js
mobile-app/node_modules/lodash/_equalObjects.js
mobile-app/node_modules/lodash/_escapeHtmlChar.js
mobile-app/node_modules/lodash/_escapeStringChar.js
mobile-app/node_modules/lodash/_flatRest.js
mobile-app/node_modules/lodash/_freeGlobal.js
mobile-app/node_modules/lodash/_getAllKeys.js
mobile-app/node_modules/lodash/_getAllKeysIn.js
mobile-app/node_modules/lodash/_getData.js
mobile-app/node_modules/lodash/_getFuncName.js
mobile-app/node_modules/lodash/_getHolder.js
mobile-app/node_modules/lodash/_getMapData.js
mobile-app/node_modules/lodash/_getMatchData.js
mobile-app/node_modules/lodash/_getNative.js
mobile-app/node_modules/lodash/_getPrototype.js
mobile-app/node_modules/lodash/_getRawTag.js
mobile-app/node_modules/lodash/_getSymbols.js
mobile-app/node_modules/lodash/_getSymbolsIn.js
mobile-app/node_modules/lodash/_getTag.js
mobile-app/node_modules/lodash/_getValue.js
mobile-app/node_modules/lodash/_getView.js
mobile-app/node_modules/lodash/_getWrapDetails.js
mobile-app/node_modules/lodash/_hasPath.js
mobile-app/node_modules/lodash/_hasUnicode.js
mobile-app/node_modules/lodash/_hasUnicodeWord.js
mobile-app/node_modules/lodash/_hashClear.js
mobile-app/node_modules/lodash/_hashDelete.js
mobile-app/node_modules/lodash/_hashGet.js
mobile-app/node_modules/lodash/_hashHas.js
mobile-app/node_modules/lodash/_hashSet.js
mobile-app/node_modules/lodash/_initCloneArray.js
mobile-app/node_modules/lodash/_initCloneByTag.js
mobile-app/node_modules/lodash/_initCloneObject.js
mobile-app/node_modules/lodash/_insertWrapDetails.js
mobile-app/node_modules/lodash/_isFlattenable.js
mobile-app/node_modules/lodash/_isIndex.js
mobile-app/node_modules/lodash/_isIterateeCall.js
mobile-app/node_modules/lodash/_isKey.js
mobile-app/node_modules/lodash/_isKeyable.js
mobile-app/node_modules/lodash/_isLaziable.js
mobile-app/node_modules/lodash/_isMaskable.js
mobile-app/node_modules/lodash/_isMasked.js
mobile-app/node_modules/lodash/_isPrototype.js
mobile-app/node_modules/lodash/_isStrictComparable.js
mobile-app/node_modules/lodash/_iteratorToArray.js
mobile-app/node_modules/lodash/_lazyClone.js
mobile-app/node_modules/lodash/_lazyReverse.js
mobile-app/node_modules/lodash/_lazyValue.js
mobile-app/node_modules/lodash/_listCacheClear.js
mobile-app/node_modules/lodash/_listCacheDelete.js
mobile-app/node_modules/lodash/_listCacheGet.js
mobile-app/node_modules/lodash/_listCacheHas.js
mobile-app/node_modules/lodash/_listCacheSet.js
mobile-app/node_modules/lodash/_mapCacheClear.js
mobile-app/node_modules/lodash/_mapCacheDelete.js
mobile-app/node_modules/lodash/_mapCacheGet.js
mobile-app/node_modules/lodash/_mapCacheHas.js
mobile-app/node_modules/lodash/_mapCacheSet.js
mobile-app/node_modules/lodash/_mapToArray.js
mobile-app/node_modules/lodash/_matchesStrictComparable.js
mobile-app/node_modules/lodash/_memoizeCapped.js
mobile-app/node_modules/lodash/_mergeData.js
mobile-app/node_modules/lodash/_metaMap.js
mobile-app/node_modules/lodash/_nativeCreate.js
mobile-app/node_modules/lodash/_nativeKeys.js
mobile-app/node_modules/lodash/_nativeKeysIn.js
mobile-app/node_modules/lodash/_nodeUtil.js
mobile-app/node_modules/lodash/_objectToString.js
mobile-app/node_modules/lodash/_overArg.js
mobile-app/node_modules/lodash/_overRest.js
mobile-app/node_modules/lodash/_parent.js
mobile-app/node_modules/lodash/_reEscape.js
mobile-app/node_modules/lodash/_reEvaluate.js
mobile-app/node_modules/lodash/_reInterpolate.js
mobile-app/node_modules/lodash/_realNames.js
mobile-app/node_modules/lodash/_reorder.js
mobile-app/node_modules/lodash/_replaceHolders.js
mobile-app/node_modules/lodash/_root.js
mobile-app/node_modules/lodash/_safeGet.js
mobile-app/node_modules/lodash/_setCacheAdd.js
mobile-app/node_modules/lodash/_setCacheHas.js
mobile-app/node_modules/lodash/_setData.js
mobile-app/node_modules/lodash/_setToArray.js
mobile-app/node_modules/lodash/_setToPairs.js
mobile-app/node_modules/lodash/_setToString.js
mobile-app/node_modules/lodash/_setWrapToString.js
mobile-app/node_modules/lodash/_shortOut.js
mobile-app/node_modules/lodash/_shuffleSelf.js
mobile-app/node_modules/lodash/_stackClear.js
mobile-app/node_modules/lodash/_stackDelete.js
mobile-app/node_modules/lodash/_stackGet.js
mobile-app/node_modules/lodash/_stackHas.js
mobile-app/node_modules/lodash/_stackSet.js
mobile-app/node_modules/lodash/_strictIndexOf.js
mobile-app/node_modules/lodash/_strictLastIndexOf.js
mobile-app/node_modules/lodash/_stringSize.js
mobile-app/node_modules/lodash/_stringToArray.js
mobile-app/node_modules/lodash/_stringToPath.js
mobile-app/node_modules/lodash/_toKey.js
mobile-app/node_modules/lodash/_toSource.js
mobile-app/node_modules/lodash/_trimmedEndIndex.js
mobile-app/node_modules/lodash/_unescapeHtmlChar.js
mobile-app/node_modules/lodash/_unicodeSize.js
mobile-app/node_modules/lodash/_unicodeToArray.js
mobile-app/node_modules/lodash/_unicodeWords.js
mobile-app/node_modules/lodash/_updateWrapDetails.js
mobile-app/node_modules/lodash/_wrapperClone.js
mobile-app/node_modules/lodash/add.js
mobile-app/node_modules/lodash/after.js
mobile-app/node_modules/lodash/array.js
mobile-app/node_modules/lodash/ary.js
mobile-app/node_modules/lodash/assign.js
mobile-app/node_modules/lodash/assignIn.js
mobile-app/node_modules/lodash/assignInWith.js
mobile-app/node_modules/lodash/assignWith.js
mobile-app/node_modules/lodash/at.js
mobile-app/node_modules/lodash/attempt.js
mobile-app/node_modules/lodash/before.js
mobile-app/node_modules/lodash/bind.js
mobile-app/node_modules/lodash/bindAll.js
mobile-app/node_modules/lodash/bindKey.js
mobile-app/node_modules/lodash/camelCase.js
mobile-app/node_modules/lodash/capitalize.js
mobile-app/node_modules/lodash/castArray.js
mobile-app/node_modules/lodash/ceil.js
mobile-app/node_modules/lodash/chain.js
mobile-app/node_modules/lodash/chunk.js
mobile-app/node_modules/lodash/clamp.js
mobile-app/node_modules/lodash/clone.js
mobile-app/node_modules/lodash/cloneDeep.js
mobile-app/node_modules/lodash/cloneDeepWith.js
mobile-app/node_modules/lodash/cloneWith.js
mobile-app/node_modules/lodash/collection.js
mobile-app/node_modules/lodash/commit.js
mobile-app/node_modules/lodash/compact.js
mobile-app/node_modules/lodash/concat.js
mobile-app/node_modules/lodash/cond.js
mobile-app/node_modules/lodash/conforms.js
mobile-app/node_modules/lodash/conformsTo.js
mobile-app/node_modules/lodash/constant.js
mobile-app/node_modules/lodash/core.js
mobile-app/node_modules/lodash/core.min.js
mobile-app/node_modules/lodash/countBy.js
mobile-app/node_modules/lodash/create.js
mobile-app/node_modules/lodash/curry.js
mobile-app/node_modules/lodash/curryRight.js
mobile-app/node_modules/lodash/date.js
mobile-app/node_modules/lodash/debounce.js
mobile-app/node_modules/lodash/deburr.js
mobile-app/node_modules/lodash/defaultTo.js
mobile-app/node_modules/lodash/defaults.js
mobile-app/node_modules/lodash/defaultsDeep.js
mobile-app/node_modules/lodash/defer.js
mobile-app/node_modules/lodash/delay.js
mobile-app/node_modules/lodash/difference.js
mobile-app/node_modules/lodash/differenceBy.js
mobile-app/node_modules/lodash/differenceWith.js
mobile-app/node_modules/lodash/divide.js
mobile-app/node_modules/lodash/drop.js
mobile-app/node_modules/lodash/dropRight.js
mobile-app/node_modules/lodash/dropRightWhile.js
mobile-app/node_modules/lodash/dropWhile.js
mobile-app/node_modules/lodash/each.js
mobile-app/node_modules/lodash/eachRight.js
mobile-app/node_modules/lodash/endsWith.js
mobile-app/node_modules/lodash/entries.js
mobile-app/node_modules/lodash/entriesIn.js
mobile-app/node_modules/lodash/eq.js
mobile-app/node_modules/lodash/escape.js
mobile-app/node_modules/lodash/escapeRegExp.js
mobile-app/node_modules/lodash/every.js
mobile-app/node_modules/lodash/extend.js
mobile-app/node_modules/lodash/extendWith.js
mobile-app/node_modules/lodash/fill.js
mobile-app/node_modules/lodash/filter.js
mobile-app/node_modules/lodash/find.js
mobile-app/node_modules/lodash/findIndex.js
mobile-app/node_modules/lodash/findKey.js
mobile-app/node_modules/lodash/findLast.js
mobile-app/node_modules/lodash/findLastIndex.js
mobile-app/node_modules/lodash/findLastKey.js
mobile-app/node_modules/lodash/first.js
mobile-app/node_modules/lodash/flatMap.js
mobile-app/node_modules/lodash/flatMapDeep.js
mobile-app/node_modules/lodash/flatMapDepth.js
mobile-app/node_modules/lodash/flatten.js
mobile-app/node_modules/lodash/flattenDeep.js
mobile-app/node_modules/lodash/flattenDepth.js
mobile-app/node_modules/lodash/flip.js
mobile-app/node_modules/lodash/floor.js
mobile-app/node_modules/lodash/flow.js
mobile-app/node_modules/lodash/flowRight.js
mobile-app/node_modules/lodash/forEach.js
mobile-app/node_modules/lodash/forEachRight.js
mobile-app/node_modules/lodash/forIn.js
mobile-app/node_modules/lodash/forInRight.js
mobile-app/node_modules/lodash/forOwn.js
mobile-app/node_modules/lodash/forOwnRight.js
mobile-app/node_modules/lodash/fp.js
mobile-app/node_modules/lodash/fp/F.js
mobile-app/node_modules/lodash/fp/T.js
mobile-app/node_modules/lodash/fp/__.js
mobile-app/node_modules/lodash/fp/_baseConvert.js
mobile-app/node_modules/lodash/fp/_convertBrowser.js
mobile-app/node_modules/lodash/fp/_falseOptions.js
mobile-app/node_modules/lodash/fp/_mapping.js
mobile-app/node_modules/lodash/fp/_util.js
mobile-app/node_modules/lodash/fp/add.js
mobile-app/node_modules/lodash/fp/after.js
mobile-app/node_modules/lodash/fp/all.js
mobile-app/node_modules/lodash/fp/allPass.js
mobile-app/node_modules/lodash/fp/always.js
mobile-app/node_modules/lodash/fp/any.js
mobile-app/node_modules/lodash/fp/anyPass.js
mobile-app/node_modules/lodash/fp/apply.js
mobile-app/node_modules/lodash/fp/array.js
mobile-app/node_modules/lodash/fp/ary.js
mobile-app/node_modules/lodash/fp/assign.js
mobile-app/node_modules/lodash/fp/assignAll.js
mobile-app/node_modules/lodash/fp/assignAllWith.js
mobile-app/node_modules/lodash/fp/assignIn.js
mobile-app/node_modules/lodash/fp/assignInAll.js
mobile-app/node_modules/lodash/fp/assignInAllWith.js
mobile-app/node_modules/lodash/fp/assignInWith.js
mobile-app/node_modules/lodash/fp/assignWith.js
mobile-app/node_modules/lodash/fp/assoc.js
mobile-app/node_modules/lodash/fp/assocPath.js
mobile-app/node_modules/lodash/fp/at.js
mobile-app/node_modules/lodash/fp/attempt.js
mobile-app/node_modules/lodash/fp/before.js
mobile-app/node_modules/lodash/fp/bind.js
mobile-app/node_modules/lodash/fp/bindAll.js
mobile-app/node_modules/lodash/fp/bindKey.js
mobile-app/node_modules/lodash/fp/camelCase.js
mobile-app/node_modules/lodash/fp/capitalize.js
mobile-app/node_modules/lodash/fp/castArray.js
mobile-app/node_modules/lodash/fp/ceil.js
mobile-app/node_modules/lodash/fp/chain.js
mobile-app/node_modules/lodash/fp/chunk.js
mobile-app/node_modules/lodash/fp/clamp.js
mobile-app/node_modules/lodash/fp/clone.js
mobile-app/node_modules/lodash/fp/cloneDeep.js
mobile-app/node_modules/lodash/fp/cloneDeepWith.js
mobile-app/node_modules/lodash/fp/cloneWith.js
mobile-app/node_modules/lodash/fp/collection.js
mobile-app/node_modules/lodash/fp/commit.js
mobile-app/node_modules/lodash/fp/compact.js
mobile-app/node_modules/lodash/fp/complement.js
mobile-app/node_modules/lodash/fp/compose.js
mobile-app/node_modules/lodash/fp/concat.js
mobile-app/node_modules/lodash/fp/cond.js
mobile-app/node_modules/lodash/fp/conforms.js
mobile-app/node_modules/lodash/fp/conformsTo.js
mobile-app/node_modules/lodash/fp/constant.js
mobile-app/node_modules/lodash/fp/contains.js
mobile-app/node_modules/lodash/fp/convert.js
mobile-app/node_modules/lodash/fp/countBy.js
mobile-app/node_modules/lodash/fp/create.js
mobile-app/node_modules/lodash/fp/curry.js
mobile-app/node_modules/lodash/fp/curryN.js
mobile-app/node_modules/lodash/fp/curryRight.js
mobile-app/node_modules/lodash/fp/curryRightN.js
mobile-app/node_modules/lodash/fp/date.js
mobile-app/node_modules/lodash/fp/debounce.js
mobile-app/node_modules/lodash/fp/deburr.js
mobile-app/node_modules/lodash/fp/defaultTo.js
mobile-app/node_modules/lodash/fp/defaults.js
mobile-app/node_modules/lodash/fp/defaultsAll.js
mobile-app/node_modules/lodash/fp/defaultsDeep.js
mobile-app/node_modules/lodash/fp/defaultsDeepAll.js
mobile-app/node_modules/lodash/fp/defer.js
mobile-app/node_modules/lodash/fp/delay.js
mobile-app/node_modules/lodash/fp/difference.js
mobile-app/node_modules/lodash/fp/differenceBy.js
mobile-app/node_modules/lodash/fp/differenceWith.js
mobile-app/node_modules/lodash/fp/dissoc.js
mobile-app/node_modules/lodash/fp/dissocPath.js
mobile-app/node_modules/lodash/fp/divide.js
mobile-app/node_modules/lodash/fp/drop.js
mobile-app/node_modules/lodash/fp/dropLast.js
mobile-app/node_modules/lodash/fp/dropLastWhile.js
mobile-app/node_modules/lodash/fp/dropRight.js
mobile-app/node_modules/lodash/fp/dropRightWhile.js
mobile-app/node_modules/lodash/fp/dropWhile.js
mobile-app/node_modules/lodash/fp/each.js
mobile-app/node_modules/lodash/fp/eachRight.js
mobile-app/node_modules/lodash/fp/endsWith.js
mobile-app/node_modules/lodash/fp/entries.js
mobile-app/node_modules/lodash/fp/entriesIn.js
mobile-app/node_modules/lodash/fp/eq.js
mobile-app/node_modules/lodash/fp/equals.js
mobile-app/node_modules/lodash/fp/escape.js
mobile-app/node_modules/lodash/fp/escapeRegExp.js
mobile-app/node_modules/lodash/fp/every.js
mobile-app/node_modules/lodash/fp/extend.js
mobile-app/node_modules/lodash/fp/extendAll.js
mobile-app/node_modules/lodash/fp/extendAllWith.js
mobile-app/node_modules/lodash/fp/extendWith.js
mobile-app/node_modules/lodash/fp/fill.js
mobile-app/node_modules/lodash/fp/filter.js
mobile-app/node_modules/lodash/fp/find.js
mobile-app/node_modules/lodash/fp/findFrom.js
mobile-app/node_modules/lodash/fp/findIndex.js
mobile-app/node_modules/lodash/fp/findIndexFrom.js
mobile-app/node_modules/lodash/fp/findKey.js
mobile-app/node_modules/lodash/fp/findLast.js
mobile-app/node_modules/lodash/fp/findLastFrom.js
mobile-app/node_modules/lodash/fp/findLastIndex.js
mobile-app/node_modules/lodash/fp/findLastIndexFrom.js
mobile-app/node_modules/lodash/fp/findLastKey.js
mobile-app/node_modules/lodash/fp/first.js
mobile-app/node_modules/lodash/fp/flatMap.js
mobile-app/node_modules/lodash/fp/flatMapDeep.js
mobile-app/node_modules/lodash/fp/flatMapDepth.js
mobile-app/node_modules/lodash/fp/flatten.js
mobile-app/node_modules/lodash/fp/flattenDeep.js
mobile-app/node_modules/lodash/fp/flattenDepth.js
mobile-app/node_modules/lodash/fp/flip.js
mobile-app/node_modules/lodash/fp/floor.js
mobile-app/node_modules/lodash/fp/flow.js
mobile-app/node_modules/lodash/fp/flowRight.js
mobile-app/node_modules/lodash/fp/forEach.js
mobile-app/node_modules/lodash/fp/forEachRight.js
mobile-app/node_modules/lodash/fp/forIn.js
mobile-app/node_modules/lodash/fp/forInRight.js
mobile-app/node_modules/lodash/fp/forOwn.js
mobile-app/node_modules/lodash/fp/forOwnRight.js
mobile-app/node_modules/lodash/fp/fromPairs.js
mobile-app/node_modules/lodash/fp/function.js
mobile-app/node_modules/lodash/fp/functions.js
mobile-app/node_modules/lodash/fp/functionsIn.js
mobile-app/node_modules/lodash/fp/get.js
mobile-app/node_modules/lodash/fp/getOr.js
mobile-app/node_modules/lodash/fp/groupBy.js
mobile-app/node_modules/lodash/fp/gt.js
mobile-app/node_modules/lodash/fp/gte.js
mobile-app/node_modules/lodash/fp/has.js
mobile-app/node_modules/lodash/fp/hasIn.js
mobile-app/node_modules/lodash/fp/head.js
mobile-app/node_modules/lodash/fp/identical.js
mobile-app/node_modules/lodash/fp/identity.js
mobile-app/node_modules/lodash/fp/inRange.js
mobile-app/node_modules/lodash/fp/includes.js
mobile-app/node_modules/lodash/fp/includesFrom.js
mobile-app/node_modules/lodash/fp/indexBy.js
mobile-app/node_modules/lodash/fp/indexOf.js
mobile-app/node_modules/lodash/fp/indexOfFrom.js
mobile-app/node_modules/lodash/fp/init.js
mobile-app/node_modules/lodash/fp/initial.js
mobile-app/node_modules/lodash/fp/intersection.js
mobile-app/node_modules/lodash/fp/intersectionBy.js
mobile-app/node_modules/lodash/fp/intersectionWith.js
mobile-app/node_modules/lodash/fp/invert.js
mobile-app/node_modules/lodash/fp/invertBy.js
mobile-app/node_modules/lodash/fp/invertObj.js
mobile-app/node_modules/lodash/fp/invoke.js
mobile-app/node_modules/lodash/fp/invokeArgs.js
mobile-app/node_modules/lodash/fp/invokeArgsMap.js
mobile-app/node_modules/lodash/fp/invokeMap.js
mobile-app/node_modules/lodash/fp/isArguments.js
mobile-app/node_modules/lodash/fp/isArray.js
mobile-app/node_modules/lodash/fp/isArrayBuffer.js
mobile-app/node_modules/lodash/fp/isArrayLike.js
mobile-app/node_modules/lodash/fp/isArrayLikeObject.js
mobile-app/node_modules/lodash/fp/isBoolean.js
mobile-app/node_modules/lodash/fp/isBuffer.js
mobile-app/node_modules/lodash/fp/isDate.js
mobile-app/node_modules/lodash/fp/isElement.js
mobile-app/node_modules/lodash/fp/isEmpty.js
mobile-app/node_modules/lodash/fp/isEqual.js
mobile-app/node_modules/lodash/fp/isEqualWith.js
mobile-app/node_modules/lodash/fp/isError.js
mobile-app/node_modules/lodash/fp/isFinite.js
mobile-app/node_modules/lodash/fp/isFunction.js
mobile-app/node_modules/lodash/fp/isInteger.js
mobile-app/node_modules/lodash/fp/isLength.js
mobile-app/node_modules/lodash/fp/isMap.js
mobile-app/node_modules/lodash/fp/isMatch.js
mobile-app/node_modules/lodash/fp/isMatchWith.js
mobile-app/node_modules/lodash/fp/isNaN.js
mobile-app/node_modules/lodash/fp/isNative.js
mobile-app/node_modules/lodash/fp/isNil.js
mobile-app/node_modules/lodash/fp/isNull.js
mobile-app/node_modules/lodash/fp/isNumber.js
mobile-app/node_modules/lodash/fp/isObject.js
mobile-app/node_modules/lodash/fp/isObjectLike.js
mobile-app/node_modules/lodash/fp/isPlainObject.js
mobile-app/node_modules/lodash/fp/isRegExp.js
mobile-app/node_modules/lodash/fp/isSafeInteger.js
mobile-app/node_modules/lodash/fp/isSet.js
mobile-app/node_modules/lodash/fp/isString.js
mobile-app/node_modules/lodash/fp/isSymbol.js
mobile-app/node_modules/lodash/fp/isTypedArray.js
mobile-app/node_modules/lodash/fp/isUndefined.js
mobile-app/node_modules/lodash/fp/isWeakMap.js
mobile-app/node_modules/lodash/fp/isWeakSet.js
mobile-app/node_modules/lodash/fp/iteratee.js
mobile-app/node_modules/lodash/fp/join.js
mobile-app/node_modules/lodash/fp/juxt.js
mobile-app/node_modules/lodash/fp/kebabCase.js
mobile-app/node_modules/lodash/fp/keyBy.js
mobile-app/node_modules/lodash/fp/keys.js
mobile-app/node_modules/lodash/fp/keysIn.js
mobile-app/node_modules/lodash/fp/lang.js
mobile-app/node_modules/lodash/fp/last.js
mobile-app/node_modules/lodash/fp/lastIndexOf.js
mobile-app/node_modules/lodash/fp/lastIndexOfFrom.js
mobile-app/node_modules/lodash/fp/lowerCase.js
mobile-app/node_modules/lodash/fp/lowerFirst.js
mobile-app/node_modules/lodash/fp/lt.js
mobile-app/node_modules/lodash/fp/lte.js
mobile-app/node_modules/lodash/fp/map.js
mobile-app/node_modules/lodash/fp/mapKeys.js
mobile-app/node_modules/lodash/fp/mapValues.js
mobile-app/node_modules/lodash/fp/matches.js
mobile-app/node_modules/lodash/fp/matchesProperty.js
mobile-app/node_modules/lodash/fp/math.js
mobile-app/node_modules/lodash/fp/max.js
mobile-app/node_modules/lodash/fp/maxBy.js
mobile-app/node_modules/lodash/fp/mean.js
mobile-app/node_modules/lodash/fp/meanBy.js
mobile-app/node_modules/lodash/fp/memoize.js
mobile-app/node_modules/lodash/fp/merge.js
mobile-app/node_modules/lodash/fp/mergeAll.js
mobile-app/node_modules/lodash/fp/mergeAllWith.js
mobile-app/node_modules/lodash/fp/mergeWith.js
mobile-app/node_modules/lodash/fp/method.js
mobile-app/node_modules/lodash/fp/methodOf.js
mobile-app/node_modules/lodash/fp/min.js
mobile-app/node_modules/lodash/fp/minBy.js
mobile-app/node_modules/lodash/fp/mixin.js
mobile-app/node_modules/lodash/fp/multiply.js
mobile-app/node_modules/lodash/fp/nAry.js
mobile-app/node_modules/lodash/fp/negate.js
mobile-app/node_modules/lodash/fp/next.js
mobile-app/node_modules/lodash/fp/noop.js
mobile-app/node_modules/lodash/fp/now.js
mobile-app/node_modules/lodash/fp/nth.js
mobile-app/node_modules/lodash/fp/nthArg.js
mobile-app/node_modules/lodash/fp/number.js
mobile-app/node_modules/lodash/fp/object.js
mobile-app/node_modules/lodash/fp/omit.js
mobile-app/node_modules/lodash/fp/omitAll.js
mobile-app/node_modules/lodash/fp/omitBy.js
mobile-app/node_modules/lodash/fp/once.js
mobile-app/node_modules/lodash/fp/orderBy.js
mobile-app/node_modules/lodash/fp/over.js
mobile-app/node_modules/lodash/fp/overArgs.js
mobile-app/node_modules/lodash/fp/overEvery.js
mobile-app/node_modules/lodash/fp/overSome.js
mobile-app/node_modules/lodash/fp/pad.js
mobile-app/node_modules/lodash/fp/padChars.js
mobile-app/node_modules/lodash/fp/padCharsEnd.js
mobile-app/node_modules/lodash/fp/padCharsStart.js
mobile-app/node_modules/lodash/fp/padEnd.js
mobile-app/node_modules/lodash/fp/padStart.js
mobile-app/node_modules/lodash/fp/parseInt.js
mobile-app/node_modules/lodash/fp/partial.js
mobile-app/node_modules/lodash/fp/partialRight.js
mobile-app/node_modules/lodash/fp/partition.js
mobile-app/node_modules/lodash/fp/path.js
mobile-app/node_modules/lodash/fp/pathEq.js
mobile-app/node_modules/lodash/fp/pathOr.js
mobile-app/node_modules/lodash/fp/paths.js
mobile-app/node_modules/lodash/fp/pick.js
mobile-app/node_modules/lodash/fp/pickAll.js
mobile-app/node_modules/lodash/fp/pickBy.js
mobile-app/node_modules/lodash/fp/pipe.js
mobile-app/node_modules/lodash/fp/placeholder.js
mobile-app/node_modules/lodash/fp/plant.js
mobile-app/node_modules/lodash/fp/pluck.js
mobile-app/node_modules/lodash/fp/prop.js
mobile-app/node_modules/lodash/fp/propEq.js
mobile-app/node_modules/lodash/fp/propOr.js
mobile-app/node_modules/lodash/fp/property.js
mobile-app/node_modules/lodash/fp/propertyOf.js
mobile-app/node_modules/lodash/fp/props.js
mobile-app/node_modules/lodash/fp/pull.js
mobile-app/node_modules/lodash/fp/pullAll.js
mobile-app/node_modules/lodash/fp/pullAllBy.js
mobile-app/node_modules/lodash/fp/pullAllWith.js
mobile-app/node_modules/lodash/fp/pullAt.js
mobile-app/node_modules/lodash/fp/random.js
mobile-app/node_modules/lodash/fp/range.js
mobile-app/node_modules/lodash/fp/rangeRight.js
mobile-app/node_modules/lodash/fp/rangeStep.js
mobile-app/node_modules/lodash/fp/rangeStepRight.js
mobile-app/node_modules/lodash/fp/rearg.js
mobile-app/node_modules/lodash/fp/reduce.js
mobile-app/node_modules/lodash/fp/reduceRight.js
mobile-app/node_modules/lodash/fp/reject.js
mobile-app/node_modules/lodash/fp/remove.js
mobile-app/node_modules/lodash/fp/repeat.js
mobile-app/node_modules/lodash/fp/replace.js
mobile-app/node_modules/lodash/fp/rest.js
mobile-app/node_modules/lodash/fp/restFrom.js
mobile-app/node_modules/lodash/fp/result.js
mobile-app/node_modules/lodash/fp/reverse.js
mobile-app/node_modules/lodash/fp/round.js
mobile-app/node_modules/lodash/fp/sample.js
mobile-app/node_modules/lodash/fp/sampleSize.js
mobile-app/node_modules/lodash/fp/seq.js
mobile-app/node_modules/lodash/fp/set.js
mobile-app/node_modules/lodash/fp/setWith.js
mobile-app/node_modules/lodash/fp/shuffle.js
mobile-app/node_modules/lodash/fp/size.js
mobile-app/node_modules/lodash/fp/slice.js
mobile-app/node_modules/lodash/fp/snakeCase.js
mobile-app/node_modules/lodash/fp/some.js
mobile-app/node_modules/lodash/fp/sortBy.js
mobile-app/node_modules/lodash/fp/sortedIndex.js
mobile-app/node_modules/lodash/fp/sortedIndexBy.js
mobile-app/node_modules/lodash/fp/sortedIndexOf.js
mobile-app/node_modules/lodash/fp/sortedLastIndex.js
mobile-app/node_modules/lodash/fp/sortedLastIndexBy.js
mobile-app/node_modules/lodash/fp/sortedLastIndexOf.js
mobile-app/node_modules/lodash/fp/sortedUniq.js
mobile-app/node_modules/lodash/fp/sortedUniqBy.js
mobile-app/node_modules/lodash/fp/split.js
mobile-app/node_modules/lodash/fp/spread.js
mobile-app/node_modules/lodash/fp/spreadFrom.js
mobile-app/node_modules/lodash/fp/startCase.js
mobile-app/node_modules/lodash/fp/startsWith.js
mobile-app/node_modules/lodash/fp/string.js
mobile-app/node_modules/lodash/fp/stubArray.js
mobile-app/node_modules/lodash/fp/stubFalse.js
mobile-app/node_modules/lodash/fp/stubObject.js
mobile-app/node_modules/lodash/fp/stubString.js
mobile-app/node_modules/lodash/fp/stubTrue.js
mobile-app/node_modules/lodash/fp/subtract.js
mobile-app/node_modules/lodash/fp/sum.js
mobile-app/node_modules/lodash/fp/sumBy.js
mobile-app/node_modules/lodash/fp/symmetricDifference.js
mobile-app/node_modules/lodash/fp/symmetricDifferenceBy.js
mobile-app/node_modules/lodash/fp/symmetricDifferenceWith.js
mobile-app/node_modules/lodash/fp/tail.js
mobile-app/node_modules/lodash/fp/take.js
mobile-app/node_modules/lodash/fp/takeLast.js
mobile-app/node_modules/lodash/fp/takeLastWhile.js
mobile-app/node_modules/lodash/fp/takeRight.js
mobile-app/node_modules/lodash/fp/takeRightWhile.js
mobile-app/node_modules/lodash/fp/takeWhile.js
mobile-app/node_modules/lodash/fp/tap.js
mobile-app/node_modules/lodash/fp/template.js
mobile-app/node_modules/lodash/fp/templateSettings.js
mobile-app/node_modules/lodash/fp/throttle.js
mobile-app/node_modules/lodash/fp/thru.js
mobile-app/node_modules/lodash/fp/times.js
mobile-app/node_modules/lodash/fp/toArray.js
mobile-app/node_modules/lodash/fp/toFinite.js
mobile-app/node_modules/lodash/fp/toInteger.js
mobile-app/node_modules/lodash/fp/toIterator.js
mobile-app/node_modules/lodash/fp/toJSON.js
mobile-app/node_modules/lodash/fp/toLength.js
mobile-app/node_modules/lodash/fp/toLower.js
mobile-app/node_modules/lodash/fp/toNumber.js
mobile-app/node_modules/lodash/fp/toPairs.js
mobile-app/node_modules/lodash/fp/toPairsIn.js
mobile-app/node_modules/lodash/fp/toPath.js
mobile-app/node_modules/lodash/fp/toPlainObject.js
mobile-app/node_modules/lodash/fp/toSafeInteger.js
mobile-app/node_modules/lodash/fp/toString.js
mobile-app/node_modules/lodash/fp/toUpper.js
mobile-app/node_modules/lodash/fp/transform.js
mobile-app/node_modules/lodash/fp/trim.js
mobile-app/node_modules/lodash/fp/trimChars.js
mobile-app/node_modules/lodash/fp/trimCharsEnd.js
mobile-app/node_modules/lodash/fp/trimCharsStart.js
mobile-app/node_modules/lodash/fp/trimEnd.js
mobile-app/node_modules/lodash/fp/trimStart.js
mobile-app/node_modules/lodash/fp/truncate.js
mobile-app/node_modules/lodash/fp/unapply.js
mobile-app/node_modules/lodash/fp/unary.js
mobile-app/node_modules/lodash/fp/unescape.js
mobile-app/node_modules/lodash/fp/union.js
mobile-app/node_modules/lodash/fp/unionBy.js
mobile-app/node_modules/lodash/fp/unionWith.js
mobile-app/node_modules/lodash/fp/uniq.js
mobile-app/node_modules/lodash/fp/uniqBy.js
mobile-app/node_modules/lodash/fp/uniqWith.js
mobile-app/node_modules/lodash/fp/uniqueId.js
mobile-app/node_modules/lodash/fp/unnest.js
mobile-app/node_modules/lodash/fp/unset.js
mobile-app/node_modules/lodash/fp/unzip.js
mobile-app/node_modules/lodash/fp/unzipWith.js
mobile-app/node_modules/lodash/fp/update.js
mobile-app/node_modules/lodash/fp/updateWith.js
mobile-app/node_modules/lodash/fp/upperCase.js
mobile-app/node_modules/lodash/fp/upperFirst.js
mobile-app/node_modules/lodash/fp/useWith.js
mobile-app/node_modules/lodash/fp/util.js
mobile-app/node_modules/lodash/fp/value.js
mobile-app/node_modules/lodash/fp/valueOf.js
mobile-app/node_modules/lodash/fp/values.js
mobile-app/node_modules/lodash/fp/valuesIn.js
mobile-app/node_modules/lodash/fp/where.js
mobile-app/node_modules/lodash/fp/whereEq.js
mobile-app/node_modules/lodash/fp/without.js
mobile-app/node_modules/lodash/fp/words.js
mobile-app/node_modules/lodash/fp/wrap.js
mobile-app/node_modules/lodash/fp/wrapperAt.js
mobile-app/node_modules/lodash/fp/wrapperChain.js
mobile-app/node_modules/lodash/fp/wrapperLodash.js
mobile-app/node_modules/lodash/fp/wrapperReverse.js
mobile-app/node_modules/lodash/fp/wrapperValue.js
mobile-app/node_modules/lodash/fp/xor.js
mobile-app/node_modules/lodash/fp/xorBy.js
mobile-app/node_modules/lodash/fp/xorWith.js
mobile-app/node_modules/lodash/fp/zip.js
mobile-app/node_modules/lodash/fp/zipAll.js
mobile-app/node_modules/lodash/fp/zipObj.js
mobile-app/node_modules/lodash/fp/zipObject.js
mobile-app/node_modules/lodash/fp/zipObjectDeep.js
mobile-app/node_modules/lodash/fp/zipWith.js
mobile-app/node_modules/lodash/fromPairs.js
mobile-app/node_modules/lodash/function.js
mobile-app/node_modules/lodash/functions.js
mobile-app/node_modules/lodash/functionsIn.js
mobile-app/node_modules/lodash/get.js
mobile-app/node_modules/lodash/groupBy.js
mobile-app/node_modules/lodash/gt.js
mobile-app/node_modules/lodash/gte.js
mobile-app/node_modules/lodash/has.js
mobile-app/node_modules/lodash/hasIn.js
mobile-app/node_modules/lodash/head.js
mobile-app/node_modules/lodash/identity.js
mobile-app/node_modules/lodash/inRange.js
mobile-app/node_modules/lodash/includes.js
mobile-app/node_modules/lodash/index.js
mobile-app/node_modules/lodash/indexOf.js
mobile-app/node_modules/lodash/initial.js
mobile-app/node_modules/lodash/intersection.js
mobile-app/node_modules/lodash/intersectionBy.js
mobile-app/node_modules/lodash/intersectionWith.js
mobile-app/node_modules/lodash/invert.js
mobile-app/node_modules/lodash/invertBy.js
mobile-app/node_modules/lodash/invoke.js
mobile-app/node_modules/lodash/invokeMap.js
mobile-app/node_modules/lodash/isArguments.js
mobile-app/node_modules/lodash/isArray.js
mobile-app/node_modules/lodash/isArrayBuffer.js
mobile-app/node_modules/lodash/isArrayLike.js
mobile-app/node_modules/lodash/isArrayLikeObject.js
mobile-app/node_modules/lodash/isBoolean.js
mobile-app/node_modules/lodash/isBuffer.js
mobile-app/node_modules/lodash/isDate.js
mobile-app/node_modules/lodash/isElement.js
mobile-app/node_modules/lodash/isEmpty.js
mobile-app/node_modules/lodash/isEqual.js
mobile-app/node_modules/lodash/isEqualWith.js
mobile-app/node_modules/lodash/isError.js
mobile-app/node_modules/lodash/isFinite.js
mobile-app/node_modules/lodash/isFunction.js
mobile-app/node_modules/lodash/isInteger.js
mobile-app/node_modules/lodash/isLength.js
mobile-app/node_modules/lodash/isMap.js
mobile-app/node_modules/lodash/isMatch.js
mobile-app/node_modules/lodash/isMatchWith.js
mobile-app/node_modules/lodash/isNaN.js
mobile-app/node_modules/lodash/isNative.js
mobile-app/node_modules/lodash/isNil.js
mobile-app/node_modules/lodash/isNull.js
mobile-app/node_modules/lodash/isNumber.js
mobile-app/node_modules/lodash/isObject.js
mobile-app/node_modules/lodash/isObjectLike.js
mobile-app/node_modules/lodash/isPlainObject.js
mobile-app/node_modules/lodash/isRegExp.js
mobile-app/node_modules/lodash/isSafeInteger.js
mobile-app/node_modules/lodash/isSet.js
mobile-app/node_modules/lodash/isString.js
mobile-app/node_modules/lodash/isSymbol.js
mobile-app/node_modules/lodash/isTypedArray.js
mobile-app/node_modules/lodash/isUndefined.js
mobile-app/node_modules/lodash/isWeakMap.js
mobile-app/node_modules/lodash/isWeakSet.js
mobile-app/node_modules/lodash/iteratee.js
mobile-app/node_modules/lodash/join.js
mobile-app/node_modules/lodash/kebabCase.js
mobile-app/node_modules/lodash/keyBy.js
mobile-app/node_modules/lodash/keys.js
mobile-app/node_modules/lodash/keysIn.js
mobile-app/node_modules/lodash/lang.js
mobile-app/node_modules/lodash/last.js
mobile-app/node_modules/lodash/lastIndexOf.js
mobile-app/node_modules/lodash/lodash.js
mobile-app/node_modules/lodash/lodash.min.js
mobile-app/node_modules/lodash/lowerCase.js
mobile-app/node_modules/lodash/lowerFirst.js
mobile-app/node_modules/lodash/lt.js
mobile-app/node_modules/lodash/lte.js
mobile-app/node_modules/lodash/map.js
mobile-app/node_modules/lodash/mapKeys.js
mobile-app/node_modules/lodash/mapValues.js
mobile-app/node_modules/lodash/matches.js
mobile-app/node_modules/lodash/matchesProperty.js
mobile-app/node_modules/lodash/math.js
mobile-app/node_modules/lodash/max.js
mobile-app/node_modules/lodash/maxBy.js
mobile-app/node_modules/lodash/mean.js
mobile-app/node_modules/lodash/meanBy.js
mobile-app/node_modules/lodash/memoize.js
mobile-app/node_modules/lodash/merge.js
mobile-app/node_modules/lodash/mergeWith.js
mobile-app/node_modules/lodash/method.js
mobile-app/node_modules/lodash/methodOf.js
mobile-app/node_modules/lodash/min.js
mobile-app/node_modules/lodash/minBy.js
mobile-app/node_modules/lodash/mixin.js
mobile-app/node_modules/lodash/multiply.js
mobile-app/node_modules/lodash/negate.js
mobile-app/node_modules/lodash/next.js
mobile-app/node_modules/lodash/noop.js
mobile-app/node_modules/lodash/now.js
mobile-app/node_modules/lodash/nth.js
mobile-app/node_modules/lodash/nthArg.js
mobile-app/node_modules/lodash/number.js
mobile-app/node_modules/lodash/object.js
mobile-app/node_modules/lodash/omit.js
mobile-app/node_modules/lodash/omitBy.js
mobile-app/node_modules/lodash/once.js
mobile-app/node_modules/lodash/orderBy.js
mobile-app/node_modules/lodash/over.js
mobile-app/node_modules/lodash/overArgs.js
mobile-app/node_modules/lodash/overEvery.js
mobile-app/node_modules/lodash/overSome.js
mobile-app/node_modules/lodash/package.json
mobile-app/node_modules/lodash/pad.js
mobile-app/node_modules/lodash/padEnd.js
mobile-app/node_modules/lodash/padStart.js
mobile-app/node_modules/lodash/parseInt.js
mobile-app/node_modules/lodash/partial.js
mobile-app/node_modules/lodash/partialRight.js
mobile-app/node_modules/lodash/partition.js
mobile-app/node_modules/lodash/pick.js
mobile-app/node_modules/lodash/pickBy.js
mobile-app/node_modules/lodash/plant.js
mobile-app/node_modules/lodash/property.js
mobile-app/node_modules/lodash/propertyOf.js
mobile-app/node_modules/lodash/pull.js
mobile-app/node_modules/lodash/pullAll.js
mobile-app/node_modules/lodash/pullAllBy.js
mobile-app/node_modules/lodash/pullAllWith.js
mobile-app/node_modules/lodash/pullAt.js
mobile-app/node_modules/lodash/random.js
mobile-app/node_modules/lodash/range.js
mobile-app/node_modules/lodash/rangeRight.js
mobile-app/node_modules/lodash/rearg.js
mobile-app/node_modules/lodash/reduce.js
mobile-app/node_modules/lodash/reduceRight.js
mobile-app/node_modules/lodash/reject.js
mobile-app/node_modules/lodash/remove.js
mobile-app/node_modules/lodash/repeat.js
mobile-app/node_modules/lodash/replace.js
mobile-app/node_modules/lodash/rest.js
mobile-app/node_modules/lodash/result.js
mobile-app/node_modules/lodash/reverse.js
mobile-app/node_modules/lodash/round.js
mobile-app/node_modules/lodash/sample.js
mobile-app/node_modules/lodash/sampleSize.js
mobile-app/node_modules/lodash/seq.js
mobile-app/node_modules/lodash/set.js
mobile-app/node_modules/lodash/setWith.js
mobile-app/node_modules/lodash/shuffle.js
mobile-app/node_modules/lodash/size.js
mobile-app/node_modules/lodash/slice.js
mobile-app/node_modules/lodash/snakeCase.js
mobile-app/node_modules/lodash/some.js
mobile-app/node_modules/lodash/sortBy.js
mobile-app/node_modules/lodash/sortedIndex.js
mobile-app/node_modules/lodash/sortedIndexBy.js
mobile-app/node_modules/lodash/sortedIndexOf.js
mobile-app/node_modules/lodash/sortedLastIndex.js
mobile-app/node_modules/lodash/sortedLastIndexBy.js
mobile-app/node_modules/lodash/sortedLastIndexOf.js
mobile-app/node_modules/lodash/sortedUniq.js
mobile-app/node_modules/lodash/sortedUniqBy.js
mobile-app/node_modules/lodash/split.js
mobile-app/node_modules/lodash/spread.js
mobile-app/node_modules/lodash/startCase.js
mobile-app/node_modules/lodash/startsWith.js
mobile-app/node_modules/lodash/string.js
mobile-app/node_modules/lodash/stubArray.js
mobile-app/node_modules/lodash/stubFalse.js
mobile-app/node_modules/lodash/stubObject.js
mobile-app/node_modules/lodash/stubString.js
mobile-app/node_modules/lodash/stubTrue.js
mobile-app/node_modules/lodash/subtract.js
mobile-app/node_modules/lodash/sum.js
mobile-app/node_modules/lodash/sumBy.js
mobile-app/node_modules/lodash/tail.js
mobile-app/node_modules/lodash/take.js
mobile-app/node_modules/lodash/takeRight.js
mobile-app/node_modules/lodash/takeRightWhile.js
mobile-app/node_modules/lodash/takeWhile.js
mobile-app/node_modules/lodash/tap.js
mobile-app/node_modules/lodash/template.js
mobile-app/node_modules/lodash/templateSettings.js
mobile-app/node_modules/lodash/throttle.js
mobile-app/node_modules/lodash/thru.js
mobile-app/node_modules/lodash/times.js
mobile-app/node_modules/lodash/toArray.js
mobile-app/node_modules/lodash/toFinite.js
mobile-app/node_modules/lodash/toInteger.js
mobile-app/node_modules/lodash/toIterator.js
mobile-app/node_modules/lodash/toJSON.js
mobile-app/node_modules/lodash/toLength.js
mobile-app/node_modules/lodash/toLower.js
mobile-app/node_modules/lodash/toNumber.js
mobile-app/node_modules/lodash/toPairs.js
mobile-app/node_modules/lodash/toPairsIn.js
mobile-app/node_modules/lodash/toPath.js
mobile-app/node_modules/lodash/toPlainObject.js
mobile-app/node_modules/lodash/toSafeInteger.js
mobile-app/node_modules/lodash/toString.js
mobile-app/node_modules/lodash/toUpper.js
mobile-app/node_modules/lodash/transform.js
mobile-app/node_modules/lodash/trim.js
mobile-app/node_modules/lodash/trimEnd.js
mobile-app/node_modules/lodash/trimStart.js
mobile-app/node_modules/lodash/truncate.js
mobile-app/node_modules/lodash/unary.js
mobile-app/node_modules/lodash/unescape.js
mobile-app/node_modules/lodash/union.js
mobile-app/node_modules/lodash/unionBy.js
mobile-app/node_modules/lodash/unionWith.js
mobile-app/node_modules/lodash/uniq.js
mobile-app/node_modules/lodash/uniqBy.js
mobile-app/node_modules/lodash/uniqWith.js
mobile-app/node_modules/lodash/uniqueId.js
mobile-app/node_modules/lodash/unset.js
mobile-app/node_modules/lodash/unzip.js
mobile-app/node_modules/lodash/unzipWith.js
mobile-app/node_modules/lodash/update.js
mobile-app/node_modules/lodash/updateWith.js
mobile-app/node_modules/lodash/upperCase.js
mobile-app/node_modules/lodash/upperFirst.js
mobile-app/node_modules/lodash/util.js
mobile-app/node_modules/lodash/value.js
mobile-app/node_modules/lodash/valueOf.js
mobile-app/node_modules/lodash/values.js
mobile-app/node_modules/lodash/valuesIn.js
mobile-app/node_modules/lodash/without.js
mobile-app/node_modules/lodash/words.js
mobile-app/node_modules/lodash/wrap.js
mobile-app/node_modules/lodash/wrapperAt.js
mobile-app/node_modules/lodash/wrapperChain.js
mobile-app/node_modules/lodash/wrapperLodash.js
mobile-app/node_modules/lodash/wrapperReverse.js
mobile-app/node_modules/lodash/wrapperValue.js
mobile-app/node_modules/lodash/xor.js
mobile-app/node_modules/lodash/xorBy.js
mobile-app/node_modules/lodash/xorWith.js
mobile-app/node_modules/lodash/zip.js
mobile-app/node_modules/lodash/zipObject.js
mobile-app/node_modules/lodash/zipObjectDeep.js
mobile-app/node_modules/lodash/zipWith.js
mobile-app/node_modules/lru-cache/LICENSE.md
mobile-app/node_modules/lru-cache/README.md
mobile-app/node_modules/lru-cache/package.json
mobile-app/node_modules/mimic-response/index.d.ts
mobile-app/node_modules/mimic-response/index.js
mobile-app/node_modules/mimic-response/license
mobile-app/node_modules/mimic-response/package.json
mobile-app/node_modules/mimic-response/readme.md
mobile-app/node_modules/minimatch/LICENSE.md
mobile-app/node_modules/minimatch/README.md
mobile-app/node_modules/minimatch/package.json
mobile-app/node_modules/minimist/.eslintrc
mobile-app/node_modules/minimist/.github/FUNDING.yml
mobile-app/node_modules/minimist/.nycrc
mobile-app/node_modules/minimist/CHANGELOG.md
mobile-app/node_modules/minimist/LICENSE
mobile-app/node_modules/minimist/README.md
mobile-app/node_modules/minimist/example/parse.js
mobile-app/node_modules/minimist/index.js
mobile-app/node_modules/minimist/package.json
mobile-app/node_modules/minimist/test/all_bool.js
mobile-app/node_modules/minimist/test/bool.js
mobile-app/node_modules/minimist/test/dash.js
mobile-app/node_modules/minimist/test/default_bool.js
mobile-app/node_modules/minimist/test/dotted.js
mobile-app/node_modules/minimist/test/kv_short.js
mobile-app/node_modules/minimist/test/long.js
mobile-app/node_modules/minimist/test/num.js
mobile-app/node_modules/minimist/test/parse.js
mobile-app/node_modules/minimist/test/parse_modified.js
mobile-app/node_modules/minimist/test/proto.js
mobile-app/node_modules/minimist/test/short.js
mobile-app/node_modules/minimist/test/stop_early.js
mobile-app/node_modules/minimist/test/unknown.js
mobile-app/node_modules/minimist/test/whitespace.js
mobile-app/node_modules/minipass/LICENSE.md
mobile-app/node_modules/minipass/README.md
mobile-app/node_modules/minipass/package.json
mobile-app/node_modules/minizlib/LICENSE
mobile-app/node_modules/minizlib/README.md
mobile-app/node_modules/minizlib/package.json
mobile-app/node_modules/mkdirp-classic/LICENSE
mobile-app/node_modules/mkdirp-classic/README.md
mobile-app/node_modules/mkdirp-classic/index.js
mobile-app/node_modules/mkdirp-classic/package.json
mobile-app/node_modules/mkdirp/CHANGELOG.md
mobile-app/node_modules/mkdirp/LICENSE
mobile-app/node_modules/mkdirp/bin/cmd.js
mobile-app/node_modules/mkdirp/index.js
mobile-app/node_modules/mkdirp/lib/find-made.js
mobile-app/node_modules/mkdirp/lib/mkdirp-manual.js
mobile-app/node_modules/mkdirp/lib/mkdirp-native.js
mobile-app/node_modules/mkdirp/lib/opts-arg.js
mobile-app/node_modules/mkdirp/lib/path-arg.js
mobile-app/node_modules/mkdirp/lib/use-native.js
mobile-app/node_modules/mkdirp/package.json
mobile-app/node_modules/mkdirp/readme.markdown
mobile-app/node_modules/ms/index.js
mobile-app/node_modules/ms/license.md
mobile-app/node_modules/ms/package.json
mobile-app/node_modules/ms/readme.md
mobile-app/node_modules/napi-build-utils/LICENSE
mobile-app/node_modules/napi-build-utils/README.md
mobile-app/node_modules/napi-build-utils/index.js
mobile-app/node_modules/napi-build-utils/index.md
mobile-app/node_modules/napi-build-utils/package.json
mobile-app/node_modules/native-run/LICENSE
mobile-app/node_modules/native-run/README.md
mobile-app/node_modules/native-run/bin/native-run
mobile-app/node_modules/native-run/dist/constants.js
mobile-app/node_modules/native-run/dist/errors.js
mobile-app/node_modules/native-run/dist/help.js
mobile-app/node_modules/native-run/dist/index.js
mobile-app/node_modules/native-run/dist/list.js
mobile-app/node_modules/native-run/package.json
mobile-app/node_modules/node-abi/LICENSE
mobile-app/node_modules/node-abi/README.md
mobile-app/node_modules/node-abi/abi_registry.json
mobile-app/node_modules/node-abi/index.js
mobile-app/node_modules/node-abi/package.json
mobile-app/node_modules/node-addon-api/LICENSE.md
mobile-app/node_modules/node-addon-api/README.md
mobile-app/node_modules/node-addon-api/common.gypi
mobile-app/node_modules/node-addon-api/except.gypi
mobile-app/node_modules/node-addon-api/index.js
mobile-app/node_modules/node-addon-api/napi-inl.deprecated.h
mobile-app/node_modules/node-addon-api/napi-inl.h
mobile-app/node_modules/node-addon-api/napi.h
mobile-app/node_modules/node-addon-api/node_api.gyp
mobile-app/node_modules/node-addon-api/noexcept.gypi
mobile-app/node_modules/node-addon-api/nothing.c
mobile-app/node_modules/node-addon-api/package-support.json
mobile-app/node_modules/node-addon-api/package.json
mobile-app/node_modules/node-addon-api/tools/README.md
mobile-app/node_modules/node-addon-api/tools/check-napi.js
mobile-app/node_modules/node-addon-api/tools/clang-format.js
mobile-app/node_modules/node-addon-api/tools/conversion.js
mobile-app/node_modules/node-addon-api/tools/eslint-format.js
mobile-app/node_modules/node-fetch/LICENSE.md
mobile-app/node_modules/node-fetch/README.md
mobile-app/node_modules/node-fetch/browser.js
mobile-app/node_modules/node-fetch/lib/index.es.js
mobile-app/node_modules/node-fetch/lib/index.js
mobile-app/node_modules/node-fetch/lib/index.mjs
mobile-app/node_modules/node-fetch/package.json
mobile-app/node_modules/node-html-parser/CHANGELOG.md
mobile-app/node_modules/node-html-parser/LICENSE
mobile-app/node_modules/node-html-parser/README.md
mobile-app/node_modules/node-html-parser/dist/back.d.ts
mobile-app/node_modules/node-html-parser/dist/back.js
mobile-app/node_modules/node-html-parser/dist/index.d.ts
mobile-app/node_modules/node-html-parser/dist/index.js
mobile-app/node_modules/node-html-parser/dist/main.js
mobile-app/node_modules/node-html-parser/dist/matcher.d.ts
mobile-app/node_modules/node-html-parser/dist/matcher.js
mobile-app/node_modules/node-html-parser/dist/parse.d.ts
mobile-app/node_modules/node-html-parser/dist/parse.js
mobile-app/node_modules/node-html-parser/dist/valid.d.ts
mobile-app/node_modules/node-html-parser/dist/valid.js
mobile-app/node_modules/node-html-parser/dist/void-tag.d.ts
mobile-app/node_modules/node-html-parser/dist/void-tag.js
mobile-app/node_modules/node-html-parser/package.json
mobile-app/node_modules/nth-check/LICENSE
mobile-app/node_modules/nth-check/README.md
mobile-app/node_modules/nth-check/lib/compile.d.ts
mobile-app/node_modules/nth-check/lib/compile.d.ts.map
mobile-app/node_modules/nth-check/lib/compile.js
mobile-app/node_modules/nth-check/lib/compile.js.map
mobile-app/node_modules/nth-check/lib/index.d.ts
mobile-app/node_modules/nth-check/lib/index.d.ts.map
mobile-app/node_modules/nth-check/lib/index.js
mobile-app/node_modules/nth-check/lib/index.js.map
mobile-app/node_modules/nth-check/lib/parse.d.ts
mobile-app/node_modules/nth-check/lib/parse.d.ts.map
mobile-app/node_modules/nth-check/lib/parse.js
mobile-app/node_modules/nth-check/lib/parse.js.map
mobile-app/node_modules/nth-check/package.json
mobile-app/node_modules/once/LICENSE
mobile-app/node_modules/once/README.md
mobile-app/node_modules/once/once.js
mobile-app/node_modules/once/package.json
mobile-app/node_modules/open/index.d.ts
mobile-app/node_modules/open/index.js
mobile-app/node_modules/open/license
mobile-app/node_modules/open/package.json
mobile-app/node_modules/open/readme.md
mobile-app/node_modules/open/xdg-open
mobile-app/node_modules/package-json-from-dist/LICENSE.md
mobile-app/node_modules/package-json-from-dist/README.md
mobile-app/node_modules/package-json-from-dist/package.json
mobile-app/node_modules/path-key/index.d.ts
mobile-app/node_modules/path-key/index.js
mobile-app/node_modules/path-key/license
mobile-app/node_modules/path-key/package.json
mobile-app/node_modules/path-key/readme.md
mobile-app/node_modules/path-scurry/LICENSE.md
mobile-app/node_modules/path-scurry/README.md
mobile-app/node_modules/path-scurry/package.json
mobile-app/node_modules/pend/LICENSE
mobile-app/node_modules/pend/README.md
mobile-app/node_modules/pend/index.js
mobile-app/node_modules/pend/package.json
mobile-app/node_modules/pend/test.js
mobile-app/node_modules/plist/.jshintrc
mobile-app/node_modules/plist/History.md
mobile-app/node_modules/plist/LICENSE
mobile-app/node_modules/plist/Makefile
mobile-app/node_modules/plist/README.md
mobile-app/node_modules/plist/dist/plist-build.js
mobile-app/node_modules/plist/dist/plist-parse.js
mobile-app/node_modules/plist/dist/plist.js
mobile-app/node_modules/plist/index.js
mobile-app/node_modules/plist/lib/build.js
mobile-app/node_modules/plist/lib/parse.js
mobile-app/node_modules/plist/package.json
mobile-app/node_modules/prebuild-install/CHANGELOG.md
mobile-app/node_modules/prebuild-install/CONTRIBUTING.md
mobile-app/node_modules/prebuild-install/LICENSE
mobile-app/node_modules/prebuild-install/README.md
mobile-app/node_modules/prebuild-install/asset.js
mobile-app/node_modules/prebuild-install/bin.js
mobile-app/node_modules/prebuild-install/download.js
mobile-app/node_modules/prebuild-install/error.js
mobile-app/node_modules/prebuild-install/help.txt
mobile-app/node_modules/prebuild-install/index.js
mobile-app/node_modules/prebuild-install/log.js
mobile-app/node_modules/prebuild-install/package.json
mobile-app/node_modules/prebuild-install/proxy.js
mobile-app/node_modules/prebuild-install/rc.js
mobile-app/node_modules/prebuild-install/util.js
mobile-app/node_modules/prettier/LICENSE
mobile-app/node_modules/prettier/README.md
mobile-app/node_modules/prettier/bin-prettier.js
mobile-app/node_modules/prettier/cli.js
mobile-app/node_modules/prettier/doc.js
mobile-app/node_modules/prettier/esm/parser-angular.mjs
mobile-app/node_modules/prettier/esm/parser-babel.mjs
mobile-app/node_modules/prettier/esm/parser-espree.mjs
mobile-app/node_modules/prettier/esm/parser-flow.mjs
mobile-app/node_modules/prettier/esm/parser-glimmer.mjs
mobile-app/node_modules/prettier/esm/parser-graphql.mjs
mobile-app/node_modules/prettier/esm/parser-html.mjs
mobile-app/node_modules/prettier/esm/parser-markdown.mjs
mobile-app/node_modules/prettier/esm/parser-meriyah.mjs
mobile-app/node_modules/prettier/esm/parser-postcss.mjs
mobile-app/node_modules/prettier/esm/parser-typescript.mjs
mobile-app/node_modules/prettier/esm/parser-yaml.mjs
mobile-app/node_modules/prettier/esm/standalone.mjs
mobile-app/node_modules/prettier/index.js
mobile-app/node_modules/prettier/package.json
mobile-app/node_modules/prettier/parser-angular.js
mobile-app/node_modules/prettier/parser-babel.js
mobile-app/node_modules/prettier/parser-espree.js
mobile-app/node_modules/prettier/parser-flow.js
mobile-app/node_modules/prettier/parser-glimmer.js
mobile-app/node_modules/prettier/parser-graphql.js
mobile-app/node_modules/prettier/parser-html.js
mobile-app/node_modules/prettier/parser-markdown.js
mobile-app/node_modules/prettier/parser-meriyah.js
mobile-app/node_modules/prettier/parser-postcss.js
mobile-app/node_modules/prettier/parser-typescript.js
mobile-app/node_modules/prettier/parser-yaml.js
mobile-app/node_modules/prettier/standalone.js
mobile-app/node_modules/prettier/third-party.js
mobile-app/node_modules/prompts/dist/index.js
mobile-app/node_modules/prompts/dist/prompts.js
mobile-app/node_modules/prompts/index.js
mobile-app/node_modules/prompts/lib/index.js
mobile-app/node_modules/prompts/lib/prompts.js
mobile-app/node_modules/prompts/license
mobile-app/node_modules/prompts/package.json
mobile-app/node_modules/prompts/readme.md
mobile-app/node_modules/pump/.github/FUNDING.yml
mobile-app/node_modules/pump/.travis.yml
mobile-app/node_modules/pump/LICENSE
mobile-app/node_modules/pump/README.md
mobile-app/node_modules/pump/SECURITY.md
mobile-app/node_modules/pump/empty.js
mobile-app/node_modules/pump/index.js
mobile-app/node_modules/pump/package.json
mobile-app/node_modules/pump/test-browser.js
mobile-app/node_modules/pump/test-node.js
mobile-app/node_modules/rc/LICENSE.APACHE2
mobile-app/node_modules/rc/LICENSE.BSD
mobile-app/node_modules/rc/LICENSE.MIT
mobile-app/node_modules/rc/README.md
mobile-app/node_modules/rc/browser.js
mobile-app/node_modules/rc/cli.js
mobile-app/node_modules/rc/index.js
mobile-app/node_modules/rc/lib/utils.js
mobile-app/node_modules/rc/package.json
mobile-app/node_modules/rc/test/ini.js
mobile-app/node_modules/rc/test/nested-env-vars.js
mobile-app/node_modules/rc/test/test.js
mobile-app/node_modules/readable-stream/CONTRIBUTING.md
mobile-app/node_modules/readable-stream/GOVERNANCE.md
mobile-app/node_modules/readable-stream/LICENSE
mobile-app/node_modules/readable-stream/README.md
mobile-app/node_modules/readable-stream/errors-browser.js
mobile-app/node_modules/readable-stream/errors.js
mobile-app/node_modules/readable-stream/experimentalWarning.js
mobile-app/node_modules/readable-stream/lib/_stream_duplex.js
mobile-app/node_modules/readable-stream/lib/_stream_passthrough.js
mobile-app/node_modules/readable-stream/lib/_stream_readable.js
mobile-app/node_modules/readable-stream/lib/_stream_transform.js
mobile-app/node_modules/readable-stream/lib/_stream_writable.js
mobile-app/node_modules/readable-stream/package.json
mobile-app/node_modules/readable-stream/readable-browser.js
mobile-app/node_modules/readable-stream/readable.js
mobile-app/node_modules/regexp-to-ast/CHANGELOG.md
mobile-app/node_modules/regexp-to-ast/LICENSE
mobile-app/node_modules/regexp-to-ast/README.md
mobile-app/node_modules/regexp-to-ast/api.d.ts
mobile-app/node_modules/regexp-to-ast/lib/regexp-to-ast.js
mobile-app/node_modules/regexp-to-ast/package.json
mobile-app/node_modules/require-directory/.jshintrc
mobile-app/node_modules/require-directory/.npmignore
mobile-app/node_modules/require-directory/.travis.yml
mobile-app/node_modules/require-directory/LICENSE
mobile-app/node_modules/require-directory/README.markdown
mobile-app/node_modules/require-directory/index.js
mobile-app/node_modules/require-directory/package.json
mobile-app/node_modules/rimraf/LICENSE.md
mobile-app/node_modules/rimraf/README.md
mobile-app/node_modules/rimraf/package.json
mobile-app/node_modules/safe-buffer/LICENSE
mobile-app/node_modules/safe-buffer/README.md
mobile-app/node_modules/safe-buffer/index.d.ts
mobile-app/node_modules/safe-buffer/index.js
mobile-app/node_modules/safe-buffer/package.json
mobile-app/node_modules/sax/LICENSE
mobile-app/node_modules/sax/LICENSE-W3C.html
mobile-app/node_modules/sax/README.md
mobile-app/node_modules/sax/lib/sax.js
mobile-app/node_modules/sax/package.json
mobile-app/node_modules/semver/LICENSE
mobile-app/node_modules/semver/README.md
mobile-app/node_modules/semver/bin/semver.js
mobile-app/node_modules/semver/classes/comparator.js
mobile-app/node_modules/semver/classes/index.js
mobile-app/node_modules/semver/classes/range.js
mobile-app/node_modules/semver/classes/semver.js
mobile-app/node_modules/semver/functions/clean.js
mobile-app/node_modules/semver/functions/cmp.js
mobile-app/node_modules/semver/functions/coerce.js
mobile-app/node_modules/semver/functions/compare-build.js
mobile-app/node_modules/semver/functions/compare-loose.js
mobile-app/node_modules/semver/functions/compare.js
mobile-app/node_modules/semver/functions/diff.js
mobile-app/node_modules/semver/functions/eq.js
mobile-app/node_modules/semver/functions/gt.js
mobile-app/node_modules/semver/functions/gte.js
mobile-app/node_modules/semver/functions/inc.js
mobile-app/node_modules/semver/functions/lt.js
mobile-app/node_modules/semver/functions/lte.js
mobile-app/node_modules/semver/functions/major.js
mobile-app/node_modules/semver/functions/minor.js
mobile-app/node_modules/semver/functions/neq.js
mobile-app/node_modules/semver/functions/parse.js
mobile-app/node_modules/semver/functions/patch.js
mobile-app/node_modules/semver/functions/prerelease.js
mobile-app/node_modules/semver/functions/rcompare.js
mobile-app/node_modules/semver/functions/rsort.js
mobile-app/node_modules/semver/functions/satisfies.js
mobile-app/node_modules/semver/functions/sort.js
mobile-app/node_modules/semver/functions/truncate.js
mobile-app/node_modules/semver/functions/valid.js
mobile-app/node_modules/semver/index.js
mobile-app/node_modules/semver/internal/constants.js
mobile-app/node_modules/semver/internal/debug.js
mobile-app/node_modules/semver/internal/identifiers.js
mobile-app/node_modules/semver/internal/lrucache.js
mobile-app/node_modules/semver/internal/parse-options.js
mobile-app/node_modules/semver/internal/re.js
mobile-app/node_modules/semver/package.json
mobile-app/node_modules/semver/preload.js
mobile-app/node_modules/semver/range.bnf
mobile-app/node_modules/semver/ranges/gtr.js
mobile-app/node_modules/semver/ranges/intersects.js
mobile-app/node_modules/semver/ranges/ltr.js
mobile-app/node_modules/semver/ranges/max-satisfying.js
mobile-app/node_modules/semver/ranges/min-satisfying.js
mobile-app/node_modules/semver/ranges/min-version.js
mobile-app/node_modules/semver/ranges/outside.js
mobile-app/node_modules/semver/ranges/simplify.js
mobile-app/node_modules/semver/ranges/subset.js
mobile-app/node_modules/semver/ranges/to-comparators.js
mobile-app/node_modules/semver/ranges/valid.js
mobile-app/node_modules/sharp/LICENSE
mobile-app/node_modules/sharp/README.md
mobile-app/node_modules/sharp/binding.gyp
mobile-app/node_modules/sharp/install/can-compile.js
mobile-app/node_modules/sharp/install/dll-copy.js
mobile-app/node_modules/sharp/install/libvips.js
mobile-app/node_modules/sharp/lib/agent.js
mobile-app/node_modules/sharp/lib/channel.js
mobile-app/node_modules/sharp/lib/colour.js
mobile-app/node_modules/sharp/lib/composite.js
mobile-app/node_modules/sharp/lib/constructor.js
mobile-app/node_modules/sharp/lib/index.d.ts
mobile-app/node_modules/sharp/lib/index.js
mobile-app/node_modules/sharp/lib/input.js
mobile-app/node_modules/sharp/lib/is.js
mobile-app/node_modules/sharp/lib/libvips.js
mobile-app/node_modules/sharp/lib/operation.js
mobile-app/node_modules/sharp/lib/output.js
mobile-app/node_modules/sharp/lib/platform.js
mobile-app/node_modules/sharp/lib/resize.js
mobile-app/node_modules/sharp/lib/sharp.js
mobile-app/node_modules/sharp/lib/utility.js
mobile-app/node_modules/sharp/package.json
mobile-app/node_modules/sharp/src/common.cc
mobile-app/node_modules/sharp/src/common.h
mobile-app/node_modules/sharp/src/metadata.cc
mobile-app/node_modules/sharp/src/metadata.h
mobile-app/node_modules/sharp/src/operations.cc
mobile-app/node_modules/sharp/src/operations.h
mobile-app/node_modules/sharp/src/pipeline.cc
mobile-app/node_modules/sharp/src/pipeline.h
mobile-app/node_modules/sharp/src/sharp.cc
mobile-app/node_modules/sharp/src/stats.cc
mobile-app/node_modules/sharp/src/stats.h
mobile-app/node_modules/sharp/src/utilities.cc
mobile-app/node_modules/sharp/src/utilities.h
mobile-app/node_modules/shebang-command/index.js
mobile-app/node_modules/shebang-command/license
mobile-app/node_modules/shebang-command/package.json
mobile-app/node_modules/shebang-command/readme.md
mobile-app/node_modules/shebang-regex/index.d.ts
mobile-app/node_modules/shebang-regex/index.js
mobile-app/node_modules/shebang-regex/license
mobile-app/node_modules/shebang-regex/package.json
mobile-app/node_modules/shebang-regex/readme.md
mobile-app/node_modules/signal-exit/LICENSE.txt
mobile-app/node_modules/signal-exit/README.md
mobile-app/node_modules/signal-exit/index.js
mobile-app/node_modules/signal-exit/package.json
mobile-app/node_modules/signal-exit/signals.js
mobile-app/node_modules/simple-concat/.travis.yml
mobile-app/node_modules/simple-concat/LICENSE
mobile-app/node_modules/simple-concat/README.md
mobile-app/node_modules/simple-concat/index.js
mobile-app/node_modules/simple-concat/package.json
mobile-app/node_modules/simple-concat/test/basic.js
mobile-app/node_modules/simple-get/.github/dependabot.yml
mobile-app/node_modules/simple-get/LICENSE
mobile-app/node_modules/simple-get/README.md
mobile-app/node_modules/simple-get/index.js
mobile-app/node_modules/simple-get/package.json
mobile-app/node_modules/simple-plist/LICENSE
mobile-app/node_modules/simple-plist/README.md
mobile-app/node_modules/simple-plist/dist/index.d.ts
mobile-app/node_modules/simple-plist/dist/index.js
mobile-app/node_modules/simple-plist/dist/parse.d.ts
mobile-app/node_modules/simple-plist/dist/parse.js
mobile-app/node_modules/simple-plist/dist/readFile.d.ts
mobile-app/node_modules/simple-plist/dist/readFile.js
mobile-app/node_modules/simple-plist/dist/readFileSync.d.ts
mobile-app/node_modules/simple-plist/dist/readFileSync.js
mobile-app/node_modules/simple-plist/dist/stringify.d.ts
mobile-app/node_modules/simple-plist/dist/stringify.js
mobile-app/node_modules/simple-plist/dist/types.d.ts
mobile-app/node_modules/simple-plist/dist/types.js
mobile-app/node_modules/simple-plist/dist/writeBinaryFile.d.ts
mobile-app/node_modules/simple-plist/dist/writeBinaryFile.js
mobile-app/node_modules/simple-plist/dist/writeBinaryFileSync.d.ts
mobile-app/node_modules/simple-plist/dist/writeBinaryFileSync.js
mobile-app/node_modules/simple-plist/dist/writeFile.d.ts
mobile-app/node_modules/simple-plist/dist/writeFile.js
mobile-app/node_modules/simple-plist/dist/writeFileSync.d.ts
mobile-app/node_modules/simple-plist/dist/writeFileSync.js
mobile-app/node_modules/simple-plist/package.json
mobile-app/node_modules/simple-swizzle/LICENSE
mobile-app/node_modules/simple-swizzle/README.md
mobile-app/node_modules/simple-swizzle/index.js
mobile-app/node_modules/simple-swizzle/package.json
mobile-app/node_modules/sisteransi/license
mobile-app/node_modules/sisteransi/package.json
mobile-app/node_modules/sisteransi/readme.md
mobile-app/node_modules/sisteransi/src/index.js
mobile-app/node_modules/sisteransi/src/sisteransi.d.ts
mobile-app/node_modules/slice-ansi/index.js
mobile-app/node_modules/slice-ansi/license
mobile-app/node_modules/slice-ansi/package.json
mobile-app/node_modules/slice-ansi/readme.md
mobile-app/node_modules/split2/LICENSE
mobile-app/node_modules/split2/README.md
mobile-app/node_modules/split2/bench.js
mobile-app/node_modules/split2/index.js
mobile-app/node_modules/split2/package.json
mobile-app/node_modules/split2/test.js
mobile-app/node_modules/stream-buffers/.mailmap
mobile-app/node_modules/stream-buffers/.travis.yml
mobile-app/node_modules/stream-buffers/README.md
mobile-app/node_modules/stream-buffers/UNLICENSE
mobile-app/node_modules/stream-buffers/coverage/coverage.json
mobile-app/node_modules/stream-buffers/coverage/lcov.info
mobile-app/node_modules/stream-buffers/lib/constants.js
mobile-app/node_modules/stream-buffers/lib/readable_streambuffer.js
mobile-app/node_modules/stream-buffers/lib/streambuffer.js
mobile-app/node_modules/stream-buffers/lib/writable_streambuffer.js
mobile-app/node_modules/stream-buffers/package.json
mobile-app/node_modules/streamx/LICENSE
mobile-app/node_modules/streamx/README.md
mobile-app/node_modules/streamx/index.d.ts
mobile-app/node_modules/streamx/index.js
mobile-app/node_modules/streamx/lib/errors.d.ts
mobile-app/node_modules/streamx/lib/errors.js
mobile-app/node_modules/streamx/package.json
mobile-app/node_modules/streamx/runtime.d.ts
mobile-app/node_modules/string-width/index.d.ts
mobile-app/node_modules/string-width/index.js
mobile-app/node_modules/string-width/license
mobile-app/node_modules/string-width/package.json
mobile-app/node_modules/string-width/readme.md
mobile-app/node_modules/string_decoder/LICENSE
mobile-app/node_modules/string_decoder/README.md
mobile-app/node_modules/string_decoder/lib/string_decoder.js
mobile-app/node_modules/string_decoder/package.json
mobile-app/node_modules/strip-ansi/index.d.ts
mobile-app/node_modules/strip-ansi/index.js
mobile-app/node_modules/strip-ansi/license
mobile-app/node_modules/strip-ansi/package.json
mobile-app/node_modules/strip-ansi/readme.md
mobile-app/node_modules/strip-json-comments/index.js
mobile-app/node_modules/strip-json-comments/license
mobile-app/node_modules/strip-json-comments/package.json
mobile-app/node_modules/strip-json-comments/readme.md
mobile-app/node_modules/tar-fs/LICENSE
mobile-app/node_modules/tar-fs/README.md
mobile-app/node_modules/tar-fs/index.js
mobile-app/node_modules/tar-fs/package.json
mobile-app/node_modules/tar-stream/LICENSE
mobile-app/node_modules/tar-stream/README.md
mobile-app/node_modules/tar-stream/constants.js
mobile-app/node_modules/tar-stream/extract.js
mobile-app/node_modules/tar-stream/headers.js
mobile-app/node_modules/tar-stream/index.d.ts
mobile-app/node_modules/tar-stream/index.js
mobile-app/node_modules/tar-stream/pack.js
mobile-app/node_modules/tar-stream/package.json
mobile-app/node_modules/tar/LICENSE.md
mobile-app/node_modules/tar/README.md
mobile-app/node_modules/tar/package.json
mobile-app/node_modules/teex/LICENSE
mobile-app/node_modules/teex/README.md
mobile-app/node_modules/teex/example.js
mobile-app/node_modules/teex/index.js
mobile-app/node_modules/teex/package.json
mobile-app/node_modules/teex/test.js
mobile-app/node_modules/text-decoder/LICENSE
mobile-app/node_modules/text-decoder/README.md
mobile-app/node_modules/text-decoder/index.js
mobile-app/node_modules/text-decoder/lib/pass-through-decoder.js
mobile-app/node_modules/text-decoder/lib/utf8-decoder.js
mobile-app/node_modules/text-decoder/package.json
mobile-app/node_modules/through2/LICENSE.md
mobile-app/node_modules/through2/README.md
mobile-app/node_modules/through2/package.json
mobile-app/node_modules/through2/through2.js
mobile-app/node_modules/tr46/.npmignore
mobile-app/node_modules/tr46/index.js
mobile-app/node_modules/tr46/lib/.gitkeep
mobile-app/node_modules/tr46/lib/mappingTable.json
mobile-app/node_modules/tr46/package.json
mobile-app/node_modules/tree-kill/LICENSE
mobile-app/node_modules/tree-kill/README.md
mobile-app/node_modules/tree-kill/cli.js
mobile-app/node_modules/tree-kill/index.d.ts
mobile-app/node_modules/tree-kill/index.js
mobile-app/node_modules/tree-kill/package.json
mobile-app/node_modules/tslib/CopyrightNotice.txt
mobile-app/node_modules/tslib/LICENSE.txt
mobile-app/node_modules/tslib/README.md
mobile-app/node_modules/tslib/SECURITY.md
mobile-app/node_modules/tslib/modules/index.d.ts
mobile-app/node_modules/tslib/modules/index.js
mobile-app/node_modules/tslib/modules/package.json
mobile-app/node_modules/tslib/package.json
mobile-app/node_modules/tslib/tslib.d.ts
mobile-app/node_modules/tslib/tslib.es6.html
mobile-app/node_modules/tslib/tslib.es6.js
mobile-app/node_modules/tslib/tslib.es6.mjs
mobile-app/node_modules/tslib/tslib.html
mobile-app/node_modules/tslib/tslib.js
mobile-app/node_modules/tunnel-agent/LICENSE
mobile-app/node_modules/tunnel-agent/README.md
mobile-app/node_modules/tunnel-agent/index.js
mobile-app/node_modules/tunnel-agent/package.json
mobile-app/node_modules/typescript/LICENSE
mobile-app/node_modules/typescript/NOTICE.txt
mobile-app/node_modules/typescript/README.md
mobile-app/node_modules/typescript/bin/tsc
mobile-app/node_modules/typescript/lib/getExePath.d.ts
mobile-app/node_modules/typescript/lib/getExePath.js
mobile-app/node_modules/typescript/lib/tsc.js
mobile-app/node_modules/typescript/lib/version.cjs
mobile-app/node_modules/typescript/lib/version.d.cts
mobile-app/node_modules/typescript/package.json
mobile-app/node_modules/undici-types/LICENSE
mobile-app/node_modules/undici-types/README.md
mobile-app/node_modules/undici-types/agent.d.ts
mobile-app/node_modules/undici-types/api.d.ts
mobile-app/node_modules/undici-types/balanced-pool.d.ts
mobile-app/node_modules/undici-types/cache-interceptor.d.ts
mobile-app/node_modules/undici-types/cache.d.ts
mobile-app/node_modules/undici-types/client-stats.d.ts
mobile-app/node_modules/undici-types/client.d.ts
mobile-app/node_modules/undici-types/connector.d.ts
mobile-app/node_modules/undici-types/content-type.d.ts
mobile-app/node_modules/undici-types/cookies.d.ts
mobile-app/node_modules/undici-types/diagnostics-channel.d.ts
mobile-app/node_modules/undici-types/dispatcher.d.ts
mobile-app/node_modules/undici-types/dispatcher1-wrapper.d.ts
mobile-app/node_modules/undici-types/env-http-proxy-agent.d.ts
mobile-app/node_modules/undici-types/errors.d.ts
mobile-app/node_modules/undici-types/eventsource.d.ts
mobile-app/node_modules/undici-types/fetch.d.ts
mobile-app/node_modules/undici-types/formdata.d.ts
mobile-app/node_modules/undici-types/global-dispatcher.d.ts
mobile-app/node_modules/undici-types/global-origin.d.ts
mobile-app/node_modules/undici-types/h2c-client.d.ts
mobile-app/node_modules/undici-types/handlers.d.ts
mobile-app/node_modules/undici-types/header.d.ts
mobile-app/node_modules/undici-types/index.d.ts
mobile-app/node_modules/undici-types/interceptors.d.ts
mobile-app/node_modules/undici-types/mock-agent.d.ts
mobile-app/node_modules/undici-types/mock-call-history.d.ts
mobile-app/node_modules/undici-types/mock-client.d.ts
mobile-app/node_modules/undici-types/mock-errors.d.ts
mobile-app/node_modules/undici-types/mock-interceptor.d.ts
mobile-app/node_modules/undici-types/mock-pool.d.ts
mobile-app/node_modules/undici-types/package.json
mobile-app/node_modules/undici-types/patch.d.ts
mobile-app/node_modules/undici-types/pool-stats.d.ts
mobile-app/node_modules/undici-types/pool.d.ts
mobile-app/node_modules/undici-types/proxy-agent.d.ts
mobile-app/node_modules/undici-types/readable.d.ts
mobile-app/node_modules/undici-types/retry-agent.d.ts
mobile-app/node_modules/undici-types/retry-handler.d.ts
mobile-app/node_modules/undici-types/round-robin-pool.d.ts
mobile-app/node_modules/undici-types/snapshot-agent.d.ts
mobile-app/node_modules/undici-types/socks5-proxy-agent.d.ts
mobile-app/node_modules/undici-types/util.d.ts
mobile-app/node_modules/undici-types/utility.d.ts
mobile-app/node_modules/undici-types/webidl.d.ts
mobile-app/node_modules/undici-types/websocket.d.ts
mobile-app/node_modules/universalify/LICENSE
mobile-app/node_modules/universalify/README.md
mobile-app/node_modules/universalify/index.js
mobile-app/node_modules/universalify/package.json
mobile-app/node_modules/untildify/index.d.ts
mobile-app/node_modules/untildify/index.js
mobile-app/node_modules/untildify/license
mobile-app/node_modules/untildify/package.json
mobile-app/node_modules/untildify/readme.md
mobile-app/node_modules/util-deprecate/History.md
mobile-app/node_modules/util-deprecate/LICENSE
mobile-app/node_modules/util-deprecate/README.md
mobile-app/node_modules/util-deprecate/browser.js
mobile-app/node_modules/util-deprecate/node.js
mobile-app/node_modules/util-deprecate/package.json
mobile-app/node_modules/uuid/CHANGELOG.md
mobile-app/node_modules/uuid/CONTRIBUTING.md
mobile-app/node_modules/uuid/LICENSE.md
mobile-app/node_modules/uuid/README.md
mobile-app/node_modules/uuid/deprecate.js
mobile-app/node_modules/uuid/dist/bytesToUuid.js
mobile-app/node_modules/uuid/dist/index.js
mobile-app/node_modules/uuid/dist/md5-browser.js
mobile-app/node_modules/uuid/dist/md5.js
mobile-app/node_modules/uuid/dist/rng-browser.js
mobile-app/node_modules/uuid/dist/rng.js
mobile-app/node_modules/uuid/dist/sha1-browser.js
mobile-app/node_modules/uuid/dist/sha1.js
mobile-app/node_modules/uuid/dist/uuid-bin.js
mobile-app/node_modules/uuid/dist/v1.js
mobile-app/node_modules/uuid/dist/v3.js
mobile-app/node_modules/uuid/dist/v35.js
mobile-app/node_modules/uuid/dist/v4.js
mobile-app/node_modules/uuid/dist/v5.js
mobile-app/node_modules/uuid/package.json
mobile-app/node_modules/uuid/v1.js
mobile-app/node_modules/uuid/v3.js
mobile-app/node_modules/uuid/v4.js
mobile-app/node_modules/uuid/v5.js
mobile-app/node_modules/webidl-conversions/LICENSE.md
mobile-app/node_modules/webidl-conversions/README.md
mobile-app/node_modules/webidl-conversions/lib/index.js
mobile-app/node_modules/webidl-conversions/package.json
mobile-app/node_modules/whatwg-url/LICENSE.txt
mobile-app/node_modules/whatwg-url/README.md
mobile-app/node_modules/whatwg-url/lib/URL-impl.js
mobile-app/node_modules/whatwg-url/lib/URL.js
mobile-app/node_modules/whatwg-url/lib/public-api.js
mobile-app/node_modules/whatwg-url/lib/url-state-machine.js
mobile-app/node_modules/whatwg-url/lib/utils.js
mobile-app/node_modules/whatwg-url/package.json
mobile-app/node_modules/which/CHANGELOG.md
mobile-app/node_modules/which/LICENSE
mobile-app/node_modules/which/README.md
mobile-app/node_modules/which/bin/node-which
mobile-app/node_modules/which/package.json
mobile-app/node_modules/which/which.js
mobile-app/node_modules/wrap-ansi/index.js
mobile-app/node_modules/wrap-ansi/license
mobile-app/node_modules/wrap-ansi/package.json
mobile-app/node_modules/wrap-ansi/readme.md
mobile-app/node_modules/wrappy/LICENSE
mobile-app/node_modules/wrappy/README.md
mobile-app/node_modules/wrappy/package.json
mobile-app/node_modules/wrappy/wrappy.js
mobile-app/node_modules/xcode/AUTHORS
mobile-app/node_modules/xcode/CONTRIBUTING.md
mobile-app/node_modules/xcode/LICENSE
mobile-app/node_modules/xcode/Makefile
mobile-app/node_modules/xcode/NOTICE
mobile-app/node_modules/xcode/README.md
mobile-app/node_modules/xcode/RELEASENOTES.md
mobile-app/node_modules/xcode/index.js
mobile-app/node_modules/xcode/lib/parseJob.js
mobile-app/node_modules/xcode/lib/pbxFile.js
mobile-app/node_modules/xcode/lib/pbxProject.js
mobile-app/node_modules/xcode/lib/pbxWriter.js
mobile-app/node_modules/xcode/package.json
mobile-app/node_modules/xml-js/LICENSE
mobile-app/node_modules/xml-js/README.md
mobile-app/node_modules/xml-js/bin/cli-helper.js
mobile-app/node_modules/xml-js/bin/cli.js
mobile-app/node_modules/xml-js/bin/test.json
mobile-app/node_modules/xml-js/bin/test.xml
mobile-app/node_modules/xml-js/dist/xml-js.js
mobile-app/node_modules/xml-js/dist/xml-js.min.js
mobile-app/node_modules/xml-js/index.js
mobile-app/node_modules/xml-js/lib/array-helper.js
mobile-app/node_modules/xml-js/lib/index.js
mobile-app/node_modules/xml-js/lib/js2xml.js
mobile-app/node_modules/xml-js/lib/json2xml.js
mobile-app/node_modules/xml-js/lib/options-helper.js
mobile-app/node_modules/xml-js/lib/xml2js.js
mobile-app/node_modules/xml-js/lib/xml2json.js
mobile-app/node_modules/xml-js/package.json
mobile-app/node_modules/xml-js/types/index.d.ts
mobile-app/node_modules/xml-js/types/tsconfig.json
mobile-app/node_modules/xml-js/types/typings.json
mobile-app/node_modules/xml-js/types/xml-js-tests.ts
mobile-app/node_modules/xml-js/webpack.config.js
mobile-app/node_modules/xml2js/LICENSE
mobile-app/node_modules/xml2js/README.md
mobile-app/node_modules/xml2js/lib/bom.js
mobile-app/node_modules/xml2js/lib/builder.js
mobile-app/node_modules/xml2js/lib/defaults.js
mobile-app/node_modules/xml2js/lib/parser.js
mobile-app/node_modules/xml2js/lib/processors.js
mobile-app/node_modules/xml2js/lib/xml2js.bc.js
mobile-app/node_modules/xml2js/lib/xml2js.js
mobile-app/node_modules/xml2js/package.json
mobile-app/node_modules/xmlbuilder/.nycrc
mobile-app/node_modules/xmlbuilder/.vscode/launch.json
mobile-app/node_modules/xmlbuilder/CHANGELOG.md
mobile-app/node_modules/xmlbuilder/LICENSE
mobile-app/node_modules/xmlbuilder/README.md
mobile-app/node_modules/xmlbuilder/lib/Derivation.js
mobile-app/node_modules/xmlbuilder/lib/DocumentPosition.js
mobile-app/node_modules/xmlbuilder/lib/NodeType.js
mobile-app/node_modules/xmlbuilder/lib/OperationType.js
mobile-app/node_modules/xmlbuilder/lib/Utility.js
mobile-app/node_modules/xmlbuilder/lib/WriterState.js
mobile-app/node_modules/xmlbuilder/lib/XMLAttribute.js
mobile-app/node_modules/xmlbuilder/lib/XMLCData.js
mobile-app/node_modules/xmlbuilder/lib/XMLCharacterData.js
mobile-app/node_modules/xmlbuilder/lib/XMLComment.js
mobile-app/node_modules/xmlbuilder/lib/XMLDOMConfiguration.js
mobile-app/node_modules/xmlbuilder/lib/XMLDOMErrorHandler.js
mobile-app/node_modules/xmlbuilder/lib/XMLDOMImplementation.js
mobile-app/node_modules/xmlbuilder/lib/XMLDOMStringList.js
mobile-app/node_modules/xmlbuilder/lib/XMLDTDAttList.js
mobile-app/node_modules/xmlbuilder/lib/XMLDTDElement.js
mobile-app/node_modules/xmlbuilder/lib/XMLDTDEntity.js
mobile-app/node_modules/xmlbuilder/lib/XMLDTDNotation.js
mobile-app/node_modules/xmlbuilder/lib/XMLDeclaration.js
mobile-app/node_modules/xmlbuilder/lib/XMLDocType.js
mobile-app/node_modules/xmlbuilder/lib/XMLDocument.js
mobile-app/node_modules/xmlbuilder/lib/XMLDocumentCB.js
mobile-app/node_modules/xmlbuilder/lib/XMLDocumentFragment.js
mobile-app/node_modules/xmlbuilder/lib/XMLDummy.js
mobile-app/node_modules/xmlbuilder/lib/XMLElement.js
mobile-app/node_modules/xmlbuilder/lib/XMLNamedNodeMap.js
mobile-app/node_modules/xmlbuilder/lib/XMLNode.js
mobile-app/node_modules/xmlbuilder/lib/XMLNodeFilter.js
mobile-app/node_modules/xmlbuilder/lib/XMLNodeList.js
mobile-app/node_modules/xmlbuilder/lib/XMLProcessingInstruction.js
mobile-app/node_modules/xmlbuilder/lib/XMLRaw.js
mobile-app/node_modules/xmlbuilder/lib/XMLStreamWriter.js
mobile-app/node_modules/xmlbuilder/lib/XMLStringWriter.js
mobile-app/node_modules/xmlbuilder/lib/XMLStringifier.js
mobile-app/node_modules/xmlbuilder/lib/XMLText.js
mobile-app/node_modules/xmlbuilder/lib/XMLTypeInfo.js
mobile-app/node_modules/xmlbuilder/lib/XMLUserDataHandler.js
mobile-app/node_modules/xmlbuilder/lib/XMLWriterBase.js
mobile-app/node_modules/xmlbuilder/lib/index.js
mobile-app/node_modules/xmlbuilder/package.json
mobile-app/node_modules/xmlbuilder/perf/index.coffee
mobile-app/node_modules/xmlbuilder/perf/perf.list
mobile-app/node_modules/xmlbuilder/typings/index.d.ts
mobile-app/node_modules/xpath/LICENSE
mobile-app/node_modules/xpath/README.md
mobile-app/node_modules/xpath/docs/XPathEvaluator.md
mobile-app/node_modules/xpath/docs/XPathResult.md
mobile-app/node_modules/xpath/docs/function resolvers.md
mobile-app/node_modules/xpath/docs/namespace resolvers.md
mobile-app/node_modules/xpath/docs/parsed expressions.md
mobile-app/node_modules/xpath/docs/variable resolvers.md
mobile-app/node_modules/xpath/docs/xpath methods.md
mobile-app/node_modules/xpath/package.json
mobile-app/node_modules/xpath/test.js
mobile-app/node_modules/xpath/xpath.d.ts
mobile-app/node_modules/xpath/xpath.js
mobile-app/node_modules/y18n/CHANGELOG.md
mobile-app/node_modules/y18n/LICENSE
mobile-app/node_modules/y18n/README.md
mobile-app/node_modules/y18n/index.mjs
mobile-app/node_modules/y18n/package.json
mobile-app/node_modules/yallist/LICENSE.md
mobile-app/node_modules/yallist/README.md
mobile-app/node_modules/yallist/package.json
mobile-app/node_modules/yargs-parser/CHANGELOG.md
mobile-app/node_modules/yargs-parser/LICENSE.txt
mobile-app/node_modules/yargs-parser/README.md
mobile-app/node_modules/yargs-parser/browser.js
mobile-app/node_modules/yargs-parser/package.json
mobile-app/node_modules/yargs/LICENSE
mobile-app/node_modules/yargs/README.md
mobile-app/node_modules/yargs/browser.d.ts
mobile-app/node_modules/yargs/browser.mjs
mobile-app/node_modules/yargs/helpers/helpers.mjs
mobile-app/node_modules/yargs/helpers/index.js
mobile-app/node_modules/yargs/helpers/package.json
mobile-app/node_modules/yargs/index.cjs
mobile-app/node_modules/yargs/index.mjs
mobile-app/node_modules/yargs/locales/be.json
mobile-app/node_modules/yargs/locales/cs.json
mobile-app/node_modules/yargs/locales/de.json
mobile-app/node_modules/yargs/locales/en.json
mobile-app/node_modules/yargs/locales/es.json
mobile-app/node_modules/yargs/locales/fi.json
mobile-app/node_modules/yargs/locales/fr.json
mobile-app/node_modules/yargs/locales/hi.json
mobile-app/node_modules/yargs/locales/hu.json
mobile-app/node_modules/yargs/locales/id.json
mobile-app/node_modules/yargs/locales/it.json
mobile-app/node_modules/yargs/locales/ja.json
mobile-app/node_modules/yargs/locales/ko.json
mobile-app/node_modules/yargs/locales/nb.json
mobile-app/node_modules/yargs/locales/nl.json
mobile-app/node_modules/yargs/locales/nn.json
mobile-app/node_modules/yargs/locales/pirate.json
mobile-app/node_modules/yargs/locales/pl.json
mobile-app/node_modules/yargs/locales/pt.json
mobile-app/node_modules/yargs/locales/pt_BR.json
mobile-app/node_modules/yargs/locales/ru.json
mobile-app/node_modules/yargs/locales/th.json
mobile-app/node_modules/yargs/locales/tr.json
mobile-app/node_modules/yargs/locales/uk_UA.json
mobile-app/node_modules/yargs/locales/uz.json
mobile-app/node_modules/yargs/locales/zh_CN.json
mobile-app/node_modules/yargs/locales/zh_TW.json
mobile-app/node_modules/yargs/package.json
mobile-app/node_modules/yargs/yargs
mobile-app/node_modules/yargs/yargs.mjs
mobile-app/node_modules/yauzl/LICENSE
mobile-app/node_modules/yauzl/README.md
mobile-app/node_modules/yauzl/index.js
mobile-app/node_modules/yauzl/package.json
mobile-app/package-lock.json
mobile-app/package.json
mobile-app/pubspec.yaml
mobile-app/pubspec.yaml.backup-20260913-112825
mobile-app/resources/icon.png
mobile-app/sync-web.sh
mobile-app/test/widget_test.dart
mobile-app/www/assets/branding/internal-logo.png
mobile-app/www/assets/branding/jawan-mark.svg
mobile-app/www/assets/branding/jawan-wordmark.svg
mobile-app/www/assets/branding/logo-external.png
mobile-app/www/assets/fonts/JwanFont.ttf
mobile-app/www/assets/icons/icon-192.svg
mobile-app/www/assets/icons/icon-512.svg
mobile-app/www/assets/images/README.txt
mobile-app/www/assets/logo/jwan-logo-original.png
mobile-app/www/assets/logo/jwan-logo.png
mobile-app/www/css/home.css
mobile-app/www/css/home.css.backup-20260911-194700
mobile-app/www/css/home.css.backup-20260911-200403
mobile-app/www/css/home.css.before-drawer-clean-20260911-195753
mobile-app/www/css/jawan-ai.css
mobile-app/www/css/style.css
mobile-app/www/css/style.css.backup-20260912-004846
mobile-app/www/css/style.css.bak-20260912-v4
mobile-app/www/index.html
mobile-app/www/js/admin.js
mobile-app/www/js/admin.js.backup-20260911-202130
mobile-app/www/js/admin.js.backup-before-free-delete-20260911-205214
mobile-app/www/js/admin.js.backup-free-admin-20260911-205325
mobile-app/www/js/admin.js.backup-free-admin-20260911-234745
mobile-app/www/js/app.js
mobile-app/www/js/app.js.backup-alert-20260912-101950
mobile-app/www/js/app.js.backup-fcm-20260912-095833
mobile-app/www/js/app.js.backup-login-push-20260912-105033
mobile-app/www/js/auth.js
mobile-app/www/js/auth.js.backup2
mobile-app/www/js/common.js
mobile-app/www/js/data-retention.backup-20260912-120836.js
mobile-app/www/js/data-retention.js
mobile-app/www/js/driver-menu.js
mobile-app/www/js/firebase-config.backup-gemini
mobile-app/www/js/firebase-config.js
mobile-app/www/js/jawan-ai.backup-ai-fix-20260912-085205.js
mobile-app/www/js/jawan-ai.backup-final-ai-20260912-085629.js
mobile-app/www/js/jawan-ai.backup-links-20260912-084247.js
mobile-app/www/js/jawan-ai.js
mobile-app/www/js/negotiation.js
mobile-app/www/js/negotiation.js.backup-20260912-004846
mobile-app/www/js/notifications.js
mobile-app/www/js/notifications.js.backup-alert-20260912-101950
mobile-app/www/js/notifications.js.backup-debug-20260912-104042
mobile-app/www/js/notifications.js.backup-fcm-20260912-095833
mobile-app/www/js/notifications.js.backup-permission-fix-20260912-104631
mobile-app/www/js/orders.js
mobile-app/www/js/orders.js.backup-20260912-004846
mobile-app/www/js/ratings.js
mobile-app/www/js/route-pricing.js
mobile-app/www/js/storage-config.js
mobile-app/www/js/storage-manager.js
mobile-app/www/js/support.js
mobile-app/www/js/wallet.js
mobile-app/www/js/whatsapp.js
mobile-app/www/js/whatsapp.js.backup-v3-20260912-004146
mobile-app/www/manifest.webmanifest
mobile-app/www/pages/404.html
mobile-app/www/pages/admin-analytics.html
mobile-app/www/pages/admin-managers.html
mobile-app/www/pages/admin-orders.html
mobile-app/www/pages/admin-topups.html
mobile-app/www/pages/admin-users.html
mobile-app/www/pages/admin-users.html.backup-20260911-202130
mobile-app/www/pages/admin-users.html.backup-free-admin-20260911-205325
mobile-app/www/pages/admin-users.html.backup-free-admin-20260911-234745
mobile-app/www/pages/admin-withdrawals.html
mobile-app/www/pages/admin.html
mobile-app/www/pages/change-password.html
mobile-app/www/pages/create-order.html
mobile-app/www/pages/create-order.html.backup-20260912-004846
mobile-app/www/pages/customer.html
mobile-app/www/pages/customer.html.bak2
mobile-app/www/pages/driver-analytics.html
mobile-app/www/pages/driver-orders.html
mobile-app/www/pages/driver-profile.html
mobile-app/www/pages/driver.html
mobile-app/www/pages/driver.html.backup-20260911-235340
mobile-app/www/pages/driver.html.backup-20260912-004846
mobile-app/www/pages/driver.html.bak-20260912-v4
mobile-app/www/pages/driver.html.bak2
mobile-app/www/pages/login.html
mobile-app/www/pages/negotiation.html
mobile-app/www/pages/privacy.html
mobile-app/www/pages/register.html
mobile-app/www/pages/register.html.backup-20260911-235643
mobile-app/www/pages/support.html
mobile-app/www/pages/terms.html
mobile-app/www/pages/wallet.html
mobile-app/www/pages/wallet.html.backup-20260912-004846
mobile-app/www/pages/wallet.html.bak-20260912-v4
mobile-app/www/sw.js
```

## 7. Flutter pubspec
```yaml
name: jawan_flutter
description: Jawan Delivery native Flutter Android application
publish_to: "none"
version: 1.0.0+1

environment:
  sdk: ">=3.6.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^4.14.0
  firebase_auth: ^6.6.1
  cloud_firestore: ^6.9.0
  firebase_messaging: ^16.6.0
  firebase_app_check: ^0.4.7
  url_launcher: ^6.3.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
```

## 8. Flutter source files

### mobile-app/lib/main.dart
```dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'firebase_options.dart';

const kBlack = Color(0xFF0B0B0B);
const kYellow = Color(0xFFFFC400);
const kBg = Color(0xFFF7F7F7);

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider: const bool.fromEnvironment('JAWAN_APPCHECK_DEBUG', defaultValue: false)
          ? AndroidProvider.debug
          : AndroidProvider.playIntegrity,
    );
  } catch (_) {}
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const JawanApp());
}

String cleanError(Object error) {
  if (error is FirebaseException) return error.message ?? error.code;
  return error.toString().replaceFirst('Exception: ', '');
}

String vehicleLabel(String value) {
  const values = {
    'car': 'سيارة', 'rickshaw': 'ركشة', 'motorcycle': 'موتر', 'tuk_tuk': 'تكتك',
    'truck': 'دفار', 'bus': 'حافلة', 'amjad': 'أمجاد', 'kreez': 'كريز',
    'taxi': 'تاكسي', 'tanker': 'تنكر', 'crane': 'كرين', 'tow_truck': 'رافعة',
    'lorry': 'لوري', 'limousine': 'ليموزين',
  };
  return values[value] ?? value;
}

String statusLabel(dynamic value) {
  const values = {
    'pending': 'بانتظار سائق', 'accepted': 'تفاوض على السعر', 'picked_up': 'تم الاستلام',
    'delivering': 'قيد التوصيل', 'awaiting_confirmation': 'بانتظار تأكيد العميل',
    'not_delivered': 'لم يتم التسليم', 'completed': 'مكتمل', 'cancelled': 'ملغي', 'rejected': 'مرفوض',
  };
  return values[value] ?? 'غير معروف';
}

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String phoneAlias(String phone) => '${phone.trim()}@jawan.app';

  Future<Map<String, dynamic>?> profile(String uid) async {
    final snapshot = await db.collection('users').doc(uid).get();
    return snapshot.data();
  }

  Future<void> login(String phone, String password) async {
    if (!RegExp(r'^\d{10}$').hasMatch(phone.trim())) {
      throw Exception('رقم الهاتف يجب أن يكون 10 أرقام فقط');
    }
    if (password.length < 6) throw Exception('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
    final credential = await auth.signInWithEmailAndPassword(
      email: phoneAlias(phone),
      password: password,
    );
    await db.collection('users').doc(credential.user!.uid).set(
      {'lastActiveAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  Future<void> register({
    required String name,
    required String phone,
    required String password,
    required String role,
    required String state,
    required String address,
    int? age,
    String? vehicleType,
  }) async {
    if (name.trim().isEmpty) throw Exception('الاسم الكامل مطلوب');
    if (!RegExp(r'^\d{10}$').hasMatch(phone.trim())) throw Exception('رقم الهاتف يجب أن يكون 10 أرقام فقط');
    if (password.length < 6) throw Exception('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
    if (!['customer', 'driver'].contains(role)) throw Exception('نوع الحساب غير صحيح');
    if (state.trim().isEmpty) throw Exception('اختر الولاية');
    if (address.trim().isEmpty) throw Exception('مكان السكن مطلوب');
    if (role == 'driver') {
      if ((age ?? 0) < 18) throw Exception('يجب أن يكون عمر السائق 18 سنة على الأقل');
      if (vehicleType == null || vehicleType.isEmpty) throw Exception('اختر نوع المركبة');
    }

    final credential = await auth.createUserWithEmailAndPassword(
      email: phoneAlias(phone),
      password: password,
    );
    await db.collection('users').doc(credential.user!.uid).set({
      'role': role,
      'name': name.trim(),
      'phone': phone.trim(),
      'address': address.trim(),
      'state': state.trim(),
      'age': role == 'driver' ? age : null,
      'vehicleType': role == 'driver' ? vehicleType : null,
      'status': role == 'customer' ? 'active' : 'pending',
      'privacyAccepted': true,
      'termsAccepted': true,
      'createdAt': FieldValue.serverTimestamp(),
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logout() => auth.signOut();
}

class OrderService {
  final db = FirebaseFirestore.instance;
  static const passenger = ['car', 'rickshaw', 'bus', 'amjad', 'taxi', 'limousine'];
  static const cargo = ['motorcycle', 'tuk_tuk', 'truck', 'kreez', 'tanker', 'crane', 'tow_truck', 'lorry'];

  Stream<QuerySnapshot<Map<String, dynamic>>> myOrders(String uid, String role) =>
      db.collection('orders').where(role == 'driver' ? 'driverId' : 'customerId', isEqualTo: uid)
          .orderBy('createdAt', descending: true).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> availableOrders(String state) =>
      db.collection('orders').where('state', isEqualTo: state).where('status', isEqualTo: 'pending')
          .where('driverId', isNull: true).orderBy('createdAt', descending: true).snapshots();

  Future<String> createOrder({
    required String uid,
    required String state,
    required String vehicleType,
    required String origin,
    required String destination,
    required String description,
    int? passengerCount,
    bool hasLuggage = false,
    String luggageDescription = '',
    String cargoType = '',
    String cargoDescription = '',
  }) async {
    final originText = origin.trim();
    final destinationText = destination.trim();
    if (originText.isEmpty || destinationText.isEmpty) throw Exception('مكان الاستلام والوجهة مطلوبان');
    if (originText == destinationText) throw Exception('مكان الاستلام والوجهة يجب أن يكونا مختلفين');
    final isPassenger = passenger.contains(vehicleType);
    final isCargo = cargo.contains(vehicleType);
    if (!isPassenger && !isCargo) throw Exception('نوع المركبة غير صحيح');
    if (isPassenger && (passengerCount == null || passengerCount < 1 || passengerCount > 100)) {
      throw Exception('عدد الركاب يجب أن يكون بين 1 و100');
    }
    if (isCargo && cargoType.trim().isEmpty) throw Exception('نوع البضاعة مطلوب');

    final ref = await db.collection('orders').add({
      'customerId': uid, 'driverId': null, 'state': state,
      'vehicleType': vehicleType, 'serviceCategory': isPassenger ? 'passenger' : 'cargo',
      'passengerCount': isPassenger ? passengerCount : null,
      'hasLuggage': isPassenger ? hasLuggage : null,
      'luggageDescription': isPassenger && hasLuggage ? luggageDescription.trim() : null,
      'cargoType': isCargo ? cargoType.trim() : null,
      'cargoDescription': isCargo ? cargoDescription.trim() : null,
      'description': description.trim().length > 1000 ? description.trim().substring(0, 1000) : description.trim(),
      'origin': originText, 'destination': destinationText,
      'deliveryFee': null,
      'agreedFee': null,
      'status': 'pending',
      'negotiationStatus': 'none',
      'commissionCharged': false,
      'cancellationPenaltyCharged': false,
      'createdAt': FieldValue.serverTimestamp(),
      'acceptedAt': null,
      'pickedUpAt': null,
      'startedAt': null,
      'deliveredAt': null,
      'customerConfirmedAt': null,
      'notDeliveredAt': null,
      'driverConfirmedAt': null,
      'completedAt': null,
      'cancelledAt': null,
      'agreedAt': null,
      'agreedBy': null,
      'cancelReason': null,
      'driverComment': null,
    });
    return ref.id;
  }

  Future<void> acceptOrder(String orderId, String driverId) async {
    await db.runTransaction((tx) async {
      final orderRef = db.collection('orders').doc(orderId);
      final negRef = db.collection('priceNegotiations').doc(orderId);
      final orderSnap = await tx.get(orderRef);
      final driverSnap = await tx.get(db.collection('users').doc(driverId));
      final walletSnap = await tx.get(db.collection('wallets').doc(driverId));
      if (!orderSnap.exists || !driverSnap.exists) throw Exception('الطلب أو حساب السائق غير موجود');
      final order = orderSnap.data()!;
      final driver = driverSnap.data()!;
      if (order['status'] != 'pending' || order['driverId'] != null) throw Exception('تم أخذ الطلب من سائق آخر');
      if (driver['role'] != 'driver' || driver['status'] != 'active' || driver['state'] != order['state']) {
        throw Exception('لا يمكنك قبول هذا الطلب');
      }
      if (!walletSnap.exists || ((walletSnap.data()?['balance'] as num?)?.toDouble() ?? 0) <= 0) {
        throw Exception('محفظتك غير مهيأة أو رصيدها صفر');
      }
      tx.update(orderRef, {'driverId': driverId, 'status': 'accepted', 'acceptedAt': FieldValue.serverTimestamp(), 'negotiationStatus': 'open'});
      tx.set(negRef, {
        'orderId': orderId, 'customerId': order['customerId'], 'driverId': driverId,
        'customerName': null, 'driverName': driver['name'] ?? 'السائق',
        'currentOffer': null, 'offeredBy': null, 'status': 'open', 'expiresAt': null,
        'updatedAt': FieldValue.serverTimestamp(), 'lastAction': 'accepted', 'lastMessageId': null,
      });
    });
  }

  Future<void> makeOffer({
    required String orderId, required String uid, required String role,
    required String name, required int amount,
  }) async {
    if (amount <= 0 || amount > 100000000) throw Exception('المبلغ غير صحيح');
    await db.runTransaction((tx) async {
      final orderRef = db.collection('orders').doc(orderId);
      final negRef = db.collection('priceNegotiations').doc(orderId);
      final orderSnap = await tx.get(orderRef);
      final negSnap = await tx.get(negRef);
      if (!orderSnap.exists || !negSnap.exists) throw Exception('المفاوضة غير موجودة');
      final order = orderSnap.data()!;
      final neg = negSnap.data()!;
      if (order['status'] != 'accepted' || neg['status'] != 'open') throw Exception('التفاوض غير متاح الآن');
      if (role == 'customer' && order['customerId'] != uid) throw Exception('ليس لديك صلاحية');
      if (role == 'driver' && order['driverId'] != uid) throw Exception('ليس لديك صلاحية');
      if (role == 'driver' && neg['currentOffer'] != null) throw Exception('يوجد عرض حالي بالفعل');
      if (role == 'customer' && neg['offeredBy'] == uid) throw Exception('انتظر رد السائق');

      Timestamp expiry;
      final existingExpiry = neg['expiresAt'];
      if (existingExpiry is Timestamp && existingExpiry.toDate().isAfter(DateTime.now())) {
        expiry = existingExpiry;
      } else {
        expiry = Timestamp.fromDate(DateTime.now().add(const Duration(minutes: 30)));
      }
      final messageRef = negRef.collection('messages').doc();
      tx.update(negRef, {
        'currentOffer': amount, 'offeredBy': uid, 'expiresAt': expiry,
        'updatedAt': FieldValue.serverTimestamp(), 'lastAction': 'offer', 'lastMessageId': messageRef.id,
        role == 'driver' ? 'driverName' : 'customerName': name,
      });
      tx.set(messageRef, {
        'orderId': orderId, 'amount': amount, 'action': 'offer', 'senderId': uid,
        'senderRole': role, 'senderName': name, 'createdAt': FieldValue.serverTimestamp(), 'expiresAt': expiry,
      });
    });
  }

  Future<void> respondToOffer({
    required String orderId, required String uid, required String role,
    required String name, required bool accept,
  }) async {
    await db.runTransaction((tx) async {
      final orderRef = db.collection('orders').doc(orderId);
      final negRef = db.collection('priceNegotiations').doc(orderId);
      final orderSnap = await tx.get(orderRef);
      final negSnap = await tx.get(negRef);
      if (!orderSnap.exists || !negSnap.exists) throw Exception('المفاوضة غير موجودة');
      final order = orderSnap.data()!;
      final neg = negSnap.data()!;
      if (order['status'] != 'accepted' || neg['status'] != 'open') throw Exception('التفاوض غير متاح');
      if (role == 'customer' && order['customerId'] != uid) throw Exception('ليس لديك صلاحية');
      if (role == 'driver' && order['driverId'] != uid) throw Exception('ليس لديك صلاحية');
      if (neg['offeredBy'] == uid) throw Exception('لا يمكنك قبول عرضك أنت');
      final offer = (neg['currentOffer'] as num?)?.toInt();
      if (offer == null || offer <= 0) throw Exception('العرض الحالي غير صالح');
      final messageRef = negRef.collection('messages').doc();

      if (!accept) {
        tx.set(messageRef, {
          'orderId': orderId, 'amount': offer, 'action': 'reject', 'senderId': uid,
          'senderRole': role, 'senderName': name, 'createdAt': FieldValue.serverTimestamp(),
          'expiresAt': neg['expiresAt'] ?? null,
        });
        tx.update(orderRef, {'driverId': null, 'status': 'pending', 'negotiationStatus': 'none'});
        tx.update(negRef, {'currentOffer': null, 'offeredBy': null, 'status': 'closed', 'updatedAt': FieldValue.serverTimestamp(), 'lastAction': 'reject', 'lastMessageId': messageRef.id});
        return;
      }

      final customerSnap = await tx.get(db.collection('users').doc(order['customerId'] as String));
      final driverSnap = await tx.get(db.collection('users').doc(order['driverId'] as String));
      if (!customerSnap.exists || !driverSnap.exists) throw Exception('بيانات أحد الطرفين غير موجودة');
      final customer = customerSnap.data()!;
      final driver = driverSnap.data()!;
      if (role == 'driver') {
        final walletSnap = await tx.get(db.collection('wallets').doc(order['driverId'] as String));
        final balance = (walletSnap.data()?['balance'] as num?)?.toInt() ?? 0;
        final commission = (offer * 0.05).round();
        if (!walletSnap.exists || balance < commission) throw Exception('رصيد المحفظة لا يكفي للعمولة');
      }
      tx.set(messageRef, {
        'orderId': orderId, 'amount': offer, 'action': 'accept', 'senderId': uid,
        'senderRole': role, 'senderName': name, 'createdAt': FieldValue.serverTimestamp(), 'expiresAt': neg['expiresAt'] ?? null,
      });
      tx.update(orderRef, {'deliveryFee': offer, 'agreedFee': offer, 'negotiationStatus': 'agreed', 'agreedAt': FieldValue.serverTimestamp(), 'agreedBy': uid});
      tx.update(negRef, {'status': 'agreed', 'currentOffer': offer, 'updatedAt': FieldValue.serverTimestamp(), 'agreedAt': FieldValue.serverTimestamp(), 'agreedBy': uid, 'lastAction': 'accept', 'lastMessageId': messageRef.id});
      tx.set(db.collection('orderContacts').doc(orderId), {
        'orderId': orderId, 'customerId': order['customerId'], 'driverId': order['driverId'],
        'customerPhone': '${customer['phone'] ?? ''}', 'driverPhone': '${driver['phone'] ?? ''}', 'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> updateStatus(String orderId, String status) async {
    final patch = <String, dynamic>{'status': status};
    final now = FieldValue.serverTimestamp();
    if (status == 'picked_up') patch['pickedUpAt'] = now;
    if (status == 'delivering') patch['startedAt'] = now;
    if (status == 'awaiting_confirmation') patch['deliveredAt'] = now;
    await db.collection('orders').doc(orderId).update(patch);
  }

  Future<void> customerConfirm(String orderId) async {
    await db.collection('orders').doc(orderId).update({'customerConfirmedAt': FieldValue.serverTimestamp()});
  }

  Future<void> rate(String orderId, String customerId, int stars, String comment) async {
    if (stars < 1 || stars > 5) throw Exception('التقييم بين 1 و5');
    final order = await db.collection('orders').doc(orderId).get();
    final driverId = order.data()?['driverId'];
    await db.collection('ratings').doc(orderId).set({
      'orderId': orderId, 'customerId': customerId, 'driverId': driverId,
      'stars': stars, 'comment': comment.trim().length > 500 ? comment.trim().substring(0, 500) : comment.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}


Future<void> openJawanWhatsApp(BuildContext context) async {
  final uri = Uri.parse(
    'https://wa.me/249964499266?text=${Uri.encodeComponent('السلام عليكم، أحتاج مساعدة من جوان للتوصيل')}',
  );

  final ok = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );

  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تعذر فتح واتساب')),
    );
  }
}

Widget whatsappTile(BuildContext context) {
  return Card(
    child: ListTile(
      leading: const CircleAvatar(
        backgroundColor: kYellow,
        foregroundColor: Colors.black,
        child: Icon(Icons.chat),
      ),
      title: const Text('التواصل مع الدعم عبر واتساب'),
      subtitle: const Text('اضغط هنا لفتح واتساب مباشرة'),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => openJawanWhatsApp(context),
    ),
  );
}

class JawanApp extends StatelessWidget {
  const JawanApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'جوان للتوصيل',
        theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: kBg, colorScheme: ColorScheme.fromSeed(seedColor: kYellow)),
        home: const Directionality(textDirection: TextDirection.rtl, child: AuthGate()),
      );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, auth) {
          if (auth.connectionState == ConnectionState.waiting) return const SplashPage();
          if (!auth.hasData) return const LoginPage();
          return FutureBuilder<Map<String, dynamic>?>(
            future: AuthService().profile(auth.data!.uid),
            builder: (context, profile) {
              if (!profile.hasData) return const SplashPage();
              final data = profile.data;
              if (data == null) return const LoginPage(message: 'ملف الحساب غير موجود');
              final status = data['status'];
              if (status == 'suspended' || status == 'rejected') return const LoginPage(message: 'الحساب موقوف أو مرفوض');
              return HomePage(profile: data);
            },
          );
        },
      );
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class LoginPage extends StatefulWidget {
  final String? message;
  const LoginPage({super.key, this.message});
  @override State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = AuthService();
  final phone = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final address = TextEditingController();
  final age = TextEditingController();
  String state = 'البحر الأحمر';
  String vehicle = 'motorcycle';
  bool register = false, driver = false, busy = false, obscure = true;
  static const states = ['الخرطوم','الجزيرة','القضارف','كسلا','البحر الأحمر','نهر النيل','الشمالية','النيل الأبيض','النيل الأزرق','سنار','شمال كردفان','جنوب كردفان','غرب كردفان','شمال دارفور','جنوب دارفور','غرب دارفور','وسط دارفور','شرق دارفور'];

  Future<void> submit() async {
    setState(() => busy = true);
    try {
      if (register) {
        await auth.register(name: name.text, phone: phone.text, password: password.text, role: driver ? 'driver' : 'customer', state: state, address: address.text, age: int.tryParse(age.text), vehicleType: driver ? vehicle : null);
      } else {
        await auth.login(phone.text, password.text);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(cleanError(e))));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: kBlack, foregroundColor: kYellow, title: const Text('جوان للتوصيل', style: TextStyle(fontWeight: FontWeight.w900))),
        body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 520), child: Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('جوان', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
          const Text('توصيل أسرع وأسهل في بورتسودان'),
          if (widget.message != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(widget.message!, style: const TextStyle(color: Colors.red))),
          if (register) ...[
            const SizedBox(height: 16), TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم الكامل')),
            const SizedBox(height: 10), DropdownButtonFormField<String>(initialValue: state, items: states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) => setState(() => state = v!), decoration: const InputDecoration(labelText: 'الولاية')),
            const SizedBox(height: 10), TextField(controller: address, decoration: const InputDecoration(labelText: 'مكان السكن')),
            SwitchListTile(title: const Text('تسجيل كسائق'), value: driver, onChanged: (v) => setState(() => driver = v)),
            if (driver) ...[
              TextField(controller: age, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'العمر')),
              const SizedBox(height: 10), DropdownButtonFormField<String>(initialValue: vehicle, items: [...OrderService.passenger, ...OrderService.cargo]
    .map((v) => DropdownMenuItem(value: v, child: Text(vehicleLabel(v))))
    .toList(), onChanged: (v) => setState(() => vehicle = v!), decoration: const InputDecoration(labelText: 'نوع المركبة')),
            ],
          ],
          const SizedBox(height: 10), TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الهاتف')),
          const SizedBox(height: 10), TextField(controller: password, obscureText: obscure, decoration: InputDecoration(labelText: 'كلمة المرور', suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => obscure = !obscure)))),
          const SizedBox(height: 18), FilledButton(onPressed: busy ? null : submit, child: Text(busy ? 'جارٍ التنفيذ...' : (register ? 'إنشاء الحساب' : 'تسجيل الدخول'))),
          TextButton(onPressed: () => setState(() => register = !register), child: Text(register ? 'لدي حساب بالفعل' : 'إنشاء حساب جديد')),
        ])))))),
      );
}

class HomePage extends StatefulWidget {
  final Map<String, dynamic> profile;
  const HomePage({super.key, required this.profile});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final role = widget.profile['role'];
    final pages = role == 'driver'
        ? [DriverDashboard(profile: widget.profile), OrdersPage(profile: widget.profile)]
        : role == 'customer'
            ? [CustomerDashboard(profile: widget.profile), OrdersPage(profile: widget.profile)]
            : [AdminDashboard(profile: widget.profile), AdminOrdersPage()];
    return Scaffold(
      appBar: AppBar(backgroundColor: kBlack, foregroundColor: Colors.white, title: Text('جوان • ${widget.profile['name'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w800)), actions: [
        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())), icon: const Icon(Icons.notifications_none)),
        IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout)),
      ]),
      body: pages[index],
      bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (v) => setState(() => index = v), destinations: role == 'admin' || role == 'super_admin'
          ? const [NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'الإدارة'), NavigationDestination(icon: Icon(Icons.list_alt_outlined), label: 'الطلبات')]
          : const [NavigationDestination(icon: Icon(Icons.home_outlined), label: 'الرئيسية'), NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'طلباتي')]),
      floatingActionButton: role == 'customer' && index == 0
          ? FloatingActionButton.extended(backgroundColor: kYellow, foregroundColor: Colors.black, onPressed: () => showModalBottomSheet(isScrollControlled: true, context: context, builder: (_) => CreateOrderSheet(profile: widget.profile)), label: const Text('طلب جديد'))
          : null,
    );
  }
}

Widget heroCard(String title, String subtitle) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: kBlack, borderRadius: BorderRadius.circular(22)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(subtitle, style: const TextStyle(color: Colors.white70))]));

class CustomerDashboard extends StatelessWidget {
  final Map<String, dynamic> profile;
  const CustomerDashboard({super.key, required this.profile});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [
        heroCard('أهلاً ${profile['name'] ?? ''}', 'أنشئ طلبك واترك التسعير للتفاوض مع السائق.'),
        const SizedBox(height: 14),
        whatsappTile(context),
        const SizedBox(height: 8),
        Card(child: ListTile(leading: const CircleAvatar(backgroundColor: kYellow, foregroundColor: Colors.black, child: Icon(Icons.local_shipping)), title: const Text('طلب جديد'), subtitle: const Text('مكان الاستلام • الوجهة • تفاصيل الخدمة'), onTap: () => showModalBottomSheet(isScrollControlled: true, context: context, builder: (_) => CreateOrderSheet(profile: profile)))),
      ]);
}

class DriverDashboard extends StatelessWidget {
  final Map<String, dynamic> profile;
  const DriverDashboard({super.key, required this.profile});
  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: OrderService().availableOrders('${profile['state'] ?? ''}'),
        builder: (context, snapshot) => ListView(padding: const EdgeInsets.all(18), children: [
          whatsappTile(context),
          const SizedBox(height: 10),
          heroCard('لوحة السائق', '${profile['status'] ?? 'pending'} • ${profile['state'] ?? ''}'),
          const SizedBox(height: 14),
          if (profile['status'] != 'active') const Card(child: ListTile(title: Text('الحساب بانتظار اعتماد الإدارة'), subtitle: Text('بعد الاعتماد ستظهر الطلبات المتاحة.'), leading: Icon(Icons.info_outline))),
          if (snapshot.hasError) Text(cleanError(snapshot.error!)),
          ...snapshot.data?.docs.map((doc) => OrderCard(order: {'id': doc.id, ...doc.data()}, profile: profile, showAccept: true)).toList() ?? const [],
        ]),
      );
}

class OrdersPage extends StatelessWidget {
  final Map<String, dynamic> profile;
  const OrdersPage({super.key, required this.profile});
  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: OrderService().myOrders(FirebaseAuth.instance.currentUser!.uid, '${profile['role']}'),
        builder: (context, snapshot) => ListView(padding: const EdgeInsets.all(18), children: [
          const Text('طلباتي', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          if (snapshot.hasError) Text(cleanError(snapshot.error!)),
          ...snapshot.data?.docs.map((doc) => OrderCard(order: {'id': doc.id, ...doc.data()}, profile: profile)).toList() ?? const [],
        ]),
      );
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final Map<String, dynamic> profile;
  final bool showAccept;
  const OrderCard({super.key, required this.order, required this.profile, this.showAccept = false});
  @override
  Widget build(BuildContext context) => Card(child: ListTile(
        title: Text('${order['origin'] ?? ''} ← ${order['destination'] ?? ''}', maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text('${statusLabel(order['status'])}${order['agreedFee'] == null ? '' : ' • ${order['agreedFee']} ج.س'}'),
        trailing: showAccept ? FilledButton(onPressed: () async {
          try { await OrderService().acceptOrder('${order['id']}', FirebaseAuth.instance.currentUser!.uid); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم قبول الطلب وبدأت المفاوضة'))); }
          catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(cleanError(e)))); }
        }, child: const Text('قبول')) : const Icon(Icons.chevron_left),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsPage(orderId: '${order['id']}', profile: profile))),
      ));
}

class CreateOrderSheet extends StatefulWidget {
  final Map<String, dynamic> profile;
  const CreateOrderSheet({super.key, required this.profile});
  @override State<CreateOrderSheet> createState() => _CreateOrderSheetState();
}

class _CreateOrderSheetState extends State<CreateOrderSheet> {
  final origin = TextEditingController(), destination = TextEditingController(), description = TextEditingController();
  final cargo = TextEditingController(), cargoDescription = TextEditingController(), luggageDescription = TextEditingController();
  String vehicle = 'motorcycle';
  int passengers = 1;
  bool luggage = false, busy = false;
  @override
  Widget build(BuildContext context) {
    final isPassenger = OrderService.passenger.contains(vehicle);
    return Padding(padding: EdgeInsets.only(left: 18, right: 18, top: 18, bottom: MediaQuery.of(context).viewInsets.bottom + 18), child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Text('إنشاء طلب', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(initialValue: vehicle, items: [...OrderService.passenger, ...OrderService.cargo].map((v) => DropdownMenuItem(value: v, child: Text(vehicleLabel(v)))).toList(), onChanged: (v) => setState(() => vehicle = v!), decoration: const InputDecoration(labelText: 'نوع المركبة')),
      const SizedBox(height: 10), TextField(controller: origin, decoration: const InputDecoration(labelText: 'مكان الاستلام')),
      const SizedBox(height: 10), TextField(controller: destination, decoration: const InputDecoration(labelText: 'الوجهة')),
      if (isPassenger) ...[
        const SizedBox(height: 10), DropdownButtonFormField<int>(initialValue: passengers, items: List.generate(10, (i) => i + 1).map((v) => DropdownMenuItem(value: v, child: Text('$v'))).toList(), onChanged: (v) => setState(() => passengers = v!), decoration: const InputDecoration(labelText: 'عدد الركاب')),
        SwitchListTile(title: const Text('يوجد أمتعة'), value: luggage, onChanged: (v) => setState(() => luggage = v)),
        if (luggage) TextField(controller: luggageDescription, decoration: const InputDecoration(labelText: 'وصف الأمتعة')),
      ] else ...[
        const SizedBox(height: 10), TextField(controller: cargo, decoration: const InputDecoration(labelText: 'نوع البضاعة')),
        const SizedBox(height: 10), TextField(controller: cargoDescription, decoration: const InputDecoration(labelText: 'وصف البضاعة')),
      ],
      const SizedBox(height: 10), TextField(controller: description, decoration: const InputDecoration(labelText: 'ملاحظات إضافية')),
      const SizedBox(height: 16), FilledButton(onPressed: busy ? null : () async {
        setState(() => busy = true);
        try {
          await OrderService().createOrder(uid: FirebaseAuth.instance.currentUser!.uid, state: '${widget.profile['state'] ?? ''}', vehicleType: vehicle, origin: origin.text, destination: destination.text, description: description.text, passengerCount: isPassenger ? passengers : null, hasLuggage: luggage, luggageDescription: luggageDescription.text, cargoType: cargo.text, cargoDescription: cargoDescription.text);
          if (context.mounted) { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء الطلب'))); }
        } catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(cleanError(e)))); }
        finally { if (mounted) setState(() => busy = false); }
      }, child: Text(busy ? 'جارٍ الإنشاء...' : 'إنشاء الطلب')),
    ])));
  }
}

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> profile;
  const OrderDetailsPage({super.key, required this.orderId, required this.profile});
  @override State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final amount = TextEditingController();
  final comment = TextEditingController();
  int stars = 5;
  bool busy = false;
  final service = OrderService();

  Future<void> run(Future<void> Function() action) async {
    setState(() => busy = true);
    try { await action(); if (mounted) setState(() {}); }
    catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(cleanError(e)))); }
    finally { if (mounted) setState(() => busy = false); }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('orders').doc(widget.orderId).snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data();
          if (data == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
          final role = '${widget.profile['role']}';
          final uid = FirebaseAuth.instance.currentUser!.uid;
          return Scaffold(appBar: AppBar(title: const Text('تفاصيل الطلب')), body: ListView(padding: const EdgeInsets.all(18), children: [
            heroCard('${data['origin']} ← ${data['destination']}', statusLabel(data['status'])),
            const SizedBox(height: 12),
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text('السعر: ${data['agreedFee'] ?? 'لم يتم الاتفاق'} ج.س', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
              if (data['status'] == 'accepted' && data['negotiationStatus'] != 'agreed') ...[
                const SizedBox(height: 12),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('priceNegotiations').doc(widget.orderId).snapshots(), builder: (context, negSnapshot) {
                  final neg = negSnapshot.data?.data();
                  if (neg == null) return const Text('جاري تجهيز التفاوض...');
                  final offer = (neg['currentOffer'] as num?)?.toInt();
                  return Column(children: [
                    if (offer != null) Text('العرض الحالي: $offer ج.س', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    TextField(controller: amount, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: role == 'driver' ? 'عرضك الأول' : 'عرض مقابل')),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: FilledButton(onPressed: busy ? null : () => run(() => service.makeOffer(orderId: widget.orderId, uid: uid, role: role, name: '${widget.profile['name']}', amount: int.tryParse(amount.text) ?? 0)), child: const Text('إرسال العرض'))),
                      if (offer != null && neg['offeredBy'] != uid) ...[
                        const SizedBox(width: 8),
                        OutlinedButton(onPressed: busy ? null : () => run(() => service.respondToOffer(orderId: widget.orderId, uid: uid, role: role, name: '${widget.profile['name']}', accept: true)), child: const Text('قبول')),
                        const SizedBox(width: 8),
                        OutlinedButton(onPressed: busy ? null : () => run(() => service.respondToOffer(orderId: widget.orderId, uid: uid, role: role, name: '${widget.profile['name']}', accept: false)), child: const Text('رفض')),
                      ],
                    ]),
                  ]);
                }),
              ],
              if (data['status'] == 'accepted' && data['negotiationStatus'] == 'agreed' && role == 'driver') FilledButton(onPressed: busy ? null : () => run(() => service.updateStatus(widget.orderId, 'picked_up')), child: const Text('تم استلام الطلب')),
              if (data['status'] == 'picked_up' && role == 'driver') FilledButton(onPressed: busy ? null : () => run(() => service.updateStatus(widget.orderId, 'delivering')), child: const Text('بدء التوصيل')),
              if (data['status'] == 'delivering' && role == 'driver') FilledButton(onPressed: busy ? null : () => run(() => service.updateStatus(widget.orderId, 'awaiting_confirmation')), child: const Text('تم التسليم')),
              if (data['status'] == 'awaiting_confirmation' &&
                  role == 'driver' &&
                  data['customerConfirmedAt'] != null) ...[
                FilledButton(
                  onPressed: busy
                      ? null
                      : () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('إغلاق الطلب'),
                              content: const Text(
                                'بعد التأكيد سيتم إكمال الطلب واحتساب عمولة 5%.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('إلغاء'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('إكمال'),
                                ),
                              ],
                            ),
                          );

                          if (ok != true) return;

                          await run(() async {
                            final uid =
                                FirebaseAuth.instance.currentUser!.uid;
                            final db = FirebaseFirestore.instance;

                            await db.runTransaction((tx) async {
                              final orderRef =
                                  db.collection('orders').doc(widget.orderId);
                              final walletRef =
                                  db.collection('wallets').doc(uid);
                              final walletTxRef =
                                  db.collection('walletTransactions').doc();

                              final orderSnap = await tx.get(orderRef);
                              final walletSnap = await tx.get(walletRef);

                              if (!orderSnap.exists) {
                                throw Exception('الطلب غير موجود');
                              }

                              if (!walletSnap.exists) {
                                throw Exception('المحفظة غير موجودة');
                              }

                              final orderData = orderSnap.data()!;
                              final walletData = walletSnap.data()!;

                              if (orderData['driverId'] != uid) {
                                throw Exception('ليس لديك صلاحية');
                              }

                              if (orderData['status'] !=
                                  'awaiting_confirmation') {
                                throw Exception('الطلب ليس جاهزاً للإغلاق');
                              }

                              if (orderData['customerConfirmedAt'] == null) {
                                throw Exception('بانتظار تأكيد العميل');
                              }

                              if (orderData['commissionCharged'] == true) {
                                throw Exception('تم احتساب العمولة مسبقاً');
                              }

                              final fee =
                                  (orderData['deliveryFee'] as num?)?.toInt() ??
                                      0;

                              if (fee <= 0) {
                                throw Exception('قيمة الطلب غير صحيحة');
                              }

                              final commission = (fee * 0.05).round();

                              final balance =
                                  (walletData['balance'] as num?)?.toInt() ?? 0;

                              if (balance < commission) {
                                throw Exception(
                                  'رصيد المحفظة لا يكفي للعمولة',
                                );
                              }

                              final before = balance;
                              final after = balance - commission;

                              tx.update(orderRef, {
                                'status': 'completed',
                                'driverConfirmedAt':
                                    FieldValue.serverTimestamp(),
                                'completedAt':
                                    FieldValue.serverTimestamp(),
                                'commissionCharged': true,
                              });

                              tx.update(walletRef, {
                                'balance': after,
                                'totalCommission':
                                    ((walletData['totalCommission'] as num?)
                                                ?.toInt() ??
                                            0) +
                                        commission,
                                'updatedAt': FieldValue.serverTimestamp(),
                                'lastCommissionOrderId': widget.orderId,
                              });

                              tx.set(walletTxRef, {
                                'userId': uid,
                                'type': 'commission',
                                'amount': -commission,
                                'balanceBefore': before,
                                'balanceAfter': after,
                                'orderId': widget.orderId,
                                'topupRequestId': null,
                                'withdrawalRequestId': null,
                                'createdAt':
                                    FieldValue.serverTimestamp(),
                                'createdBy': uid,
                              });
                            });
                          });
                        },
                  child: const Text('إكمال الطلب واحتساب العمولة'),
                ),
              ],

              if (data['status'] == 'awaiting_confirmation') ...[
                FilledButton(
                  onPressed: busy
                      ? null
                      : () => run(
                            () => service.customerConfirm(widget.orderId),
                          ),
                  child: const Text('تأكيد الاستلام'),
                ),
                const SizedBox(height: 8),
              ],

              if (data['customerConfirmedAt'] != null) ...[
                DropdownButtonFormField<int>(
                  initialValue: stars,
                  items: List.generate(5, (i) => i + 1)
                      .map(
                        (v) => DropdownMenuItem(
                          value: v,
                          child: Text('$v نجوم'),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => stars = v);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'التقييم',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: comment,
                  decoration: const InputDecoration(
                    labelText: 'تعليق مختصر',
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: busy
                      ? null
                      : () => run(
                            () => service.rate(
                              widget.orderId,
                              uid,
                              stars,
                              comment.text,
                            ),
                          ),
                  child: const Text('حفظ التقييم'),
                ),
              ],
            ]))),
          ]));
        },
      );
}

class AdminDashboard extends StatelessWidget {
  final Map<String, dynamic> profile;
  const AdminDashboard({super.key, required this.profile});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [
        heroCard('لوحة الإدارة', '${profile['role']} • ${profile['status']}'),
        const SizedBox(height: 12),
        Card(child: ListTile(leading: const Icon(Icons.people_outline), title: const Text('المستخدمون'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminUsersPage())))),
        Card(child: ListTile(leading: const Icon(Icons.account_balance_wallet_outlined), title: const Text('طلبات الشحن'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminTopupsPage())))),
      ]);
}

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).limit(200).snapshots(),
        builder: (context, snapshot) => ListView(padding: const EdgeInsets.all(18), children: [
          const Text('كل الطلبات', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          ...snapshot.data?.docs.map((doc) => OrderCard(order: {'id': doc.id, ...doc.data()}, profile: const {'role': 'admin'})).toList() ?? const [],
        ]),
      );
}

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('المستخدمون')), body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').orderBy('createdAt', descending: true).limit(300).snapshots(),
        builder: (context, snapshot) => ListView(children: snapshot.data?.docs.map((doc) => ListTile(title: Text('${doc.data()['name'] ?? doc.id}'), subtitle: Text('${doc.data()['role'] ?? ''} • ${doc.data()['status'] ?? ''} • ${doc.data()['phone'] ?? ''}'))).toList() ?? const []),
      ));
}

class AdminTopupsPage extends StatelessWidget {
  const AdminTopupsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('طلبات الشحن')), body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('topupRequests').orderBy('createdAt', descending: true).limit(200).snapshots(),
        builder: (context, snapshot) => ListView(children: snapshot.data?.docs.map((doc) => ListTile(title: Text('${doc.data()['amount'] ?? ''} ج.س'), subtitle: Text('${doc.data()['status'] ?? ''} • ${doc.data()['driverId'] ?? ''}'))).toList() ?? const []),
      ));
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(appBar: AppBar(title: const Text('الإشعارات')), body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('notifications').where('userId', isEqualTo: uid).orderBy('createdAt', descending: true).limit(100).snapshots(),
      builder: (context, snapshot) => ListView(children: snapshot.data?.docs.map((doc) => ListTile(title: Text('${doc.data()['title'] ?? 'جوان'}'), subtitle: Text('${doc.data()['body'] ?? ''}'), onTap: () => doc.reference.update({'read': true}))).toList() ?? const []),
    ));
  }
}
```

## 9. Android configuration

### mobile-app/android/gradle.properties
```text
# Project-wide Gradle settings.

# IDE (e.g. Android Studio) users:
# Gradle settings configured through the IDE *will override*
# any settings specified in this file.

# For more details on how to configure your build environment visit
# http://www.gradle.org/docs/current/userguide/build_environment.html

# Specifies the JVM arguments used for the daemon process.
# The setting is particularly useful for tweaking memory settings.
org.gradle.jvmargs=-Xmx1536m

# When configured, Gradle will run in incubating parallel mode.
# This option should only be used with decoupled projects. More details, visit
# http://www.gradle.org/docs/current/userguide/multi_project_builds.html#sec:decoupled_projects
# org.gradle.parallel=true

# AndroidX package structure to make it clearer which packages are bundled with the
# Android operating system, and which are packaged with your app's APK
# https://developer.android.com/topic/libraries/support-library/androidx-rn
android.useAndroidX=true

android.builder.sdkDownload=false
```

### mobile-app/capacitor.config.ts
```text
import type { CapacitorConfig } from '@capacitor/cli';

// www/ يُبنى تلقائيًا (نسخة منسوخة من ملفات الموقع الرئيسية) بواسطة
// npm run sync-web، ولا يُحفظ في git — راجع package.json و README-APK.md.
const config: CapacitorConfig = {
  appId: 'sd.jawan.delivery',
  appName: 'جوان للتوصيل',
  webDir: 'www',
  server: {
    androidScheme: 'https'
  }
};

export default config;
```

### mobile-app/package.json
```text
{
  "name": "jawan-delivery-mobile-app",
  "version": "1.0.0",
  "description": "غلاف Android لتطبيق جوان للتوصيل عبر Capacitor",
  "private": true,
  "scripts": {
    "sync-web": "bash sync-web.sh",
    "sync": "npm run sync-web && npx cap sync android"
  },
  "license": "ISC",
  "dependencies": {
    "@capacitor/android": "^8.5.1",
    "@capacitor/cli": "^8.5.1",
    "@capacitor/core": "^8.5.1"
  },
  "devDependencies": {
    "@capacitor/assets": "^3.0.5",
    "typescript": "^7.0.2"
  }
}
```

## 10. GitHub workflows

### .github/workflows/android-apk.yml
```yaml
name: Build Jwan Android APK

on:
  workflow_dispatch:
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v6

      - name: Setup Java
        uses: actions/setup-java@v5
        with:
          distribution: temurin
          java-version: '21'

      - name: Setup Android SDK
        uses: android-actions/setup-android@v4

      - name: Install Android SDK packages
        run: |
          yes | sdkmanager --licenses > /dev/null || true
          sdkmanager "platform-tools" "platforms;android-36" "build-tools;36.0.0"

      - name: Setup Node.js
        uses: actions/setup-node@v5
        with:
          node-version: '22'
          cache: npm
          cache-dependency-path: mobile-app/package-lock.json

      - name: Install npm dependencies
        working-directory: mobile-app
        run: npm ci --ignore-scripts --no-audit --no-fund

      - name: Sync Capacitor
        working-directory: mobile-app
        run: npx cap sync android

      - name: Build Debug APK
        working-directory: mobile-app/android
        run: ./gradlew assembleDebug --no-daemon

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: jwan-debug-apk
          path: mobile-app/android/app/build/outputs/apk/debug/app-debug.apk
          if-no-files-found: error
```

### .github/workflows/build-apk.yml
```yaml
name: Build Android APK

on:
  workflow_dispatch:
  push:
    branches:
      - main

jobs:
  build-apk:
    name: Build Jawan APK
    runs-on: ubuntu-latest

    defaults:
      run:
        working-directory: mobile-app

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
          cache-dependency-path: mobile-app/package-lock.json

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: 21
          cache: gradle

      - name: Install npm dependencies
        run: npm ci

      - name: Generate Android app icons
        run: npx capacitor-assets generate --android

      - name: Sync web files and Capacitor
        run: npm run sync

      - name: Make Gradle executable
        run: chmod +x android/gradlew

      - name: Build Debug APK
        run: |
          cd android
          ./gradlew assembleDebug --no-daemon

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: jawan-debug-apk
          path: mobile-app/android/app/build/outputs/apk/debug/app-debug.apk
          if-no-files-found: error
          retention-days: 14
```

### .github/workflows/build-apk.yml.backup
```yaml
name: Build Android APK

on:
  workflow_dispatch:
  push:
    branches:
      - main

jobs:
  build-apk:
    name: Build Jawan APK
    runs-on: ubuntu-latest

    defaults:
      run:
        working-directory: mobile-app

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
          cache-dependency-path: mobile-app/package-lock.json

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: 21
          cache: gradle

      - name: Install npm dependencies
        run: npm ci

      - name: Sync web files and Capacitor
        run: npm run sync

      - name: Make Gradle executable
        run: chmod +x android/gradlew

      - name: Build Debug APK
        run: |
          cd android
          ./gradlew assembleDebug --no-daemon

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: jawan-debug-apk
          path: mobile-app/android/app/build/outputs/apk/debug/app-debug.apk
          if-no-files-found: error
          retention-days: 14
```

### .github/workflows/flutter-apk.yml
```yaml
name: Jawan Flutter Release Candidate

on:
  workflow_dispatch:
  push:
    branches:
      - main
      - flutter-native-20260913

permissions:
  contents: read

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true

      - name: Generate Android project
        run: |
          rm -rf .flutter_seed
          flutter create \
            --org sd.jawan \
            --project-name delivery \
            --platforms android \
            .flutter_seed

          rm -rf mobile-app/android
          cp -R .flutter_seed/android mobile-app/android
          rm -rf .flutter_seed

      - name: Allow url_launcher to open links (WhatsApp/browser)
        run: |
          python3 - <<'PY'
          from pathlib import Path
          p = Path("mobile-app/android/app/src/main/AndroidManifest.xml")
          s = p.read_text()
          block = (
              '    <queries>\n'
              '        <intent>\n'
              '            <action android:name="android.intent.action.VIEW" />\n'
              '            <category android:name="android.intent.category.BROWSABLE" />\n'
              '            <data android:scheme="https" />\n'
              '        </intent>\n'
              '    </queries>\n'
              '</manifest>'
          )
          s = s.replace('</manifest>', block)
          p.write_text(s)
          PY

      - name: Get dependencies
        working-directory: mobile-app
        run: flutter pub get

      - name: Analyze
        working-directory: mobile-app
        run: flutter analyze

      - name: Test
        working-directory: mobile-app
        run: flutter test

      - name: Build Release APK
        working-directory: mobile-app
        run: |
          flutter build apk --release \
            --dart-define=JAWAN_FIREBASE_API_KEY=${{ secrets.JAWAN_FIREBASE_API_KEY }} \
            --dart-define=JAWAN_FIREBASE_APP_ID=${{ secrets.JAWAN_FIREBASE_APP_ID }}

      - name: Build Release AAB
        working-directory: mobile-app
        run: |
          flutter build appbundle --release \
            --dart-define=JAWAN_FIREBASE_API_KEY=${{ secrets.JAWAN_FIREBASE_API_KEY }} \
            --dart-define=JAWAN_FIREBASE_APP_ID=${{ secrets.JAWAN_FIREBASE_APP_ID }}

      - name: Upload release artifacts
        uses: actions/upload-artifact@v4
        with:
          name: jawan-flutter-release
          path: |
            mobile-app/build/app/outputs/flutter-apk/app-release.apk
            mobile-app/build/app/outputs/bundle/release/app-release.aab
          if-no-files-found: error
```

## 11. Legacy Web/PWA business logic files

### js/auth.js
```javascript
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
```

### js/orders.js
```javascript
import { db } from "./firebase-config.js";

import {
  collection,
  doc,
  addDoc,
  updateDoc,
  onSnapshot,
  query,
  where,
  orderBy,
  limit,
  runTransaction,
  serverTimestamp,
  getDoc
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

import { driverCommission } from "./wallet.js";

export const ORDER_STATUSES = {
  PENDING: "pending",
  ACCEPTED: "accepted",
  PICKED_UP: "picked_up",
  DELIVERING: "delivering",
  AWAITING_CONFIRMATION: "awaiting_confirmation",
  NOT_DELIVERED: "not_delivered",
  COMPLETED: "completed",
  CANCELLED: "cancelled",
  REJECTED: "rejected"
};

export const PASSENGER_VEHICLES = [
  "car", "rickshaw", "bus", "amjad", "taxi", "limousine"
];

export const CARGO_VEHICLES = [
  "motorcycle", "tuk_tuk", "truck", "kreez", "tanker", "crane", "tow_truck", "lorry"
];

export function driverNet(deliveryFee) {
  const fee = Number(deliveryFee || 0);
  return Math.max(0, fee - driverCommission(fee));
}

export function driverCancellationPenalty(deliveryFee) {
  const fee = Number(deliveryFee || 0);
  return Number.isFinite(fee) && fee > 0 ? Math.round(fee * 0.10) : 0;
}

function cleanText(value, label, max = 1000) {
  const text = String(value ?? "").trim();
  if (!text) throw new Error(`${label} مطلوب`);
  if (text.length > max) throw new Error(`${label} طويل جدًا`);
  return text;
}

export async function createOrder(
  customerId,
  {
    vehicleType,
    passengerCount,
    hasLuggage,
    luggageDescription,
    cargoType,
    cargoDescription,
    description,
    origin,
    destination
  }
) {
  if (!customerId) throw new Error("حساب العميل غير صحيح");

  const vehicle = cleanText(vehicleType, "نوع المركبة", 40);
  const cleanOrigin = cleanText(origin, "مكان الاستلام", 250);
  const cleanDestination = cleanText(destination, "مكان التسليم", 250);
  const cleanDescription = String(description || "").trim().slice(0, 1000);

  if (cleanOrigin === cleanDestination) {
    throw new Error("مكان الاستلام والوجهة يجب أن يكونا مختلفين");
  }

  const passengerVehicle = PASSENGER_VEHICLES.includes(vehicle);
  const cargoVehicle = CARGO_VEHICLES.includes(vehicle);

  if (!passengerVehicle && !cargoVehicle) {
    throw new Error("نوع المركبة غير صحيح");
  }

  let cleanPassengerCount = null;
  let cleanHasLuggage = null;
  let cleanLuggageDescription = null;
  let cleanCargoType = null;
  let cleanCargoDescription = null;

  if (passengerVehicle) {
    cleanPassengerCount = Number(passengerCount);
    if (!Number.isInteger(cleanPassengerCount) || cleanPassengerCount < 1 || cleanPassengerCount > 100) {
      throw new Error("عدد الركاب يجب أن يكون بين 1 و100");
    }

    cleanHasLuggage = Boolean(hasLuggage);

    if (cleanHasLuggage) {
      cleanLuggageDescription = cleanText(luggageDescription, "وصف الأمتعة", 500);
    }
  } else {
    cleanCargoType = cleanText(cargoType, "نوع البضاعة", 120);
    cleanCargoDescription = cleanText(cargoDescription, "وصف البضاعة", 1000);
  }

  const customerSnap = await getDoc(doc(db, "users", customerId));
  if (!customerSnap.exists()) throw new Error("حساب العميل غير موجود");
  const customer = customerSnap.data();

  if (customer.role !== "customer" || customer.status !== "active") {
    throw new Error("حساب العميل غير نشط");
  }
  if (!customer.state) throw new Error("الولاية غير محددة في حسابك");

  const ref = await addDoc(collection(db, "orders"), {
    customerId,
    driverId: null,

    state: customer.state,

    vehicleType: vehicle,
    serviceCategory: passengerVehicle ? "passenger" : "cargo",

    passengerCount: cleanPassengerCount,
    hasLuggage: cleanHasLuggage,
    luggageDescription: cleanLuggageDescription,

    cargoType: cleanCargoType,
    cargoDescription: cleanCargoDescription,

    description: cleanDescription,

    origin: cleanOrigin,
    destination: cleanDestination,

    deliveryFee: null,
    agreedFee: null,

    status: ORDER_STATUSES.PENDING,
    negotiationStatus: "none",

    commissionCharged: false,
    cancellationPenaltyCharged: false,

    createdAt: serverTimestamp(),
    acceptedAt: null,
    pickedUpAt: null,
    startedAt: null,
    deliveredAt: null,
    customerConfirmedAt: null,
    notDeliveredAt: null,
    driverConfirmedAt: null,
    completedAt: null,
    cancelledAt: null,
    agreedAt: null,
    agreedBy: null,

    cancelReason: null,
    driverComment: null
  });

  return ref.id;
}

export function listenAvailableOrders(state, callback) {
  const cleanState = String(state || "").trim();
  if (!cleanState) {
    callback([]);
    return () => {};
  }

  const q = query(
    collection(db, "orders"),
    where("state", "==", cleanState),
    where("status", "==", ORDER_STATUSES.PENDING),
    where("driverId", "==", null),
    orderBy("createdAt", "desc")
  );

  return onSnapshot(q, (snap) => {
    callback(snap.docs.map((d) => ({ id: d.id, ...d.data() })));
  });
}

export function listenMyOrders(role, uid, callback) {
  const field = role === "driver" ? "driverId" : "customerId";
  const q = query(
    collection(db, "orders"),
    where(field, "==", uid),
    orderBy("createdAt", "desc")
  );

  return onSnapshot(q, (snap) => {
    callback(snap.docs.map((d) => ({ id: d.id, ...d.data() })));
  });
}

export function listenAllOrders(callback, max = 200) {
  const q = query(
    collection(db, "orders"),
    orderBy("createdAt", "desc"),
    limit(max)
  );

  return onSnapshot(q, (snap) => {
    callback(snap.docs.map((d) => ({ id: d.id, ...d.data() })));
  });
}

export async function acceptOrder(orderId, driverId) {
  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const negotiationRef = doc(db, "priceNegotiations", orderId);

    const orderSnap = await tx.get(orderRef);
    if (!orderSnap.exists()) throw new Error("الطلب غير موجود");

    const order = orderSnap.data();

    if (
      order.status !== ORDER_STATUSES.PENDING ||
      order.driverId !== null
    ) {
      throw new Error("تم قبول هذا الطلب من سائق آخر");
    }

    if (!order.state) throw new Error("الولاية غير موجودة في الطلب");

    const driverSnap = await tx.get(doc(db, "users", driverId));
    if (!driverSnap.exists()) throw new Error("حساب السائق غير موجود");

    const driver = driverSnap.data();
    if (
      driver.role !== "driver" ||
      driver.status !== "active" ||
      driver.state !== order.state
    ) {
      throw new Error("لا يمكنك قبول طلب خارج ولايتك");
    }

    const walletRef = doc(db, "wallets", driverId);
    const walletSnap = await tx.get(walletRef);

    if (!walletSnap.exists()) {
      throw new Error("محفظتك غير مهيأة. اشحن رصيدك أولًا ثم حاول قبول الطلب.");
    }

    const walletBalance = Number(walletSnap.data()?.balance || 0);

    if (walletBalance <= 0) {
      throw new Error("رصيدك صفر حاليًا 😊 اشحن المحفظة قليلًا ثم ارجع لنا، والطلبات تنتظرك.");
    }

    tx.update(orderRef, {
      driverId,
      status: ORDER_STATUSES.ACCEPTED,
      acceptedAt: serverTimestamp(),
      negotiationStatus: "open"
    });

    tx.set(negotiationRef, {
      orderId,
      customerId: order.customerId,
      driverId,
      customerName: null,
      driverName: driver.name || "السائق",
      currentOffer: null,
      offeredBy: null,
      status: "open",
      expiresAt: null,
      updatedAt: serverTimestamp(),
      lastAction: "accepted",
      lastMessageId: null
    });
  });
}

export async function pickupOrder(orderId) {
  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const snap = await tx.get(orderRef);
    if (!snap.exists()) throw new Error("الطلب غير موجود");
    const order = snap.data();

    if (
      order.negotiationStatus !== "agreed" ||
      !Number(order.agreedFee || 0)
    ) {
      throw new Error("لا يمكن استلام الطلب قبل الاتفاق على السعر");
    }

    tx.update(orderRef, {
      status: ORDER_STATUSES.PICKED_UP,
      pickedUpAt: serverTimestamp()
    });
  });
}

export async function startDelivering(orderId) {
  await updateDoc(doc(db, "orders", orderId), {
    status: ORDER_STATUSES.DELIVERING,
    startedAt: serverTimestamp()
  });
}

export async function markDelivered(orderId) {
  await updateDoc(doc(db, "orders", orderId), {
    status: ORDER_STATUSES.AWAITING_CONFIRMATION,
    deliveredAt: serverTimestamp()
  });
}

export async function customerConfirmDelivery(orderId) {
  await updateDoc(doc(db, "orders", orderId), {
    customerConfirmedAt: serverTimestamp()
  });
}

export async function customerReportNotDelivered(orderId, customerId) {
  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const snap = await tx.get(orderRef);
    if (!snap.exists()) throw new Error("الطلب غير موجود");

    const order = snap.data();
    if (order.customerId !== customerId) throw new Error("ليس لديك صلاحية لهذا الطلب");
    if (order.status !== ORDER_STATUSES.AWAITING_CONFIRMATION) {
      throw new Error("الطلب ليس في مرحلة تأكيد التوصيل");
    }
    if (order.customerConfirmedAt) throw new Error("تم تأكيد استلام الطلب بالفعل");

    const createdAt = order.createdAt;
    if (!createdAt || typeof createdAt.toMillis !== "function") {
      throw new Error("وقت إنشاء الطلب غير متوفر");
    }

    if (Date.now() - createdAt.toMillis() < 60 * 60 * 1000) {
      throw new Error("يمكنك الإبلاغ عن عدم وصول الطلب بعد مرور ساعة من إنشاء الطلب");
    }

    tx.update(orderRef, {
      status: ORDER_STATUSES.NOT_DELIVERED,
      notDeliveredAt: serverTimestamp()
    });
  });
}

export async function driverFinalizeOrder(orderId, driverId) {
  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const walletRef = doc(db, "wallets", driverId);

    const orderSnap = await tx.get(orderRef);
    if (!orderSnap.exists()) throw new Error("الطلب غير موجود");

    const order = orderSnap.data();

    if (order.driverId !== driverId) throw new Error("هذا الطلب ليس لديك");
    if (order.status !== ORDER_STATUSES.AWAITING_CONFIRMATION) {
      throw new Error("الطلب ليس جاهزًا للإغلاق");
    }
    if (order.negotiationStatus !== "agreed" || !Number(order.deliveryFee || 0)) {
      throw new Error("سعر الطلب المتفق عليه غير موجود");
    }
    if (!order.customerConfirmedAt) throw new Error("بانتظار تأكيد العميل أولًا");
    if (order.commissionCharged === true) throw new Error("تم احتساب عمولة هذا الطلب مسبقًا");

    const walletSnap = await tx.get(walletRef);
    if (!walletSnap.exists()) throw new Error("محفظتك غير مهيأة، تواصل مع الإدارة");

    const wallet = walletSnap.data();
    const commission = driverCommission(order.deliveryFee);
    const balanceBefore = Number(wallet.balance || 0);

    if (balanceBefore < commission) {
      throw new Error("رصيد المحفظة لا يكفي للعمولة");
    }

    const balanceAfter = balanceBefore - commission;

    tx.update(orderRef, {
      status: ORDER_STATUSES.COMPLETED,
      driverConfirmedAt: serverTimestamp(),
      completedAt: serverTimestamp(),
      commissionCharged: true
    });

    tx.update(walletRef, {
      balance: balanceAfter,
      totalCommission: Number(wallet.totalCommission || 0) + commission,
      updatedAt: serverTimestamp(),
      lastCommissionOrderId: orderId
    });

    const txRef = doc(collection(db, "walletTransactions"));
    tx.set(txRef, {
      userId: driverId,
      type: "commission",
      amount: -commission,
      balanceBefore,
      balanceAfter,
      orderId,
      topupRequestId: null,
      withdrawalRequestId: null,
      createdAt: serverTimestamp(),
      createdBy: driverId
    });
  });
}

export async function driverCancelOrder(orderId, driverId, cancelReason) {
  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const walletRef = doc(db, "wallets", driverId);

    const orderSnap = await tx.get(orderRef);
    if (!orderSnap.exists()) throw new Error("الطلب غير موجود");

    const order = orderSnap.data();

    if (order.driverId !== driverId) throw new Error("هذا الطلب ليس لديك");
    if (![ORDER_STATUSES.ACCEPTED, ORDER_STATUSES.PICKED_UP].includes(order.status)) {
      throw new Error("لا يمكن إلغاء الطلب في هذه المرحلة");
    }

    if (order.cancellationPenaltyCharged === true) {
      throw new Error("تم احتساب غرامة الإلغاء مسبقًا");
    }

    const common = {
      status: ORDER_STATUSES.CANCELLED,
      cancelledAt: serverTimestamp(),
      cancelReason: String(cancelReason || "إلغاء بواسطة السائق").slice(0, 300)
    };

    if (order.negotiationStatus !== "agreed") {
      tx.update(orderRef, { ...common, cancellationPenaltyCharged: false });
      return;
    }

    const penalty = driverCancellationPenalty(order.deliveryFee);
    if (penalty <= 0) throw new Error("قيمة غرامة الإلغاء غير صحيحة");

    const walletSnap = await tx.get(walletRef);
    if (!walletSnap.exists()) throw new Error("محفظة السائق غير موجودة");

    const wallet = walletSnap.data();
    const balanceBefore = Number(wallet.balance || 0);
    if (balanceBefore < penalty) throw new Error("رصيد المحفظة لا يكفي لتغطية غرامة الإلغاء");

    const balanceAfter = balanceBefore - penalty;

    tx.update(orderRef, {
      ...common,
      cancellationPenaltyCharged: true
    });

    tx.update(walletRef, {
      balance: balanceAfter,
      totalCancellationPenalties:
        Number(wallet.totalCancellationPenalties || 0) + penalty,
      updatedAt: serverTimestamp(),
      lastCancellationOrderId: orderId
    });

    const transactionRef = doc(collection(db, "walletTransactions"));
    tx.set(transactionRef, {
      userId: driverId,
      type: "cancellation_penalty",
      amount: -penalty,
      balanceBefore,
      balanceAfter,
      orderId,
      topupRequestId: null,
      withdrawalRequestId: null,
      createdAt: serverTimestamp(),
      createdBy: driverId
    });
  });
}

export async function customerCancelOrder(orderId, customerId, cancelReason) {
  const orderRef = doc(db, "orders", orderId);

  await runTransaction(db, async (tx) => {
    const snap = await tx.get(orderRef);

    if (!snap.exists()) {
      throw new Error("الطلب غير موجود.");
    }

    const order = snap.data();

    if (order.customerId !== customerId) {
      throw new Error("لا يمكنك إلغاء هذا الطلب.");
    }

    // Customer cancellation is allowed only at the very beginning:
    // pending + no driver + no negotiation.
    if (
      order.status !== ORDER_STATUSES.PENDING ||
      order.driverId != null ||
      (order.negotiationStatus && order.negotiationStatus !== "none")
    ) {
      throw new Error("لا يمكن إلغاء الطلب بعد بدء التفاوض أو تعيين سائق.");
    }

    const reason = String(cancelReason || "").trim();
    if (!reason) {
      throw new Error("يجب اختيار سبب الإلغاء.");
    }

    tx.update(orderRef, {
      status: ORDER_STATUSES.CANCELLED,
      cancelledAt: serverTimestamp(),
      cancelReason: reason.slice(0, 300),
      cancellationPenaltyCharged: false,
      driverId: null,
      negotiationStatus: "none"
    });
  });
}

export async function cancelOrder(orderId, cancelReason) {
  await updateDoc(doc(db, "orders", orderId), {
    status: ORDER_STATUSES.CANCELLED,
    cancelledAt: serverTimestamp(),
    cancelReason: cancelReason || null
  });
}
```

### js/negotiation.js
```javascript
import { db } from "./firebase-config.js";
import {
  collection,
  doc,
  getDoc,
  onSnapshot,
  query,
  orderBy,
  runTransaction,
  serverTimestamp,
  Timestamp
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

export const NEGOTIATION_MINUTES = 30;
export const NEGOTIATION_DURATION_MS = NEGOTIATION_MINUTES * 60 * 1000;
export const MAX_NEGOTIATION_AMOUNT = 100000000;

function cleanAmount(value) {
  const n = Math.round(Number(value));
  if (!Number.isFinite(n) || n <= 0) throw new Error("أدخل مبلغًا صحيحًا.");
  if (n > MAX_NEGOTIATION_AMOUNT) throw new Error("المبلغ كبير جدًا.");
  return n;
}

function isParticipant(order, uid, role) {
  return role === "customer"
    ? order.customerId === uid
    : order.driverId === uid;
}

function toMillis(value) {
  if (!value) return 0;
  if (typeof value.toMillis === "function") return value.toMillis();
  const d = value instanceof Date ? value : new Date(value);
  return Number.isFinite(d.getTime()) ? d.getTime() : 0;
}

function checkOpen(order, negotiation, uid, role) {
  if (!order || order.status !== "accepted") {
    throw new Error("التفاوض متاح بعد قبول السائق وقبل بدء التوصيل فقط.");
  }
  if (!isParticipant(order, uid, role)) {
    throw new Error("ليس لديك صلاحية على هذا الطلب.");
  }
  if (!negotiation || negotiation.status !== "open") {
    throw new Error("لا توجد مفاوضة مفتوحة لهذا الطلب.");
  }
  if (negotiation.expiresAt && toMillis(negotiation.expiresAt) <= Date.now()) {
    throw new Error("انتهت مدة التفاوض.");
  }
}

export function listenNegotiation(orderId, callback) {
  const negotiationRef = doc(db, "priceNegotiations", orderId);
  const messagesRef = collection(db, "priceNegotiations", orderId, "messages");
  const messagesQuery = query(messagesRef, orderBy("createdAt", "asc"));
  let state = { negotiation: null, messages: [] };

  const emit = () => callback({ ...state });

  const unsubNegotiation = onSnapshot(negotiationRef, (snap) => {
    state = {
      ...state,
      negotiation: snap.exists() ? snap.data() : null
    };
    emit();
  });

  const unsubMessages = onSnapshot(messagesQuery, (snap) => {
    state = {
      ...state,
      messages: snap.docs.map((d) => ({ id: d.id, ...d.data() }))
    };
    emit();
  });

  return () => {
    unsubNegotiation();
    unsubMessages();
  };
}

export async function startNegotiation({ orderId, userId, role, name, amount }) {
  if (role !== "driver") {
    throw new Error("العرض الأول يرسله السائق فقط.");
  }
  const value = cleanAmount(amount);

  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const negRef = doc(db, "priceNegotiations", orderId);
    const orderSnap = await tx.get(orderRef);
    if (!orderSnap.exists()) throw new Error("الطلب غير موجود.");

    const order = orderSnap.data();

    if (
      order.status !== "accepted" ||
      !isParticipant(order, userId, role) ||
      (order.negotiationStatus || "none") === "agreed"
    ) {
      throw new Error("التفاوض غير متاح في هذه المرحلة.");
    }

    const negSnap = await tx.get(negRef);
    if (!negSnap.exists()) {
      throw new Error("محادثة التفاوض غير مهيأة.");
    }

    const neg = negSnap.data();
    if (neg.status !== "open") throw new Error("لا توجد مفاوضة مفتوحة.");
    if (neg.currentOffer != null) {
      throw new Error("يوجد عرض حالي بالفعل؛ يمكنك قبوله أو رفضه أو تقديم عرض مقابل.");
    }

    const expiresAt = Timestamp.fromMillis(
      Date.now() + NEGOTIATION_DURATION_MS
    );
    const messageRef = doc(collection(negRef, "messages"));
    const messageId = messageRef.id;

    const patch = {
      currentOffer: value,
      offeredBy: userId,
      expiresAt,
      updatedAt: serverTimestamp(),
      lastAction: "offer",
      lastMessageId: messageId
    };

    if (role === "driver") {
      patch.driverName = String(name || "السائق").slice(0, 120);
    } else {
      patch.customerName = String(name || "العميل").slice(0, 120);
    }

    tx.update(negRef, patch);
    tx.set(messageRef, {
      orderId,
      amount: value,
      action: "offer",
      senderId: userId,
      senderRole: role,
      senderName: String(name || (role === "driver" ? "السائق" : "العميل")).slice(0, 120),
      createdAt: serverTimestamp(),
      expiresAt
    });
  });
}

export async function proposePrice({ orderId, userId, role, name, amount }) {
  const value = cleanAmount(amount);

  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const negRef = doc(db, "priceNegotiations", orderId);
    const orderSnap = await tx.get(orderRef);
    const negSnap = await tx.get(negRef);

    if (!orderSnap.exists() || !negSnap.exists()) {
      throw new Error("لا توجد مفاوضة.");
    }

    const order = orderSnap.data();
    const negotiation = negSnap.data();
    checkOpen(order, negotiation, userId, role);

    if (negotiation.offeredBy === userId && negotiation.currentOffer != null) {
      throw new Error("انتظر الطرف الآخر للرد على عرضك الحالي.");
    }

    const messageRef = doc(collection(negRef, "messages"));
    const messageId = messageRef.id;

    const patch = {
      currentOffer: value,
      offeredBy: userId,
      updatedAt: serverTimestamp(),
      lastAction: "offer",
      lastMessageId: messageId
    };

    if (role === "driver") patch.driverName = String(name || "السائق").slice(0, 120);
    if (role === "customer") patch.customerName = String(name || "العميل").slice(0, 120);

    tx.update(negRef, patch);
    tx.set(messageRef, {
      orderId,
      amount: value,
      action: "offer",
      senderId: userId,
      senderRole: role,
      senderName: String(name || (role === "driver" ? "السائق" : "العميل")).slice(0, 120),
      createdAt: serverTimestamp(),
      expiresAt: negotiation.expiresAt || null
    });
  });
}

export async function respondToOffer({ orderId, userId, role, name, action }) {
  if (!["accept", "reject"].includes(action)) {
    throw new Error("إجراء غير صحيح.");
  }

  await runTransaction(db, async (tx) => {
    const orderRef = doc(db, "orders", orderId);
    const negRef = doc(db, "priceNegotiations", orderId);

    // READS FIRST
    const orderSnap = await tx.get(orderRef);
    const negSnap = await tx.get(negRef);

    if (!orderSnap.exists() || !negSnap.exists()) {
      throw new Error("لا توجد مفاوضة.");
    }

    const order = orderSnap.data();
    const negotiation = negSnap.data();

    checkOpen(order, negotiation, userId, role);

    if (negotiation.offeredBy === userId) {
      throw new Error("لا يمكنك قبول أو رفض عرضك أنت.");
    }

    if (
      negotiation.expiresAt &&
      toMillis(negotiation.expiresAt) <= Date.now()
    ) {
      throw new Error("انتهت مدة التفاوض.");
    }

    const amount = cleanAmount(negotiation.currentOffer);
    const messageRef = doc(collection(negRef, "messages"));
    const messageId = messageRef.id;

    let customer = null;
    let driver = null;

    // For ACCEPT only, read everything needed before any write.
    if (action === "accept") {
      const customerRef = doc(db, "users", order.customerId);
      const driverRef = doc(db, "users", order.driverId);

      const customerSnap = await tx.get(customerRef);
      const driverSnap = await tx.get(driverRef);

      if (!customerSnap.exists() || !driverSnap.exists()) {
        throw new Error("بيانات أحد الطرفين غير موجودة.");
      }

      customer = customerSnap.data();
      driver = driverSnap.data();

      if (role === "driver") {
        const walletRef = doc(db, "wallets", order.driverId);
        const walletSnap = await tx.get(walletRef);

        if (!walletSnap.exists()) {
          throw new Error("محفظة السائق غير مهيأة. يجب شحن المحفظة أولًا.");
        }

        const balance = Number(walletSnap.data()?.balance || 0);
        const commission = Math.round(amount * 0.05);

        if (balance <= 0) {
          throw new Error("رصيدك صفر حاليًا 😊 اشحن المحفظة أولًا ثم حاول قبول العرض.");
        }

        if (balance < commission) {
          throw new Error(
            `رصيدك لا يكفي لعمولة هذا الطلب (${commission} ج.س). اشحن المحفظة ثم أعد قبول العرض.`
          );
        }
      }
    }

    // WRITES START HERE — after ALL reads
    tx.set(messageRef, {
      orderId,
      amount,
      action,
      senderId: userId,
      senderRole: role,
      senderName: String(
        name ||
        (role === "driver"
          ? negotiation.driverName || "السائق"
          : negotiation.customerName || "العميل")
      ).slice(0, 120),
      createdAt: serverTimestamp(),
      expiresAt: negotiation.expiresAt || null
    });

    if (action === "reject") {
      // Either side rejecting closes this negotiation and releases the order.
      tx.update(orderRef, {
        driverId: null,
        status: "pending",
        negotiationStatus: "none"
      });

      tx.update(negRef, {
        currentOffer: null,
        offeredBy: null,
        status: "closed",
        updatedAt: serverTimestamp(),
        lastAction: "reject",
        lastMessageId: messageId
      });

      return;
    }

    const contactRef = doc(db, "orderContacts", orderId);

    tx.update(orderRef, {
      deliveryFee: amount,
      agreedFee: amount,
      negotiationStatus: "agreed",
      agreedAt: serverTimestamp(),
      agreedBy: userId
    });

    tx.update(negRef, {
      status: "agreed",
      currentOffer: amount,
      updatedAt: serverTimestamp(),
      agreedAt: serverTimestamp(),
      agreedBy: userId,
      lastAction: "accept",
      lastMessageId: messageId
    });

    tx.set(contactRef, {
      orderId,
      customerId: order.customerId,
      driverId: order.driverId,
      customerPhone: String(customer.phone || ""),
      driverPhone: String(driver.phone || ""),
      createdAt: serverTimestamp()
    });
  });
}

export async function saveOwnContact({ orderId }) {
  const snap = await getDoc(doc(db, "orders", orderId));
  if (!snap.exists() || snap.data().negotiationStatus !== "agreed") {
    throw new Error("تظهر أرقام الهاتف بعد الاتفاق فقط.");
  }
  return true;
}

export function listenOrderContacts(orderId, callback) {
  const ref = doc(db, "orderContacts", orderId);
  return onSnapshot(ref, (snap) => {
    callback(snap.exists() ? { id: snap.id, ...snap.data() } : null);
  });
}
```

### js/wallet.js
```javascript
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
```

### js/ratings.js
```javascript
import { db } from "./firebase-config.js";
import {
  collection,
  doc,
  setDoc,
  getDocs,
  query,
  where,
  serverTimestamp
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

export async function submitRating(orderId, customerId, driverId, rating, comment) {
  const value = Math.min(5, Math.max(1, Math.round(Number(rating))));
  await setDoc(doc(db, "ratings", `${orderId}_${customerId}`), {
    orderId,
    customerId,
    driverId,
    rating: value,
    comment: comment ? String(comment).trim() : null,
    createdAt: serverTimestamp()
  });
}

// أرقام الطلبات التي قيّمها هذا العميل مسبقًا، لإخفاء نموذج التقييم عنها.
export async function fetchRatedOrderIds(customerId) {
  const q = query(collection(db, "ratings"), where("customerId", "==", customerId));
  const snap = await getDocs(q);
  return new Set(snap.docs.map((d) => d.data().orderId));
}
```

### js/notifications.js
```javascript
import { db, auth } from "./firebase-config.js";

import {
  collection,
  doc,
  addDoc,
  updateDoc,
  onSnapshot,
  query,
  where,
  orderBy,
  limit,
  serverTimestamp,
  setDoc
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

import {
  getMessaging,
  getToken,
  onMessage,
  isSupported
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-messaging.js";

export const NOTIFICATION_TYPES = [
  "new_order",
  "order_accepted",
  "order_status",
  "topup_review",
  "support_message",
  "system"
];

const FCM_VAPID_KEY =
  "BJi2lxS0joWxpmBthsYEpRBxOtc3T1scWdQzACWZQFEE1Pr_QqI2YwUWrL2lvG8D3AS6seU3mPWxS2wYOYGybNo";

let messagingInstance = null;
let foregroundListenerBound = false;

async function getMessagingInstance() {
  if (!messagingInstance) {
    messagingInstance = getMessaging();
  }
  return messagingInstance;
}

export async function initPushNotifications() {
  try {
    if (!("Notification" in window)) {
      return {
        success: false,
        supported: false
      };
    }

    const supported = await isSupported();

    if (!supported) {
      console.warn("Jwan: Firebase Messaging غير مدعوم.");
      return {
        success: false,
        supported: false
      };
    }

    const messaging = await getMessagingInstance();

    if (!foregroundListenerBound) {
      onMessage(messaging, (payload) => {
        console.log("Jwan foreground notification:", payload);

        const notification = payload?.notification || {};
        const data = payload?.data || {};

        if (Notification.permission !== "granted") {
          return;
        }

        try {
          new Notification(
            notification.title || "جوان",
            {
              body:
                notification.body ||
                "لديك إشعار جديد من جوان.",
              icon: "/assets/branding/logo-external.png",
              badge: "/assets/branding/logo-external.png",
              data
            }
          );
        } catch (error) {
          console.warn(
            "Jwan foreground notification display failed:",
            error
          );
        }
      });

      foregroundListenerBound = true;
    }

    return {
      success: true,
      supported: true
    };

  } catch (error) {
    console.warn(
      "Jwan push initialization skipped:",
      error
    );

    return {
      success: false,
      error
    };
  }
}

export async function enablePushNotifications() {
  try {
    if (!auth.currentUser) {
      throw new Error("يجب تسجيل الدخول أولًا.");
    }

    if (!("Notification" in window)) {
      throw new Error("الجهاز لا يدعم إشعارات النظام.");
    }

    if (!window.isSecureContext) {
      throw new Error(
        "الإشعارات تحتاج HTTPS أو localhost."
      );
    }

    let permission = Notification.permission;

    if (permission !== "granted") {
      permission = await Notification.requestPermission();
    }

    console.log(
      "JWAN notification permission:",
      permission
    );

    if (permission !== "granted") {
      throw new Error(
        "لم يتم السماح بالإشعارات. حالة الإذن: " +
        permission
      );
    }

    const supported = await isSupported();

    if (!supported) {
      throw new Error(
        "Firebase Messaging غير مدعوم في هذا المتصفح."
      );
    }

    await initPushNotifications();

    const messaging = await getMessagingInstance();

    if (!("serviceWorker" in navigator)) {
      throw new Error(
        "Service Worker غير مدعوم في هذا الجهاز."
      );
    }

    const registration =
      await navigator.serviceWorker.register("/sw.js");

    await navigator.serviceWorker.ready;

    const token = await getToken(messaging, {
      vapidKey: FCM_VAPID_KEY,
      serviceWorkerRegistration: registration
    });

    if (!token) {
      throw new Error(
        "تم السماح بالإشعارات لكن تعذر الحصول على FCM token."
      );
    }

    const uid = auth.currentUser.uid;

    await setDoc(
      doc(db, "fcmTokens", token),
      {
        uid,
        token,
        platform: "web",
        userAgent: navigator.userAgent,
        updatedAt: serverTimestamp()
      },
      {
        merge: true
      }
    );

    console.log(
      "Jwan FCM token registered:",
      token.slice(0, 18) + "..."
    );

    return {
      success: true,
      token
    };

  } catch (error) {
    console.error(
      "Jwan FCM error:",
      error
    );

    return {
      success: false,
      error
    };
  }
}

export async function createNotification(
  userId,
  type,
  title,
  body,
  createdBy
) {
  if (!userId) {
    throw new Error("userId مطلوب.");
  }

  if (!NOTIFICATION_TYPES.includes(type)) {
    throw new Error("نوع الإشعار غير معروف.");
  }

  return addDoc(
    collection(db, "notifications"),
    {
      userId,
      type,
      title,
      body,
      read: false,
      createdAt: serverTimestamp(),
      createdBy: createdBy || null
    }
  );
}

export function listenNotifications(
  uid,
  callback,
  max = 30
) {
  const q = query(
    collection(db, "notifications"),
    where("userId", "==", uid),
    orderBy("createdAt", "desc"),
    limit(max)
  );

  return onSnapshot(
    q,
    (snap) => {
      callback(
        snap.docs.map((d) => ({
          id: d.id,
          ...d.data()
        }))
      );
    },
    (error) => {
      console.error(
        "Jwan notifications listener error:",
        error
      );
    }
  );
}

export async function markNotificationRead(id) {
  if (!id) return;

  await updateDoc(
    doc(db, "notifications", id),
    {
      read: true
    }
  );
}
```

### js/support.js
```javascript
import { db } from "./firebase-config.js";
import {
  collection,
  doc,
  addDoc,
  updateDoc,
  onSnapshot,
  query,
  where,
  orderBy,
  serverTimestamp
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

export async function sendSupportMessage(userId, role, message) {
  const text = String(message || "").trim();
  if (!text) throw new Error("اكتب رسالتك أولًا");

  await addDoc(collection(db, "supportMessages"), {
    userId,
    role,
    message: text,
    reply: null,
    status: "open",
    createdAt: serverTimestamp(),
    repliedAt: null,
    repliedBy: null
  });
}

export function listenMySupportMessages(uid, callback) {
  const q = query(collection(db, "supportMessages"), where("userId", "==", uid), orderBy("createdAt", "desc"));
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}

// كل الرسائل، للإدارة.
export function listenAllSupportMessages(callback) {
  const q = query(collection(db, "supportMessages"), orderBy("createdAt", "desc"));
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}

export async function replySupportMessage(id, adminUid, reply) {
  const text = String(reply || "").trim();
  if (!text) throw new Error("اكتب الرد أولًا");

  await updateDoc(doc(db, "supportMessages", id), {
    reply: text,
    status: "answered",
    repliedAt: serverTimestamp(),
    repliedBy: adminUid
  });
}
```

### js/admin.js
```javascript
import { db, firebaseConfig } from "./firebase-config.js";
import {
  initializeApp,
  deleteApp
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-app.js";
import {
  getAuth,
  createUserWithEmailAndPassword,
  signOut
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-auth.js";
import {
  collection,
  doc,
  addDoc,
  getDoc,
  setDoc,
  updateDoc,
  deleteDoc,
  runTransaction,
  onSnapshot,
  query,
  where,
  orderBy,
  serverTimestamp
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";
import { validatePhone, validatePassword } from "./auth.js";

const DRIVER_ACTIVATION_BALANCE = 10000;

export async function writeAuditLog(admin, action, targetType, targetId, metadata = {}) {
  await addDoc(collection(db, "auditLogs"), {
    actorUid: admin.uid,
    actorRole: admin.role,
    action,
    targetType,
    targetId,
    metadata,
    createdAt: serverTimestamp()
  });
}

export function listenUsersByRole(role, callback) {
  const q = query(collection(db, "users"), where("role", "==", role));
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}

// موافقة على حساب معلّق. عند تفعيل سائق لأول مرة تُنشأ محفظته برصيد التفعيل،
// أما إن كانت محفظته موجودة أصلًا (إعادة تفعيل بعد إيقاف) فلا تُصفَّر.
export async function approveUser(admin, targetUser) {
  await updateDoc(doc(db, "users", targetUser.id), { status: "active" });

  if (targetUser.role === "driver") {
    const walletRef = doc(db, "wallets", targetUser.id);
    const existing = await getDoc(walletRef);
    if (!existing.exists()) {
      await setDoc(walletRef, {
        balance: DRIVER_ACTIVATION_BALANCE,
        totalCommission: 0,
        totalTopups: 0,
        totalWithdrawals: 0,
        totalCancellationPenalties: 0,
        updatedAt: serverTimestamp()
      });
    }
  }

  await writeAuditLog(admin, "approve_user", "user", targetUser.id, { role: targetUser.role });
}


// ============================================================
// الحذف المجاني من لوحة الإدارة
// يحذف ملف Firestore والمحفظة فقط.
// لا يحذف Firebase Authentication ولا الطلبات التاريخية.
// ============================================================
export async function deleteUserByAdmin(admin, targetUser) {
  if (!admin?.uid) {
    throw new Error("جلسة الإدارة غير صالحة.");
  }

  if (!targetUser?.id) {
    throw new Error("لم يتم تحديد المستخدم.");
  }

  if (targetUser.id === admin.uid) {
    throw new Error("لا يمكنك حذف حساب الإدارة الحالي.");
  }

  if (targetUser.role === "super_admin") {
    throw new Error("لا يمكن حذف حساب super_admin.");
  }

  if (
    admin.role !== "super_admin" &&
    targetUser.role === "admin"
  ) {
    throw new Error("لا يملك هذا المسؤول صلاحية حذف مدير آخر.");
  }

  await deleteDoc(doc(db, "users", targetUser.id));

  // حذف المحفظة إن وجدت.
  await deleteDoc(doc(db, "wallets", targetUser.id)).catch(() => {});

  await writeAuditLog(admin, "delete_user_firestore_only", "user", targetUser.id, {
    deletedRole: targetUser.role || null,
    deletedName: targetUser.name || null,
    deletedPhone: targetUser.phone || null,
    authenticationDeleted: false,
    ordersDeleted: false
  });

  return {
    success: true,
    uid: targetUser.id
  };
}

// ============================================================
// طلب إجبار المستخدم على تغيير كلمة المرور.
// لا يغيّر Firebase Authentication مباشرة.
// ============================================================
export async function requestPasswordChange(admin, targetUser) {
  if (!admin?.uid) {
    throw new Error("جلسة الإدارة غير صالحة.");
  }

  if (!targetUser?.id) {
    throw new Error("لم يتم تحديد المستخدم.");
  }

  if (targetUser.id === admin.uid) {
    throw new Error("لا يمكن تنفيذ هذا الإجراء على حسابك الحالي.");
  }

  if (targetUser.role === "super_admin") {
    throw new Error("لا يمكن تعديل حساب super_admin.");
  }

  if (
    admin.role !== "super_admin" &&
    targetUser.role === "admin"
  ) {
    throw new Error("لا يملك هذا المسؤول صلاحية تعديل مدير آخر.");
  }

  await updateDoc(doc(db, "users", targetUser.id), {
    mustChangePassword: true,
    passwordChangeRequestedAt: serverTimestamp(),
    passwordChangeRequestedBy: admin.uid
  });

  await writeAuditLog(
    admin,
    "request_password_change",
    "user",
    targetUser.id,
    {
      targetRole: targetUser.role || null,
      targetName: targetUser.name || null
    }
  );

  return { success: true, uid: targetUser.id };
}


// ============================================================
// الحذف المجاني من لوحة الإدارة
// يحذف ملف Firestore والمحفظة فقط.
// لا يحذف Firebase Authentication ولا الطلبات التاريخية.
// ============================================================
export async function deleteUserByAdmin(admin, targetUser) {
  if (!admin?.uid) {
    throw new Error("جلسة الإدارة غير صالحة.");
  }

  if (!targetUser?.id) {
    throw new Error("لم يتم تحديد المستخدم.");
  }

  if (targetUser.id === admin.uid) {
    throw new Error("لا يمكنك حذف حساب الإدارة الحالي.");
  }

  if (targetUser.role === "super_admin") {
    throw new Error("لا يمكن حذف حساب super_admin.");
  }

  if (
    admin.role !== "super_admin" &&
    targetUser.role === "admin"
  ) {
    throw new Error("لا يملك هذا المسؤول صلاحية حذف مدير آخر.");
  }

  await deleteDoc(doc(db, "users", targetUser.id));

  // حذف المحفظة إن وجدت.
  await deleteDoc(doc(db, "wallets", targetUser.id)).catch(() => {});

  await writeAuditLog(admin, "delete_user_firestore_only", "user", targetUser.id, {
    deletedRole: targetUser.role || null,
    deletedName: targetUser.name || null,
    deletedPhone: targetUser.phone || null,
    authenticationDeleted: false,
    ordersDeleted: false
  });

  return {
    success: true,
    uid: targetUser.id
  };
}

// ============================================================
// طلب إجبار المستخدم على تغيير كلمة المرور.
// لا يغيّر Firebase Authentication مباشرة.
// ============================================================
export async function requestPasswordChange(admin, targetUser) {
  if (!admin?.uid) {
    throw new Error("جلسة الإدارة غير صالحة.");
  }

  if (!targetUser?.id) {
    throw new Error("لم يتم تحديد المستخدم.");
  }

  if (targetUser.id === admin.uid) {
    throw new Error("لا يمكن تنفيذ هذا الإجراء على حسابك الحالي.");
  }

  if (targetUser.role === "super_admin") {
    throw new Error("لا يمكن تعديل حساب super_admin.");
  }

  if (
    admin.role !== "super_admin" &&
    targetUser.role === "admin"
  ) {
    throw new Error("لا يملك هذا المسؤول صلاحية تعديل مدير آخر.");
  }

  await updateDoc(doc(db, "users", targetUser.id), {
    mustChangePassword: true,
    passwordChangeRequestedAt: serverTimestamp(),
    passwordChangeRequestedBy: admin.uid
  });

  await writeAuditLog(
    admin,
    "request_password_change",
    "user",
    targetUser.id,
    {
      targetRole: targetUser.role || null,
      targetName: targetUser.name || null
    }
  );

  return { success: true, uid: targetUser.id };
}

export function listenAllTopupRequests(callback) {
  const q = query(collection(db, "topupRequests"), orderBy("submittedAt", "desc"));
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}

export async function reviewTopupRequest(admin, requestId, approve, note) {
  await runTransaction(db, async (tx) => {
    const reqRef = doc(db, "topupRequests", requestId);
    const reqSnap = await tx.get(reqRef);
    if (!reqSnap.exists()) throw new Error("الطلب غير موجود");
    const request = reqSnap.data();
    if (request.status !== "pending") throw new Error("تمت مراجعة هذا الطلب مسبقًا");

    tx.update(reqRef, {
      status: approve ? "approved" : "rejected",
      reviewedAt: serverTimestamp(),
      reviewedBy: admin.uid,
      reviewNote: note || null
    });

    if (approve) {
      const walletRef = doc(db, "wallets", request.driverId);
      const walletSnap = await tx.get(walletRef);
      const wallet = walletSnap.exists() ? walletSnap.data() : { balance: 0, totalTopups: 0 };
      const before = Number(wallet.balance || 0);
      const after = before + Number(request.amount || 0);

      tx.update(walletRef, {
        balance: after,
        totalTopups: Number(wallet.totalTopups || 0) + Number(request.amount || 0),
        updatedAt: serverTimestamp(),
        lastTopupRequestId: requestId
      });

      const txRef = doc(collection(db, "walletTransactions"));
      tx.set(txRef, {
        userId: request.driverId,
        type: "topup",
        amount: request.amount,
        balanceBefore: before,
        balanceAfter: after,
        orderId: null,
        topupRequestId: requestId,
        createdAt: serverTimestamp(),
        createdBy: admin.uid
      });
    }
  });

  await writeAuditLog(admin, `review_topup:${approve ? "approve" : "reject"}`, "topupRequest", requestId, {});
}


// شحن مباشر لمحفظة سائق من لوحة الإدارة.
// يتم تحديث المحفظة وتسجيل الحركة المالية داخل Transaction واحدة.
export async function manualTopupDriver(admin, driverId, amount, note = "") {
  const numericAmount = Number(amount);

  if (!driverId) throw new Error("يجب اختيار السائق");
  if (!Number.isFinite(numericAmount) || numericAmount <= 0) {
    throw new Error("مبلغ الشحن غير صحيح");
  }

  await runTransaction(db, async (tx) => {
    const userRef = doc(db, "users", driverId);
    const walletRef = doc(db, "wallets", driverId);
    const transactionRef = doc(collection(db, "walletTransactions"));

    const userSnap = await tx.get(userRef);
    if (!userSnap.exists()) throw new Error("السائق غير موجود");

    const driver = userSnap.data();
    if (driver.role !== "driver") throw new Error("الحساب المحدد ليس سائقًا");
    if (driver.status !== "active") throw new Error("لا يمكن شحن سائق غير نشط");

    const walletSnap = await tx.get(walletRef);
    if (!walletSnap.exists()) throw new Error("محفظة السائق غير موجودة");

    const wallet = walletSnap.data();
    const before = Number(wallet.balance || 0);
    const after = before + numericAmount;

    tx.update(walletRef, {
      balance: after,
      totalTopups: Number(wallet.totalTopups || 0) + numericAmount,
      updatedAt: serverTimestamp(),
      lastManualTopupId: transactionRef.id
    });

    tx.set(transactionRef, {
      userId: driverId,
      type: "manual_topup",
      amount: numericAmount,
      balanceBefore: before,
      balanceAfter: after,
      orderId: null,
      topupRequestId: null,
      withdrawalRequestId: null,
      manualTopupId: transactionRef.id,
      note: String(note || ""),
      createdAt: serverTimestamp(),
      createdBy: admin.uid
    });
  });

  await writeAuditLog(admin, "manual_topup", "wallet", driverId, {
    amount: numericAmount,
    note: String(note || "")
  });
}

export function listenAllWithdrawalRequests(callback) {
  const q = query(collection(db, "withdrawalRequests"), orderBy("createdAt", "desc"));
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}

export async function reviewWithdrawalRequest(admin, requestId, status) {
  await runTransaction(db, async (tx) => {
    const reqRef = doc(db, "withdrawalRequests", requestId);
    const reqSnap = await tx.get(reqRef);
    if (!reqSnap.exists()) throw new Error("الطلب غير موجود");
    const request = reqSnap.data();
    if (request.status !== "pending") throw new Error("تمت مراجعة هذا الطلب مسبقًا");

    tx.update(reqRef, {
      status,
      reviewedAt: serverTimestamp(),
      reviewedBy: admin.uid
    });

    if (status === "paid") {
      const walletRef = doc(db, "wallets", request.driverId);
      const walletSnap = await tx.get(walletRef);
      const wallet = walletSnap.exists() ? walletSnap.data() : { balance: 0, totalWithdrawals: 0 };
      const before = Number(wallet.balance || 0);
      const amount = Number(request.amount || 0);
      if (before < amount) throw new Error("الرصيد غير كافٍ لتنفيذ السحب");
      const after = before - amount;

      tx.update(walletRef, {
        balance: after,
        totalWithdrawals: Number(wallet.totalWithdrawals || 0) + amount,
        updatedAt: serverTimestamp(),
        lastWithdrawalRequestId: requestId
      });

      const txRef = doc(collection(db, "walletTransactions"));
      tx.set(txRef, {
        userId: request.driverId,
        type: "withdrawal",
        amount: -request.amount,
        balanceBefore: before,
        balanceAfter: after,
        orderId: null,
        topupRequestId: null,
        withdrawalRequestId: requestId,
        createdAt: serverTimestamp(),
        createdBy: admin.uid
      });
    }
  });

  await writeAuditLog(admin, `review_withdrawal:${status}`, "withdrawalRequest", requestId, {});
}

export function listenManagers(callback) {
  const q = query(collection(db, "users"), where("role", "in", ["admin", "super_admin"]));
  return onSnapshot(q, (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))));
}

// إنشاء حساب مدير جديد بواسطة الإدارة العليا، بدون تسجيل خروج الحساب الحالي.
// يُستخدم تطبيق Firebase ثانوي مؤقت فقط لإنشاء حساب الدخول، ثم يُحذف فورًا.
export async function createManager(superAdmin, name, phone, password) {
  if (!validatePhone(phone)) throw new Error("رقم الهاتف يجب أن يكون 10 أرقام فقط");
  if (!validatePassword(password)) throw new Error("كلمة المرور يجب أن تكون 6 أحرف على الأقل");

  const secondaryApp = initializeApp(firebaseConfig, `manager-creation-${Date.now()}`);
  const secondaryAuth = getAuth(secondaryApp);

  try {
    const credential = await createUserWithEmailAndPassword(secondaryAuth, `${phone}@jawan.app`, password);
    const uid = credential.user.uid;
    await signOut(secondaryAuth);

    await setDoc(doc(db, "users", uid), {
      role: "admin",
      name,
      phone,
      address: null,
      status: "active",
      privacyAccepted: true,
      termsAccepted: true,
      createdAt: serverTimestamp(),
      lastActiveAt: serverTimestamp()
    });

    await writeAuditLog(superAdmin, "create_manager", "user", uid, { phone });
    return uid;
  } finally {
    await deleteApp(secondaryApp).catch(() => {});
  }
}

export async function setManagerRole(superAdmin, targetUser, newRole) {
  if (targetUser.id === superAdmin.uid) throw new Error("لا يمكنك تعديل صلاحيتك الخاصة");
  await updateDoc(doc(db, "users", targetUser.id), { role: newRole });
  await writeAuditLog(superAdmin, `set_manager_role:${newRole}`, "user", targetUser.id, {});
}

export async function suspendManager(superAdmin, targetUser) {
  if (targetUser.id === superAdmin.uid) throw new Error("لا يمكنك إيقاف حسابك الخاص");
  await setUserStatus(superAdmin, targetUser, "suspended");
}

// تحليلات مبنية على الطلبات المحمّلة أصلاً في لوحة الإدارة، بدون قراءات إضافية.
export function computeAnalytics(orders, users) {
  const completed = orders.filter((o) => o.status === "completed");
  const byDriver = {};
  const byCustomer = {};
  let totalMinutes = 0;
  let timedOrders = 0;
  const driverActiveDays = {};

  for (const o of completed) {
    if (o.driverId) {
      byDriver[o.driverId] = byDriver[o.driverId] || { count: 0, totalMinutes: 0, timed: 0 };
      byDriver[o.driverId].count += 1;

      if (o.acceptedAt?.toDate && o.completedAt?.toDate) {
        const minutes = (o.completedAt.toDate() - o.acceptedAt.toDate()) / 60000;
        if (minutes >= 0) {
          byDriver[o.driverId].totalMinutes += minutes;
          byDriver[o.driverId].timed += 1;
          totalMinutes += minutes;
          timedOrders += 1;
        }
      }

      if (o.completedAt?.toDate) {
        const day = o.completedAt.toDate().toISOString().slice(0, 10);
        driverActiveDays[o.driverId] = driverActiveDays[o.driverId] || new Set();
        driverActiveDays[o.driverId].add(day);
      }
    }

    if (o.customerId) {
      byCustomer[o.customerId] = byCustomer[o.customerId] || { count: 0, spent: 0 };
      byCustomer[o.customerId].count += 1;
      byCustomer[o.customerId].spent += Number(o.deliveryFee || 0);
    }
  }

  const nameOf = (uid) => users.find((u) => u.id === uid)?.name || "—";

  const topDriverEntry = Object.entries(byDriver).sort((a, b) => b[1].count - a[1].count)[0];
  const fastestDriverEntry = Object.entries(byDriver)
    .filter(([, v]) => v.timed > 0)
    .sort((a, b) => a[1].totalMinutes / a[1].timed - b[1].totalMinutes / b[1].timed)[0];
  const topCustomerByCountEntry = Object.entries(byCustomer).sort((a, b) => b[1].count - a[1].count)[0];
  const topCustomerBySpendEntry = Object.entries(byCustomer).sort((a, b) => b[1].spent - a[1].spent)[0];

  return {
    topDriver: topDriverEntry ? { name: nameOf(topDriverEntry[0]), count: topDriverEntry[1].count } : null,
    fastestDriver: fastestDriverEntry
      ? { name: nameOf(fastestDriverEntry[0]), minutes: Math.round(fastestDriverEntry[1].totalMinutes / fastestDriverEntry[1].timed) }
      : null,
    topCustomerByOrders: topCustomerByCountEntry
      ? { name: nameOf(topCustomerByCountEntry[0]), count: topCustomerByCountEntry[1].count }
      : null,
    topCustomerBySpend: topCustomerBySpendEntry
      ? { name: nameOf(topCustomerBySpendEntry[0]), spent: topCustomerBySpendEntry[1].spent }
      : null,
    avgDeliveryMinutes: timedOrders ? Math.round(totalMinutes / timedOrders) : null,
    driverActiveDays: Object.fromEntries(
      Object.entries(driverActiveDays).map(([uid, days]) => [nameOf(uid), days.size])
    )
  };
}
```

### js/common.js
```javascript
export function showToast(message) {
  let el = document.querySelector(".toast");
  if (!el) {
    el = document.createElement("div");
    el.className = "toast";
    document.body.appendChild(el);
  }
  el.textContent = message;
  el.classList.add("show");
  clearTimeout(window.__toastTimer);
  window.__toastTimer = setTimeout(() => el.classList.remove("show"), 2600);
}

export function normalizePhone(value) {
  return String(value || "").replace(/\D/g, "").slice(0, 10);
}

export function formatMoney(value) {
  return Number(value || 0).toLocaleString("ar-SD") + " ج.س";
}

export function statusLabel(status) {
  const map = {
    pending: "بانتظار سائق",
    accepted: "تم قبول الطلب",
    delivering: "قيد التوصيل",
    awaiting_confirmation: "بانتظار التأكيد",
    completed: "مكتمل",
    cancelled: "ملغي",
    rejected: "مرفوض"
  };
  return map[status] || status;
}

export function statusBadgeClass(status) {
  if (["completed", "active", "approved", "paid", "answered"].includes(status)) return "badge badge-ok";
  if (["cancelled", "rejected", "suspended"].includes(status)) return "badge badge-danger";
  if (["pending", "open"].includes(status)) return "badge badge-pending";
  return "badge badge-info";
}

export function accountStatusLabel(status) {
  const map = {
    pending: "بانتظار المراجعة",
    active: "مفعّل",
    suspended: "موقوف",
    rejected: "مرفوض"
  };
  return map[status] || status;
}

// يمنع أي نص قادم من المستخدم (اسم، وصف طلب، رسالة دعم...) من التحول
// إلى HTML عند إدراجه داخل الصفحة عبر innerHTML.
export function escapeHtml(value) {
  return String(value ?? "").replace(/[&<>"']/g, (ch) => ({
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#39;"
  }[ch]));
}

export function formatDate(value) {
  const date = value && typeof value.toDate === "function" ? value.toDate() : value;
  if (!(date instanceof Date) || isNaN(date)) return "—";
  return date.toLocaleString("ar-SD", { dateStyle: "short", timeStyle: "short" });
}

export function openWhatsApp(message = "") {
  const encoded = encodeURIComponent(message);
  window.open(`https://wa.me/249964499266?text=${encoded}`, "_blank", "noopener");
}
```

### js/driver-menu.js
```javascript
(() => {
  const DRIVER_PAGES = new Set([
    "driver.html",
    "driver-orders.html",
    "driver-analytics.html"
  ]);

  const currentPage =
    location.pathname.split("/").pop() || "index.html";

  if (!DRIVER_PAGES.has(currentPage)) return;

  function initDriverMenu() {
    if (document.getElementById("jawanDriverMobileBar")) return;

    const oldBars = document.querySelectorAll(
      "body > header.mobilebar, body > header.driver-mobilebar"
    );

    oldBars.forEach((el) => el.remove());

    const header = document.createElement("header");
    header.id = "jawanDriverMobileBar";
    header.className = "jawan-driver-fixedbar";

    header.innerHTML = `
      <div class="driver-mobile-brand">
        <strong>جوان</strong>
        <span>السائق</span>
      </div>

      <button
        id="driverMenuBtn"
        class="driver-menu-btn"
        type="button"
        aria-label="فتح قائمة السائق"
        aria-expanded="false"
      >
        <svg viewBox="0 0 24 24" fill="none"
             stroke="currentColor"
             stroke-width="2"
             stroke-linecap="round">
          <path d="M4 6h16"></path>
          <path d="M4 12h16"></path>
          <path d="M4 18h16"></path>
        </svg>
      </button>
    `;

    const backdrop = document.createElement("div");
    backdrop.id = "driverMenuBackdrop";
    backdrop.className = "driver-menu-backdrop";

    const menu = document.createElement("aside");
    menu.id = "driverMenu";
    menu.className = "driver-menu";
    menu.setAttribute("aria-hidden", "true");

    menu.innerHTML = `
      <div class="driver-menu-head">
        <div>
          <strong>قائمة السائق</strong>
          <small>جوان للتوصيل</small>
        </div>

        <button
          id="driverMenuClose"
          class="icon-btn"
          type="button"
          aria-label="إغلاق"
        >×</button>
      </div>

      <nav class="driver-menu-links">

        <a href="driver.html">
          <span>لوحتي</span>
        </a>

        <a href="driver-orders.html">
          <span>طلباتي السابقة</span>
        </a>

        <a href="driver-analytics.html">
          <span>تحليلاتي</span>
        </a>

        <a href="wallet.html">
          <span>المحفظة</span>
        </a>

        <a href="support.html">
          <span>الدعم داخل التطبيق</span>
        </a>

        <a href="change-password.html">
          <span>تغيير كلمة المرور</span>
        </a>

        <a href="driver-profile.html">
          <span>ملفي وبياناتي</span>
        </a>

        <a
          data-whatsapp="contact"
          href="#"
        >
          <span>راسلنا على واتساب</span>
        </a>

      </nav>
    `;

    document.body.prepend(header);
    document.body.appendChild(backdrop);
    document.body.appendChild(menu);

    document.body.classList.add("has-jawan-driver-menu");

    const btn =
      document.getElementById("driverMenuBtn");

    const closeBtn =
      document.getElementById("driverMenuClose");

    function closeMenu() {
      menu.classList.remove("open");
      backdrop.classList.remove("open");

      menu.setAttribute(
        "aria-hidden",
        "true"
      );

      btn?.setAttribute(
        "aria-expanded",
        "false"
      );

      document.body.classList.remove(
        "driver-menu-open"
      );
    }

    function openMenu() {
      menu.classList.add("open");
      backdrop.classList.add("open");

      menu.setAttribute(
        "aria-hidden",
        "false"
      );

      btn?.setAttribute(
        "aria-expanded",
        "true"
      );

      document.body.classList.add(
        "driver-menu-open"
      );
    }

    btn?.addEventListener(
      "click",
      (event) => {
        event.preventDefault();
        event.stopPropagation();

        if (menu.classList.contains("open")) {
          closeMenu();
        } else {
          openMenu();
        }
      }
    );

    closeBtn?.addEventListener(
      "click",
      closeMenu
    );

    backdrop.addEventListener(
      "click",
      closeMenu
    );

    menu
      .querySelectorAll("a")
      .forEach((link) => {
        link.addEventListener(
          "click",
          closeMenu
        );
      });

    document.addEventListener(
      "keydown",
      (event) => {
        if (event.key === "Escape") {
          closeMenu();
        }
      }
    );

    const active =
      menu.querySelector(
        `a[href="${currentPage}"]`
      );

    active?.classList.add("active");
  }

  if (
    document.readyState === "loading"
  ) {
    document.addEventListener(
      "DOMContentLoaded",
      initDriverMenu,
      { once: true }
    );
  } else {
    initDriverMenu();
  }
})();
```

### js/admin-menu.js
```javascript
(() => {
  const ADMIN_PAGES = new Set([
    "admin.html",
    "admin-orders.html",
    "admin-users.html",
    "admin-topups.html",
    "admin-withdrawals.html",
    "admin-analytics.html",
    "admin-managers.html"
  ]);

  const currentPage =
    location.pathname.split("/").pop() || "index.html";

  if (!ADMIN_PAGES.has(currentPage)) return;

  function init() {
    if (
      document.getElementById(
        "jawanAdminMobileBar"
      )
    ) {
      return;
    }

    /*
     * إزالة أي قائمة إدارية قديمة
     * حتى لا توجد قائمتان فوق بعضهما.
     */

    document
      .querySelectorAll(
        "#adminMenuBtn," +
        "#adminMenuOverlay," +
        "#adminHamburger"
      )
      .forEach((el) => {
        if (
          el.closest("body")
        ) {
          const parent =
            el.closest(
              "header,nav,div"
            );

          if (
            parent &&
            (
              parent.id ===
                "adminHamburger" ||
              parent.id ===
                "adminMenuOverlay"
            )
          ) {
            parent.remove();
          } else {
            el.remove();
          }
        }
      });

    const oldHeader =
      document.querySelector(
        "body > header.mobilebar"
      );

    oldHeader?.remove();

    const bar =
      document.createElement("header");

    bar.id =
      "jawanAdminMobileBar";

    bar.className =
      "admin-mobilebar";

    bar.innerHTML = `
      <div class="admin-mobile-brand">
        <div class="brand-mark">
          <img
            src="/assets/branding/logo-external.png"
            alt="جوان للتوصيل"
          >
        </div>

        <strong>
          جوان — الإدارة
        </strong>
      </div>

      <button
        type="button"
        class="admin-menu-btn"
        id="jawanAdminMenuBtn"
        aria-label="فتح قائمة الإدارة"
        aria-expanded="false"
      >
        <svg viewBox="0 0 24 24">
          <path
            d="M4 6h16M4 12h16M4 18h16"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
          />
        </svg>
      </button>
    `;

    const overlay =
      document.createElement("div");

    overlay.id =
      "jawanAdminMenuOverlay";

    overlay.className =
      "admin-menu-overlay";

    const menu =
      document.createElement("aside");

    menu.id =
      "jawanAdminMenu";

    menu.className =
      "admin-hamburger";

    menu.setAttribute(
      "aria-hidden",
      "true"
    );

    menu.innerHTML = `
      <div class="admin-menu-header">

        <div class="brand-mark">
          <img
            src="/assets/branding/logo-external.png"
            alt="جوان للتوصيل"
          >
        </div>

        <div>
          <strong>
            جوان للتوصيل
          </strong>

          <small>
            الإدارة
          </small>
        </div>

      </div>

      <div class="admin-menu-head">

        <strong>
          قائمة الإدارة
        </strong>

        <button
          type="button"
          id="jawanAdminMenuClose"
          class="icon-btn"
          aria-label="إغلاق"
        >×</button>

      </div>

      <div class="admin-menu-links">

        <a href="admin.html">
          لوحة الإدارة
        </a>

        <a href="admin-orders.html">
          كل الطلبات
        </a>

        <a href="admin-users.html">
          المستخدمون والسائقون
        </a>

        <a href="admin-topups.html">
          شحن المحافظ
        </a>

        <a href="admin-withdrawals.html">
          السحوبات
        </a>

        <a href="admin-analytics.html">
          التحليلات
        </a>

        <a href="admin-managers.html">
          إدارة المدراء
        </a>

        <a href="support.html">
          الدعم
        </a>

      </div>

      <div class="admin-menu-footer">

        <button
          type="button"
          id="jawanAdminLogout"
        >
          تسجيل الخروج
        </button>

      </div>
    `;

    document.body.prepend(bar);
    document.body.appendChild(overlay);
    document.body.appendChild(menu);

    const btn =
      document.getElementById(
        "jawanAdminMenuBtn"
      );

    const closeBtn =
      document.getElementById(
        "jawanAdminMenuClose"
      );

    function closeMenu() {

      menu.classList.remove("open");

      overlay.classList.remove("open");

      menu.setAttribute(
        "aria-hidden",
        "true"
      );

      btn?.setAttribute(
        "aria-expanded",
        "false"
      );

      document.body.classList.remove(
        "admin-menu-open"
      );
    }

    function openMenu() {

      menu.classList.add("open");

      overlay.classList.add("open");

      menu.setAttribute(
        "aria-hidden",
        "false"
      );

      btn?.setAttribute(
        "aria-expanded",
        "true"
      );

      document.body.classList.add(
        "admin-menu-open"
      );
    }

    btn?.addEventListener(
      "click",
      (event) => {

        event.preventDefault();
        event.stopPropagation();

        menu.classList.contains("open")
          ? closeMenu()
          : openMenu();
      }
    );

    closeBtn?.addEventListener(
      "click",
      closeMenu
    );

    overlay.addEventListener(
      "click",
      closeMenu
    );

    menu
      .querySelectorAll("a")
      .forEach((link) => {
        link.addEventListener(
          "click",
          closeMenu
        );
      });

    document.addEventListener(
      "keydown",
      (event) => {
        if (event.key === "Escape") {
          closeMenu();
        }
      }
    );

    document
      .getElementById(
        "jawanAdminLogout"
      )
      ?.addEventListener(
        "click",
        async () => {

          try {

            const {
              logoutUser
            } = await import(
              "./auth.js"
            );

            await logoutUser();

          } finally {

            location.href =
              "login.html";
          }
        }
      );

    const active =
      menu.querySelector(
        `a[href="${currentPage}"]`
      );

    active?.classList.add(
      "active"
    );
  }

  if (
    document.readyState ===
    "loading"
  ) {
    document.addEventListener(
      "DOMContentLoaded",
      init,
      { once: true }
    );
  } else {
    init();
  }
})();
```

## 12. Current Flutter diff against HEAD
```text
```

## END AUDIT
