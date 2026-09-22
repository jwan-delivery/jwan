import 'package:cloud_firestore/cloud_firestore.dart';

class NegotiationService {
  NegotiationService({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _db;
  static const duration = Duration(minutes: 30);
  static const maxAmount = 100000000;

  Stream<Map<String, dynamic>?> watchNegotiation(String orderId) =>
      _db.collection('priceNegotiations').doc(orderId).snapshots().map((s) => s.exists ? s.data() : null);

  Stream<List<Map<String, dynamic>>> watchMessages(String orderId) => _db
      .collection('priceNegotiations').doc(orderId).collection('messages').orderBy('createdAt')
      .snapshots().map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());

  int cleanAmount(String input) {
    final value = int.tryParse(input.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (value <= 0) throw ArgumentError('أدخل مبلغًا صحيحًا');
    if (value > maxAmount) throw ArgumentError('المبلغ كبير جدًا');
    return value;
  }

  Future<void> offer({required String orderId, required String uid, required String role, required String name, required int amount}) async {
    if (role != 'driver' && role != 'customer') throw StateError('الدور غير صالح للتفاوض');
    if (amount <= 0 || amount > maxAmount) throw ArgumentError('المبلغ غير صحيح');
    await _db.runTransaction((tx) async {
      final orderRef = _db.collection('orders').doc(orderId);
      final negRef = _db.collection('priceNegotiations').doc(orderId);
      final orderSnap = await tx.get(orderRef);
      final negSnap = await tx.get(negRef);
      if (!orderSnap.exists || !negSnap.exists) throw StateError('المفاوضة غير موجودة');
      final order = orderSnap.data()!;
      final neg = negSnap.data()!;
      final participant = role == 'driver' ? order['driverId'] == uid : order['customerId'] == uid;
      if (!participant || order['status'] != 'accepted' || neg['status'] != 'open') throw StateError('التفاوض غير متاح الآن');
      if (neg['offeredBy'] == uid && neg['currentOffer'] != null) throw StateError('انتظر الطرف الآخر للرد على عرضك');

      final existingExpiry = neg['expiresAt'];
      Timestamp expiry;
      if (existingExpiry is Timestamp) {
        if (!existingExpiry.toDate().isAfter(DateTime.now())) throw StateError('انتهت مدة التفاوض');
        expiry = existingExpiry;
      } else {
        expiry = Timestamp.fromDate(DateTime.now().add(duration));
        if (role != 'driver') throw StateError('السائق يبدأ العرض الأول');
      }

      final messageRef = negRef.collection('messages').doc();
      tx.update(negRef, {
        'currentOffer': amount, 'offeredBy': uid, 'expiresAt': expiry,
        'updatedAt': FieldValue.serverTimestamp(), 'lastAction': 'offer', 'lastMessageId': messageRef.id,
        if (role == 'driver') 'driverName': name.toString().trim().substring(0, name.trim().length > 120 ? 120 : name.trim().length),
        if (role == 'customer') 'customerName': name.toString().trim().substring(0, name.trim().length > 120 ? 120 : name.trim().length),
      });
      tx.set(messageRef, {
        'orderId': orderId, 'amount': amount, 'action': 'offer', 'senderId': uid, 'senderRole': role,
        'senderName': name.toString().trim().substring(0, name.trim().length > 120 ? 120 : name.trim().length),
        'createdAt': FieldValue.serverTimestamp(), 'expiresAt': expiry,
      });
    });
  }

  Future<void> respond({required String orderId, required String uid, required String role, required String name, required bool accept}) async {
    if (role != 'driver' && role != 'customer') throw StateError('الدور غير صالح للتفاوض');
    await _db.runTransaction((tx) async {
      final orderRef = _db.collection('orders').doc(orderId);
      final negRef = _db.collection('priceNegotiations').doc(orderId);
      final orderSnap = await tx.get(orderRef);
      final negSnap = await tx.get(negRef);
      if (!orderSnap.exists || !negSnap.exists) throw StateError('المفاوضة غير موجودة');
      final order = orderSnap.data()!;
      final neg = negSnap.data()!;
      final participant = role == 'driver' ? order['driverId'] == uid : order['customerId'] == uid;
      if (!participant || order['status'] != 'accepted' || neg['status'] != 'open') throw StateError('التفاوض غير متاح الآن');
      if (neg['offeredBy'] == uid || neg['currentOffer'] == null) throw StateError('لا يوجد عرض من الطرف الآخر');
      final expiry = neg['expiresAt'];
      if (expiry is Timestamp && !expiry.toDate().isAfter(DateTime.now())) throw StateError('انتهت مدة التفاوض');
      final amount = (neg['currentOffer'] as num).round();
      final messageRef = negRef.collection('messages').doc();

      DocumentSnapshot<Map<String, dynamic>>? customerSnap;
      DocumentSnapshot<Map<String, dynamic>>? driverSnap;
      DocumentSnapshot<Map<String, dynamic>>? walletSnap;
      if (accept) {
        customerSnap = await tx.get(_db.collection('users').doc(order['customerId'] as String));
        driverSnap = await tx.get(_db.collection('users').doc(order['driverId'] as String));
        if (!customerSnap.exists || !driverSnap.exists) throw StateError('بيانات أحد الطرفين غير موجودة');
        if (role == 'driver') {
          walletSnap = await tx.get(_db.collection('wallets').doc(order['driverId'] as String));
          final balance = (walletSnap.data()?['balance'] as num?)?.toDouble() ?? 0;
          final commission = (amount * 0.05).round();
          if (!walletSnap.exists || balance < commission) throw StateError('رصيد المحفظة لا يكفي لعمولة هذا الطلب');
        }
      }

      final senderName = name.trim();
      tx.set(messageRef, {
        'orderId': orderId, 'amount': amount, 'action': accept ? 'accept' : 'reject',
        'senderId': uid, 'senderRole': role,
        'senderName': senderName.substring(0, senderName.length > 120 ? 120 : senderName.length),
        'createdAt': FieldValue.serverTimestamp(), 'expiresAt': neg['expiresAt'] ?? null,
      });

      if (!accept) {
        tx.update(orderRef, {'driverId': null, 'status': 'pending', 'negotiationStatus': 'none'});
        tx.update(negRef, {'status': 'closed', 'currentOffer': null, 'offeredBy': null, 'updatedAt': FieldValue.serverTimestamp(), 'lastAction': 'reject', 'lastMessageId': messageRef.id});
        return;
      }

      final customer = customerSnap!.data()!;
      final driver = driverSnap!.data()!;
      final contactRef = _db.collection('orderContacts').doc(orderId);
      tx.set(contactRef, {
        'orderId': orderId, 'customerId': order['customerId'], 'driverId': order['driverId'],
        'customerPhone': '${customer['phone'] ?? ''}', 'driverPhone': '${driver['phone'] ?? ''}',
        'createdAt': FieldValue.serverTimestamp(),
      });
      tx.update(orderRef, {'deliveryFee': amount, 'agreedFee': amount, 'negotiationStatus': 'agreed', 'agreedAt': FieldValue.serverTimestamp(), 'agreedBy': uid});
      tx.update(negRef, {'status': 'agreed', 'currentOffer': amount, 'updatedAt': FieldValue.serverTimestamp(), 'agreedAt': FieldValue.serverTimestamp(), 'agreedBy': uid, 'lastAction': 'accept', 'lastMessageId': messageRef.id});
    });
  }
}