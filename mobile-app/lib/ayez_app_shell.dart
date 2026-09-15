import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart' as legacy;

const ayezBlack = Color(0xFF0A0A0A);
const ayezBlack2 = Color(0xFF131315);
const ayezYellow = Color(0xFFF5C400);
const ayezBg = Color(0xFFF5F3EE);
const ayezMuted = Color(0xFF6B6B6B);

class AyezHomeGate extends StatelessWidget {
  const AyezHomeGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, auth) {
        if (auth.connectionState == ConnectionState.waiting) {
          return const Scaffold(backgroundColor: ayezBlack, body: Center(child: CircularProgressIndicator(color: ayezYellow)));
        }
        final user = auth.data;
        if (user == null) return const legacy.LoginPage();
        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
          builder: (context, profile) {
            if (profile.connectionState == ConnectionState.waiting) {
              return const Scaffold(backgroundColor: ayezBlack, body: Center(child: CircularProgressIndicator(color: ayezYellow)));
            }
            if (profile.hasError || !profile.hasData || !profile.data!.exists) return const _ProfileErrorPage();
            final data = profile.data!.data()!;
            final status = '${data['status'] ?? 'active'}';
            if (status == 'suspended' || status == 'rejected') return _BlockedPage(status: status);
            return AyezAppShell(profile: data);
          },
        );
      },
    );
  }
}

class AyezAppShell extends StatefulWidget {
  final Map<String, dynamic> profile;
  const AyezAppShell({super.key, required this.profile});
  @override
  State<AyezAppShell> createState() => _AyezAppShellState();
}

class _AyezAppShellState extends State<AyezAppShell> {
  int index = 0;
  String get role => '${widget.profile['role'] ?? 'customer'}';
  String get name => '${widget.profile['name'] ?? 'مستخدم عايز'}';

  List<_NavItem> get items {
    if (role == 'driver') {
      return const [
        _NavItem(Icons.home_rounded, 'الرئيسية'),
        _NavItem(Icons.receipt_long_rounded, 'الطلبات'),
        _NavItem(Icons.account_balance_wallet_rounded, 'المحفظة'),
        _NavItem(Icons.notifications_none_rounded, 'الإشعارات'),
      ];
    }
    if (role == 'admin' || role == 'super_admin' || role == 'office_manager') {
      return const [
        _NavItem(Icons.dashboard_rounded, 'الإدارة'),
        _NavItem(Icons.receipt_long_rounded, 'الطلبات'),
        _NavItem(Icons.people_alt_outlined, 'المستخدمون'),
        _NavItem(Icons.notifications_none_rounded, 'الإشعارات'),
      ];
    }
    return const [
      _NavItem(Icons.home_rounded, 'الرئيسية'),
      _NavItem(Icons.receipt_long_rounded, 'طلباتي'),
      _NavItem(Icons.notifications_none_rounded, 'الإشعارات'),
      _NavItem(Icons.person_outline_rounded, 'حسابي'),
    ];
  }

  Widget pageFor(int selected) {
    if (role == 'driver') {
      if (selected == 1) return legacy.OrdersPage(profile: widget.profile);
      if (selected == 2) return const AyezWalletPage();
      if (selected == 3) return const AyezNotificationsPage();
      return AyezDriverHome(profile: widget.profile);
    }
    if (role == 'admin' || role == 'super_admin' || role == 'office_manager') {
      if (selected == 1) return const legacy.AdminOrdersPage();
      if (selected == 2) return const legacy.AdminUsersPage();
      if (selected == 3) return const AyezNotificationsPage();
      return AyezAdminHome(profile: widget.profile);
    }
    if (selected == 1) return legacy.OrdersPage(profile: widget.profile);
    if (selected == 2) return const AyezNotificationsPage();
    if (selected == 3) return AyezAccountPage(profile: widget.profile);
    return AyezCustomerHome(profile: widget.profile);
  }

  void openCreateOrder() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ayezBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => legacy.CreateOrderSheet(profile: widget.profile),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nav = items;
    final safeIndex = index.clamp(0, nav.length - 1);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ayezBg,
        appBar: AppBar(
          backgroundColor: ayezBlack,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Row(children: [
            Container(width: 40, height: 40, padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: ayezYellow, borderRadius: BorderRadius.circular(12)), child: Image.asset('assets/branding/jawan-logo.png', fit: BoxFit.contain)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('عايز', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Color(0xFFB8B8B8))),
            ])),
          ]),
          actions: [
            Builder(builder: (drawerContext) => IconButton(tooltip: 'القائمة', onPressed: () => Scaffold.of(drawerContext).openEndDrawer(), icon: const Icon(Icons.menu_rounded))),
          ],
        ),
        endDrawer: AyezDrawer(profile: widget.profile, items: nav, onSelect: (value) { Navigator.pop(context); setState(() => index = value); }),
        body: SafeArea(child: pageFor(safeIndex)),
        bottomNavigationBar: NavigationBar(
          selectedIndex: safeIndex,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          indicatorColor: const Color(0x22F5C400),
          onDestinationSelected: (value) => setState(() => index = value),
          destinations: nav.map((item) => NavigationDestination(icon: Icon(item.icon), selectedIcon: Icon(item.icon, color: ayezBlack), label: item.label)).toList(),
        ),
        floatingActionButton: role == 'customer' && safeIndex == 0
            ? FloatingActionButton.extended(backgroundColor: ayezYellow, foregroundColor: ayezBlack, onPressed: openCreateOrder, icon: const Icon(Icons.add_rounded), label: const Text('طلب جديد', style: TextStyle(fontWeight: FontWeight.w900)))
            : null,
      ),
    );
  }
}

class AyezDrawer extends StatelessWidget {
  final Map<String, dynamic> profile;
  final List<_NavItem> items;
  final ValueChanged<int> onSelect;
  const AyezDrawer({super.key, required this.profile, required this.items, required this.onSelect});
  @override
  Widget build(BuildContext context) {
    final elevated = profile['role'] == 'admin' || profile['role'] == 'super_admin' || profile['role'] == 'office_manager';
    return Drawer(
      backgroundColor: ayezBlack,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(children: [
            Row(children: [
              Container(width: 50, height: 50, padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: ayezYellow, borderRadius: BorderRadius.circular(15)), child: Image.asset('assets/branding/jawan-logo.png', fit: BoxFit.contain)),
              const SizedBox(width: 12),
              const Text('عايز', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
              const Spacer(),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded, color: Colors.white)),
            ]),
            const SizedBox(height: 18),
            Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: ayezBlack2, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0x18FFFFFF))), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text('${profile['name'] ?? ''}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text('${profile['phone'] ?? ''}', style: const TextStyle(color: Color(0xFF9C9C9C), fontSize: 12)),
              const SizedBox(height: 4),
              Text('${profile['role'] ?? ''} • ${profile['status'] ?? ''}', style: const TextStyle(color: ayezYellow, fontSize: 12, fontWeight: FontWeight.w800)),
            ])),
            const SizedBox(height: 12),
            Expanded(child: ListView(children: [
              for (var i = 0; i < items.length; i++) ListTile(leading: Icon(items[i].icon, color: ayezYellow), title: Text(items[i].label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), onTap: () => onSelect(i)),
              if (elevated) ListTile(leading: const Icon(Icons.account_balance_wallet_outlined, color: ayezYellow), title: const Text('طلبات الشحن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const legacy.AdminTopupsPage())); }),
              ListTile(leading: const Icon(Icons.support_agent_rounded, color: ayezYellow), title: const Text('الدعم عبر واتساب', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), subtitle: const Text('فتح المحادثة مباشرة', style: TextStyle(color: Color(0xFF858585), fontSize: 11)), onTap: () { Navigator.pop(context); legacy.openJawanWhatsApp(context); }),
            ])),
            const Divider(color: Color(0x22FFFFFF)),
            ListTile(leading: const Icon(Icons.logout_rounded, color: Colors.redAccent), title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), onTap: () => FirebaseAuth.instance.signOut()),
          ]),
        ),
      ),
    );
  }
}

class _NavItem { final IconData icon; final String label; const _NavItem(this.icon, this.label); }

class AyezCustomerHome extends StatelessWidget {
  final Map<String, dynamic> profile;
  const AyezCustomerHome({super.key, required this.profile});
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return ListView(padding: const EdgeInsets.fromLTRB(18, 20, 18, 30), children: [
      const _HeroCard(eyebrow: 'منصة سودانية للتوصيل والنقل', title: 'توصيلك يبدأ من هنا', body: 'اطلب، تفاوض، تابع، وتواصل بسهولة من تطبيق واحد.'),
      const SizedBox(height: 16),
      const Row(children: [Expanded(child: _MiniCard(icon: Icons.speed_rounded, title: 'سريع', value: 'متابعة مباشرة')), SizedBox(width: 10), Expanded(child: _MiniCard(icon: Icons.local_shipping_outlined, title: 'مرن', value: 'ركاب وبضائع'))]),
      const SizedBox(height: 16),
      const Text('أحدث طلباتك', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('orders').where('customerId', isEqualTo: uid).orderBy('createdAt', descending: true).limit(3).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const _InfoCard(text: 'تعذر تحميل الطلبات الآن.');
          final docs = snapshot.data?.docs ?? const [];
          if (docs.isEmpty) return const _InfoCard(text: 'لا توجد طلبات حتى الآن. اضغط «طلب جديد» للبدء.');
          return Column(children: docs.map((doc) => legacy.OrderCard(order: {'id': doc.id, ...doc.data()}, profile: profile)).toList());
        },
      ),
    ]);
  }
}

class AyezDriverHome extends StatelessWidget {
  final Map<String, dynamic> profile;
  const AyezDriverHome({super.key, required this.profile});
  @override
  Widget build(BuildContext context) {
    final state = '${profile['state'] ?? ''}';
    return ListView(padding: const EdgeInsets.fromLTRB(18, 20, 18, 30), children: [
      const _HeroCard(eyebrow: 'مساحة السائق', title: 'كن جاهزًا للطلب التالي', body: 'الطلبات المتاحة في ولايتك تظهر هنا بنفس نموذج النظام.'),
      const SizedBox(height: 14),
      if ('${profile['status']}' != 'active') const _InfoCard(text: 'حساب السائق بانتظار اعتماد الإدارة.'),
      const SizedBox(height: 10),
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: legacy.OrderService().availableOrders(state), builder: (context, snapshot) => _MiniCard(icon: Icons.inbox_rounded, title: 'الطلبات المتاحة', value: '${snapshot.data?.docs.length ?? 0} طلب')),
      const SizedBox(height: 14),
      const Text('الطلبات المتاحة الآن', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: legacy.OrderService().availableOrders(state), builder: (context, snapshot) {
        if (snapshot.hasError) return const _InfoCard(text: 'تعذر تحميل الطلبات الآن.');
        final docs = snapshot.data?.docs ?? const [];
        if (docs.isEmpty) return const _InfoCard(text: 'لا توجد طلبات متاحة حاليًا.');
        return Column(children: docs.map((doc) => legacy.OrderCard(order: {'id': doc.id, ...doc.data()}, profile: profile, showAccept: true)).toList());
      }),
    ]);
  }
}

class AyezAdminHome extends StatelessWidget {
  final Map<String, dynamic> profile;
  const AyezAdminHome({super.key, required this.profile});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(18, 20, 18, 30), children: [
    const _HeroCard(eyebrow: 'لوحة الإدارة', title: 'إدارة عايز', body: 'متابعة الطلبات والمستخدمين وعمليات المحفظة من واجهة واحدة.'),
    const SizedBox(height: 14),
    Row(children: [Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('orders').limit(200).snapshots(), builder: (context, s) => _MiniCard(icon: Icons.receipt_long_rounded, title: 'الطلبات', value: '${s.data?.docs.length ?? 0}'))), const SizedBox(width: 10), Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('users').limit(300).snapshots(), builder: (context, s) => _MiniCard(icon: Icons.people_alt_outlined, title: 'المستخدمون', value: '${s.data?.docs.length ?? 0}')))]),
    const SizedBox(height: 14),
    _AdminAction(icon: Icons.people_alt_outlined, title: 'المستخدمون', text: 'إدارة المستخدمين وحالات الحسابات.', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const legacy.AdminUsersPage()))),
    _AdminAction(icon: Icons.account_balance_wallet_outlined, title: 'طلبات الشحن', text: 'مراجعة طلبات شحن المحافظ.', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const legacy.AdminTopupsPage()))),
    _AdminAction(icon: Icons.receipt_long_rounded, title: 'كل الطلبات', text: 'متابعة الطلبات والحالات.', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const legacy.AdminOrdersPage()))),
  ]);
}

class AyezAccountPage extends StatelessWidget {
  final Map<String, dynamic> profile;
  const AyezAccountPage({super.key, required this.profile});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [
    const _PageHeading(title: 'حسابي', subtitle: 'معلومات الحساب الحالية'),
    const SizedBox(height: 12),
    _InfoRow(title: 'الاسم', value: '${profile['name'] ?? ''}', icon: Icons.person_outline),
    _InfoRow(title: 'الهاتف', value: '${profile['phone'] ?? ''}', icon: Icons.phone_outlined),
    _InfoRow(title: 'الولاية', value: '${profile['state'] ?? ''}', icon: Icons.location_on_outlined),
    _InfoRow(title: 'السكن', value: '${profile['address'] ?? ''}', icon: Icons.home_outlined),
    _InfoRow(title: 'الحالة', value: '${profile['status'] ?? ''}', icon: Icons.verified_user_outlined),
    const SizedBox(height: 12),
    FilledButton.icon(onPressed: () => legacy.openJawanWhatsApp(context), icon: const Icon(Icons.support_agent_rounded), label: const Text('التواصل مع الدعم')),
  ]);
}

class AyezWalletPage extends StatelessWidget {
  const AyezWalletPage({super.key});
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return ListView(padding: const EdgeInsets.fromLTRB(18, 20, 18, 30), children: [
      const _PageHeading(title: 'المحفظة', subtitle: 'الرصيد والعمولات وحركات الحساب'),
      const SizedBox(height: 12),
      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('wallets').doc(uid).snapshots(), builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? const <String, dynamic>{};
        final balance = (data['balance'] as num?)?.toInt() ?? 0;
        final commission = (data['totalCommission'] as num?)?.toInt() ?? 0;
        final penalties = (data['totalCancellationPenalties'] as num?)?.toInt() ?? 0;
        return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: ayezBlack, borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [const Text('الرصيد الحالي', style: TextStyle(color: Color(0xFFB8B8B8))), const SizedBox(height: 4), Text('$balance ج.س', style: const TextStyle(color: ayezYellow, fontSize: 34, fontWeight: FontWeight.w900)), const SizedBox(height: 12), Text('العمولات: $commission', style: const TextStyle(color: Colors.white)), Text('غرامات الإلغاء: $penalties', style: const TextStyle(color: Colors.white))]));
      }),
      const SizedBox(height: 14),
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('walletTransactions').where('userId', isEqualTo: uid).orderBy('createdAt', descending: true).limit(30).snapshots(), builder: (context, snapshot) {
        if (snapshot.hasError) return const _InfoCard(text: 'تعذر تحميل الحركات المالية.');
        final docs = snapshot.data?.docs ?? const [];
        if (docs.isEmpty) return const _InfoCard(text: 'لا توجد حركات مالية حتى الآن.');
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [const Text('آخر الحركات', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)), const SizedBox(height: 8), ...docs.map((doc) { final item = doc.data(); return Card(elevation: 0, child: ListTile(leading: const Icon(Icons.swap_vert_rounded), title: Text('${item['type'] ?? ''}'), subtitle: Text('${item['createdAt'] ?? ''}'), trailing: Text('${item['amount'] ?? 0} ج.س', style: const TextStyle(fontWeight: FontWeight.w900)))); })]);
      }),
    ]);
  }
}

class AyezNotificationsPage extends StatelessWidget {
  const AyezNotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return ListView(padding: const EdgeInsets.all(18), children: [
      const _PageHeading(title: 'الإشعارات', subtitle: 'آخر التنبيهات الخاصة بحسابك'),
      const SizedBox(height: 12),
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('notifications').where('userId', isEqualTo: uid).orderBy('createdAt', descending: true).limit(100).snapshots(), builder: (context, snapshot) {
        if (snapshot.hasError) return const _InfoCard(text: 'تعذر تحميل الإشعارات.');
        final docs = snapshot.data?.docs ?? const [];
        if (docs.isEmpty) return const _InfoCard(text: 'لا توجد إشعارات جديدة.');
        return Column(children: docs.map((doc) { final item = doc.data(); return Card(elevation: 0, child: ListTile(leading: const Icon(Icons.notifications_none_rounded), title: Text('${item['title'] ?? 'عايز'}'), subtitle: Text('${item['body'] ?? ''}'), onTap: () => doc.reference.update({'read': true}))); }).toList());
      }),
    ]);
  }
}

class _HeroCard extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String body;
  const _HeroCard({required this.eyebrow, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: ayezBlack, borderRadius: BorderRadius.circular(26), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 24, offset: Offset(0, 10))]), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text(eyebrow, style: const TextStyle(color: ayezYellow, fontWeight: FontWeight.w800, fontSize: 12)), const SizedBox(height: 7), Text(title, style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text(body, style: const TextStyle(color: Color(0xFFB8B8B8), height: 1.7))]);
}

class _MiniCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _MiniCard({required this.icon, required this.title, required this.value});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(15), child: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0x12F5C400), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: ayezBlack)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text(title, style: const TextStyle(color: ayezMuted, fontSize: 12)), const SizedBox(height: 2), Text(value, style: const TextStyle(fontWeight: FontWeight.w900))]))]));
}

class _InfoCard extends StatelessWidget {
  final String text;
  const _InfoCard({required this.text});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE9E6DF))), child: Row(children: [const Icon(Icons.info_outline_rounded, color: ayezYellow), const SizedBox(width: 10), Expanded(child: Text(text, style: const TextStyle(color: ayezMuted, height: 1.6)))]));
}

class _PageHeading extends StatelessWidget {
  final String title;
  final String subtitle;
  const _PageHeading({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: ayezMuted))]);
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _InfoRow({required this.title, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: ListTile(leading: Icon(icon), title: Text(title, style: const TextStyle(fontSize: 12, color: ayezMuted)), subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w800))));
}

class _AdminAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final VoidCallback onTap;
  const _AdminAction({required this.icon, required this.title, required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: ListTile(leading: Icon(icon), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), subtitle: Text(text), trailing: const Icon(Icons.chevron_left_rounded), onTap: onTap));
}

class _ProfileErrorPage extends StatelessWidget {
  const _ProfileErrorPage();
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: ayezBlack, body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.person_off_rounded, color: ayezYellow, size: 48), const SizedBox(height: 12), const Text('تعذر تحميل الحساب', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)), const SizedBox(height: 8), const Text('سجّل الخروج ثم أعد تسجيل الدخول.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFB8B8B8))), const SizedBox(height: 16), FilledButton(onPressed: () => FirebaseAuth.instance.signOut(), child: const Text('تسجيل الخروج'))])));
}

class _BlockedPage extends StatelessWidget {
  final String status;
  const _BlockedPage({required this.status});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: ayezBlack, body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.block_rounded, color: ayezYellow, size: 48), const SizedBox(height: 12), const Text('الحساب غير متاح حاليًا', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text(status == 'rejected' ? 'تم رفض الحساب.' : 'تم تعليق الحساب. تواصل مع الإدارة.', textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFB8B8B8))), const SizedBox(height: 16), FilledButton(onPressed: () => FirebaseAuth.instance.signOut(), child: const Text('تسجيل الخروج'))])));
}
