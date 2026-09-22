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
      _db.collection('walletTransactions').where('userId', isEqualTo: uid).orderBy('createdAt', descending: true).limit(100).snapshots();
  Stream<QuerySnapshot<Map<String, dynamic>>> topupRequests(String uid) =>
      _db.collection('topupRequests').where('driverId', isEqualTo: uid).orderBy('submittedAt', descending: true).limit(30).snapshots();
  Stream<QuerySnapshot<Map<String, dynamic>>> withdrawalRequests(String uid) =>
      _db.collection('withdrawalRequests').where('driverId', isEqualTo: uid).orderBy('createdAt', descending: true).limit(30).snapshots();

  Future<void> createTopupRequest({required String uid, required int amount, required String paymentMethod}) async {
    if (amount <= 0) throw ArgumentError('مبلغ الشحن يجب أن يكون أكبر من صفر');
    const methods = ['بنكك', 'فوري', 'أوكاش', 'ماي كاشي'];
    if (!methods.contains(paymentMethod)) throw ArgumentError('اختر طريقة تحويل صحيحة');
    await _db.collection('topupRequests').add({
      'driverId': uid, 'amount': amount, 'paymentMethod': paymentMethod, 'status': 'pending',
      'submittedAt': FieldValue.serverTimestamp(), 'reviewedAt': null, 'reviewedBy': null,
      'reviewNote': null, 'whatsappVerified': false,
    });
  }

  Future<void> createWithdrawalRequest({required String uid, required int amount, required String paymentMethod, required String accountReference}) async {
    if (amount <= 0) throw ArgumentError('مبلغ السحب يجب أن يكون أكبر من صفر');
    const methods = ['بنكك', 'فوري', 'أوكاش', 'ماي كاشي'];
    if (!methods.contains(paymentMethod)) throw ArgumentError('اختر طريقة تحويل صحيحة');
    final reference = accountReference.trim();
    if (reference.isEmpty) throw ArgumentError('أدخل رقم الحساب/المحفظة المستلمة');
    await _db.collection('withdrawalRequests').add({
      'driverId': uid, 'amount': amount, 'paymentMethod': paymentMethod, 'accountReference': reference,
      'status': 'pending', 'createdAt': FieldValue.serverTimestamp(), 'reviewedAt': null, 'reviewedBy': null,
    });
  }

  Future<void> submitSupport({required String uid, required String role, required String message}) async {
    final clean = message.trim();
    if (clean.isEmpty) throw ArgumentError('اكتب رسالتك أولًا');
    if (clean.length > 3000) throw ArgumentError('الرسالة أطول من الحد المسموح');
    await _db.collection('supportMessages').add({
      'userId': uid, 'role': role, 'message': clean, 'reply': null, 'status': 'open',
      'createdAt': FieldValue.serverTimestamp(), 'repliedAt': null, 'repliedBy': null,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> supportMessages(String uid) =>
      _db.collection('supportMessages').where('userId', isEqualTo: uid).orderBy('createdAt', descending: true).snapshots();

  Future<void> createRating({required String orderId, required String customerId, required int rating, String? comment}) async {
    if (rating < 1 || rating > 5) throw ArgumentError('التقييم يجب أن يكون من 1 إلى 5');
    final orderSnap = await _db.collection('orders').doc(orderId).get();
    if (!orderSnap.exists) throw StateError('الطلب غير موجود');
    final order = orderSnap.data()!;
    if (order['customerId'] != customerId || order['status'] != 'completed') throw StateError('يمكن تقييم الطلب بعد اكتماله وبواسطة العميل فقط');
    final driverId = order['driverId'];
    if (driverId is! String || driverId.isEmpty) throw StateError('السائق غير محدد في الطلب');
    final cleanComment = (comment ?? '').trim();
    if (cleanComment.length > 500) throw ArgumentError('التعليق أطول من الحد المسموح');
    await _db.collection('ratings').doc('${orderId}_$customerId').create({
      'orderId': orderId, 'customerId': customerId, 'driverId': driverId, 'rating': rating,
      'comment': cleanComment.isEmpty ? null : cleanComment, 'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProfile({required String uid, required String name, required String state, String? address}) async {
    final cleanName = name.trim();
    final cleanState = state.trim();
    if (cleanName.length < 2 || cleanName.length > 100) throw ArgumentError('الاسم غير صحيح');
    if (cleanState.isEmpty) throw ArgumentError('الولاية غير محددة');
    await _db.collection('users').doc(uid).update({
      'name': cleanName, 'address': (address ?? '').trim(), 'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }
}