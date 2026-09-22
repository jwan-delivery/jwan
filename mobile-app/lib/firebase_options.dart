import 'package:firebase_core/firebase_core.dart';

/// Shared Firebase project configuration.
///
/// Supply FIREBASE_ANDROID_APP_ID at build time after registering the Android
/// package in Firebase. Do not commit generated signing credentials or other
/// private secrets to source control.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    const appId = String.fromEnvironment('FIREBASE_ANDROID_APP_ID');
    if (appId.isEmpty) {
      throw StateError(
        'Missing FIREBASE_ANDROID_APP_ID. Register the Android app in Firebase '
        'and pass its app id with --dart-define.',
      );
    }

    return const FirebaseOptions(
      apiKey: 'AIzaSyDQKVd7QlaLfNyZyIdtHbS91wVtSd1QeuM',
      appId: appId,
      messagingSenderId: '22978141935',
      projectId: 'jwan-delivery-c930d-72911',
      storageBucket: 'jwan-delivery-c930d-72911.firebasestorage.app',
    );
  }
}
