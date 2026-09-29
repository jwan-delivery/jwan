import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> writeAdminAuditLog({
  required String action,
  required String targetType,
  required String targetId,
  Map<String, dynamic> metadata = const {},
}) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = snap.data();
    final role = data?['role']?.toString();
    final status = data?['status']?.toString();
    if (status != 'active' || (role != 'admin' && role != 'super_admin')) return;
    await FirebaseFirestore.instance.collection('auditLogs').add({
      'actorUid': user.uid,
      'actorRole': role,
      'action': action,
      'targetType': targetType,
      'targetId': targetId,
      'metadata': metadata,
      'createdAt': FieldValue.serverTimestamp(),
    });
  } catch (_) {
    // Audit logging must never break the underlying admin action.
  }
}
