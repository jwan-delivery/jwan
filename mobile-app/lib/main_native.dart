import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'main.dart' as legacy;

const _black = Color(0xFF0B0B0B);
const _yellow = Color(0xFFF5C400);
const _background = Color(0xFFF7F7F7);

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
        // App Check must never leave the application stuck on the splash.
      }

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
    if (_error != null) {
      return _StartupErrorPage(error: _error!, retry: _retry);
    }

    final theme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _yellow,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _black,
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'جوان للتوصيل',
      theme: theme.copyWith(
        textTheme: GoogleFonts.cairoTextTheme(theme.textTheme),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: legacy.AuthGate(),
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
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
          backgroundColor: _black,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: AssetImage('assets/branding/jawan-logo.png'),
                  width: 112,
                  height: 112,
                  fit: BoxFit.contain,
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
                CircularProgressIndicator(
                  color: _yellow,
                  strokeWidth: 3,
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
          backgroundColor: _background,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          image: const AssetImage(
                            'assets/branding/jawan-logo.png',
                          ),
                          width: 90,
                          height: 90,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'تعذر تشغيل جوان',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'تحقق من الإنترنت ثم أعد المحاولة.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 11),
                        ),
                        const SizedBox(height: 18),
                        FilledButton.icon(
                          onPressed: retry,
                          icon: const Icon(Icons.refresh),
                          label: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
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
