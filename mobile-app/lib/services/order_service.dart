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

  Stream<QuerySnapshot<Map<String, dynamic>>> availableOrders(String state) =>
      _orders.where('state', isEqualTo: state).where('status', isEqualTo: 'pending').orderBy('createdAt', descending: true).snapshots();

  Future<DocumentReference<Map<String, dynamic>>> createOrder({
    required String customerId,
    required String state,
    required String vehicleType,
    required String serviceCategory,
    required String origin,
    required String destination,
    required String description,
    int? passengerCount,
    bool? hasLuggage,
    String? luggageDescription,
    String? cargoType,
    String? cargoDescription,
  }) {
    return _orders.add({
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
      'description': description,
      'origin': origin,
      'destination': destination,
      'deliveryFee': null,
      'agreedFee': null,
      'status': 'pending',
      'negotiationStatus': 'none',
      'commissionCharged': false,
      'cancellationPenaltyCharged': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Customer confirmation intentionally does not complete the order.
  /// The driver finalization flow performs the protected commission transaction.
  Future<void> confirmDelivery(String orderId) => _orders.doc(orderId).update({
        'customerConfirmedAt': FieldValue.serverTimestamp(),
      });
}
