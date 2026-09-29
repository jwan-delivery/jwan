import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AyezAdminAuditLogsPage extends StatelessWidget {
  const AyezAdminAuditLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('auditLogs')
          .orderBy('createdAt', descending: true)
          .limit(300)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text(snapshot.error.toString()));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? const [];
        if (docs.isEmpty) return const Center(child: Text('لا توجد سجلات تدقيق بعد.'));
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final data = docs[index].data();
            final ts = data['createdAt'];
            final created = ts is Timestamp ? ts.toDate() : null;
            final action = data['action']?.toString() ?? '-';
            final targetType = data['targetType']?.toString() ?? '-';
            final targetId = data['targetId']?.toString() ?? '-';
            final role = data['actorRole']?.toString() ?? '-';
            final meta = data['metadata'];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: Text(action, style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text('$targetType • $targetId\nالمنفذ: $role\n${created ?? '-'}\n${meta is Map ? meta.entries.map((e) => '${e.key}: ${e.value}').join(' • ') : ''}'),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}
