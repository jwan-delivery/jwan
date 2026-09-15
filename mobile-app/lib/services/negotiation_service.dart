import 'package:cloud_firestore/cloud_firestore.dart';

class NegotiationService {
  NegotiationService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  static const duration = Duration(minutes: 30);

  Stream<Map<String, dynamic>?> watchNegotiation(String orderId) =>
      _db.collection('priceNegotiations').doc(orderId).snapshots().map(
            (s) => s.exists ? s.data() : null,
          );

  Stream<List<Map<String, dynamic>>> watchMessages(String orderId) =>
      _db
          .collection('priceNegotiations')
          .doc(orderId)
          .collection('messages')
          .orderBy('createdAt')
          .snapshots()
          .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());

  int cleanAmount(String input) {
    final value = int.tryParse(input.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (value <= 0) throw ArgumentError('أدخل مبلغًا صحيحًا');
    if (value > 100000000) throw ArgumentError('المبلغ كبير جدًا');
    return value;
  }

  Future<void> offer({
    required String orderId,
    required String uid,
    required String role,
    required String name,
    required int amount,
  }) async {
    if (role != 'driver' && role != 'customer') {
      throw StateError('الدور غير صالح للتفاوض');
    }

    await _db.runTransaction((tx) async {
      final orderRef = _db.collection('orders').doc(orderId);
      final negRef = _db.collection('priceNegotiations').doc(orderId);
      final orderSnap = await tx.get(orderRef);
      final negSnap = await tx.get(negRef);
      if (!orderSnap.exists || !negSnap.exists) throw StateError('المفاوضة غير موجودة');

      final order = orderSnap.data()!;
      final neg = negSnap.data()!;
      final participant = role == 'driver'
          ? order['driverId'] == uid
          : order['customerId'] == uid;
      if (!participant || order['status'] != 'accepted' || neg['status'] != 'open') {
        throw StateError('التفاوض غير متاح الآن');
      }

      final expiresAt = neg['expiresAt'];
      if (expiresAt is Timestamp && expiresAt.toDate().isBefore(DateTime.now())) {
        throw StateError('انتهت مدة التفاوض');
      }

      if (neg['offeredBy'] == uid && neg['currentOffer'] != null) {
        throw StateError('انتظر الطرف الآخر للرد على عرضك');
      }

      final messageRef = negRef.collection('messages').doc();
      final expiry = Timestamp.fromDate(DateTime.now().add(duration));
      tx.update(negRef, {
        'currentOffer': amount,
        'offeredBy': uid,
        'expiresAt': expiry,
        'updatedAt': FieldValue.serverTimestamp(),
        'lastAction': 'offer',
        'lastMessageId': messageRef.id,
        if (role == 'driver') 'driverName': name,
        if (role == 'customer') 'customerName': name,
      });
      tx.set(messageRef, {
        'orderId': orderId,
        'amount': amount,
        'action': 'offer',
        'senderId': uid,
        'senderRole': role,
        'senderName': name,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': expiry,
      });
    });
  }

  Future<void> respond({
    required String orderId,
    required String uid,
    required String role,
    required String name,
    required bool accept,
  }) async {
    await _db.runTransaction((tx) async {
      final orderRef = _db.collection('orders').doc(orderId);
      final negRef = _db.collection('priceNegotiations').doc(orderId);
      final orderSnap = await tx.get(orderRef);
      final negSnap = await tx.get(negRef);
      if (!orderSnap.exists || !negSnap.exists) throw StateError('المفاوضة غير موجودة');

      final order = orderSnap.data()!;
      final neg = negSnap.data()!;
      final participant = role == 'driver'
          ? order['driverId'] == uid
          : order['customerId'] == uid;
      if (!participant || order['status'] != 'accepted' || neg['status'] != 'open') {
        throw StateError('التفاوض غير متاح الآن');
      }
      if (neg['offeredBy'] == uid || neg['currentOffer'] == null) {
        throw StateError('لا يوجد عرض من الطرف الآخر');
      }

      final amount = (neg['currentOffer'] as num).round();
      final messageRef = negRef.collection('messages').doc();
      tx.set(messageRef, {
        'orderId': orderId,
        'amount': amount,
        'action': accept ? 'accept' : 'reject',
        'senderId': uid,
        'senderRole': role,
        'senderName': name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!accept) {
        tx.update(orderRef, {
          'driverId': null,
          'status': 'pending',
          'negotiationStatus': 'none',
        });
        tx.update(negRef, {
          'status': 'closed',
          'currentOffer': null,
          'offeredBy': null,
          'updatedAt': FieldValue.serverTimestamp(),
          'lastAction': 'reject',
          'lastMessageId': messageRef.id,
        });
        return;
      }

      tx.update(orderRef, {
        'deliveryFee': amount,
        'agreedFee': amount,
        'negotiationStatus': 'agreed',
        'agreedAt': FieldValue.serverTimestamp(),
        'agreedBy': uid,
      });
      tx.update(negRef, {
        'status': 'agreed',
        'currentOffer': amount,
        'updatedAt': FieldValue.serverTimestamp(),
        'agreedAt': FieldValue.serverTimestamp(),
        'agreedBy': uid,
        'lastAction': 'accept',
        'lastMessageId': messageRef.id,
      });
    });
  }
}
