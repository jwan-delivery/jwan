import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  FcmService({FirebaseMessaging? messaging, FirebaseFirestore? firestore})
      : _messaging = messaging ?? FirebaseMessaging.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseMessaging _messaging;
  final FirebaseFirestore _db;
  StreamSubscription<String>? _tokenSub;

  Future<void> initializeForUser(String uid) async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    await _saveToken(uid, await _messaging.getToken());
    await _tokenSub?.cancel();
    _tokenSub = _messaging.onTokenRefresh.listen((token) => _saveToken(uid, token));
  }

  Future<void> _saveToken(String uid, String? token) async {
    if (token == null || token.isEmpty) return;
    final id = token.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '').substring(0, token.length > 120 ? 120 : token.length);
    await _db.collection('fcmTokens').doc(id).set({
      'uid': uid,
      'token': token,
      'platform': 'flutter',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<RemoteMessage> get foregroundMessages => FirebaseMessaging.onMessage;

  Future<void> dispose() async {
    await _tokenSub?.cancel();
    _tokenSub = null;
  }
}
