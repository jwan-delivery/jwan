import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'main.dart' as legacy;

/// Native Android entrypoint for the Jawan Flutter application.
///
/// The Android APK intentionally boots the same complete Flutter application
/// implemented in `main.dart`, so the native build does not fork business
/// logic or lose customer/driver/admin capabilities.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JawanNativeBootstrap());
}

class JawanNativeBootstrap extends StatefulWidget {
  const JawanNativeBootstrap({super.key});

  @override
  State<JawanNativeBootstrap> createState() => _JawanNativeBootstrapState();
}

class _JawanNativeBootstrapState extends State<JawanNativeBootstrap> {
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ).timeout(const Duration(seconds: 15));
      }

      // Keep App Check enabled for release builds. Debug builds can opt into
      // the debug provider through the same CI dart-define already supported.
      try {
        await FirebaseAppCheck.instance.activate(
          androidProvider: const bool.fromEnvironment(
            'JAWAN_APPCHECK_DEBUG',
            defaultValue: false,
          )
              ? AndroidProvider.debug
              : AndroidProvider.playIntegrity,
        );
      } catch (_) {
        // App Check must not leave the whole UI stuck at the splash screen.
      }

      try {
        FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler,
        );
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e;
      });
    }
  }

  void _retry() {
    setState(() {
      _loading = true;
      _error = null;
    });
    unawaited(_initialize());
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const _StartupPage();
    if (_error != null) {
      return _StartupErrorPage(error: _error!, retry: _retry);
    }

    // IMPORTANT: use the complete Flutter app rather than the reduced native
    // shell. This preserves the same order lifecycle, negotiation, delivery,
    // wallet, rating, notifications, support and admin flows in the APK.
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: legacy.JawanApp(),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (_) {}
}

class _StartupPage extends StatelessWidget {
  const _StartupPage();

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xFF0B0B0B),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_shipping_rounded,
                  size: 72,
                  color: Color(0xFFFFC400),
                ),
                SizedBox(height: 16),
                Text(
                  'جوان للتوصيل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 18),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xFFFFC400),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _StartupErrorPage extends StatelessWidget {
  final Object error;
  final VoidCallback retry;

  const _StartupErrorPage({required this.error, required this.retry});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFF7F7F7),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off, size: 54),
                        const SizedBox(height: 12),
                        const Text(
                          'تعذر تشغيل جوان',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'تحقق من اتصال الإنترنت ثم أعد المحاولة.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        SelectableText(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 18),
                        FilledButton.icon(
                          onPressed: retry,
                          icon: const Icon(Icons.refresh),
                          label: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
