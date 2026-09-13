#!/data/data/com.termux/files/usr/bin/bash
set -e

BRANCH="flutter-native-20260913"

echo "==> Creating Flutter branch"
git checkout -b "$BRANCH" 2>/dev/null || git checkout "$BRANCH"

echo "==> Creating directories"
mkdir -p mobile-app/lib
mkdir -p .github/workflows

cat > mobile-app/flutter_spec.yaml <<'YAML'
name: jawan_flutter
description: Jawan Delivery native Flutter Android application
publish_to: "none"

version: 1.0.0+1

environment:
  sdk: ">=3.5.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
YAML

cat > mobile-app/lib/main.dart <<'DART'
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JawanApp());
}

class JawanApp extends StatelessWidget {
  const JawanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'جوان للتوصيل',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans',
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC400),
          brightness: Brightness.light,
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: JawanHomePage(),
      ),
    );
  }
}

class JawanHomePage extends StatelessWidget {
  const JawanHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'جوان للتوصيل',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      drawer: const JawanDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أهلاً بك في جوان',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'توصيل أسرع وأسهل في بورتسودان',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _ActionCard(
            icon: Icons.local_shipping_outlined,
            title: 'إنشاء طلب',
            subtitle: 'اطلب خدمة توصيل جديدة',
          ),
          _ActionCard(
            icon: Icons.receipt_long_outlined,
            title: 'طلباتي',
            subtitle: 'تابع حالة طلباتك',
          ),
          _ActionCard(
            icon: Icons.notifications_none,
            title: 'الإشعارات',
            subtitle: 'آخر التنبيهات والتحديثات',
          ),
          _ActionCard(
            icon: Icons.support_agent,
            title: 'الدعم',
            subtitle: 'تواصل مع جوان',
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFFC400),
          foregroundColor: Colors.black,
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_left),
      ),
    );
  }
}

class JawanDrawer extends StatelessWidget {
  const JawanDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              color: Colors.black,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'جوان',
                    style: TextStyle(
                      color: Color(0xFFFFC400),
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'للتوصيل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('الرئيسية'),
              onTap: () => Navigator.pop(context),
            ),
            const ListTile(
              leading: Icon(Icons.local_shipping_outlined),
              title: Text('طلباتي'),
            ),
            const ListTile(
              leading: Icon(Icons.notifications_none),
              title: Text('الإشعارات'),
            ),
            const ListTile(
              leading: Icon(Icons.support_agent),
              title: Text('الدعم'),
            ),
            const ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('حسابي'),
            ),
          ],
        ),
      ),
    );
  }
}
DART

cat > .github/workflows/flutter-apk.yml <<'YAML'
name: Build Jawan Flutter APK

on:
  workflow_dispatch:
  push:
    branches:
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

      - name: Create Flutter project
        run: |
          rm -rf mobile-app/lib mobile-app/android mobile-app/ios mobile-app/test mobile-app/web mobile-app/linux mobile-app/macos mobile-app/windows
          mv mobile-app/flutter_spec.yaml /tmp/flutter_spec.yaml

          flutter create \
            --org sd.jawan.delivery \
            --project-name jawan_flutter \
            --platforms android \
            mobile-app

          mv /tmp/flutter_spec.yaml mobile-app/flutter_spec.yaml

      - name: Copy application code
        run: |
          cp mobile-app/flutter_spec.yaml /tmp/flutter_spec.yaml
          cp mobile-app/lib/main.dart mobile-app/lib/main.dart

      - name: Install dependencies
        working-directory: mobile-app
        run: flutter pub get

      - name: Analyze
        working-directory: mobile-app
        run: flutter analyze

      - name: Test
        working-directory: mobile-app
        run: flutter test

      - name: Build debug APK
        working-directory: mobile-app
        run: flutter build apk --debug

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: jawan-flutter-debug-apk
          path: mobile-app/build/app/outputs/flutter-apk/app-debug.apk
          if-no-files-found: error
YAML

echo "==> Removing accidental generated artifacts if any"
rm -rf .jawan-backups
rm -f add_admin_menu.sh

echo "==> Git status"
git status --short

echo "==> Commit"
git add mobile-app/lib/main.dart mobile-app/flutter_spec.yaml .github/workflows/flutter-apk.yml
git commit -m "feat: bootstrap native Flutter Android app"

echo "==> Push"
git push -u origin "$BRANCH"

echo
echo "DONE"
echo "Branch: $BRANCH"
echo
echo "Open GitHub -> Actions -> Build Jawan Flutter APK"
