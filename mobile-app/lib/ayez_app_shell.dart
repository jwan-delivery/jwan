import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'admin_center_page.dart';
import 'services/ayez_mobile_service.dart';
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
          return const _LoadingPage();
        }

        final user = auth.data;
        if (user == null) {
          return const legacy.LoginPage();
        }

        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
          builder: (context, profile) {
            if (profile.connectionState == ConnectionState.waiting) {
              return const _LoadingPage();
            }
            if (profile.hasError || !profile.hasData || !profile.data!.exists) {
              return const _ProfileErrorPage();
            }

            final data = profile.data!.data() ?? <String, dynamic>{};
            final status = '${data['status'] ?? 'active'}';
            if (status == 'suspended' || status == 'rejected') {
              return _BlockedPage(status: status);
            }

            return AyezAppShell(profile: data);
          },
        );
      },
    );
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ayezBlack,
      body: Center(
        child: CircularProgressIndicator(color: ayezYellow),
      ),
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
  final _mobile = AyezMobileService();
  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _mobile.registerDevice(uid).catchError((_) {});
      _tokenSubscription = _mobile.watchTokenRefresh(uid);
      _foregroundSubscription = _mobile.foregroundMessages.listen((message) {
        if (!mounted) return;
        final title = message.notification?.title ?? 'إشعار جديد';
        final body = message.notification?.body;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body == null || body.isEmpty ? title : '$title: $body')),
        );
      });
    }
  }

  @override
  void dispose() {
    _tokenSubscription?.cancel();
    _foregroundSubscription?.cancel();
    super.dispose();
  }

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

    if (_isAdminRole(role)) {
      final items = <_NavItem>[
        const _NavItem(Icons.dashboard_rounded, 'الإدارة'),
        const _NavItem(Icons.receipt_long_rounded, 'الطلبات'),
        const _NavItem(Icons.people_alt_outlined, 'المستخدمون'),
        const _NavItem(Icons.account_balance_wallet_rounded, 'الماليات'),
        const _NavItem(Icons.support_agent_rounded, 'الدعم'),
        const _NavItem(Icons.notifications_none_rounded, 'الإشعارات'),
      ];
      if (role == 'super_admin') {
        items.insert(5, const _NavItem(Icons.admin_panel_settings_rounded, 'المدراء'));
      }
      return items;
    }

    return const [
      _NavItem(Icons.home_rounded, 'الرئيسية'),
      _NavItem(Icons.receipt_long_rounded, 'طلباتي'),
      _NavItem(Icons.notifications_none_rounded, 'الإشعارات'),
      _NavItem(Icons.person_outline_rounded, 'حسابي'),
    ];
  }

  static bool _isAdminRole(String value) =>
      value == 'admin' || value == 'super_admin' || value == 'office_manager';

  Widget pageFor(int selected) {
    if (role == 'driver') {
      switch (selected) {
        case 1:
          return legacy.OrdersPage(profile: widget.profile);
        case 2:
          return const AyezWalletPage();
        case 3:
          return const AyezNotificationsPage();
        default:
          return AyezDriverHome(profile: widget.profile);
      }
    }

    if (_isAdminRole(role)) {
      if (selected == (role == 'super_admin' ? 6 : 5)) {
        return const AyezNotificationsPage();
      }
      return AyezAdminCenterPage(
        profile: widget.profile,
        initialSection: selected,
      );
    }

    switch (selected) {
      case 1:
        return legacy.OrdersPage(profile: widget.profile);
      case 2:
        return const AyezNotificationsPage();
      case 3:
        return AyezAccountPage(profile: widget.profile);
      default:
        return AyezCustomerHome(profile: widget.profile);
    }
  }

  void openCreateOrder() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ayezBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => legacy.CreateOrderSheet(profile: widget.profile),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nav = items;
    final safeIndex = index >= 0 && index < nav.length ? index : 0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ayezBg,
        appBar: AppBar(
          backgroundColor: ayezBlack,
          foregroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 12,
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ayezYellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/branding/jawan-logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'عايز',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFB8B8B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Builder(
              builder: (drawerContext) => IconButton(
                tooltip: 'القائمة',
                onPressed: () => Scaffold.of(drawerContext).openEndDrawer(),
                icon: const Icon(Icons.menu_rounded),
              ),
            ),
          ],
        ),
        endDrawer: AyezDrawer(
          profile: widget.profile,
          items: nav,
          onSelect: (value) {
            Navigator.pop(context);
            if (!mounted) return;
            setState(() => index = value);
          },
        ),
        body: SafeArea(child: pageFor(safeIndex)),
        bottomNavigationBar: NavigationBar(
          selectedIndex: safeIndex,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          indicatorColor: const Color(0x22F5C400),
          onDestinationSelected: (value) => setState(() => index = value),
          destinations: [
            for (final item in nav)
              NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.icon, color: ayezBlack),
                label: item.label,
              ),
          ],
        ),
        floatingActionButton: role == 'customer' && safeIndex == 0
            ? FloatingActionButton.extended(
                backgroundColor: ayezYellow,
                foregroundColor: ayezBlack,
                onPressed: openCreateOrder,
                icon: const Icon(Icons.add_rounded),
                label: const Text(
                  'طلب جديد',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              )
            : null,
      ),
    );
  }
}

class AyezDrawer extends StatelessWidget {
  final Map<String, dynamic> profile;
  final List<_NavItem> items;
  final ValueChanged<int> onSelect;

  const AyezDrawer({
    super.key,
    required this.profile,
    required this.items,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final elevated = profile['role'] == 'admin' ||
        profile['role'] == 'super_admin' ||
        profile['role'] == 'office_manager';

    return Drawer(
      backgroundColor: ayezBlack,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: ayezYellow,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      'assets/branding/jawan-logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'عايز',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: ayezBlack2,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0x18FFFFFF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${profile['name'] ?? ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profile['phone'] ?? ''}',
                      style: const TextStyle(
                        color: Color(0xFF9C9C9C),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profile['role'] ?? ''} • ${profile['status'] ?? ''}',
                      style: const TextStyle(
                        color: ayezYellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      ListTile(
                        leading: Icon(items[i].icon, color: ayezYellow),
                        title: Text(
                          items[i].label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onTap: () => onSelect(i),
                      ),
                    if (elevated)
                      ListTile(
                        leading: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: ayezYellow,
                        ),
                        title: const Text(
                          'طلبات الشحن',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const legacy.AdminTopupsPage(),
                            ),
                          );
                        },
                      ),
                    ListTile(
                      leading: const Icon(
                        Icons.support_agent_rounded,
                        color: ayezYellow,
                      ),
                      title: const Text(
                        'الدعم عبر واتساب',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'فتح المحادثة مباشرة',
                        style: TextStyle(
                          color: Color(0xFF858585),
                          fontSize: 11,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        legacy.openJawanWhatsApp(context);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0x22FFFFFF)),
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onTap: () => FirebaseAuth.instance.signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem(this.icon, this.label);
}

class AyezCustomerHome extends StatelessWidget {
  final Map<String, dynamic> profile;

  const AyezCustomerHome({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
      children: [
        const _HeroCard(
          eyebrow: 'منصة سودانية للتوصيل والنقل',
          title: 'توصيلك يبدأ من هنا',
          body: 'اطلب، تفاوض، تابع، وتواصل بسهولة من تطبيق واحد.',
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(
              child: _MiniCard(
                icon: Icons.speed_rounded,
                title: 'سريع',
                value: 'متابعة مباشرة',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _MiniCard(
                icon: Icons.local_shipping_outlined,
                title: 'مرن',
                value: 'ركاب وبضائع',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'أحدث طلباتك',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('customerId', isEqualTo: uid)
              .orderBy('createdAt', descending: true)
              .limit(3)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const _InfoCard(text: 'تعذر تحميل الطلبات الآن.');
            }
            final docs = snapshot.data?.docs ?? const [];
            if (docs.isEmpty) {
              return const _InfoCard(
                text: 'لا توجد طلبات حتى الآن. اضغط «طلب جديد» للبدء.',
              );
            }
            return Column(
              children: [
                for (final doc in docs)
                  legacy.OrderCard(
                    order: {'id': doc.id, ...doc.data()},
                    profile: profile,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class AyezDriverHome extends StatelessWidget {
  final Map<String, dynamic> profile;

  const AyezDriverHome({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final state = '${profile['state'] ?? ''}';
    final ordersStream = legacy.OrderService().availableOrders(state);

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
      children: [
        const _HeroCard(
          eyebrow: 'مساحة السائق',
          title: 'كن جاهزًا للطلب التالي',
          body: 'الطلبات المتاحة في ولايتك تظهر هنا بنفس نموذج النظام.',
        ),
        const SizedBox(height: 14),
        if ('${profile['status']}' != 'active')
          const _InfoCard(text: 'حساب السائق بانتظار اعتماد الإدارة.'),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: ordersStream,
          builder: (context, snapshot) => _MiniCard(
            icon: Icons.inbox_rounded,
            title: 'الطلبات المتاحة',
            value: '${snapshot.data?.docs.length ?? 0} طلب',
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'الطلبات المتاحة الآن',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: ordersStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const _InfoCard(text: 'تعذر تحميل الطلبات الآن.');
            }
            final docs = snapshot.data?.docs ?? const [];
            if (docs.isEmpty) {
              return const _InfoCard(text: 'لا توجد طلبات متاحة حاليًا.');
            }
            return Column(
              children: [
                for (final doc in docs)
                  legacy.OrderCard(
                    order: {'id': doc.id, ...doc.data()},
                    profile: profile,
                    showAccept: true,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class AyezAdminHome extends StatelessWidget {
  final Map<String, dynamic> profile;

  const AyezAdminHome({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
      children: [
        const _HeroCard(
          eyebrow: 'لوحة الإدارة',
          title: 'إدارة عايز',
          body: 'متابعة الطلبات والمستخدمين وعمليات المحفظة من واجهة واحدة.',
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .limit(200)
                    .snapshots(),
                builder: (context, snapshot) => _MiniCard(
                  icon: Icons.receipt_long_rounded,
                  title: 'الطلبات',
                  value: '${snapshot.data?.docs.length ?? 0}',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .limit(300)
                    .snapshots(),
                builder: (context, snapshot) => _MiniCard(
                  icon: Icons.people_alt_outlined,
                  title: 'المستخدمون',
                  value: '${snapshot.data?.docs.length ?? 0}',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _AdminAction(
          icon: Icons.people_alt_outlined,
          title: 'المستخدمون',
          text: 'إدارة المستخدمين وحالات الحسابات.',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const legacy.AdminUsersPage(),
            ),
          ),
        ),
        _AdminAction(
          icon: Icons.account_balance_wallet_outlined,
          title: 'طلبات الشحن',
          text: 'مراجعة طلبات شحن المحافظ.',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const legacy.AdminTopupsPage(),
            ),
          ),
        ),
        _AdminAction(
          icon: Icons.receipt_long_rounded,
          title: 'كل الطلبات',
          text: 'متابعة الطلبات والحالات.',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const legacy.AdminOrdersPage(),
            ),
          ),
        ),
      ],
    );
  }
}

class AyezSupportPage extends StatefulWidget {
  const AyezSupportPage({super.key, required this.role});
  final String role;
  @override State<AyezSupportPage> createState()=>_AyezSupportPageState();
}

class _AyezSupportPageState extends State<AyezSupportPage> {
  final message=TextEditingController();
  bool busy=false;
  final mobile=AyezMobileService();
  String get uid=>FirebaseAuth.instance.currentUser!.uid;

  Future<void> send() async {
    try{setState(()=>busy=true);await mobile.sendSupport(uid:uid,role:widget.role,message:message.text);message.clear();if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تم إرسال الرسالة')));}catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.toString())));}finally{if(mounted)setState(()=>busy=false);}
  }
  @override void dispose(){message.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('الدعم')),body:ListView(padding:const EdgeInsets.all(18),children:[
    TextField(controller:message,maxLines:6,maxLength:3000,decoration:const InputDecoration(labelText:'اكتب رسالتك')),
    const SizedBox(height:10),
    FilledButton(onPressed:busy?null:send,child:Text(busy?'جارٍ الإرسال...':'إرسال للدعم')),
    const SizedBox(height:18),
    const Text('رسائلي السابقة',style:TextStyle(fontSize:19,fontWeight:FontWeight.w900)),
    StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:mobile.support(uid),builder:(context,snapshot){if(snapshot.hasError)return const _InfoCard(text:'تعذر تحميل رسائل الدعم.');final docs=snapshot.data?.docs??const[];if(docs.isEmpty)return const _InfoCard(text:'لا توجد رسائل سابقة.');return Column(children:[for(final d in docs) Card(elevation:0,child:ListTile(title:Text('${d.data()['message']??''}'),subtitle:Text(d.data()['reply']==null?'الحالة: ${d.data()['status']??'open'}':'رد الإدارة: ${d.data()['reply']}'))) ]);}),
  ]));
}
class AyezAccountPage extends StatelessWidget {
  final Map<String, dynamic> profile;

  const AyezAccountPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const _PageHeading(
          title: 'حسابي',
          subtitle: 'معلومات الحساب الحالية',
        ),
        const SizedBox(height: 12),
        _InfoRow(
          title: 'الاسم',
          value: '${profile['name'] ?? ''}',
          icon: Icons.person_outline,
        ),
        _InfoRow(
          title: 'الهاتف',
          value: '${profile['phone'] ?? ''}',
          icon: Icons.phone_outlined,
        ),
        _InfoRow(
          title: 'الولاية',
          value: '${profile['state'] ?? ''}',
          icon: Icons.location_on_outlined,
        ),
        _InfoRow(
          title: 'السكن',
          value: '${profile['address'] ?? ''}',
          icon: Icons.home_outlined,
        ),
        _InfoRow(
          title: 'الحالة',
          value: '${profile['status'] ?? ''}',
          icon: Icons.verified_user_outlined,
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AyezSupportPage(role: '${profile['role'] ?? 'customer'}'))),
          icon: const Icon(Icons.support_agent_rounded),
          label: const Text('الدعم داخل التطبيق'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => legacy.openJawanWhatsApp(context),
          icon: const Icon(Icons.chat_outlined),
          label: const Text('فتح واتساب'),
        ),
      ],
    );
  }
}

class AyezWalletPage extends StatefulWidget {
  const AyezWalletPage({super.key});
  @override State<AyezWalletPage> createState() => _AyezWalletPageState();
}

class _AyezWalletPageState extends State<AyezWalletPage> {
  final mobile = AyezMobileService();
  final methods = const ['بنكك','فوري','أوكاش','ماي كاشي'];

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> requestMoney({required bool topup}) async {
    final amount = TextEditingController();
    final account = TextEditingController();
    String method = methods.first;
    try {
      final ok = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(topup ? 'طلب شحن' : 'طلب سحب'),
            content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ')),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(value: method, items: methods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(), onChanged: (v) => setDialogState(() => method = v ?? method), decoration: const InputDecoration(labelText: 'طريقة التحويل')),
              if (!topup) ...[
                const SizedBox(height: 10),
                TextField(controller: account, decoration: const InputDecoration(labelText: 'رقم الحساب/المحفظة المستلمة')),
              ],
            ])),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('إلغاء')),
              FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('إرسال')),
            ],
          ),
        ),
      );
      if (ok != true) return;
      final value = num.tryParse(amount.text.trim()) ?? 0;
      if (topup) {
        await mobile.createTopupRequest(driverId: uid, amount: value, paymentMethod: method);
      } else {
        await mobile.createWithdrawalRequest(driverId: uid, amount: value, paymentMethod: method, accountReference: account.text);
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال الطلب للمراجعة')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      amount.dispose();
      account.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
      children: [
        const _PageHeading(title: 'المحفظة', subtitle: 'الرصيد، الشحن، السحب، والعمولات'),
        const SizedBox(height: 12),
        StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
          stream: FirebaseFirestore.instance.collection('wallets').doc(uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const _InfoCard(text: 'تعذر تحميل المحفظة.');
            final data = snapshot.data?.data() ?? const <String,dynamic>{};
            final balance = (data['balance'] as num?)?.toDouble() ?? 0;
            final commission = (data['totalCommission'] as num?)?.toDouble() ?? 0;
            final penalties = (data['totalCancellationPenalties'] as num?)?.toDouble() ?? 0;
            return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: ayezBlack, borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text('الرصيد الحالي', style: TextStyle(color: Color(0xFFB8B8B8))),
              const SizedBox(height: 4), Text('${balance.toStringAsFixed(0)} ج.س', style: const TextStyle(color: ayezYellow,fontSize:34,fontWeight:FontWeight.w900)),
              const SizedBox(height:12),
              Text('العمولات: ${commission.toStringAsFixed(0)} ج.س',style:const TextStyle(color:Colors.white)),
              Text('غرامات الإلغاء: ${penalties.toStringAsFixed(0)} ج.س',style:const TextStyle(color:Colors.white)),
            ]));
          },
        ),
        const SizedBox(height:12),
        Row(children:[
          Expanded(child:FilledButton.icon(onPressed:()=>requestMoney(topup:true),icon:const Icon(Icons.add),label:const Text('شحن'))),
          const SizedBox(width:10),
          Expanded(child:OutlinedButton.icon(onPressed:()=>requestMoney(topup:false),icon:const Icon(Icons.south),label:const Text('سحب'))),
        ]),
        const SizedBox(height:14),
        const Text('حركات المحفظة',style:TextStyle(fontSize:19,fontWeight:FontWeight.w900)),
        const SizedBox(height:8),
        StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
          stream: FirebaseFirestore.instance.collection('walletTransactions').where('userId',isEqualTo:uid).orderBy('createdAt',descending:true).limit(50).snapshots(),
          builder:(context,snapshot){if(snapshot.hasError)return const _InfoCard(text:'تعذر تحميل الحركات المالية.');final docs=snapshot.data?.docs??const[];if(docs.isEmpty)return const _InfoCard(text:'لا توجد حركات مالية بعد.');return Column(children:[for(final d in docs)Card(elevation:0,child:ListTile(leading:const Icon(Icons.swap_vert),title:Text('${d.data()['type']??'-'}'),subtitle:Text(_formatDate(d.data()['createdAt'])),trailing:Text('${d.data()['amount']??0} ج.س',style:const TextStyle(fontWeight:FontWeight.w900))))]);}
        ),
        const SizedBox(height:14),
        const Text('طلبات الشحن الأخيرة',style:TextStyle(fontSize:19,fontWeight:FontWeight.w900)),
        StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:mobile.topups(uid),builder:(context,snapshot)=>_requestList(snapshot)),
        const SizedBox(height:10),
        const Text('طلبات السحب الأخيرة',style:TextStyle(fontSize:19,fontWeight:FontWeight.w900)),
        StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:mobile.withdrawals(uid),builder:(context,snapshot)=>_requestList(snapshot)),
      ],
    );
  }

  Widget _requestList(AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
    if(snapshot.hasError)return const _InfoCard(text:'تعذر تحميل الطلبات المالية.');
    final docs=snapshot.data?.docs??const[];
    if(docs.isEmpty)return const _InfoCard(text:'لا توجد طلبات سابقة.');
    return Column(children:[for(final d in docs)Card(elevation:0,child:ListTile(title:Text('${d.data()['amount']??0} ج.س'),subtitle:Text('${d.data()['paymentMethod']??'-'} • ${d.data()['status']??'-'}')))]);
  }
}
class AyezNotificationsPage extends StatelessWidget {
  const AyezNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const _PageHeading(
          title: 'الإشعارات',
          subtitle: 'آخر التنبيهات الخاصة بحسابك',
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('notifications')
              .where('userId', isEqualTo: uid)
              .orderBy('createdAt', descending: true)
              .limit(100)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const _InfoCard(text: 'تعذر تحميل الإشعارات.');
            }

            final docs = snapshot.data?.docs ?? const [];
            if (docs.isEmpty) {
              return const _InfoCard(text: 'لا توجد إشعارات جديدة.');
            }

            return Column(
              children: [
                for (final doc in docs)
                  Card(
                    elevation: 0,
                    child: ListTile(
                      leading: const Icon(Icons.notifications_none_rounded),
                      title: Text('${doc.data()['title'] ?? 'عايز'}'),
                      subtitle: Text('${doc.data()['body'] ?? ''}'),
                      onTap: () async {
                        try {
                          await doc.reference.update({'read': true});
                        } catch (_) {
                          // A failed read marker should not break notification viewing.
                        }
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String body;

  const _HeroCard({
    required this.eyebrow,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: ayezBlack,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            eyebrow,
            style: const TextStyle(
              color: ayezYellow,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: Color(0xFFB8B8B8),
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _MiniCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0x12F5C400),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: ayezBlack),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: ayezMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String text;

  const _InfoCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9E6DF)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: ayezYellow),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: ayezMuted, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _PageHeading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(color: ayezMuted),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: ayezMuted,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _AdminAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final VoidCallback onTap;

  const _AdminAction({
    required this.icon,
    required this.title,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(text),
        trailing: const Icon(Icons.chevron_left_rounded),
        onTap: onTap,
      ),
    );
  }
}

class _ProfileErrorPage extends StatelessWidget {
  const _ProfileErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ayezBlack,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.person_off_rounded,
                color: ayezYellow,
                size: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                'تعذر تحميل الحساب',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'سجّل الخروج ثم أعد تسجيل الدخول.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFB8B8B8)),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text('تسجيل الخروج'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlockedPage extends StatelessWidget {
  final String status;

  const _BlockedPage({required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ayezBlack,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.block_rounded, color: ayezYellow, size: 48),
              const SizedBox(height: 12),
              const Text(
                'الحساب غير متاح حاليًا',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                status == 'rejected'
                    ? 'تم رفض الحساب.'
                    : 'تم تعليق الحساب. تواصل مع الإدارة.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFB8B8B8)),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text('تسجيل الخروج'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDate(dynamic value) {
  if (value is Timestamp) {
    final d = value.toDate();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}/${two(d.month)}/${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
  }
  return value?.toString() ?? '';
}
