import 'package:cloud_firestore/cloud_firestore.dart';

class AppDataService {
  AppDataService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUser(String uid) =>
      _db.collection('users').doc(uid).snapshots();

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) =>
      _db.collection('users').doc(uid).get();

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchWallet(String uid) =>
      _db.collection('wallets').doc(uid).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> walletTransactions(String uid) =>
      _db
          .collection('walletTransactions')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .limit(100)
          .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> topupRequests(String uid) =>
      _db
          .collection('topupRequests')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .limit(30)
          .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> withdrawalRequests(String uid) =>
      _db
          .collection('withdrawalRequests')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .limit(30)
          .snapshots();

  Future<void> createTopupRequest({required String uid, required int amount}) async {
    if (amount <= 0) throw ArgumentError('مبلغ الشحن يجب أن يكون أكبر من صفر');
    await _db.collection('topupRequests').add({
      'userId': uid,
      'amount': amount,
      'status': 'pending',
      'approvedBy': null,
      'approvalNote': null,
      'createdAt': FieldValue.serverTimestamp(),
      'reviewedAt': null,
    });
  }

  Future<void> createWithdrawalRequest({
    required String uid,
    required int amount,
    required Map<String, dynamic> bankDetails,
  }) async {
    if (amount <= 0) throw ArgumentError('مبلغ السحب يجب أن يكون أكبر من صفر');
    await _db.collection('withdrawalRequests').add({
      'userId': uid,
      'amount': amount,
      'bankDetails': bankDetails,
      'status': 'pending',
      'approvedBy': null,
      'approvalNote': null,
      'createdAt': FieldValue.serverTimestamp(),
      'reviewedAt': null,
    });
  }

  Future<void> submitSupport({
    required String uid,
    required String role,
    required String subject,
    required String body,
  }) async {
    final cleanSubject = subject.trim();
    final cleanBody = body.trim();
    if (cleanSubject.isEmpty || cleanBody.isEmpty) {
      throw ArgumentError('اكتب عنوان الرسالة ومحتواها');
    }
    if (cleanSubject.length > 120 || cleanBody.length > 3000) {
      throw ArgumentError('الرسالة أطول من الحد المسموح');
    }
    await _db.collection('supportMessages').add({
      'userId': uid,
      'role': role,
      'subject': cleanSubject,
      'body': cleanBody,
      'replies': <Map<String, dynamic>>[],
      'createdAt': FieldValue.serverTimestamp(),
      'resolvedAt': null,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> supportMessages(String uid) =>
      _db
          .collection('supportMessages')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> ratingsForDriver(String driverId) =>
      _db.collection('ratings').where('driverId', isEqualTo: driverId).snapshots();

  Future<void> createRating({
    required String orderId,
    required String customerId,
    required int rating,
    String? comment,
  }) async {
    if (rating < 1 || rating > 5) throw ArgumentError('التقييم يجب أن يكون من 1 إلى 5');
    await _db.collection('ratings').doc('${orderId}_$customerId').create({
      'orderId': orderId,
      'customerId': customerId,
      'rating': rating,
      'comment': (comment ?? '').trim().isEmpty ? null : comment!.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProfile({
    required String uid,
    required String name,
    required String state,
    String? address,
  }) async {
    final cleanName = name.trim();
    final cleanState = state.trim();
    if (cleanName.length < 2 || cleanName.length > 100) {
      throw ArgumentError('الاسم غير صحيح');
    }
    if (cleanState.isEmpty) throw ArgumentError('اختر الولاية');
    await _db.collection('users').doc(uid).update({
      'name': cleanName,
      'state': cleanState,
      'address': (address ?? '').trim(),
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }
}
