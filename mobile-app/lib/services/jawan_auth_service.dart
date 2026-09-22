import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JawanAuthService {
  JawanAuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  String phoneToEmail(String phone) => '${phone.trim()}@jawan.app';

  bool _validPhone(String phone) => RegExp(r'^\d{10}$').hasMatch(phone.trim());

  Future<UserCredential> signIn({
    required String phone,
    required String password,
  }) async {
    final cleanPhone = phone.trim();
    if (!_validPhone(cleanPhone)) {
      throw ArgumentError('رقم الهاتف يجب أن يكون 10 أرقام فقط');
    }
    if (password.length < 6) {
      throw ArgumentError('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
    }

    final credential = await _auth.signInWithEmailAndPassword(
      email: phoneToEmail(cleanPhone),
      password: password,
    );

    await _firestore.collection('users').doc(credential.user!.uid).update({
      'lastActiveAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  Future<UserCredential> register({
    required String phone,
    required String password,
    required String name,
    required String state,
    required String role,
    required String address,
    required bool acceptedPolicies,
    int? age,
    String? vehicleType,
  }) async {
    final cleanPhone = phone.trim();
    final cleanName = name.trim();
    final cleanState = state.trim();
    final cleanAddress = address.trim();

    if (!_validPhone(cleanPhone)) {
      throw ArgumentError('رقم الهاتف يجب أن يكون 10 أرقام فقط');
    }
    if (password.length < 6) {
      throw ArgumentError('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
    }
    if (cleanName.isEmpty) throw ArgumentError('الاسم الكامل مطلوب');
    if (cleanState.isEmpty) throw ArgumentError('اختر الولاية');
    if (cleanAddress.isEmpty) throw ArgumentError('مكان السكن مطلوب');
    if (!acceptedPolicies) {
      throw ArgumentError('يجب الموافقة على سياسة الخصوصية والشروط والأحكام');
    }
    if (role != 'customer' && role != 'driver') {
      throw ArgumentError('نوع الحساب غير صحيح');
    }

    int? cleanAge;
    String? cleanVehicleType;
    if (role == 'driver') {
      if (age == null || age < 18 || age > 100) {
        throw ArgumentError('يجب أن يكون عمر السائق بين 18 و100');
      }
      if (vehicleType == null || vehicleType.trim().isEmpty) {
        throw ArgumentError('اختر نوع المركبة');
      }
      cleanAge = age;
      cleanVehicleType = vehicleType.trim();
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: phoneToEmail(cleanPhone),
      password: password,
    );

    await _firestore.collection('users').doc(credential.user!.uid).set({
      'role': role,
      'name': cleanName,
      'phone': cleanPhone,
      'address': cleanAddress,
      'state': cleanState,
      'age': role == 'driver' ? cleanAge : null,
      'vehicleType': role == 'driver' ? cleanVehicleType : null,
      'status': role == 'customer' ? 'active' : 'pending',
      'privacyAccepted': true,
      'termsAccepted': true,
      'createdAt': FieldValue.serverTimestamp(),
      'lastActiveAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  Future<void> signOut() => _auth.signOut();
}