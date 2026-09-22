import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  OrderService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  CollectionReference<Map<String, dynamic>> get _orders => _firestore.collection('orders');

  Stream<QuerySnapshot<Map<String, dynamic>>> customerOrders(String uid) =>
      _orders.where('customerId', isEqualTo: uid).orderBy('createdAt', descending: true).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> driverOrders(String uid) =>
      _orders.where('driverId', isEqualTo: uid).orderBy('createdAt', descending: true).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> availableOrders(String state) => _orders
      .where('state', isEqualTo: state)
      .where('status', isEqualTo: 'pending')
      .orderBy('createdAt', descending: true)
      .snapshots();

  Future<String> createOrder({
    required String customerId,
    required String state,
    required String vehicleType,
    required String serviceCategory,
    required String origin,
    required String destination,
    String description = '',
    int? passengerCount,
    bool? hasLuggage,
    String? luggageDescription,
    String? cargoType,
    String? cargoDescription,
  }) async {
    if (origin.trim().isEmpty || destination.trim().isEmpty) throw ArgumentError('أدخل نقطة الاستلام والوجهة');
    if (origin.trim() == destination.trim()) throw ArgumentError('مكان الاستلام والوجهة يجب أن يكونا مختلفين');
    final ref = await _orders.add({
      'customerId': customerId,
      'driverId': null,
      'state': state,
      'vehicleType': vehicleType,
      'serviceCategory': serviceCategory,
      'passengerCount': passengerCount,
      'hasLuggage': hasLuggage,
      'luggageDescription': luggageDescription,
      'cargoType': cargoType,
      'cargoDescription': cargoDescription,
      'description': description.trim().length > 1000 ? description.trim().substring(0, 1000) : description.trim(),
      'origin': origin.trim(),
      'destination': destination.trim(),
      'deliveryFee': null,
      'agreedFee': null,
      'status': 'pending',
      'negotiationStatus': 'none',
      'commissionCharged': false,
      'cancellationPenaltyCharged': false,
      'createdAt': FieldValue.serverTimestamp(),
      'acceptedAt': null,
      'pickedUpAt': null,
      'startedAt': null,
      'deliveredAt': null,
      'customerConfirmedAt': null,
      'notDeliveredAt': null,
      'driverConfirmedAt': null,
      'completedAt': null,
      'cancelledAt': null,
      'agreedAt': null,
      'agreedBy': null,
      'cancelReason': null,
      'driverComment': null,
    });
    return ref.id;
  }

  Future<void> acceptOrder(String orderId, String driverId) async {
    await _firestore.runTransaction((tx) async {
      final orderRef = _orders.doc(orderId);
      final negRef = _firestore.collection('priceNegotiations').doc(orderId);
      final orderSnap = await tx.get(orderRef);
      final driverSnap = await tx.get(_firestore.collection('users').doc(driverId));
      final walletSnap = await tx.get(_firestore.collection('wallets').doc(driverId));
      if (!orderSnap.exists) throw StateError('الطلب غير موجود');
      if (!driverSnap.exists) throw StateError('حساب السائق غير موجود');
      final walletBalance = (walletSnap.data()?['balance'] as num?)?.toDouble() ?? 0;
      if (!walletSnap.exists || walletBalance <= 0) throw StateError('رصيد المحفظة غير كافٍ لقبول الطلب');
      final order = orderSnap.data()!;
      final driver = driverSnap.data()!;
      if (order['status'] != 'pending' || order['driverId'] != null) throw StateError('تم أخذ الطلب بالفعل');
      if (driver['role'] != 'driver' || driver['status'] != 'active' || driver['state'] != order['state']) {
        throw StateError('لا يمكنك قبول طلب خارج ولايتك');
      }
      tx.update(orderRef, {
        'driverId': driverId,
        'status': 'accepted',
        'acceptedAt': FieldValue.serverTimestamp(),
        'negotiationStatus': 'open',
      });
      tx.set(negRef, {
        'orderId': orderId,
        'customerId': order['customerId'],
        'driverId': driverId,
        'customerName': null,
        'driverName': driver['name'] ?? 'السائق',
        'currentOffer': null,
        'offeredBy': null,
        'status': 'open',
        'expiresAt': null,
        'updatedAt': FieldValue.serverTimestamp(),
        'lastAction': 'accepted',
        'lastMessageId': null,
      });
    });
  }

  Future<void> pickupOrder(String orderId) => _orders.doc(orderId).update({
        'status': 'picked_up',
        'pickedUpAt': FieldValue.serverTimestamp(),
      });

  Future<void> startDelivering(String orderId) => _orders.doc(orderId).update({
        'status': 'delivering',
        'startedAt': FieldValue.serverTimestamp(),
      });

  Future<void> markDelivered(String orderId) => _orders.doc(orderId).update({
        'status': 'awaiting_confirmation',
        'deliveredAt': FieldValue.serverTimestamp(),
      });

  Future<void> confirmDelivery(String orderId) => _orders.doc(orderId).update({
        'customerConfirmedAt': FieldValue.serverTimestamp(),
      });

  Future<void> customerCancel(String orderId, String customerId, String reason) async {
    await _firestore.runTransaction((tx) async {
      final ref = _orders.doc(orderId);
      final snap = await tx.get(ref);
      if (!snap.exists) throw StateError('الطلب غير موجود');
      final order = snap.data()!;
      if (order['customerId'] != customerId || order['status'] != 'pending' || order['driverId'] != null) {
        throw StateError('لا يمكن إلغاء الطلب في هذه المرحلة');
      }
      final cleanReason = reason.trim();
      tx.update(ref, {
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'cancelReason': cleanReason.isEmpty ? 'إلغاء بواسطة العميل' : cleanReason.substring(0, cleanReason.length > 300 ? 300 : cleanReason.length),
      });
    });
  }

  Future<void> customerReportNotDelivered(String orderId, String customerId) async {
    await _firestore.runTransaction((tx) async {
      final ref = _orders.doc(orderId);
      final snap = await tx.get(ref);
      if (!snap.exists) throw StateError('الطلب غير موجود');
      final order = snap.data()!;
      if (order['customerId'] != customerId || order['status'] != 'awaiting_confirmation') {
        throw StateError('الطلب ليس في مرحلة تأكيد التسليم');
      }
      final createdAt = order['createdAt'];
      if (createdAt is Timestamp && DateTime.now().difference(createdAt.toDate()) < const Duration(hours: 1)) {
        throw StateError('يمكن الإبلاغ عن عدم الوصول بعد مرور ساعة من إنشاء الطلب');
      }
      tx.update(ref, {'status': 'not_delivered', 'notDeliveredAt': FieldValue.serverTimestamp()});
    });
  }

  Future<void> driverFinalize(String orderId, String driverId) async {
    await _firestore.runTransaction((tx) async {
      final orderRef = _orders.doc(orderId);
      final walletRef = _firestore.collection('wallets').doc(driverId);
      final orderSnap = await tx.get(orderRef);
      final walletSnap = await tx.get(walletRef);
      if (!orderSnap.exists) throw StateError('الطلب غير موجود');
      if (!walletSnap.exists) throw StateError('محفظة السائق غير موجودة');
      final order = orderSnap.data()!;
      final wallet = walletSnap.data()!;
      if (order['driverId'] != driverId || order['status'] != 'awaiting_confirmation') throw StateError('الطلب ليس جاهزًا للإغلاق');
      if (order['negotiationStatus'] != 'agreed' || order['customerConfirmedAt'] == null) throw StateError('بانتظار اتفاق السعر وتأكيد العميل');
      if (order['commissionCharged'] == true) throw StateError('تم احتساب العمولة مسبقًا');
      final fee = (order['deliveryFee'] as num?)?.round() ?? 0;
      final commission = (fee * 0.05).round();
      final before = (wallet['balance'] as num?)?.toDouble() ?? 0;
      if (before < commission) throw StateError('رصيد المحفظة لا يكفي للعمولة');
      final after = before - commission;
      tx.update(orderRef, {
        'status': 'completed',
        'driverConfirmedAt': FieldValue.serverTimestamp(),
        'completedAt': FieldValue.serverTimestamp(),
        'commissionCharged': true,
      });
      tx.update(walletRef, {
        'balance': after,
        'totalCommission': ((wallet['totalCommission'] as num?)?.toDouble() ?? 0) + commission,
        'updatedAt': FieldValue.serverTimestamp(),
        'lastCommissionOrderId': orderId,
      });
      tx.set(_firestore.collection('walletTransactions').doc(), {
        'userId': driverId,
        'type': 'commission',
        'amount': -commission,
        'balanceBefore': before,
        'balanceAfter': after,
        'orderId': orderId,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': driverId,
      });
    });
  }

  Future<void> driverCancel(String orderId, String driverId, String reason) async {
    await _firestore.runTransaction((tx) async {
      final orderRef = _orders.doc(orderId);
      final walletRef = _firestore.collection('wallets').doc(driverId);
      final orderSnap = await tx.get(orderRef);
      if (!orderSnap.exists) throw StateError('الطلب غير موجود');
      final order = orderSnap.data()!;
      if (order['driverId'] != driverId || !['accepted', 'picked_up'].contains(order['status'])) {
        throw StateError('لا يمكن إلغاء الطلب في هذه المرحلة');
      }
      if (order['cancellationPenaltyCharged'] == true) throw StateError('تم احتساب الغرامة مسبقًا');
      final agreed = order['negotiationStatus'] == 'agreed';
      final fee = (order['deliveryFee'] as num?)?.round() ?? 0;
      final penalty = agreed ? (fee * 0.10).round() : 0;
      final cleanReason = reason.trim();
      final cancelReason = cleanReason.isEmpty ? 'إلغاء بواسطة السائق' : cleanReason.substring(0, cleanReason.length > 300 ? 300 : cleanReason.length);
      if (penalty <= 0) {
        tx.update(orderRef, {
          'status': 'cancelled',
          'cancelledAt': FieldValue.serverTimestamp(),
          'cancelReason': cancelReason,
          'cancellationPenaltyCharged': false,
        });
        return;
      }
      final walletSnap = await tx.get(walletRef);
      if (!walletSnap.exists) throw StateError('محفظة السائق غير موجودة');
      final wallet = walletSnap.data()!;
      final before = (wallet['balance'] as num?)?.toDouble() ?? 0;
      if (before < penalty) throw StateError('رصيد المحفظة لا يكفي لغرامة الإلغاء');
      final after = before - penalty;
      tx.update(orderRef, {
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'cancelReason': cancelReason,
        'cancellationPenaltyCharged': true,
      });
      tx.update(walletRef, {
        'balance': after,
        'totalCancellationPenalties': ((wallet['totalCancellationPenalties'] as num?)?.toDouble() ?? 0) + penalty,
        'updatedAt': FieldValue.serverTimestamp(),
        'lastCancellationOrderId': orderId,
      });
      tx.set(_firestore.collection('walletTransactions').doc(), {
        'userId': driverId,
        'type': 'cancellation_penalty',
        'amount': -penalty,
        'balanceBefore': before,
        'balanceAfter': after,
        'orderId': orderId,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': driverId,
      });
    });
  }
}
