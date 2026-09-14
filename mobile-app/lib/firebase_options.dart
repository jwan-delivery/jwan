import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  // The project's known-good public web configuration is the safe fallback.
  // A dedicated Android API key can override it through CI when API key
  // restrictions are enabled in Google Cloud/Firebase.
  static const _apiKey = String.fromEnvironment(
    'JAWAN_FIREBASE_API_KEY',
    defaultValue: 'AIzaSyDQKVdQ7laLfNyZyIdtHbS91wVtSd1QeuM',
  );
  static const _appId = String.fromEnvironment(
    'JAWAN_FIREBASE_APP_ID',
    defaultValue: '1:22978141935:web:cea2a66dd01f5bec04051a',
  );
  static const _projectId = String.fromEnvironment(
    'JAWAN_FIREBASE_PROJECT_ID',
    defaultValue: 'jwan-delivery-c930d-72911',
  );
  static const _messagingSenderId = String.fromEnvironment(
    'JAWAN_FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '22978141935',
  );

  static FirebaseOptions get currentPlatform {
    if (_apiKey.isEmpty || _appId.isEmpty) {
      throw StateError('Firebase configuration is incomplete.');
    }
    return const FirebaseOptions(
      apiKey: _apiKey,
      appId: _appId,
      projectId: _projectId,
      messagingSenderId: _messagingSenderId,
      authDomain: 'jwan-delivery-c930d-72911.firebaseapp.com',
      storageBucket: 'jwan-delivery-c930d-72911.firebasestorage.app',
    );
  }
}
