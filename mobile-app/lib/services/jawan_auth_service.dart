import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JawanAuthService {
  JawanAuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  String phoneToEmail(String phone) {
    final normalized = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    return '$normalized@jawan.app';
  }

  Future<UserCredential> signIn({required String phone, required String password}) {
    return _auth.signInWithEmailAndPassword(
      email: phoneToEmail(phone),
      password: password,
    );
  }

  Future<UserCredential> register({
    required String phone,
    required String password,
    required String name,
    required String state,
    required String role,
    String? vehicleType,
  }) async {
    if (role != 'customer' && role != 'driver') {
      throw ArgumentError('Public registration can only create customer or driver accounts.');
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: phoneToEmail(phone),
      password: password,
    );

    await _firestore.collection('users').doc(credential.user!.uid).set({
      'name': name.trim(),
      'phone': phone.trim(),
      'email': phoneToEmail(phone),
      'state': state,
      'role': role,
      'status': 'pending',
      if (role == 'driver' && vehicleType != null) 'vehicleType': vehicleType,
      'privacyAccepted': true,
      'termsAccepted': true,
      'createdAt': FieldValue.serverTimestamp(),
      'lastActiveAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  Future<void> signOut() => _auth.signOut();
}
