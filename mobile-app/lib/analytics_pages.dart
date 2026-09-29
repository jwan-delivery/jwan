import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AyezDriverAnalyticsPage extends StatelessWidget {
  const AyezDriverAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('orders').where('driverId', isEqualTo: userId).orderBy('createdAt', descending: true).limit(500).snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? const [];
        final completed = docs.where((d) => d.data()['status'] == 'completed').toList();
        final cancelled = docs.where((d) => d.data()['status'] == 'cancelled').length;
        final revenue = completed.fold<double>(0, (sum, d) => sum + ((d.data()['agreedFee'] as num?)?.toDouble() ?? (d.data()['deliveryFee'] as num?)?.toDouble() ?? 0));
        final average = completed.isEmpty ? 0.0 : revenue / completed.length;
        final activeDays = <String>{};
        for (final d in completed) {
          final ts = d.data()['completedAt'];
          if (ts is Timestamp) {
            final date = ts.toDate();
            activeDays.add(date.toIso8601String().substring(0, 10));
          }
        }
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const _AnalyticsHeading(title: 'تحليلاتي', subtitle: 'ملخص نشاطك داخل عايز، بنفس مؤشرات صفحة الويب.'),
            const SizedBox(height: 14),
            if (snapshot.hasError) const _AnalyticsCard(text: 'تعذر تحميل بيانات التحليلات الآن.'),
            if (!snapshot.hasError) _stats([
              ('مكتملة', completed.length.toString(), Icons.check_circle_outline),
              ('ملغاة', cancelled.toString(), Icons.cancel_outlined),
              ('الدخل المتفق عليه', revenue.toStringAsFixed(0) + ' ج.س', Icons.payments_outlined),
              ('متوسط الطلب', average.toStringAsFixed(0) + ' ج.س', Icons.calculate_outlined),
            ]),
            const SizedBox(height: 12),
            _AnalyticsCard(text: completed.isEmpty ? 'لم تبدأ لديك طلبات مكتملة بعد.' : 'أنجزت ' + completed.length.toString() + ' طلبًا مكتملًا بإجمالي أجور متفق عليها ' + revenue.toStringAsFixed(0) + ' ج.س.'),
            const SizedBox(height: 10),
            _AnalyticsCard(text: 'أيام النشاط المكتملة: ' + activeDays.length.toString() + ' يوم'),
          ],
        );
      },
    );
  }

  Widget _stats(List<(String, String, IconData)> values) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: values.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 100, crossAxisSpacing: 8, mainAxisSpacing: 8),
        itemBuilder: (_, index) => Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(values[index].$3),
                const Spacer(),
                Text(values[index].$1, style: const TextStyle(color: Colors.black54)),
                Text(values[index].$2, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ),
      );
}

class AyezAdminAnalyticsPage extends StatelessWidget {
  const AyezAdminAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).limit(500).snapshots(),
      builder: (context, orderSnapshot) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'driver').limit(500).snapshots(),
        builder: (context, driverSnapshot) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'customer').limit(500).snapshots(),
          builder: (context, customerSnapshot) {
            if (orderSnapshot.hasError || driverSnapshot.hasError || customerSnapshot.hasError) return const _AnalyticsCard(text: 'تعذر تحميل تحليلات الإدارة.');
            final orders = (orderSnapshot.data?.docs ?? const []).map((d) => {'id': d.id, ...d.data()}).toList();
            final users = <String, String>{};
            for (final d in [...(driverSnapshot.data?.docs ?? const []), ...(customerSnapshot.data?.docs ?? const [])]) {
              users[d.id] = d.data()['name']?.toString() ?? '—';
            }
            final completed = orders.where((o) => o['status'] == 'completed').toList();
            final byDriver = <String, List<Map<String, dynamic>>>{};
            final byCustomer = <String, List<Map<String, dynamic>>>{};
            final activeDays = <String, Set<String>>{};
            double totalMinutes = 0;
            int timedOrders = 0;
            for (final order in completed) {
              final driverId = order['driverId']?.toString();
              final customerId = order['customerId']?.toString();
              if (driverId != null && driverId.isNotEmpty) {
                byDriver.putIfAbsent(driverId, () => <Map<String, dynamic>>[]).add(order);
                final accepted = order['acceptedAt'];
                final finished = order['completedAt'];
                if (accepted is Timestamp && finished is Timestamp) {
                  final minutes = finished.toDate().difference(accepted.toDate()).inSeconds / 60;
                  if (minutes >= 0) { totalMinutes += minutes; timedOrders++; }
                }
                if (finished is Timestamp) activeDays.putIfAbsent(driverId, () => <String>{}).add(finished.toDate().toIso8601String().substring(0, 10));
              }
              if (customerId != null && customerId.isNotEmpty) byCustomer.putIfAbsent(customerId, () => <Map<String, dynamic>>[]).add(order);
            }
            String? topDriver;
            for (final e in byDriver.entries) { if (topDriver == null || e.value.length > byDriver[topDriver]!.length) topDriver = e.key; }
            String? fastestDriver;
            double? fastestMinutes;
            for (final e in byDriver.entries) {
              final times = e.value.where((o) => o['acceptedAt'] is Timestamp && o['completedAt'] is Timestamp).map((o) => (o['completedAt'] as Timestamp).toDate().difference((o['acceptedAt'] as Timestamp).toDate()).inSeconds / 60).where((m) => m >= 0).toList();
              if (times.isEmpty) continue;
              final avg = times.reduce((a, b) => a + b) / times.length;
              if (fastestMinutes == null || avg < fastestMinutes!) { fastestMinutes = avg; fastestDriver = e.key; }
            }
            String? topCustomerOrders;
            String? topCustomerSpend;
            for (final e in byCustomer.entries) {
              if (topCustomerOrders == null || e.value.length > byCustomer[topCustomerOrders]!.length) topCustomerOrders = e.key;
              double spend(List<Map<String, dynamic>> xs) => xs.fold<double>(0, (sum, o) => sum + ((o['deliveryFee'] as num?)?.toDouble() ?? 0));
              if (topCustomerSpend == null || spend(e.value) > spend(byCustomer[topCustomerSpend]!)) topCustomerSpend = e.key;
            }
            final avgMinutes = timedOrders == 0 ? null : totalMinutes / timedOrders;
            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                const _AnalyticsHeading(title: 'تحليلات الإدارة', subtitle: 'مطابقة لصفحة admin-analytics في الويب.'),
                const SizedBox(height: 14),
                _AnalyticsCard(text: 'الطلبات المكتملة: ' + completed.length.toString()),
                _AnalyticsCard(text: topDriver == null ? 'أعلى سائق حسب الطلبات المكتملة: —' : 'أعلى سائق حسب الطلبات المكتملة: ' + (users[topDriver] ?? '—') + ' (' + byDriver[topDriver]!.length.toString() + ' طلب)'),
                _AnalyticsCard(text: fastestDriver == null ? 'أسرع سائق حسب متوسط الإنجاز: —' : 'أسرع سائق حسب متوسط الإنجاز: ' + (users[fastestDriver] ?? '—') + ' (' + fastestMinutes!.round().toString() + ' دقيقة)'),
                _AnalyticsCard(text: avgMinutes == null ? 'متوسط الزمن بين القبول والإكمال: —' : 'متوسط الزمن بين القبول والإكمال: ' + avgMinutes.round().toString() + ' دقيقة'),
                _AnalyticsCard(text: topCustomerOrders == null ? 'أعلى عميل حسب عدد الطلبات: —' : 'أعلى عميل حسب عدد الطلبات: ' + (users[topCustomerOrders] ?? '—') + ' (' + byCustomer[topCustomerOrders]!.length.toString() + ' طلب)'),
                _AnalyticsCard(text: topCustomerSpend == null ? 'أعلى عميل حسب الإنفاق: —' : 'أعلى عميل حسب الإنفاق: ' + (users[topCustomerSpend] ?? '—') + ' (' + byCustomer[topCustomerSpend]!.fold<double>(0, (sum, o) => sum + ((o['deliveryFee'] as num?)?.toDouble() ?? 0)).toStringAsFixed(0) + ' ج.س)'),
                const SizedBox(height: 8),
                const Text('أيام نشاط السائقين', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                for (final entry in activeDays.entries) _AnalyticsCard(text: (users[entry.key] ?? 'سائق') + ' — ' + entry.value.length.toString() + ' يوم'),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AnalyticsHeading extends StatelessWidget {
  const _AnalyticsHeading({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: Colors.black54))]);
}

class _AnalyticsCard extends StatelessWidget {
  const _AnalyticsCard({required this.text});
  final String text;
  @override Widget build(BuildContext context) => Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(14), child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700))));
}