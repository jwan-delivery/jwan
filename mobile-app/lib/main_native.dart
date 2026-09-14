import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'firebase_options.dart';
import 'main.dart' as legacy;

const kBlack = Color(0xFF0B0B0B);
const kYellow = Color(0xFFFFC400);
const kBg = Color(0xFFF7F7F7);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JawanBootstrapApp());
}

class JawanBootstrapApp extends StatefulWidget {
  const JawanBootstrapApp({super.key});

  @override
  State<JawanBootstrapApp> createState() => _JawanBootstrapAppState();
}

class _JawanBootstrapAppState extends State<JawanBootstrapApp> {
  bool loading = true;
  Object? error;

  @override
  void initState() {
    super.initState();
    unawaited(_boot());
  }

  Future<void> _boot() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 15));
      if (!mounted) return;
      setState(() {
        loading = false;
        error = null;
      });
      unawaited(_activateOptionalServices());
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e;
      });
    }
  }

  Future<void> _activateOptionalServices() async {
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: const bool.fromEnvironment(
          'JAWAN_APPCHECK_DEBUG',
          defaultValue: false,
        )
            ? AndroidProvider.debug
            : AndroidProvider.playIntegrity,
      );
    } catch (_) {}

    try {
      FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'جوان للتوصيل',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBg,
        colorScheme: ColorScheme.fromSeed(seedColor: kYellow),
        appBarTheme: const AppBarTheme(
          backgroundColor: kBlack,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
      ),
      home: loading
          ? const StartupPage()
          : error != null
              ? StartupErrorPage(error: error!, retry: _retry)
              : const NativeAuthGate(),
    );
  }

  void _retry() {
    setState(() {
      loading = true;
      error = null;
    });
    unawaited(_boot());
  }
}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
}

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: kBlack,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _JawanLogoMark(),
              SizedBox(height: 18),
              Text(
                'جوان للتوصيل',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 18),
              SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ],
          ),
        ),
      );
}

class StartupErrorPage extends StatelessWidget {
  final Object error;
  final VoidCallback retry;

  const StartupErrorPage({super.key, required this.error, required this.retry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _JawanLogoMark(),
                    const SizedBox(height: 18),
                    const Text(
                      'تعذر تشغيل جوان',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'حدث خطأ أثناء تهيئة الاتصال بالخدمات. تحقق من الإنترنت ثم أعد المحاولة.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NativeAuthGate extends StatelessWidget {
  const NativeAuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, auth) {
        if (auth.connectionState == ConnectionState.waiting) {
          return const StartupPage();
        }
        final user = auth.data;
        if (user == null) return const NativeLoginPage();
        return FutureBuilder<Map<String, dynamic>?>(
          future: legacy.AuthService().profile(user.uid),
          builder: (context, profile) {
            if (profile.connectionState == ConnectionState.waiting) {
              return const StartupPage();
            }
            if (profile.hasError) {
              return ProfileLoadErrorPage(
                error: profile.error!,
                retry: () => (context as Element).markNeedsBuild(),
              );
            }
            final data = profile.data;
            if (data == null) {
              return const NativeLoginPage(
                message: 'ملف الحساب غير موجود. سجّل الدخول مرة أخرى.',
              );
            }
            final status = '${data['status'] ?? 'active'}';
            if (status == 'suspended' || status == 'rejected') {
              return NativeLoginPage(
                message: 'الحساب موقوف أو مرفوض.',
              );
            }
            return NativeHomeShell(profile: data);
          },
        );
      },
    );
  }
}

class ProfileLoadErrorPage extends StatelessWidget {
  final Object error;
  final VoidCallback retry;

  const ProfileLoadErrorPage({super.key, required this.error, required this.retry});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('جوان للتوصيل')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, size: 56),
                const SizedBox(height: 12),
                const Text('تعذر تحميل بيانات الحساب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(legacy.cleanError(error), textAlign: TextAlign.center),
                const SizedBox(height: 18),
                FilledButton.icon(onPressed: retry, icon: const Icon(Icons.refresh), label: const Text('إعادة المحاولة')),
              ],
            ),
          ),
        ),
      );
}

class NativeLoginPage extends StatefulWidget {
  final String? message;
  const NativeLoginPage({super.key, this.message});

  @override
  State<NativeLoginPage> createState() => _NativeLoginPageState();
}

class _NativeLoginPageState extends State<NativeLoginPage> {
  final auth = legacy.AuthService();
  final phone = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final address = TextEditingController();
  final age = TextEditingController();
  bool register = false;
  bool driver = false;
  bool busy = false;
  bool obscure = true;
  String state = 'البحر الأحمر';
  String vehicle = 'motorcycle';

  static const states = [
    'الخرطوم', 'الجزيرة', 'القضارف', 'كسلا', 'البحر الأحمر', 'نهر النيل',
    'الشمالية', 'النيل الأبيض', 'النيل الأزرق', 'سنار', 'شمال كردفان',
    'جنوب كردفان', 'غرب كردفان', 'شمال دارفور', 'جنوب دارفور',
    'غرب دارفور', 'وسط دارفور', 'شرق دارفور'
  ];

  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    name.dispose();
    address.dispose();
    age.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    setState(() => busy = true);
    try {
      if (register) {
        await auth.register(
          name: name.text,
          phone: phone.text,
          password: password.text,
          role: driver ? 'driver' : 'customer',
          state: state,
          address: address.text,
          age: int.tryParse(age.text),
          vehicleType: driver ? vehicle : null,
        );
      } else {
        await auth.login(phone.text, password.text);
      }
    } catch (e) {
      if (mounted) _message(legacy.cleanError(e));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _JawanLogoMark(),
                      const SizedBox(height: 14),
                      const Text('جوان للتوصيل', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      const Text('توصيل أسرع وأسهل في السودان', textAlign: TextAlign.center),
                      if (widget.message != null) ...[
                        const SizedBox(height: 12),
                        Text(widget.message!, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                      if (register) ...[
                        const SizedBox(height: 18),
                        TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم الكامل')),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          initialValue: state,
                          items: states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                          onChanged: (v) => setState(() => state = v ?? state),
                          decoration: const InputDecoration(labelText: 'الولاية'),
                        ),
                        const SizedBox(height: 10),
                        TextField(controller: address, decoration: const InputDecoration(labelText: 'مكان السكن')),
                        SwitchListTile(title: const Text('تسجيل كسائق'), value: driver, onChanged: (v) => setState(() => driver = v)),
                        if (driver) ...[
                          TextField(controller: age, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'العمر')),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            initialValue: vehicle,
                            items: [...legacy.OrderService.passenger, ...legacy.OrderService.cargo]
                                .map((v) => DropdownMenuItem(value: v, child: Text(legacy.vehicleLabel(v))))
                                .toList(),
                            onChanged: (v) => setState(() => vehicle = v ?? vehicle),
                            decoration: const InputDecoration(labelText: 'نوع المركبة'),
                          ),
                        ],
                      ],
                      const SizedBox(height: 10),
                      TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الهاتف')),
                      const SizedBox(height: 10),
                      TextField(
                        controller: password,
                        obscureText: obscure,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => obscure = !obscure),
                            icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: busy ? null : submit,
                        child: Text(busy ? 'جارٍ التنفيذ...' : (register ? 'إنشاء الحساب' : 'تسجيل الدخول')),
                      ),
                      TextButton(
                        onPressed: busy ? null : () => setState(() => register = !register),
                        child: Text(register ? 'لدي حساب بالفعل' : 'إنشاء حساب جديد'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NativeHomeShell extends StatefulWidget {
  final Map<String, dynamic> profile;
  const NativeHomeShell({super.key, required this.profile});

  @override
  State<NativeHomeShell> createState() => _NativeHomeShellState();
}

class _NativeHomeShellState extends State<NativeHomeShell> {
  int index = 0;

  String get role => '${widget.profile['role'] ?? 'customer'}';
  String get name => '${widget.profile['name'] ?? ''}';

  @override
  void initState() {
    super.initState();
    unawaited(_enableNotifications());
  }

  Future<void> _enableNotifications() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {
          'fcmToken': token,
          'notificationsEnabled': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (_) {}
  }

  List<_NavItem> get _items {
    if (role == 'driver') {
      return const [
        _NavItem(Icons.dashboard_outlined, 'الرئيسية'),
        _NavItem(Icons.receipt_long_outlined, 'طلباتي'),
        _NavItem(Icons.account_balance_wallet_outlined, 'المحفظة'),
        _NavItem(Icons.notifications_none, 'الإشعارات'),
        _NavItem(Icons.support_agent_outlined, 'الدعم'),
        _NavItem(Icons.person_outline, 'حسابي'),
      ];
    }
    if (role == 'admin' || role == 'super_admin' || role == 'office_manager') {
      return const [
        _NavItem(Icons.dashboard_outlined, 'الرئيسية'),
        _NavItem(Icons.list_alt_outlined, 'الطلبات'),
        _NavItem(Icons.people_outline, 'المستخدمون'),
        _NavItem(Icons.account_balance_wallet_outlined, 'طلبات الشحن'),
        _NavItem(Icons.notifications_none, 'الإشعارات'),
        _NavItem(Icons.support_agent_outlined, 'الدعم'),
        _NavItem(Icons.person_outline, 'حسابي'),
      ];
    }
    return const [
      _NavItem(Icons.dashboard_outlined, 'الرئيسية'),
      _NavItem(Icons.receipt_long_outlined, 'طلباتي'),
      _NavItem(Icons.notifications_none, 'الإشعارات'),
      _NavItem(Icons.support_agent_outlined, 'الدعم'),
      _NavItem(Icons.person_outline, 'حسابي'),
    ];
  }

  Widget _pageFor(int i) {
    if (role == 'driver') {
      switch (i) {
        case 0: return DriverHome(profile: widget.profile);
        case 1: return legacy.OrdersPage(profile: widget.profile);
        case 2: return const WalletPage();
        case 3: return const NativeNotificationsPage();
        case 4: return const SupportPage();
        default: return AccountPage(profile: widget.profile);
      }
    }
    if (role == 'admin' || role == 'super_admin' || role == 'office_manager') {
      switch (i) {
        case 0: return AdminHome(profile: widget.profile);
        case 1: return const NativeAdminOrdersPage();
        case 2: return const NativeAdminUsersPage();
        case 3: return const NativeAdminTopupsPage();
        case 4: return const NativeNotificationsPage();
        case 5: return const SupportPage();
        default: return AccountPage(profile: widget.profile);
      }
    }
    switch (i) {
      case 0: return CustomerHome(profile: widget.profile);
      case 1: return legacy.OrdersPage(profile: widget.profile);
      case 2: return const NativeNotificationsPage();
      case 3: return const SupportPage();
      default: return AccountPage(profile: widget.profile);
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    return Scaffold(
      appBar: AppBar(
        title: Text('جوان • $name', style: const TextStyle(fontWeight: FontWeight.w800)),
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: 'القائمة',
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'الإشعارات',
            onPressed: () {
              final target = items.indexWhere((e) => e.label == 'الإشعارات');
              if (target >= 0) setState(() => index = target);
            },
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: kBlack,
                child: Row(
                  children: [
                    const _JawanLogoMark(size: 52),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                          Text(_roleLabel(role), style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, i) => ListTile(
                    leading: Icon(items[i].icon),
                    title: Text(items[i].label),
                    selected: i == index,
                    selectedTileColor: kYellow.withAlpha(55),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => index = i);
                    },
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('تسجيل الخروج'),
                onTap: () async {
                  Navigator.pop(context);
                  await _logout();
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: index, children: List.generate(items.length, _pageFor)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index > 4 ? 0 : index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: items
            .take(items.length > 4 ? 5 : items.length)
            .map((e) => NavigationDestination(icon: Icon(e.icon), label: e.label))
            .toList(),
      ),
      floatingActionButton: role == 'customer' && index == 0
          ? FloatingActionButton.extended(
              backgroundColor: kYellow,
              foregroundColor: Colors.black,
              onPressed: () => _newOrder(context),
              icon: const Icon(Icons.add),
              label: const Text('طلب جديد'),
            )
          : null,
    );
  }

  Future<void> _newOrder(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => legacy.CreateOrderSheet(profile: widget.profile),
    );
  }
}

String _roleLabel(String role) {
  switch (role) {
    case 'driver': return 'سائق';
    case 'admin': return 'مدير';
    case 'super_admin': return 'مدير عام';
    case 'office_manager': return 'مدير مكتب';
    default: return 'عميل';
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

class CustomerHome extends StatelessWidget {
  final Map<String, dynamic> profile;
  const CustomerHome({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _hero('أهلاً ${profile['name'] ?? ''}', 'أنشئ طلبك وتفاوض مع السائق حتى تصل للسعر المناسب.'),
        const SizedBox(height: 14),
        ActionCard(
          icon: Icons.add_road,
          title: 'إنشاء طلب جديد',
          subtitle: 'حدد مكان الاستلام والوجهة ونوع الخدمة.',
          onTap: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) => legacy.CreateOrderSheet(profile: profile),
          ),
        ),
        const SizedBox(height: 10),
        ActionCard(
          icon: Icons.receipt_long,
          title: 'متابعة طلباتي',
          subtitle: 'شاهد حالة الطلب والتفاوض والتسليم.',
          onTap: () => _goToOrders(context),
        ),
        const SizedBox(height: 10),
        const ActionCard(
          icon: Icons.security,
          title: 'معلومات الأمان',
          subtitle: 'بياناتك ومعاملاتك محمية بقواعد Firebase والصلاحيات.',
        ),
      ],
    );
  }

  void _goToOrders(BuildContext context) {
    final shell = context.findAncestorStateOfType<_NativeHomeShellState>();
    shell?.setState(() => shell.index = 1);
  }
}

class DriverHome extends StatelessWidget {
  final Map<String, dynamic> profile;
  const DriverHome({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final state = '${profile['state'] ?? ''}';
    final active = profile['status'] == 'active';
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: active ? legacy.OrderService().availableOrders(state) : const Stream.empty(),
      builder: (context, snapshot) {
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _hero('لوحة السائق', '${profile['name'] ?? ''} • $state'),
            const SizedBox(height: 12),
            if (!active)
              const Card(
                child: ListTile(
                  leading: Icon(Icons.pending_actions),
                  title: Text('الحساب بانتظار اعتماد الإدارة'),
                  subtitle: Text('بعد الاعتماد ستظهر الطلبات المتاحة في ولايتك.'),
                ),
              ),
            if (snapshot.hasError)
              _ErrorCard(error: snapshot.error!),
            if (active && !snapshot.hasData)
              const Card(child: ListTile(title: Text('جارٍ تحميل الطلبات المتاحة...'))),
            if (active && snapshot.hasData && snapshot.data!.docs.isEmpty)
              const Card(child: ListTile(leading: Icon(Icons.inbox_outlined), title: Text('لا توجد طلبات جديدة الآن'))),
            ...snapshot.data?.docs.map(
                  (doc) => legacy.OrderCard(
                    order: {'id': doc.id, ...doc.data()},
                    profile: profile,
                    showAccept: true,
                  ),
                ) ??
                const [],
          ],
        );
      },
    );
  }
}

class AdminHome extends StatelessWidget {
  final Map<String, dynamic> profile;
  const AdminHome({super.key, required this.profile});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _hero('لوحة الإدارة', '${profile['name'] ?? ''} • ${_roleLabel('${profile['role'] ?? ''}')}'),
          const SizedBox(height: 12),
          ActionCard(icon: Icons.people_outline, title: 'المستخدمون', subtitle: 'إدارة وعرض حسابات المستخدمين حسب الصلاحيات.', onTap: () => _select(context, 'المستخدمون')),
          ActionCard(icon: Icons.list_alt_outlined, title: 'كل الطلبات', subtitle: 'متابعة الطلبات ومراحلها.', onTap: () => _select(context, 'الطلبات')),
          ActionCard(icon: Icons.account_balance_wallet_outlined, title: 'طلبات الشحن', subtitle: 'مراجعة طلبات شحن المحافظ.', onTap: () => _select(context, 'طلبات الشحن')),
        ],
      );

  void _select(BuildContext context, String label) {
    final shell = context.findAncestorStateOfType<_NativeHomeShellState>();
    if (shell == null) return;
    final target = shell._items.indexWhere((e) => e.label == label);
    if (target >= 0) shell.setState(() => shell.index = target);
  }
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Center(child: Text('الحساب غير متاح'));
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('wallets').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return _ErrorCard(error: snapshot.error!);
        final data = snapshot.data?.data() ?? const <String, dynamic>{};
        final balance = (data['balance'] as num?)?.toDouble() ?? 0;
        final totalCommission = (data['totalCommission'] as num?)?.toDouble() ?? 0;
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text('المحفظة', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Card(
              color: kBlack,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('الرصيد الحالي', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('${balance.toStringAsFixed(0)} ج.س', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text('إجمالي العمولات: ${totalCommission.toStringAsFixed(0)} ج.س', style: const TextStyle(color: Colors.white70)),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            ActionCard(icon: Icons.add_card, title: 'طلب شحن الرصيد', subtitle: 'أرسل طلب الشحن للمراجعة الإدارية.', onTap: () => _requestAmount(context, 'topupRequests')),
            const SizedBox(height: 10),
            ActionCard(icon: Icons.payments_outlined, title: 'طلب سحب الرصيد', subtitle: 'أرسل طلب السحب مع بيانات الحساب.', onTap: () => _requestWithdrawal(context)),
            const SizedBox(height: 10),
            ActionCard(icon: Icons.receipt_long, title: 'حركات المحفظة', subtitle: 'عرض آخر الحركات المسجلة.', onTap: () => _walletTransactions(context)),
          ],
        );
      },
    );
  }

  Future<void> _requestAmount(BuildContext context, String collection) async {
    final amount = TextEditingController();
    final result = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('طلب شحن'),
        content: TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(context, int.tryParse(amount.text)), child: const Text('إرسال')),
        ],
      ),
    );
    if (result == null || result <= 0) return;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      await FirebaseFirestore.instance.collection(collection).add({
        'driverId': uid,
        'userId': uid,
        'amount': result,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (context.mounted) _snack(context, 'تم إرسال الطلب للمراجعة');
    } catch (e) {
      if (context.mounted) _snack(context, legacy.cleanError(e));
    }
  }

  Future<void> _requestWithdrawal(BuildContext context) async {
    final amount = TextEditingController();
    final bank = TextEditingController();
    final account = TextEditingController();
    final form = GlobalKey<FormState>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('طلب سحب'),
        content: Form(
          key: form,
          child: SingleChildScrollView(
            child: Column(children: [
              TextFormField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ'), validator: (v) => (int.tryParse(v ?? '') ?? 0) > 0 ? null : 'أدخل مبلغًا صحيحًا'),
              const SizedBox(height: 10),
              TextFormField(controller: bank, decoration: const InputDecoration(labelText: 'نوع البنك')),
              const SizedBox(height: 10),
              TextFormField(controller: account, decoration: const InputDecoration(labelText: 'رقم الحساب')),
            ]),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(context, form.currentState?.validate() == true), child: const Text('إرسال')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('withdrawalRequests').add({
        'driverId': uid,
        'userId': uid,
        'amount': int.parse(amount.text),
        'bankType': bank.text.trim(),
        'bankAccount': account.text.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (context.mounted) _snack(context, 'تم إرسال طلب السحب');
    } catch (e) {
      if (context.mounted) _snack(context, legacy.cleanError(e));
    }
  }

  Future<void> _walletTransactions(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 520,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('walletTransactions').where('userId', isEqualTo: uid).orderBy('createdAt', descending: true).limit(100).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Center(child: Text(legacy.cleanError(snapshot.error!)));
            final docs = snapshot.data?.docs ?? const [];
            if (docs.isEmpty) return const Center(child: Text('لا توجد حركات مسجلة'));
            return ListView(
              padding: const EdgeInsets.all(12),
              children: docs
                  .map((d) => ListTile(title: Text('${d.data()['amount'] ?? 0} ج.س'), subtitle: Text('${d.data()['type'] ?? ''}'), trailing: Text('${d.data()['balanceAfter'] ?? ''}')))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}

class NativeNotificationsPage extends StatelessWidget {
  const NativeNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Center(child: Text('الحساب غير متاح'));
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('notifications').where('userId', isEqualTo: uid).orderBy('createdAt', descending: true).limit(100).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return _ErrorCard(error: snapshot.error!);
        final docs = snapshot.data?.docs ?? const [];
        if (docs.isEmpty) return const Center(child: Text('لا توجد إشعارات حتى الآن'));
        return ListView(
          padding: const EdgeInsets.all(18),
          children: docs.map((doc) {
            final data = doc.data();
            return Card(
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: kYellow, foregroundColor: Colors.black, child: Icon(Icons.notifications_none)),
                title: Text('${data['title'] ?? 'جوان'}'),
                subtitle: Text('${data['body'] ?? ''}'),
                trailing: (data['read'] == true) ? null : const Icon(Icons.circle, size: 10),
                onTap: () => doc.reference.set({'read': true}, SetOptions(merge: true)),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _hero('الدعم', 'تواصل مباشرة مع فريق جوان للتوصيل.'),
          const SizedBox(height: 12),
          ActionCard(icon: Icons.chat, title: 'واتساب جوان', subtitle: 'اضغط هنا لفتح واتساب مباشرة.', onTap: () => _openWhatsApp(context)),
          const SizedBox(height: 10),
          const Card(child: ListTile(leading: Icon(Icons.info_outline), title: Text('ملاحظة'), subtitle: Text('لا نطلب منك كلمة المرور أو رموز التحقق عبر الدعم.'))),
        ],
      );

  Future<void> _openWhatsApp(BuildContext context) async {
    final uri = Uri.parse('https://wa.me/249964499266?text=${Uri.encodeComponent('السلام عليكم، أحتاج مساعدة من جوان للتوصيل')}');
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) _snack(context, 'تعذر فتح واتساب');
    } catch (e) {
      if (context.mounted) _snack(context, 'تعذر فتح واتساب');
    }
  }
}

class AccountPage extends StatelessWidget {
  final Map<String, dynamic> profile;
  const AccountPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _hero('${profile['name'] ?? ''}', _roleLabel('${profile['role'] ?? ''}')),
          const SizedBox(height: 12),
          _detail('الهاتف', '${profile['phone'] ?? ''}'),
          _detail('الولاية', '${profile['state'] ?? ''}'),
          _detail('مكان السكن', '${profile['address'] ?? ''}'),
          _detail('الحالة', '${profile['status'] ?? ''}'),
          if (profile['vehicleType'] != null) _detail('المركبة', legacy.vehicleLabel('${profile['vehicleType']}')),
        ],
      );
}

class NativeAdminOrdersPage extends StatelessWidget {
  const NativeAdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).limit(200).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return _ErrorCard(error: snapshot.error!);
          final docs = snapshot.data?.docs ?? const [];
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Text('كل الطلبات', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              if (docs.isEmpty) const Card(child: ListTile(title: Text('لا توجد طلبات'))),
              ...docs.map((d) => legacy.OrderCard(order: {'id': d.id, ...d.data()}, profile: const {'role': 'admin'})),
            ],
          );
        },
      );
}

class NativeAdminUsersPage extends StatelessWidget {
  const NativeAdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').orderBy('createdAt', descending: true).limit(300).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return _ErrorCard(error: snapshot.error!);
          final docs = snapshot.data?.docs ?? const [];
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Text('المستخدمون', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              ...docs.map((doc) {
                final d = doc.data();
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${d['role'] ?? '?'}'.characters.first)),
                    title: Text('${d['name'] ?? doc.id}'),
                    subtitle: Text('${d['role'] ?? ''} • ${d['status'] ?? ''}\n${d['phone'] ?? ''}'),
                    isThreeLine: true,
                  ),
                );
              }),
            ],
          );
        },
      );
}

class NativeAdminTopupsPage extends StatelessWidget {
  const NativeAdminTopupsPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('طلبات الشحن والسحب', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          _RequestList(collection: 'topupRequests', title: 'طلبات الشحن'),
          const SizedBox(height: 16),
          _RequestList(collection: 'withdrawalRequests', title: 'طلبات السحب'),
        ],
      );
}

class _RequestList extends StatelessWidget {
  final String collection;
  final String title;
  const _RequestList({required this.collection, required this.title});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection(collection).orderBy('createdAt', descending: true).limit(100).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return _ErrorCard(error: snapshot.error!);
              final docs = snapshot.data?.docs ?? const [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  if (docs.isEmpty) const Text('لا توجد طلبات'),
                  ...docs.map((doc) {
                    final d = doc.data();
                    return ListTile(
                      title: Text('${d['amount'] ?? ''} ج.س'),
                      subtitle: Text('${d['driverId'] ?? d['userId'] ?? ''} • ${d['status'] ?? ''}'),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      );
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ActionCard({super.key, required this.icon, required this.title, required this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: const CircleAvatar(backgroundColor: kYellow, foregroundColor: Colors.black, child: Icon(Icons.arrow_back)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text(subtitle),
          trailing: Icon(icon),
          onTap: onTap,
        ),
      );
}

class _ErrorCard extends StatelessWidget {
  final Object error;
  const _ErrorCard({required this.error});

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: const Icon(Icons.cloud_off),
          title: const Text('تعذر تحميل البيانات'),
          subtitle: Text(legacy.cleanError(error)),
        ),
      );
}

Widget _hero(String title, String subtitle) => Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: kBlack, borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );

Widget _detail(String label, String value) => Card(
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: SelectableText(value),
      ),
    );

void _snack(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class _JawanLogoMark extends StatelessWidget {
  final double size;
  const _JawanLogoMark({this.size = 68});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: kYellow,
          borderRadius: BorderRadius.circular(size * 0.25),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.local_shipping, size: size * 0.55, color: Colors.black),
      );
}
