import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main.dart' as legacy;

const _black = Color(0xFF0A0A0A);
const _black2 = Color(0xFF131315);
const _yellow = Color(0xFFF5C400);
const _bg = Color(0xFFF5F3EE);
const _muted = Color(0xFF6B6B6B);

class AyezHomeGate extends StatelessWidget {
  const AyezHomeGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, auth) {
        if (auth.connectionState == ConnectionState.waiting) {
          return const Scaffold(backgroundColor: _black, body: Center(child: CircularProgressIndicator(color: _yellow)));
        }
        final user = auth.data;
        if (user == null) return const legacy.LoginPage();
        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
          builder: (context, profile) {
            if (profile.connectionState == ConnectionState.waiting) {
              return const Scaffold(backgroundColor: _black, body: Center(child: CircularProgressIndicator(color: _yellow)));
            }
            if (profile.hasError || !profile.hasData || !profile.data!.exists) {
              return Scaffold(
                backgroundColor: _black,
                body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.person_off_rounded, color: _yellow, size: 46),
                  const SizedBox(height: 12),
                  const Text('تعذر تحميل الحساب', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text('حاول تسجيل الخروج ثم الدخول مرة أخرى.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFB8B8B8))),
                  const SizedBox(height: 18),
                  FilledButton(onPressed: () => FirebaseAuth.instance.signOut(), child: const Text('تسجيل الخروج')),
                ]))),
              );
            }
            final data = profile.data!.data()!;
            final status = '${data['status'] ?? 'active'}';
            if (status == 'suspended' || status == 'rejected') {
              return Scaffold(
                backgroundColor: _black,
                body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.block_rounded, color: _yellow, size: 46),
                  const SizedBox(height: 12),
                  const Text('الحساب غير متاح حاليًا', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(status == 'rejected' ? 'تم رفض طلب الحساب.' : 'تم تعليق الحساب. تواصل مع الإدارة.', textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFB8B8B8))),
                  const SizedBox(height: 18),
                  FilledButton(onPressed: () => FirebaseAuth.instance.signOut(), child: const Text('تسجيل الخروج')),
                ]))),
              );
            }
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
  int _index = 0;

  String get role => '${widget.profile['role'] ?? 'customer'}';
  String get name => '${widget.profile['name'] ?? 'مستخدم عايز'}';

  List<_NavItem> get _items {
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

  Widget _page() {
    if (role == 'driver') {
      switch (_index) {
        case 1: return legacy.OrdersPage(profile: widget.profile);
        case 2: return const _WalletPage();
        case 3: return const _NotificationsBody();
        default: return _DriverHome(profile: widget.profile);
      }
    }
    if (role == 'admin' || role == 'super_admin' || role == 'office_manager') {
      switch (_index) {
        case 1: return const _AdminOrdersBody();
        case 2: return const _AdminUsersBody();
        case 3: return const _NotificationsBody();
        default: return _AdminHome(profile: widget.profile);
      }
    }
    switch (_index) {
      case 1: return legacy.OrdersPage(profile: widget.profile);
      case 2: return const _NotificationsBody();
      case 3: return _AccountBody(profile: widget.profile);
      default: return _CustomerHome(profile: widget.profile);
    }
  }

  void _openCreateOrder() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => legacy.CreateOrderSheet(profile: widget.profile),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    final current = items[_index.clamp(0, items.length - 1)];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _black,
          foregroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 18,
          title: Row(children: [
            Container(width: 40, height: 40, padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: _yellow, borderRadius: BorderRadius.circular(12)), child: Image.asset('assets/branding/jawan-logo.png', fit: BoxFit.contain)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('عايز', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Color(0xFFB8B8B8))),
            ])),
          ]),
          actions: [
            Builder(builder: (ctx) => IconButton(onPressed: () => Scaffold.of(ctx).openEndDrawer(), icon: const Icon(Icons.menu_rounded))),
          ],
        ),
        endDrawer: _Drawer(profile: widget.profile, items: items, onSelect: (i) { Navigator.pop(context); setState(() => _index = i); }),
        body: SafeArea(child: _page()),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          indicatorColor: const Color(0x22F5C400),
          selectedIndex: _index.clamp(0, items.length - 1),
          onDestinationSelected: (value) => setState(() => _index = value),
          destinations: items.map((e) => NavigationDestination(icon: Icon(e.icon), selectedIcon: Icon(e.icon, color: _black), label: e.label)).toList(),
        ),
        floatingActionButton: role == 'customer' && _index == 0
            ? FloatingActionButton.extended(backgroundColor: _yellow, foregroundColor: _black, onPressed: _openCreateOrder, icon: const Icon(Icons.add_rounded), label: const Text('طلب جديد', style: TextStyle(fontWeight: FontWeight.w900)))
            : null,
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  final Map<String, dynamic> profile;
  final List<_NavItem> items;
  final ValueChanged<int> onSelect;
  const _Drawer({required this.profile, required this.items, required this.onSelect});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: _black,
      child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(18, 18, 18, 14), child: Column(children: [
        Row(children: [Container(width: 50, height: 50, padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: _yellow, borderRadius: BorderRadius.circular(15)), child: Image.asset('assets/branding/jawan-logo.png', fit: BoxFit.contain)), const SizedBox(width: 12), const Text('عايز', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)), const Spacer(), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded, color: Colors.white))]),
        const SizedBox(height: 22),
        Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: _black2, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0x18FFFFFF))), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text('${profile['name'] ?? ''}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text('${profile['phone'] ?? ''}', style: const TextStyle(color: Color(0xFF9C9C9C), fontSize: 12)), const SizedBox(height: 5), Text('${profile['role'] ?? ''} • ${profile['status'] ?? ''}', style: const TextStyle(color: _yellow, fontSize: 12, fontWeight: FontWeight.w800))])),
        const SizedBox(height: 16),
        Expanded(child: ListView(children: [for (var i = 0; i < items.length; i++) ListTile(leading: Icon(items[i].icon, color: _yellow), title: Text(items[i].label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), onTap: () => onSelect(i)),
          if (profile['role'] == 'admin' || profile['role'] == 'super_admin' || profile['role'] == 'office_manager') ...[
            ListTile(leading: const Icon(Icons.account_balance_wallet_outlined, color: _yellow), title: const Text('طلبات الشحن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const legacy.AdminTopupsPage())); }),
          ],
          ListTile(leading: const Icon(Icons.support_agent_rounded, color: _yellow), title: const Text('الدعم عبر واتساب', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), subtitle: const Text('فتح المحادثة مباشرة', style: TextStyle(color: Color(0xFF858585), fontSize: 11)), onTap: () { Navigator.pop(context); legacy.openJawanWhatsApp(context); }),
        ])),
        const Divider(color: Color(0x22FFFFFF)),
        ListTile(leading: const Icon(Icons.logout_rounded, color: Colors.redAccent), title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), onTap: () => FirebaseAuth.instance.signOut()),
      ])),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

class _CustomerHome extends StatelessWidget {
  final Map<String, dynamic> profile;
  const _CustomerHome({required this.profile});
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return ListView(padding: const EdgeInsets.fromLTRB(18, 20, 18, 30), children: [
      _Hero(title: 'أهلاً ${profile['name'] ?? ''}', text: 'اطلب خدمتك وتابع الطلب والتفاوض من مكان واحد.'),
      const SizedBox(height: 16),
      Row(children: [Expanded(child: _StatCard(icon: Icons.local_shipping_outlined, title: 'خدمة', value: 'نقل وتوصيل')), const SizedBox(width: 10), Expanded(child: _StatCard(icon: Icons.speed_rounded, title: 'مباشر', value: 'متابعة الطلب'))]),
      const SizedBox(height: 16),
      _SectionTitle(title: 'ابدأ الآن', action: 'طلب جديد', onTap: () => showModalBottomSheet<void>(context: context, isScrollControlled: true, backgroundColor: _bg, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))), builder: (_) => legacy.CreateOrderSheet(profile: profile))),
      const SizedBox(height: 10),
      _ActionCard(icon: Icons.add_road_rounded, title: 'إنشاء طلب', text: 'حدد المركبة والاستلام والوجهة والتفاصيل.', onTap: () => showModalBottomSheet<void>(context: context, isScrollControlled: true, backgroundColor: _bg, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))), builder: (_) => legacy.CreateOrderSheet(profile: profile))),
      const SizedBox(height: 10),
      _ActionCard(icon: Icons.history_rounded, title: 'طلباتك السابقة', text: 'راجع آخر الطلبات وحالة كل طلب.', onTap: () => DefaultTabController.of(context)?.animateTo(1)),
      const SizedBox(height: 14),
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('orders').where('customerId', isEqualTo: uid).orderBy('createdAt', descending: true).limit(3).snapshots(), builder: (context, snap) {
        if (snap.hasError) return _InfoBox(text: 'تعذر تحميل أحدث الطلبات.');
        final docs = snap.data?.docs ?? const [];
        if (docs.isEmpty) return const _InfoBox(text: 'لا توجد طلبات حتى الآن. ابدأ بطلب جديد.');
        return Column(children: [const Align(alignment: Alignment.centerRight, child: Text('أحدث طلباتك', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900))), const SizedBox(height: 8), ...docs.map((d) => legacy.OrderCard(order: {'id': d.id, ...d.data()}, profile: profile))]);
      }),
    ]);
  }
}

class _DriverHome extends StatelessWidget {
  final Map<String, dynamic> profile;
  const _DriverHome({required this.profile});
  @override
  Widget build(BuildContext context) {
    final state = '${profile['state'] ?? ''}';
    return ListView(padding: const EdgeInsets.fromLTRB(18, 20, 18, 30), children: [
      _Hero(title: 'لوحة السائق', text: 'الطلبات المتاحة في ${state.isEmpty ? 'ولايتك' : state} تظهر هنا.'),
      const SizedBox(height: 14),
      if ('${profile['status']}' != 'active') const _InfoBox(text: 'حسابك بانتظار اعتماد الإدارة. ستظهر الطلبات بعد الاعتماد.'),
      const SizedBox(height: 10),
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: legacy.OrderService().availableOrders(state), builder: (context, snap) {
        final count = snap.data?.docs.length ?? 0;
        return _StatCard(icon: Icons.inbox_rounded, title: 'الطلبات المتاحة', value: '$count طلب');
      }),
      const SizedBox(height: 14),
      _ActionCard(icon: Icons.account_balance_wallet_rounded, title: 'المحفظة', text: 'راجع رصيدك والعمولات وحركات المحفظة.', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _WalletPage()))),
      const SizedBox(height: 10),
      _ActionCard(icon: Icons.support_agent_rounded, title: 'الدعم', text: 'تواصل مع الدعم عبر واتساب مباشرة.', onTap: () => legacy.openJawanWhatsApp(context)),
      const SizedBox(height: 14),
      const Align(alignment: Alignment.centerRight, child: Text('الطلبات المتاحة الآن', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900))),
      const SizedBox(height: 8),
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: legacy.OrderService().availableOrders(state), builder: (context, snap) {
        if (snap.hasError) return _InfoBox(text: 'تعذر تحميل الطلبات المتاحة.');
        final docs = snap.data?.docs ?? const [];
        if (docs.isEmpty) return const _InfoBox(text: 'لا توجد طلبات متاحة حاليًا.');
        return Column(children: docs.map((d) => legacy.OrderCard(order: {'id': d.id, ...d.data()}, profile: profile, showAccept: true)).toList());
      }),
    ]);
  }
}

class _AdminHome extends StatelessWidget {
  final Map<String, dynamic> profile;
  const _AdminHome({required this.profile});
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(18, 20, 18, 30), children: [
      _Hero(title: 'لوحة الإدارة', text: 'مراقبة الطلبات والمستخدمين وإدارة التشغيل من مكان واحد.'),
      const SizedBox(height: 14),
      Row(children: [Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('orders').limit(200).snapshots(), builder: (context, s) => _StatCard(icon: Icons.receipt_long_rounded, title: 'الطلبات', value: '${s.data?.docs.length ?? 0}'))), const SizedBox(width: 10), Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('users').limit(300).snapshots(), builder: (context, s) => _StatCard(icon: Icons.people_alt_outlined, title: 'المستخدمون', value: '${s.data?.docs.length ?? 0}')))]),
      const SizedBox(height: 14),
      _ActionCard(icon: Icons.people_alt_outlined, title: 'إدارة المستخدمين', text: 'عرض المستخدمين وحالات الحسابات.', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const legacy.AdminUsersPage()))),
      const SizedBox(height: 10),
      _ActionCard(icon: Icons.account_balance_wallet_outlined, title: 'طلبات الشحن', text: 'مراجعة طلبات شحن المحافظ.', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const legacy.AdminTopupsPage()))),
      const SizedBox(height: 10),
      _ActionCard(icon: Icons.receipt_long_rounded, title: 'كل الطلبات', text: 'متابعة الطلبات وحالاتها.', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const legacy.AdminOrdersPage()))),
    ]);
  }
}

class _AccountBody extends StatelessWidget {
  final Map<String, dynamic> profile;
  const _AccountBody({required this.profile});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [
    const _PageTitle(title: 'حسابي', subtitle: 'معلومات الحساب الحالية'),
    const SizedBox(height: 12),
    _InfoTile(title: 'الاسم', value: '${profile['name'] ?? ''}', icon: Icons.person_outline_rounded),
    _InfoTile(title: 'الهاتف', value: '${profile['phone'] ?? ''}', icon: Icons.phone_outlined),
    _InfoTile(title: 'الولاية', value: '${profile['state'] ?? ''}', icon: Icons.location_on_outlined),
    _InfoTile(title: 'مكان السكن', value: '${profile['address'] ?? ''}', icon: Icons.home_outlined),
    _InfoTile(title: 'حالة الحساب', value: '${profile['status'] ?? ''}', icon: Icons.verified_user_outlined),
    const SizedBox(height: 10),
    FilledButton.icon(onPressed: () => legacy.openJawanWhatsApp(context), icon: const Icon(Icons.support_agent_rounded), label: const Text('التواصل مع الدعم')),
  ]);
}

class _WalletPage extends StatelessWidget {
  const _WalletPage();
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('wallets').doc(uid).snapshots(), builder: (context, wallet) {
      final data = wallet.data?.data() ?? const <String, dynamic>{};
      final balance = (data['balance'] as num?)?.toInt() ?? 0;
      final commission = (data['totalCommission'] as num?)?.toInt() ?? 0;
      final penalties = (data['totalCancellationPenalties'] as num?)?.toInt() ?? 0;
      return ListView(padding: const EdgeInsets.fromLTRB(18, 20, 18, 30), children: [
        const _PageTitle(title: 'المحفظة', subtitle: 'رصيدك وحركاتك المالية'),
        const SizedBox(height: 14),
        Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: _black, borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [const Text('الرصيد الحالي', style: TextStyle(color: Color(0xFFB8B8B8))), const SizedBox(height: 4), Text('$balance ج.س', style: const TextStyle(color: _yellow, fontSize: 34, fontWeight: FontWeight.w900)), const SizedBox(height: 15), Row(children: [Expanded(child: Text('عمولات: $commission', style: const TextStyle(color: Colors.white))), Expanded(child: Text('غرامات: $penalties', style: const TextStyle(color: Colors.white)))] )]),
        const SizedBox(height: 14),
        const _InfoBox(text: 'طلبات الشحن والسحب تتم وفق صلاحيات الإدارة وقواعد النظام الحالية.'),
        const SizedBox(height: 14),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('walletTransactions').where('userId', isEqualTo: uid).orderBy('createdAt', descending: true).limit(30).snapshots(), builder: (context, txs) {
          if (txs.hasError) return const _InfoBox(text: 'تعذر تحميل الحركات المالية.');
          final docs = txs.data?.docs ?? const [];
          if (docs.isEmpty) return const _InfoBox(text: 'لا توجد حركات مالية حتى الآن.');
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [const Text('آخر الحركات', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)), const SizedBox(height: 8), ...docs.map((d) { final x = d.data(); return Card(child: ListTile(leading: const Icon(Icons.swap_vert_rounded), title: Text('${x['type'] ?? ''}'), subtitle: Text('${x['createdAt'] ?? ''}'), trailing: Text('${x['amount'] ?? 0} ج.س', style: const TextStyle(fontWeight: FontWeight.w900))); })]);
        }),
      ]);
    });
  }
}

class _NotificationsBody extends StatelessWidget {
  const _NotificationsBody();
  @override
  Widget build(BuildContext context) => const legacy.NotificationsPage();
}

class _AdminOrdersBody extends StatelessWidget {
  const _AdminOrdersBody();
  @override
  Widget build(BuildContext context) => const legacy.AdminOrdersPage();
}

class _AdminUsersBody extends StatelessWidget {
  const _AdminUsersBody();
  @override
  Widget build(BuildContext context) => const legacy.AdminUsersPage();
}

class _Hero extends StatelessWidget {
  final String title;
  final String text;
  const _Hero({required this.title, required this.text});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: _black, borderRadius: BorderRadius.circular(26), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 24, offset: Offset(0, 10))]), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [const Text('منصة سودانية للتوصيل والنقل', style: TextStyle(color: _yellow, fontSize: 13, fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text(title, style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w900)), const SizedBox(height: 7), Text(text, style: const TextStyle(color: Color(0xFFB8B8B8), height: 1.7))]);
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onTap;
  const _SectionTitle({required this.title, required this.action, required this.onTap});
  @override
  Widget build(BuildContext context) => Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900))), TextButton(onPressed: onTap, child: Text(action, style: const TextStyle(color: _black, fontWeight: FontWeight.w900))) ]);
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.title, required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: InkWell(borderRadius: BorderRadius.circular(20), onTap: onTap, child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0x12F5C400), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: _black)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(text, style: const TextStyle(color: _muted, fontSize: 12, height: 1.45))])), const Icon(Icons.chevron_left_rounded, color: _muted)])));
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _StatCard({required this.icon, required this.title, required this.value});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(15), child: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0x12F5C400), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: _black)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text(title, style: const TextStyle(color: _muted, fontSize: 12)), const SizedBox(height: 2), Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15))]))]));
}

class _InfoBox extends StatelessWidget {
  final String text;
  const _InfoBox({required this.text});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE9E6DF))), child: Row(children: [const Icon(Icons.info_outline_rounded, color: _yellow), const SizedBox(width: 10), Expanded(child: Text(text, style: const TextStyle(color: _muted, height: 1.6)))]));
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _InfoTile({required this.title, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: ListTile(leading: Icon(icon), title: Text(title, style: const TextStyle(fontSize: 12, color: _muted)), subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w800))));
}

class _PageTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _PageTitle({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: _muted))]);
}
