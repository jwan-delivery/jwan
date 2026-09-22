import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'native_entry.dart';

const _black = kAyezBlack;
const _yellow = kAyezYellow;
const _background = kAyezBlack;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AyezNativeBootstrap());
}

class AyezNativeBootstrap extends StatefulWidget {
  const AyezNativeBootstrap({super.key});

  @override
  State<AyezNativeBootstrap> createState() => _AyezNativeBootstrapState();
}

class _AyezNativeBootstrapState extends State<AyezNativeBootstrap> {
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
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).timeout(const Duration(seconds: 15));
      }
      try {
        await FirebaseAppCheck.instance.activate(
          providerAndroid: const bool.fromEnvironment('JAWAN_APPCHECK_DEBUG', defaultValue: false)
              ? AndroidDebugProvider()
              : AndroidPlayIntegrityProvider(),
        );
      } catch (_) {}
      try {
        FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
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
    if (_error != null) return _StartupErrorPage(error: _error!, retry: _retry);

    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _background,
      colorScheme: ColorScheme.fromSeed(seedColor: _yellow, brightness: Brightness.dark),
      fontFamily: GoogleFonts.cairo().fontFamily,
      appBarTheme: const AppBarTheme(backgroundColor: _black, foregroundColor: Colors.white, elevation: 0),
      snackBarTheme: SnackBarThemeData(backgroundColor: const Color(0xFF242424), contentTextStyle: GoogleFonts.cairo(color: Colors.white)),
      inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'عايز',
      theme: base.copyWith(textTheme: GoogleFonts.cairoTextTheme(base.textTheme)),
      home: const Directionality(textDirection: TextDirection.rtl, child: AyezEntry()),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }
  } catch (_) {}
}

class _StartupPage extends StatelessWidget {
  const _StartupPage();
  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: _black,
          body: Center(child: CircularProgressIndicator(color: _yellow, strokeWidth: 3)),
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
          backgroundColor: _black,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: kAyezBlack2, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0x16FFFFFF))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off_rounded, color: _yellow, size: 48),
                      const SizedBox(height: 14),
                      Text('تعذر تشغيل عايز', style: GoogleFonts.cairo(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      Text('تحقق من الإنترنت ثم أعد المحاولة.', textAlign: TextAlign.center, style: GoogleFonts.cairo(color: kAyezGray)),
                      const SizedBox(height: 8),
                      Text(error.toString(), textAlign: TextAlign.center, style: const TextStyle(color: kAyezGrayDark, fontSize: 11)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(onPressed: retry, icon: const Icon(Icons.refresh, color: Colors.black), label: const Text('إعادة المحاولة'), style: ElevatedButton.styleFrom(backgroundColor: _yellow, foregroundColor: Colors.black)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
