import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AyezMobileService {
  AyezMobileService({FirebaseFirestore? firestore, FirebaseMessaging? messaging})
      : db = firestore ?? FirebaseFirestore.instance,
        messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseFirestore db;
  final FirebaseMessaging messaging;

  Stream<RemoteMessage> get foregroundMessages => FirebaseMessaging.onMessage;

  Future<void> registerDevice(String uid) async {
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    final token = await messaging.getToken();
    if (token != null && token.isNotEmpty) {
      await db.collection('fcmTokens').doc(token).set({
        'uid': uid,
        'token': token,
        'platform': 'flutter',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  StreamSubscription<String> watchTokenRefresh(String uid) => messaging.onTokenRefresh.listen((token) async {
    if (token.isEmpty) return;
    await db.collection('fcmTokens').doc(token).set({
      'uid': uid,
      'token': token,
      'platform': 'flutter',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  });

  Future<void> createTopupRequest({required String driverId, required num amount, required String paymentMethod}) async {
    final value = amount.toDouble();
    if (value <= 0) throw ArgumentError('أدخل مبلغًا صحيحًا');
    const methods = ['بنكك', 'فوري', 'أوكاش', 'ماي كاشي'];
    if (!methods.contains(paymentMethod)) throw ArgumentError('اختر طريقة تحويل صحيحة');
    await db.collection('topupRequests').add({
      'driverId': driverId, 'amount': value, 'paymentMethod': paymentMethod, 'status': 'pending',
      'submittedAt': FieldValue.serverTimestamp(), 'reviewedAt': null, 'reviewedBy': null,
      'reviewNote': null, 'whatsappVerified': false,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> topups(String driverId) => db.collection('topupRequests')
      .where('driverId', isEqualTo: driverId).orderBy('submittedAt', descending: true).limit(50).snapshots();

  Future<void> createWithdrawalRequest({required String driverId, required num amount, required String paymentMethod, required String accountReference}) async {
    final value = amount.toDouble();
    final account = accountReference.trim();
    if (value <= 0) throw ArgumentError('أدخل مبلغًا صحيحًا');
    const methods = ['بنكك', 'فوري', 'أوكاش', 'ماي كاشي'];
    if (!methods.contains(paymentMethod)) throw ArgumentError('اختر طريقة تحويل صحيحة');
    if (account.isEmpty || account.length > 120) throw ArgumentError('رقم الحساب غير صحيح');
    await db.collection('withdrawalRequests').add({
      'driverId': driverId, 'amount': value, 'paymentMethod': paymentMethod, 'accountReference': account,
      'status': 'pending', 'createdAt': FieldValue.serverTimestamp(), 'reviewedAt': null, 'reviewedBy': null,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> withdrawals(String driverId) => db.collection('withdrawalRequests')
      .where('driverId', isEqualTo: driverId).orderBy('createdAt', descending: true).limit(50).snapshots();

  Future<void> sendSupport({required String uid, required String role, required String message}) async {
    final clean = message.trim();
    if (clean.isEmpty || clean.length > 3000) throw ArgumentError('الرسالة غير صحيحة');
    await db.collection('supportMessages').add({
      'userId': uid, 'role': role, 'message': clean, 'reply': null, 'status': 'open',
      'createdAt': FieldValue.serverTimestamp(), 'repliedAt': null, 'repliedBy': null,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> support(String uid) => db.collection('supportMessages')
      .where('userId', isEqualTo: uid).orderBy('createdAt', descending: true).limit(50).snapshots();
}