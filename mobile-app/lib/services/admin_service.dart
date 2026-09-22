import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

class AdminService {
  AdminService({FirebaseFirestore? firestore, FirebaseFunctions? functions})
      : _db = firestore ?? FirebaseFirestore.instance,
        _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;

  Stream<QuerySnapshot<Map<String, dynamic>>> users(String role) =>
      _db.collection('users').where('role', isEqualTo: role).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> allOrders() =>
      _db.collection('orders').orderBy('createdAt', descending: true).limit(200).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> topups() =>
      _db.collection('topupRequests').orderBy('submittedAt', descending: true).limit(200).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> withdrawals() =>
      _db.collection('withdrawalRequests').orderBy('createdAt', descending: true).limit(200).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> supportMessages() =>
      _db.collection('supportMessages').orderBy('createdAt', descending: true).limit(200).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> managers() =>
      _db.collection('users').where('role', whereIn: ['admin', 'super_admin']).snapshots();

  Future<void> setUserStatus({required String uid, required String status}) async {
    if (!['pending', 'active', 'suspended', 'rejected'].contains(status)) {
      throw ArgumentError('حالة الحساب غير صحيحة');
    }
    await _db.collection('users').doc(uid).update({'status': status});
  }

  Future<void> cancelOrder(String orderId, {String reason = 'إلغاء بواسطة الإدارة'}) async {
    final ref = _db.collection('orders').doc(orderId);
    final snap = await ref.get();
    if (!snap.exists) throw StateError('الطلب غير موجود');
    final status = snap.data()!['status'];
    if (status != 'pending' && status != 'accepted') {
      throw StateError('لا يمكن إلغاء الطلب في هذه المرحلة');
    }
    await ref.update({
      'status': 'cancelled',
      'cancelledAt': FieldValue.serverTimestamp(),
      'cancelReason': reason.trim().isEmpty ? 'إلغاء بواسطة الإدارة' : reason.trim().substring(0, reason.trim().length > 300 ? 300 : reason.trim().length),
    });
  }

  Future<void> reviewTopup({required String adminUid, required String requestId, required bool approve, String note = ''}) async {
    await _db.runTransaction((tx) async {
      final reqRef = _db.collection('topupRequests').doc(requestId);
      final reqSnap = await tx.get(reqRef);
      if (!reqSnap.exists) throw StateError('طلب الشحن غير موجود');
      final request = reqSnap.data()!;
      if (request['status'] != 'pending') throw StateError('تمت مراجعة الطلب مسبقًا');
      tx.update(reqRef, {'status': approve ? 'approved' : 'rejected', 'reviewedAt': FieldValue.serverTimestamp(), 'reviewedBy': adminUid, 'reviewNote': note.trim().isEmpty ? null : note.trim()});
      if (!approve) return;
      final driverId = request['driverId'];
      if (driverId is! String || driverId.isEmpty) throw StateError('السائق غير محدد');
      final walletRef = _db.collection('wallets').doc(driverId);
      final walletSnap = await tx.get(walletRef);
      if (!walletSnap.exists) throw StateError('محفظة السائق غير موجودة');
      final wallet = walletSnap.data()!;
      final before = (wallet['balance'] as num?)?.toDouble() ?? 0;
      final amount = (request['amount'] as num?)?.toDouble() ?? 0;
      if (amount <= 0) throw StateError('مبلغ الشحن غير صحيح');
      final transactionRef = _db.collection('walletTransactions').doc();
      tx.update(walletRef, {'balance': before + amount, 'totalTopups': ((wallet['totalTopups'] as num?)?.toDouble() ?? 0) + amount, 'updatedAt': FieldValue.serverTimestamp(), 'lastTopupRequestId': requestId});
      tx.set(transactionRef, {'userId': driverId, 'type': 'topup', 'amount': amount, 'balanceBefore': before, 'balanceAfter': before + amount, 'orderId': null, 'topupRequestId': requestId, 'withdrawalRequestId': null, 'createdAt': FieldValue.serverTimestamp(), 'createdBy': adminUid});
    });
  }

  Future<void> manualTopup({required String adminUid, required String driverId, required num amount, String note = ''}) async {
    if (amount <= 0) throw ArgumentError('مبلغ الشحن غير صحيح');
    await _db.runTransaction((tx) async {
      final userRef = _db.collection('users').doc(driverId);
      final walletRef = _db.collection('wallets').doc(driverId);
      final transactionRef = _db.collection('walletTransactions').doc();
      final userSnap = await tx.get(userRef);
      final walletSnap = await tx.get(walletRef);
      if (!userSnap.exists || userSnap.data()?['role'] != 'driver' || userSnap.data()?['status'] != 'active') throw StateError('السائق غير نشط أو غير موجود');
      if (!walletSnap.exists) throw StateError('محفظة السائق غير موجودة');
      final wallet = walletSnap.data()!;
      final before = (wallet['balance'] as num?)?.toDouble() ?? 0;
      final value = amount.toDouble();
      tx.update(walletRef, {'balance': before + value, 'totalTopups': ((wallet['totalTopups'] as num?)?.toDouble() ?? 0) + value, 'updatedAt': FieldValue.serverTimestamp(), 'lastManualTopupId': transactionRef.id});
      tx.set(transactionRef, {'userId': driverId, 'type': 'manual_topup', 'amount': value, 'balanceBefore': before, 'balanceAfter': before + value, 'orderId': null, 'topupRequestId': null, 'withdrawalRequestId': null, 'manualTopupId': transactionRef.id, 'note': note.trim(), 'createdAt': FieldValue.serverTimestamp(), 'createdBy': adminUid});
    });
  }

  Future<void> reviewWithdrawal({required String adminUid, required String requestId, required String status}) async {
    if (status != 'paid' && status != 'rejected') throw ArgumentError('حالة السحب غير صحيحة');
    await _db.runTransaction((tx) async {
      final reqRef = _db.collection('withdrawalRequests').doc(requestId);
      final reqSnap = await tx.get(reqRef);
      if (!reqSnap.exists) throw StateError('طلب السحب غير موجود');
      final request = reqSnap.data()!;
      if (request['status'] != 'pending') throw StateError('تمت مراجعة الطلب مسبقًا');
      tx.update(reqRef, {'status': status, 'reviewedAt': FieldValue.serverTimestamp(), 'reviewedBy': adminUid});
      if (status != 'paid') return;
      final driverId = request['driverId'];
      final amount = (request['amount'] as num?)?.toDouble() ?? 0;
      if (driverId is! String || driverId.isEmpty || amount <= 0) throw StateError('بيانات السحب غير صحيحة');
      final walletRef = _db.collection('wallets').doc(driverId);
      final walletSnap = await tx.get(walletRef);
      if (!walletSnap.exists) throw StateError('محفظة السائق غير موجودة');
      final wallet = walletSnap.data()!;
      final before = (wallet['balance'] as num?)?.toDouble() ?? 0;
      if (before < amount) throw StateError('الرصيد غير كافٍ لتنفيذ السحب');
      final txRef = _db.collection('walletTransactions').doc();
      tx.update(walletRef, {'balance': before - amount, 'totalWithdrawals': ((wallet['totalWithdrawals'] as num?)?.toDouble() ?? 0) + amount, 'updatedAt': FieldValue.serverTimestamp(), 'lastWithdrawalRequestId': requestId});
      tx.set(txRef, {'userId': driverId, 'type': 'withdrawal', 'amount': -amount, 'balanceBefore': before, 'balanceAfter': before - amount, 'orderId': null, 'topupRequestId': null, 'withdrawalRequestId': requestId, 'createdAt': FieldValue.serverTimestamp(), 'createdBy': adminUid});
    });
  }

  Future<void> replySupport({required String adminUid, required String requestId, required String reply}) async {
    final clean = reply.trim();
    if (clean.isEmpty || clean.length > 3000) throw ArgumentError('الرد غير صحيح');
    await _db.collection('supportMessages').doc(requestId).update({'reply': clean, 'status': 'answered', 'repliedAt': FieldValue.serverTimestamp(), 'repliedBy': adminUid});
  }

  Future<void> deleteUser({required String uid}) async {
    final callable = _functions.httpsCallable('adminDeleteUser');
    await callable.call({'uid': uid});
  }

  Future<void> createManager({required String name, required String phone, required String password}) async {
    final secondary = await Firebase.initializeApp(name: 'manager-${DateTime.now().microsecondsSinceEpoch}', options: DefaultFirebaseOptions.currentPlatform);
    try {
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondary);
      final email = '${phone.trim()}@jawan.app';
      final credential = await secondaryAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _db.collection('users').doc(credential.user!.uid).set({'role': 'admin', 'name': name.trim(), 'phone': phone.trim(), 'address': null, 'state': null, 'age': null, 'vehicleType': null, 'status': 'active', 'privacyAccepted': true, 'termsAccepted': true, 'createdAt': FieldValue.serverTimestamp(), 'lastActiveAt': FieldValue.serverTimestamp()});
      await secondaryAuth.signOut();
    } finally {
      await secondary.delete();
    }
  }

  Future<void> setManagerRole({required String uid, required String role}) async {
    if (role != 'admin' && role != 'super_admin') throw ArgumentError('دور المدير غير صحيح');
    await _db.collection('users').doc(uid).update({'role': role});
  }
}