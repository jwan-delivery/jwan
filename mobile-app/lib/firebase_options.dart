import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    const apiKey = String.fromEnvironment('JAWAN_FIREBASE_API_KEY');
    const appId = String.fromEnvironment('JAWAN_FIREBASE_APP_ID');
    if (apiKey.isEmpty || appId.isEmpty) {
      throw StateError('Missing Firebase Android dart-defines. Configure CI before release build.');
    }
    return const FirebaseOptions(
      apiKey: String.fromEnvironment('JAWAN_FIREBASE_API_KEY'),
      appId: String.fromEnvironment('JAWAN_FIREBASE_APP_ID'),
      projectId: String.fromEnvironment('JAWAN_FIREBASE_PROJECT_ID', defaultValue: 'jwan-delivery-c930d-72911'),
      messagingSenderId: String.fromEnvironment('JAWAN_FIREBASE_MESSAGING_SENDER_ID', defaultValue: '22978141935'),
    );
  }
}
