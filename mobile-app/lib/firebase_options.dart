import 'package:firebase_core/firebase_core.dart';

/// Firebase configuration for the Jawan Delivery project.
///
/// Android production builds should additionally contain the Firebase-generated
/// google-services.json for the registered Android app. The values below allow
/// the Dart SDK to use the same Firebase project as the web application.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyDQKVd7QlaLfNyZyIdtHbS91wVtSd1QeuM',
      appId: '1:22978141935:android:REPLACE_WITH_ANDROID_APP_ID',
      messagingSenderId: '22978141935',
      projectId: 'jwan-delivery-c930d-72911',
      storageBucket: 'jwan-delivery-c930d-72911.firebasestorage.app',
    );
  }
}
