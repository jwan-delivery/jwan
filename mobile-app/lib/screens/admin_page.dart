
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/admin_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

const _black = Color(0xFF111111);
const _yellow = Color(0xFFFFC400);

class AdminPage extends StatefulWidget {
  const AdminPage({super.key, required this.uid, required this.profile, required this.role});
  final String uid;
  final Map<String, dynamic> profile;
  final String role;
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final service = AdminService();
  int index = 0;
  bool showingDrivers = true;

  bool get isSuper => widget.role == 'super_admin';

  @override
  Widget build(BuildContext context) {
    final titles = <String>['الملخص', 'المستخدمون', 'الطلبات', 'الماليات', 'الدعم'];
    if (isSuper) titles.add('المدراء');
    final pages = <Widget>[_overview(), _users(), _orders(), _finance(), _support()];
    if (isSuper) pages.add(_managers());

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[index], style: const TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: _black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () => setState(() {}), icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout)),
        ],
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'ملخص'),
          const NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'المستخدمون'),
          const NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'الطلبات'),
          const NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'الماليات'),
          const NavigationDestination(icon: Icon(Icons.support_agent_outlined), selectedIcon: Icon(Icons.support_agent), label: 'الدعم'),
          if (isSuper) const NavigationDestination(icon: Icon(Icons.admin_panel_settings_outlined), selectedIcon: Icon(Icons.admin_panel_settings), label: 'المدراء'),
        ],
      ),
    );
  }

  Widget _overview() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: service.allOrders(),
      builder: (_, ordersSnap) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: service.users('driver'),
        builder: (_, driversSnap) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: service.users('customer'),
          builder: (_, customersSnap) {
            if (ordersSnap.hasError || driversSnap.hasError || customersSnap.hasError) {
              return _error(ordersSnap.error ?? driversSnap.error ?? customersSnap.error);
            }
            final orders = ordersSnap.data?.docs ?? const [];
            final drivers = driversSnap.data?.docs ?? const [];
            final customers = customersSnap.data?.docs ?? const [];
            final active = orders.where((d) => !['completed', 'cancelled', 'rejected'].contains(d.data()['status'])).length;
            final completed = orders.where((d) => d.data()['status'] == 'completed').length;
            final pendingDrivers = drivers.where((d) => d.data()['status'] == 'pending').length;
            final revenue = orders.where((d) => d.data()['status'] == 'completed').fold<double>(
              0,
              (sum, d) => sum + ((d.data()['deliveryFee'] as num?)?.toDouble() ?? 0),
            );
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: _black,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('مرحبًا ' + display(widget.profile['name']), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text(isSuper ? 'إدارة عليا' : 'إدارة', style: const TextStyle(color: Colors.white70)),
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
                _stats([
                  ('كل الطلبات', orders.length),
                  ('النشطة', active),
                  ('المكتملة', completed),
                  ('السائقون', drivers.length),
                  ('السائقون بانتظار التفعيل', pendingDrivers),
                  ('العملاء', customers.length),
                ]),
                const SizedBox(height: 12),
                Card(child: ListTile(
                  leading: const CircleAvatar(backgroundColor: _yellow, child: Icon(Icons.payments, color: _black)),
                  title: const Text('أجور الطلبات المكتملة'),
                  trailing: Text(money(revenue)),
                )),
                const SizedBox(height: 8),
                const Text('الوظائف الأساسية: المستخدمون، الطلبات، التفعيل، المحفظة، الشحن، السحب، الدعم، والتحليلات.', textAlign: TextAlign.center),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _users() {
    final role = showingDrivers ? 'driver' : 'customer';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('السائقون')),
              ButtonSegment(value: false, label: Text('العملاء')),
            ],
            selected: {showingDrivers},
            onSelectionChanged: (s) => setState(() => showingDrivers = s.first),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: service.users(role),
            builder: (_, snap) {
              if (snap.hasError) return _error(snap.error);
              if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              final docs = snap.data?.docs ?? const [];
              if (docs.isEmpty) return const Center(child: Text('لا توجد حسابات.'));
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final d = docs[i];
                  final u = d.data();
                  final status = display(u['status']);
                  return Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(display(u['name']), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(display(u['phone']) + ' • ' + display(u['state'])),
                        if (role == 'driver') Text('المركبة: ' + display(u['vehicleType']) + ' • الحالة: ' + status),
                        const SizedBox(height: 8),
                        Wrap(spacing: 6, runSpacing: 6, children: [
                          if (status != 'active') _button('تفعيل', () => _run(() => service.setUserStatus(uid: d.id, status: 'active'))),
                          if (status != 'suspended') _button('إيقاف', () => _run(() => service.setUserStatus(uid: d.id, status: 'suspended'))),
                          if (status != 'rejected') _button('رفض', () => _run(() => service.setUserStatus(uid: d.id, status: 'rejected')),
                          if (role == 'driver' && status == 'active') _button('شحن يدوي', () => _manualTopup(d.id, display(u['name']))),
                          if (isSuper) _button('حذف', () => _confirmDelete(d.id, display(u['name'])), danger: true),
                        ]),
                      ]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _orders() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: service.allOrders(),
      builder: (_, snap) {
        if (snap.hasError) return _error(snap.error);
        if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        final docs = snap.data?.docs ?? const [];
        if (docs.isEmpty) return const Center(child: Text('لا توجد طلبات.'));
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final d = docs[i];
            final o = d.data();
            final status = display(o['status']);
            return Card(
              child: ListTile(
                title: Text('طلب #' + shortId(d.id), style: const TextStyle(fontWeight: FontWeight.w900)),
                subtitle: Text(display(o['origin']) + ' ← ' + display(o['destination']) + '\nالحالة: ' + status + ' • السعر: ' + display(o['agreedFee']) + ' ج.س'),
                isThreeLine: true,
                onTap: () => _orderDetails(o, d.id),
                trailing: (status == 'pending' || status == 'accepted')
                    ? IconButton(onPressed: () => _run(() => service.cancelOrder(d.id)), icon: const Icon(Icons.cancel_outlined))
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  Widget _finance() {
    return DefaultTabController(
      length: 2,
      child: Column(children: [
        const TabBar(tabs: [Tab(text: 'الشحن'), Tab(text: 'السحب')]),
        Expanded(child: TabBarView(children: [_topups(), _withdrawals()])),
      ]),
    );
  }

  Widget _topups() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: service.topups(),
      builder: (_, snap) {
        if (snap.hasError) return _error(snap.error);
        final docs = snap.data?.docs ?? const [];
        if (docs.isEmpty) return const Center(child: Text('لا توجد طلبات شحن.'));
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final d = docs[i];
            final r = d.data();
            final status = display(r['status']);
            return Card(child: ListTile(
              title: Text(display(r['driverId']) + ' • ' + display(r['amount']) + ' ج.س'),
              subtitle: Text(display(r['paymentMethod']) + ' • ' + status),
              trailing: status == 'pending'
                  ? Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(onPressed: () => _run(() => service.reviewTopup(adminUid: widget.uid, requestId: d.id, approve: true)), icon: const Icon(Icons.check)),
                      IconButton(onPressed: () => _run(() => service.reviewTopup(adminUid: widget.uid, requestId: d.id, approve: false)), icon: const Icon(Icons.close)),
                    ])
                  : null,
            ));
          },
        );
      },
    );
  }

  Widget _withdrawals() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: service.withdrawals(),
      builder: (_, snap) {
        if (snap.hasError) return _error(snap.error);
        final docs = snap.data?.docs ?? const [];
        if (docs.isEmpty) return const Center(child: Text('لا توجد طلبات سحب.'));
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final d = docs[i];
            final r = d.data();
            final status = display(r['status']);
            return Card(child: ListTile(
              title: Text(display(r['driverId']) + ' • ' + display(r['amount']) + ' ج.س'),
              subtitle: Text(display(r['paymentMethod']) + ' • ' + display(r['accountReference']) + ' • ' + status),
              trailing: status == 'pending'
                  ? Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(onPressed: () => _run(() => service.reviewWithdrawal(adminUid: widget.uid, requestId: d.id, status: 'paid')), icon: const Icon(Icons.paid_outlined)),
                      IconButton(onPressed: () => _run(() => service.reviewWithdrawal(adminUid: widget.uid, requestId: d.id, status: 'rejected')), icon: const Icon(Icons.close)),
                    ])
                  : null,
            ));
          },
        );
      },
    );
  }

  Widget _support() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: service.supportMessages(),
      builder: (_, snap) {
        if (snap.hasError) return _error(snap.error);
        final docs = snap.data?.docs ?? const [];
        if (docs.isEmpty) return const Center(child: Text('لا توجد رسائل دعم.'));
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final d = docs[i];
            final x = d.data();
            return Card(child: ListTile(
              title: Text(display(x['message']), maxLines: 3, overflow: TextOverflow.ellipsis),
              subtitle: Text(x['reply'] == null ? 'بانتظار الرد' : 'الرد: ' + display(x['reply'])),
              trailing: x['reply'] == null ? IconButton(onPressed: () => _reply(d.id), icon: const Icon(Icons.reply)) : null,
            ));
          },
        );
      },
    );
  }

  Widget _managers() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: service.managers(),
      builder: (_, snap) {
        if (snap.hasError) return _error(snap.error);
        final docs = snap.data?.docs ?? const [];
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            FilledButton.icon(onPressed: _createManager, icon: const Icon(Icons.person_add), label: const Text('إنشاء مدير')),
            const SizedBox(height: 10),
            ...docs.map((d) {
              final u = d.data();
              final self = d.id == widget.uid;
              return Card(child: ListTile(
                title: Text(display(u['name'])),
                subtitle: Text(display(u['phone']) + ' • ' + display(u['role']) + ' • ' + display(u['status'])),
                trailing: self ? const Chip(label: Text('أنت')) : PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'active') await _run(() => service.setUserStatus(uid: d.id, status: 'active'));
                    if (v == 'suspend') await _run(() => service.setUserStatus(uid: d.id, status: 'suspended'));
                    if (v == 'admin') await _run(() => service.setManagerRole(uid: d.id, role: 'admin'));
                    if (v == 'super') await _run(() => service.setManagerRole(uid: d.id, role: 'super_admin'));
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'active', child: Text('تفعيل')),
                    PopupMenuItem(value: 'suspend', child: Text('إيقاف')),
                    PopupMenuItem(value: 'admin', child: Text('Admin')),
                    PopupMenuItem(value: 'super', child: Text('Super Admin')),
                  ],
                ),
              ));
            }),
          ],
        );
      },
    );
  }

  Widget _stats(List<(String, int)> items) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: items.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 82, crossAxisSpacing: 8, mainAxisSpacing: 8),
    itemBuilder: (_, i) => Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(items[i].$1, style: const TextStyle(color: Colors.black54)),
      const Spacer(),
      Text(items[i].$2.toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
    ]))),
  );

  Widget _button(String label, VoidCallback fn, {bool danger = false}) => OutlinedButton(
    onPressed: fn,
    style: OutlinedButton.styleFrom(foregroundColor: danger ? Colors.red.shade700 : _black),
    child: Text(label),
  );

  Widget _error(Object? e) => Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('تعذر تحميل البيانات\n' + display(e), textAlign: TextAlign.center)));

  Future<void> _run(Future<void> Function() fn) async {
    try {
      await fn();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم التنفيذ')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(display(e)), backgroundColor: Colors.red.shade700));
    }
  }

  Future<void> _orderDetails(Map<String, dynamic> o, String id) async {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('طلب #' + shortId(id)),
        content: SingleChildScrollView(child: Text([
          'الحالة: ' + display(o['status']),
          'الاستلام: ' + display(o['origin']),
          'التسليم: ' + display(o['destination']),
          'المركبة: ' + display(o['vehicleType']),
          'الخدمة: ' + display(o['serviceCategory']),
          'العميل: ' + display(o['customerId']),
          'السائق: ' + display(o['driverId']),
          'السعر: ' + display(o['agreedFee']) + ' ج.س',
          'المفاوضة: ' + display(o['negotiationStatus']),
        ].join('\n'))),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق'))],
      ),
    );
  }

  Future<void> _manualTopup(String driverId, String name) async {
    final amount = TextEditingController();
    final note = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('شحن يدوي — ' + name),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ')),
          const SizedBox(height: 8),
          TextField(controller: note, decoration: const InputDecoration(labelText: 'ملاحظة')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('شحن')),
        ],
      ),
    );
    if (ok == true) await _run(() => service.manualTopup(adminUid: widget.uid, driverId: driverId, amount: num.tryParse(amount.text.trim()) ?? 0, note: note.text));
    amount.dispose();
    note.dispose();
  }

  Future<void> _reply(String id) async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('الرد على الرسالة'),
        content: TextField(controller: controller, maxLines: 5, maxLength: 3000),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('إرسال')),
        ],
      ),
    );
    if (ok == true) await _run(() => service.replySupport(adminUid: widget.uid, requestId: id, reply: controller.text));
    controller.dispose();
  }

  Future<void> _confirmDelete(String uid, String name) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف الحساب'),
        content: Text('حذف ملف ' + name + '؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف')),
        ],
      ),
    );
    if (ok == true) await _run(() => service.deleteUser(uid: uid));
  }

  Future<void> _createManager() async {
    final name = TextEditingController();
    final phone = TextEditingController();
    final password = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إنشاء مدير'),
        content: SingleChildScrollView(child: Column(children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم')),
          const SizedBox(height: 8),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'الهاتف')),
          const SizedBox(height: 8),
          TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور')),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('إنشاء')),
        ],
      ),
    );
    if (ok == true) await _run(() => service.createManager(name: name.text, phone: phone.text, password: password.text));
    name.dispose();
    phone.dispose();
    password.dispose();
  }
}

String display(Object? value) => value == null ? '-' : value.toString();
String money(num value) => value.toStringAsFixed(0) + ' ج.س';
String shortId(String id) => id.length <= 8 ? id : id.substring(0, 8);
