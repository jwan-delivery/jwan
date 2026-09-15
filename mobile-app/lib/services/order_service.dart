import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  OrderService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection('orders');

  Stream<QuerySnapshot<Map<String, dynamic>>> customerOrders(String uid) {
    return _orders
        .where('customerId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> driverOrders({
    required String uid,
    String? state,
  }) {
    Query<Map<String, dynamic>> query = _orders
        .where('driverId', isEqualTo: uid)
        .orderBy('createdAt', descending: true);

    if (state != null && state.isNotEmpty) {
      query = query.where('state', isEqualTo: state);
    }

    return query.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> availableOrders(String state) {
    return _orders
        .where('state', isEqualTo: state)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<DocumentReference<Map<String, dynamic>>> createOrder({
    required String customerId,
    required String state,
    required String vehicleType,
    required String serviceCategory,
    required String origin,
    required String destination,
    String? description,
    int? passengerCount,
    bool? hasLuggage,
    String? luggageDescription,
    String? cargoType,
    String? cargoDescription,
  }) {
    final data = <String, dynamic>{
      'customerId': customerId,
      'driverId': null,
      'state': state,
      'vehicleType': vehicleType,
      'serviceCategory': serviceCategory,
      'origin': origin,
      'destination': destination,
      'description': description,
      'status': 'pending',
      'negotiationStatus': 'closed',
      'deliveryFee': null,
      'agreedFee': null,
      'commissionCharged': false,
      'cancellationPenaltyCharged': false,
      'createdAt': FieldValue.serverTimestamp(),
      if (passengerCount != null) 'passengerCount': passengerCount,
      if (hasLuggage != null) 'hasLuggage': hasLuggage,
      if (luggageDescription != null) 'luggageDescription': luggageDescription,
      if (cargoType != null) 'cargoType': cargoType,
      if (cargoDescription != null) 'cargoDescription': cargoDescription,
    };

    return _orders.add(data);
  }

  Future<void> customerConfirmDelivery(String orderId) {
    return _orders.doc(orderId).update({
      'status': 'completed',
      'customerConfirmedAt': FieldValue.serverTimestamp(),
    });
  }
}
