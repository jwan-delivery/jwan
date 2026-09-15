import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'services/app_data_service.dart';
import 'services/fcm_service.dart';
import 'services/jawan_auth_service.dart';
import 'services/negotiation_service.dart';
import 'services/notification_service.dart';
import 'services/order_service.dart';

const kYellow = Color(0xFFFFC400);
const kBlack = Color(0xFF111111);

const sudanStates = <String>[
  'الخرطوم',
  'الجزيرة',
  'البحر الأحمر',
  'كسلا',
  'القضارف',
  'سنار',
  'النيل الأزرق',
  'النيل الأبيض',
  'شمال كردفان',
  'جنوب كردفان',
  'غرب كردفان',
  'شمال دارفور',
  'جنوب دارفور',
  'شرق دارفور',
  'وسط دارفور',
  'غرب دارفور',
  'نهر النيل',
  'الشمالية',
];

const passengerVehicles = <String, String>{
  'car': 'سيارة',
  'rickshaw': 'ركشة',
  'bus': 'بص',
  'amjad': 'أمجاد',
  'taxi': 'تاكسي',
  'limousine': 'ليموزين',
};

const cargoVehicles = <String, String>{
  'motorcycle': 'دراجة نارية',
  'tuk_tuk': 'توك توك',
  'truck': 'شاحنة',
  'kreez': 'كريز',
  'tanker': 'ناقلة',
  'crane': 'رافعة',
  'tow_truck': 'سطحة',
  'lorry': 'لوري',
};

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const AyezApp());
}

class AyezApp extends StatelessWidget {
  const AyezApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'عايز',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        colorScheme: ColorScheme.fromSeed(seedColor: kYellow),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: kYellow, width: 2),
          ),
        ),
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        final user = snap.data;
        if (user == null) return const LoginPage();
        return ProfileGate(uid: user.uid);
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: kBlack,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('عايز', style: TextStyle(color: kYellow, fontSize: 46, fontWeight: FontWeight.w900)),
              SizedBox(height: 8),
              Text('نوصلك أسرع', style: TextStyle(color: Colors.white70, fontSize: 16)),
              SizedBox(height: 24),
              CircularProgressIndicator(color: kYellow),
            ],
          ),
        ),
      );
}

class ProfileGate extends StatefulWidget {
  const ProfileGate({super.key, required this.uid});
  final String uid;

  @override
  State<ProfileGate> createState() => _ProfileGateState();
}

class _ProfileGateState extends State<ProfileGate> {
  final _data = AppDataService();
  final _fcm = FcmService();
  StreamSubscription<RemoteMessage>? _foreground;

  @override
  void initState() {
    super.initState();
    _fcm.initializeForUser(widget.uid).catchError((_) {});
  }

  @override
  void dispose() {
    _foreground?.cancel();
    _fcm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _data.watchUser(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const SplashScreen();
        if (snapshot.hasError) {
          return ErrorScreen(message: 'تعذر تحميل ملف حسابك: ${snapshot.error}');
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return MissingProfileScreen(uid: widget.uid);
        }
        final data = snapshot.data!.data()!;
        final role = (data['role'] ?? 'customer').toString();
        final status = (data['status'] ?? 'pending').toString();
        if (status != 'active') return AccountStatusScreen(status: status);
        return HomeShell(uid: widget.uid, profile: data, role: role);
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phone = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  bool obscure = true;
  final auth = JawanAuthService();

  Future<void> submit() async {
    if (phone.text.trim().isEmpty || password.text.isEmpty) {
      showError(context, 'أدخل رقم الهاتف وكلمة المرور');
      return;
    }
    setState(() => loading = true);
    try {
      await auth.signIn(phone: phone.text, password: password.text);
    } on FirebaseAuthException catch (e) {
      showError(context, firebaseAuthMessage(e));
    } catch (e) {
      showError(context, e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              children: [
                const BrandHeader(),
                const SizedBox(height: 28),
                const Text('تسجيل الدخول', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('ادخل إلى حسابك في عايز', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 28),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'رقم الهاتف', prefixIcon: Icon(Icons.phone_outlined)),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: password,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => obscure = !obscure),
                      icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: loading ? null : submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: kBlack,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(54),
                  ),
                  child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text('دخول', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: loading ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                  child: const Text('إنشاء حساب جديد'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  String role = 'customer';
  String state = sudanStates.first;
  String vehicleType = passengerVehicles.keys.first;
  bool loading = false;

  Future<void> submit() async {
    if (name.text.trim().length < 2 || phone.text.trim().isEmpty || password.text.length < 6) {
      showError(context, 'تأكد من الاسم ورقم الهاتف وكلمة المرور (6 أحرف على الأقل)');
      return;
    }
    setState(() => loading = true);
    try {
      await JawanAuthService().register(
        phone: phone.text,
        password: password.text,
        name: name.text,
        state: state,
        role: role,
        vehicleType: role == 'driver' ? vehicleType : null,
      );
      if (mounted) {
        Navigator.pop(context);
        showInfo(context, 'تم إنشاء الحساب. سيظهر لك بعد اعتماد الإدارة.');
      }
    } on FirebaseAuthException catch (e) {
      showError(context, firebaseAuthMessage(e));
    } catch (e) {
      showError(context, e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')), 
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم الكامل')),
          const SizedBox(height: 12),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الهاتف')),
          const SizedBox(height: 12),
          TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور')),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: role,
            decoration: const InputDecoration(labelText: 'نوع الحساب'),
            items: const [
              DropdownMenuItem(value: 'customer', child: Text('عميل')),
              DropdownMenuItem(value: 'driver', child: Text('سائق')),
            ],
            onChanged: (v) => setState(() => role = v ?? 'customer'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: state,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'الولاية'),
            items: sudanStates.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => state = v ?? state),
          ),
          if (role == 'driver') ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: vehicleType,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'نوع المركبة'),
              items: [...passengerVehicles.entries, ...cargoVehicles.entries]
                  .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                  .toList(),
              onChanged: (v) => setState(() => vehicleType = v ?? vehicleType),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: loading ? null : submit,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54), backgroundColor: kBlack),
            child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text('إنشاء الحساب'),
          ),
        ],
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.uid, required this.profile, required this.role});
  final String uid;
  final Map<String, dynamic> profile;
  final String role;
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;
  late Map<String, dynamic> profile;

  @override
  void initState() {
    super.initState();
    profile = widget.profile;
  }

  String get name => (profile['name'] ?? 'صديقنا').toString();

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(uid: widget.uid, role: widget.role, profile: profile),
      MyOrdersPage(uid: widget.uid, role: widget.role),
      WalletPage(uid: widget.uid, role: widget.role),
      ProfilePage(uid: widget.uid, role: widget.role, profile: profile, onChanged: (p) => setState(() => profile = p)),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(index == 0 ? 'مرحباً $name' : ['الرئيسية', 'طلباتي', 'المحفظة', 'حسابي'][index], style: const TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: kBlack,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'الإشعارات',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsPage(uid: widget.uid))),
            icon: const Icon(Icons.notifications_none),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'support') Navigator.push(context, MaterialPageRoute(builder: (_) => SupportPage(uid: widget.uid, role: widget.role)));
              if (v == 'logout') JawanAuthService().signOut();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'support', child: Text('الدعم')),
              PopupMenuItem(value: 'logout', child: Text('تسجيل الخروج')),
            ],
          ),
        ],
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'الطلبات'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'المحفظة'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.uid, required this.role, required this.profile});
  final String uid;
  final String role;
  final Map<String, dynamic> profile;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(color: kBlack, borderRadius: BorderRadius.circular(24)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(role == 'driver' ? 'لوحة السائق' : 'كل شيء يبدأ من هنا', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(role == 'driver' ? 'طلبات ولايتك والتفاوض والتوصيل في مكان واحد.' : 'اطلب توصيلك وتابع الطلب لحظة بلحظة.', style: const TextStyle(color: Colors.white70, fontSize: 15)),
          ]),
        ),
        const SizedBox(height: 16),
        if (role == 'customer') ...[
          FeatureCard(
            icon: Icons.add_location_alt_outlined,
            title: 'إنشاء طلب جديد',
            subtitle: 'حدد الرحلة أو البضاعة وابدأ الطلب',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreateOrderPage(uid: uid, profile: profile))),
          ),
          FeatureCard(
            icon: Icons.receipt_long,
            title: 'تتبع طلباتي',
            subtitle: 'شاهد الحالات والاتفاقات والتسليم',
            onTap: () {},
          ),
        ] else ...[
          FeatureCard(
            icon: Icons.local_shipping_outlined,
            title: 'طلبات متاحة في ولايتك',
            subtitle: 'استعرض الطلبات واقبل ما يناسبك',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AvailableOrdersPage(uid: uid, profile: profile))),
          ),
          FeatureCard(
            icon: Icons.account_balance_wallet_outlined,
            title: 'محفظتي',
            subtitle: 'تابع الرصيد والعمولات والعمليات',
            onTap: () {},
          ),
        ],
        FeatureCard(
          icon: Icons.notifications_none,
          title: 'الإشعارات',
          subtitle: 'التحديثات المهمة من عايز',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsPage(uid: uid))),
        ),
        FeatureCard(
          icon: Icons.support_agent,
          title: 'الدعم',
          subtitle: 'أرسل استفسارك لفريق عايز',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SupportPage(uid: uid, role: role))),
        ),
      ],
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key, required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          leading: CircleAvatar(backgroundColor: kYellow, foregroundColor: kBlack, child: Icon(icon)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_left),
        ),
      );
}

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key, required this.uid, required this.profile});
  final String uid;
  final Map<String, dynamic> profile;
  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final origin = TextEditingController();
  final destination = TextEditingController();
  final description = TextEditingController();
  final luggageDescription = TextEditingController();
  final cargoType = TextEditingController();
  final cargoDescription = TextEditingController();
  String vehicleType = passengerVehicles.keys.first;
  int passengerCount = 1;
  bool hasLuggage = false;
  bool loading = false;

  bool get passenger => passengerVehicles.containsKey(vehicleType);

  Future<void> submit() async {
    if (origin.text.trim().isEmpty || destination.text.trim().isEmpty) {
      showError(context, 'أدخل مكان الاستلام والوجهة');
      return;
    }
    if (passenger && hasLuggage && luggageDescription.text.trim().isEmpty) {
      showError(context, 'اكتب وصف الأمتعة');
      return;
    }
    if (!passenger && (cargoType.text.trim().isEmpty || cargoDescription.text.trim().isEmpty)) {
      showError(context, 'أدخل نوع ووصف البضاعة');
      return;
    }
    setState(() => loading = true);
    try {
      final orderId = await OrderService().createOrder(
        customerId: widget.uid,
        state: (widget.profile['state'] ?? '').toString(),
        vehicleType: vehicleType,
        serviceCategory: passenger ? 'passenger' : 'cargo',
        origin: origin.text,
        destination: destination.text,
        description: description.text,
        passengerCount: passenger ? passengerCount : null,
        hasLuggage: passenger ? hasLuggage : null,
        luggageDescription: passenger && hasLuggage ? luggageDescription.text : null,
        cargoType: passenger ? null : cargoType.text,
        cargoDescription: passenger ? null : cargoDescription.text,
      );
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderDetailsPage(orderId: orderId, uid: widget.uid, role: 'customer')));
    } catch (e) {
      showError(context, cleanException(e));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    origin.dispose();
    destination.dispose();
    description.dispose();
    luggageDescription.dispose();
    cargoType.dispose();
    cargoDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء طلب')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          DropdownButtonFormField<String>(
            value: vehicleType,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'نوع المركبة'),
            items: [...passengerVehicles.entries, ...cargoVehicles.entries].map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
            onChanged: (v) => setState(() => vehicleType = v ?? vehicleType),
          ),
          const SizedBox(height: 12),
          TextField(controller: origin, decoration: const InputDecoration(labelText: 'مكان الاستلام', prefixIcon: Icon(Icons.radio_button_checked))),
          const SizedBox(height: 12),
          TextField(controller: destination, decoration: const InputDecoration(labelText: 'مكان التسليم', prefixIcon: Icon(Icons.location_on_outlined))),
          const SizedBox(height: 12),
          if (passenger) ...[
            Row(children: [
              const Expanded(child: Text('عدد الركاب', style: TextStyle(fontWeight: FontWeight.w800))),
              IconButton(onPressed: passengerCount <= 1 ? null : () => setState(() => passengerCount--), icon: const Icon(Icons.remove_circle_outline)),
              Text('$passengerCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              IconButton(onPressed: passengerCount >= 100 ? null : () => setState(() => passengerCount++), icon: const Icon(Icons.add_circle_outline)),
            ]),
            SwitchListTile(value: hasLuggage, onChanged: (v) => setState(() => hasLuggage = v), title: const Text('هل توجد أمتعة؟')),
            if (hasLuggage) TextField(controller: luggageDescription, decoration: const InputDecoration(labelText: 'وصف الأمتعة')),
          ] else ...[
            TextField(controller: cargoType, decoration: const InputDecoration(labelText: 'نوع البضاعة')),
            const SizedBox(height: 12),
            TextField(controller: cargoDescription, maxLines: 3, decoration: const InputDecoration(labelText: 'وصف البضاعة')),
          ],
          const SizedBox(height: 12),
          TextField(controller: description, maxLines: 4, decoration: const InputDecoration(labelText: 'ملاحظات إضافية')),
          const SizedBox(height: 22),
          FilledButton(onPressed: loading ? null : submit, style: FilledButton.styleFrom(backgroundColor: kBlack, minimumSize: const Size.fromHeight(54)), child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text('إرسال الطلب')),
        ],
      ),
    );
  }
}

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key, required this.uid, required this.role});
  final String uid;
  final String role;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: role == 'driver' ? OrderService().driverOrders(uid) : OrderService().customerOrders(uid),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snap.hasError) return Center(child: Text('تعذر تحميل الطلبات\n${snap.error}', textAlign: TextAlign.center));
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) return const EmptyState(icon: Icons.receipt_long_outlined, title: 'لا توجد طلبات', subtitle: 'ستظهر طلباتك هنا فور إنشائها أو قبولها.');
        return ListView.separated(
          padding: const EdgeInsets.all(14),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final data = docs[i].data();
            final id = docs[i].id;
            return OrderTile(orderId: id, data: data, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsPage(orderId: id, uid: uid, role: role))));
          },
        );
      },
    );
  }
}

class AvailableOrdersPage extends StatelessWidget {
  const AvailableOrdersPage({super.key, required this.uid, required this.profile});
  final String uid;
  final Map<String, dynamic> profile;
  @override
  Widget build(BuildContext context) {
    final state = (profile['state'] ?? '').toString();
    return Scaffold(
      appBar: AppBar(title: const Text('الطلبات المتاحة')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: OrderService().availableOrders(state),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('تعذر تحميل الطلبات\n${snap.error}', textAlign: TextAlign.center));
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) return const EmptyState(icon: Icons.local_shipping_outlined, title: 'لا توجد طلبات الآن', subtitle: 'عندما تصل طلبات جديدة في ولايتك ستظهر هنا.');
          return ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final d = docs[i];
              final data = d.data();
              return OrderTile(
                orderId: d.id,
                data: data,
                action: FilledButton.tonal(
                  onPressed: () async {
                    try {
                      await OrderService().acceptOrder(d.id, uid);
                      if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsPage(orderId: d.id, uid: uid, role: 'driver')));
                    } catch (e) {
                      if (context.mounted) showError(context, cleanException(e));
                    }
                  },
                  child: const Text('قبول الطلب'),
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsPage(orderId: d.id, uid: uid, role: 'driver'))),
              );
            },
          );
        },
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.orderId, required this.data, required this.onTap, this.action});
  final String orderId;
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  final Widget? action;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text('طلب #${shortId(orderId)}', style: const TextStyle(fontWeight: FontWeight.w900))), StatusChip(status: (data['status'] ?? 'unknown').toString())]),
            const SizedBox(height: 10),
            Text('${data['origin'] ?? '-'}  ←  ${data['destination'] ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text('${vehicleLabel(data['vehicleType'])} • ${(data['serviceCategory'] ?? '-').toString() == 'cargo' ? 'بضاعة' : 'ركاب'}'),
            if (data['agreedFee'] != null) Text('السعر المتفق عليه: ${data['agreedFee']} ج.س', style: const TextStyle(fontWeight: FontWeight.w800)),
            if (action != null) ...[const SizedBox(height: 10), Align(alignment: Alignment.centerLeft, child: action!)],
          ]),
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});
  final String status;
  @override
  Widget build(BuildContext context) => Chip(label: Text(statusLabel(status), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)), backgroundColor: statusColor(status));
}

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.orderId, required this.uid, required this.role});
  final String orderId;
  final String uid;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('طلب #${shortId(orderId)}')),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('orders').doc(orderId).snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('تعذر تحميل الطلب\n${snap.error}', textAlign: TextAlign.center));
          if (!snap.hasData || !snap.data!.exists) return const EmptyState(icon: Icons.error_outline, title: 'الطلب غير موجود', subtitle: 'ربما تم حذفه أو لم تعد لديك صلاحية الوصول إليه.');
          final order = snap.data!.data()!;
          return ListView(padding: const EdgeInsets.all(18), children: [
            OrderSummary(data: order),
            const SizedBox(height: 16),
            if (role == 'driver' && order['status'] == 'accepted') ...[
              FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NegotiationPage(orderId: orderId, uid: uid, role: role))), icon: const Icon(Icons.forum_outlined), label: const Text('فتح التفاوض')),
              const SizedBox(height: 10),
            ],
            if (order['negotiationStatus'] == 'open') ...[
              OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NegotiationPage(orderId: orderId, uid: uid, role: role))), icon: const Icon(Icons.handshake_outlined), label: const Text('التفاوض على السعر')),
              const SizedBox(height: 10),
            ],
            if (role == 'driver') DriverActions(orderId: orderId, uid: uid, order: order),
            if (role == 'customer') CustomerActions(orderId: orderId, uid: uid, order: order),
            if (order['status'] == 'completed' && role == 'customer') ...[
              const SizedBox(height: 12),
              FilledButton.icon(onPressed: () => showRatingDialog(context, orderId: orderId, customerId: uid), icon: const Icon(Icons.star_outline), label: const Text('قيّم الخدمة')),
            ],
          ]);
        },
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Text('الحالة', style: TextStyle(fontWeight: FontWeight.w900)), const Spacer(), StatusChip(status: (data['status'] ?? '').toString())]),
        const Divider(height: 26),
        detailLine('الاستلام', data['origin']),
        detailLine('التسليم', data['destination']),
        detailLine('المركبة', vehicleLabel(data['vehicleType'])),
        detailLine('نوع الخدمة', data['serviceCategory'] == 'cargo' ? 'بضاعة' : 'ركاب'),
        if (data['passengerCount'] != null) detailLine('عدد الركاب', data['passengerCount']),
        if (data['cargoType'] != null) detailLine('نوع البضاعة', data['cargoType']),
        if (data['description'] != null && data['description'].toString().isNotEmpty) detailLine('ملاحظات', data['description']),
        if (data['agreedFee'] != null) detailLine('السعر المتفق عليه', '${data['agreedFee']} ج.س'),
      ])));
}

Widget detailLine(String label, dynamic value) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 115, child: Text(label, style: const TextStyle(color: Colors.black54))), Expanded(child: Text('${value ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w700)))]));

class DriverActions extends StatelessWidget {
  const DriverActions({super.key, required this.orderId, required this.uid, required this.order});
  final String orderId;
  final String uid;
  final Map<String, dynamic> order;

  Future<void> act(BuildContext context, Future<void> Function() fn) async {
    try {
      await fn();
      if (context.mounted) showInfo(context, 'تم تحديث الطلب');
    } catch (e) {
      if (context.mounted) showError(context, cleanException(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = order['status'];
    if (status == 'accepted' && order['negotiationStatus'] == 'agreed') {
      return Column(children: [
        FilledButton.icon(onPressed: () => act(context, () => OrderService().pickupOrder(orderId)), icon: const Icon(Icons.inventory_2_outlined), label: const Text('تم الاستلام')),
        const SizedBox(height: 10),
        OutlinedButton.icon(onPressed: () => act(context, () => OrderService().driverCancel(orderId, uid, 'إلغاء بواسطة السائق')), icon: const Icon(Icons.cancel_outlined), label: const Text('إلغاء الطلب')),
      ]);
    }
    if (status == 'picked_up') return FilledButton.icon(onPressed: () => act(context, () => OrderService().startDelivering(orderId)), icon: const Icon(Icons.directions_car_outlined), label: const Text('بدء التوصيل'));
    if (status == 'delivering') return FilledButton.icon(onPressed: () => act(context, () => OrderService().markDelivered(orderId)), icon: const Icon(Icons.check_circle_outline), label: const Text('تم التسليم'));
    if (status == 'awaiting_confirmation') return FilledButton.icon(onPressed: () => act(context, () => OrderService().driverFinalize(orderId, uid)), icon: const Icon(Icons.done_all), label: const Text('إغلاق الطلب واحتساب العمولة'));
    if (status == 'accepted' && order['negotiationStatus'] != 'agreed') return const InfoBanner(text: 'يجب إكمال التفاوض والاتفاق على السعر قبل استلام الطلب.');
    return const SizedBox.shrink();
  }
}

class CustomerActions extends StatelessWidget {
  const CustomerActions({super.key, required this.orderId, required this.uid, required this.order});
  final String orderId;
  final String uid;
  final Map<String, dynamic> order;

  Future<void> act(BuildContext context, Future<void> Function() fn) async {
    try {
      await fn();
      if (context.mounted) showInfo(context, 'تم تحديث الطلب');
    } catch (e) {
      if (context.mounted) showError(context, cleanException(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (order['status'] == 'pending' && order['driverId'] == null) {
      return OutlinedButton.icon(onPressed: () => act(context, () => OrderService().customerCancel(orderId, uid, 'إلغاء بواسطة العميل')), icon: const Icon(Icons.cancel_outlined), label: const Text('إلغاء الطلب'));
    }
    if (order['status'] == 'awaiting_confirmation' && order['customerConfirmedAt'] == null) {
      return Column(children: [
        FilledButton.icon(onPressed: () => act(context, () => OrderService().confirmDelivery(orderId)), icon: const Icon(Icons.verified_outlined), label: const Text('تأكيد استلام الطلب')),
        const SizedBox(height: 10),
        OutlinedButton.icon(onPressed: () => act(context, () => OrderService().customerReportNotDelivered(orderId, uid)), icon: const Icon(Icons.report_problem_outlined), label: const Text('الإبلاغ عن عدم الوصول')),
      ]);
    }
    return const SizedBox.shrink();
  }
}

class NegotiationPage extends StatefulWidget {
  const NegotiationPage({super.key, required this.orderId, required this.uid, required this.role});
  final String orderId;
  final String uid;
  final String role;
  @override
  State<NegotiationPage> createState() => _NegotiationPageState();
}

class _NegotiationPageState extends State<NegotiationPage> {
  final offer = TextEditingController();
  final negotiation = NegotiationService();
  final data = AppDataService();
  bool loading = false;
  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    data.getUser(widget.uid).then((s) { if (mounted) setState(() => profile = s.data()); });
  }

  String get userName => (profile?['name'] ?? (widget.role == 'driver' ? 'السائق' : 'العميل')).toString();

  Future<void> sendOffer() async {
    try {
      setState(() => loading = true);
      await negotiation.offer(orderId: widget.orderId, uid: widget.uid, role: widget.role, name: userName, amount: negotiation.cleanAmount(offer.text));
      offer.clear();
    } catch (e) {
      if (mounted) showError(context, cleanException(e));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> respond(bool accept) async {
    try {
      setState(() => loading = true);
      await negotiation.respond(orderId: widget.orderId, uid: widget.uid, role: widget.role, name: userName, accept: accept);
    } catch (e) {
      if (mounted) showError(context, cleanException(e));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() { offer.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التفاوض على السعر')),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: negotiation.watchNegotiation(widget.orderId),
        builder: (context, negSnap) {
          final n = negSnap.data;
          return Column(children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: negotiation.watchMessages(widget.orderId),
                builder: (context, msgSnap) {
                  final messages = msgSnap.data ?? [];
                  if (messages.isEmpty) return const EmptyState(icon: Icons.forum_outlined, title: 'ابدأ التفاوض', subtitle: 'السائق يبدأ بالعرض الأول ثم يمكن للطرف الآخر الرد.');
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final m = messages[i];
                      final mine = m['senderId'] == widget.uid;
                      return Align(
                        alignment: mine ? Alignment.centerLeft : Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 330),
                          decoration: BoxDecoration(color: mine ? kBlack : Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('${m['action'] == 'accept' ? 'وافق' : m['action'] == 'reject' ? 'رفض' : 'عرض'} • ${m['amount'] ?? '-'} ج.س', style: TextStyle(color: mine ? Colors.white : Colors.black, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 4),
                            Text((m['senderName'] ?? '').toString(), style: TextStyle(color: mine ? Colors.white70 : Colors.black54, fontSize: 12)),
                          ]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (n != null && n['status'] == 'open' && n['currentOffer'] != null && n['offeredBy'] != widget.uid) ...[
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [
                Expanded(child: FilledButton(onPressed: loading ? null : () => respond(true), child: const Text('موافقة على العرض'))),
                const SizedBox(width: 10),
                Expanded(child: OutlinedButton(onPressed: loading ? null : () => respond(false), child: const Text('رفض'))),
              ])),
              const SizedBox(height: 10),
            ],
            if (n == null || n['status'] == 'open') Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(children: [
                Expanded(child: TextField(controller: offer, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'أدخل عرضك بالجنيه'))),
                const SizedBox(width: 10),
                IconButton.filled(onPressed: loading ? null : sendOffer, icon: const Icon(Icons.send)),
              ]),
            ),
          ]);
        },
      ),
    );
  }
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key, required this.uid, required this.role});
  final String uid;
  final String role;
  @override
  Widget build(BuildContext context) {
    if (role != 'driver') return const EmptyState(icon: Icons.account_balance_wallet_outlined, title: 'المحفظة متاحة للسائق', subtitle: 'سيظهر الرصيد والعمولات وطلبات الشحن والسحب عند حساب السائق.');
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: AppDataService().watchWallet(uid),
      builder: (context, snap) {
        final wallet = snap.data?.data() ?? const <String, dynamic>{};
        final balance = (wallet['balance'] as num?)?.toDouble() ?? 0;
        final commission = (wallet['totalCommission'] as num?)?.toDouble() ?? 0;
        final penalties = (wallet['totalCancellationPenalties'] as num?)?.toDouble() ?? 0;
        return ListView(padding: const EdgeInsets.all(18), children: [
          Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: kBlack, borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('الرصيد المتاح', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('${money(balance)} ج.س', style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
            const SizedBox(height: 18),
            Row(children: [Expanded(child: stat('العمولات', commission)), Expanded(child: stat('غرامات الإلغاء', penalties))]),
          ])),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: FilledButton.icon(onPressed: () => showMoneyRequest(context, uid, true), icon: const Icon(Icons.add), label: const Text('شحن'))),
            const SizedBox(width: 10),
            Expanded(child: OutlinedButton.icon(onPressed: () => showMoneyRequest(context, uid, false), icon: const Icon(Icons.arrow_upward), label: const Text('سحب'))),
          ]),
          const SizedBox(height: 18),
          const Text('آخر العمليات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: AppDataService().walletTransactions(uid),
            builder: (_, txSnap) {
              if (txSnap.hasError) return Text('${txSnap.error}');
              final docs = txSnap.data?.docs ?? [];
              if (docs.isEmpty) return const Padding(padding: EdgeInsets.all(18), child: Text('لا توجد عمليات بعد.'));
              return Card(elevation: 0, child: Column(children: docs.take(20).map((d) {
                final x = d.data();
                return ListTile(leading: CircleAvatar(backgroundColor: kYellow, child: Icon(transactionIcon(x['type']), color: kBlack)), title: Text(transactionType(x['type'])), trailing: Text('${x['amount'] ?? 0} ج.س', style: const TextStyle(fontWeight: FontWeight.w900)));
              }).toList()));
            },
          ),
        ]);
      },
    );
  }
}

Widget stat(String label, double value) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Colors.white70)), const SizedBox(height: 3), Text('${money(value)} ج.س', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))]);

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key, required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('الإشعارات')),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: NotificationService().watchForUser(uid),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snap.hasError) return Center(child: Text('تعذر تحميل الإشعارات\n${snap.error}', textAlign: TextAlign.center));
            final docs = snap.data?.docs ?? [];
            if (docs.isEmpty) return const EmptyState(icon: Icons.notifications_none, title: 'لا توجد إشعارات', subtitle: 'ستظهر هنا تحديثات الطلبات والحساب.');
            return ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final d = docs[i];
                final n = d.data();
                return Card(elevation: 0, child: ListTile(onTap: () => NotificationService().markRead(d.id), leading: Icon(n['read'] == true ? Icons.notifications_none : Icons.notifications_active, color: n['read'] == true ? Colors.black45 : kYellow), title: Text('${n['title'] ?? 'إشعار'}', style: const TextStyle(fontWeight: FontWeight.w900)), subtitle: Text('${n['body'] ?? ''}')));
              },
            );
          },
        ),
      );
}

class SupportPage extends StatefulWidget {
  const SupportPage({super.key, required this.uid, required this.role});
  final String uid;
  final String role;
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final subject = TextEditingController();
  final body = TextEditingController();
  bool loading = false;
  Future<void> send() async {
    try {
      setState(() => loading = true);
      await AppDataService().submitSupport(uid: widget.uid, role: widget.role, subject: subject.text, body: body.text);
      subject.clear(); body.clear();
      if (mounted) showInfo(context, 'تم إرسال رسالتك للدعم');
    } catch (e) {
      if (mounted) showError(context, cleanException(e));
    } finally { if (mounted) setState(() => loading = false); }
  }
  @override
  void dispose() { subject.dispose(); body.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('الدعم')),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          TextField(controller: subject, decoration: const InputDecoration(labelText: 'عنوان المشكلة')),
          const SizedBox(height: 12),
          TextField(controller: body, maxLines: 7, decoration: const InputDecoration(labelText: 'اكتب رسالتك')),
          const SizedBox(height: 16),
          FilledButton(onPressed: loading ? null : send, style: FilledButton.styleFrom(backgroundColor: kBlack), child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text('إرسال')),
          const SizedBox(height: 24),
          const Text('رسائلي السابقة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: AppDataService().supportMessages(widget.uid), builder: (_, snap) {
            if (snap.hasError) return Text('${snap.error}');
            final docs = snap.data?.docs ?? [];
            if (docs.isEmpty) return const Padding(padding: EdgeInsets.all(18), child: Text('لا توجد رسائل سابقة.'));
            return Column(children: docs.map((d) { final x = d.data(); final replies = (x['replies'] as List?) ?? const []; return Card(elevation: 0, child: ExpansionTile(title: Text('${x['subject'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text('${x['body'] ?? ''}'), children: [for (final r in replies) ListTile(title: const Text('رد الإدارة'), subtitle: Text('${r['response'] ?? ''}'))])); }).toList());
          }),
        ]);
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.uid, required this.role, required this.profile, required this.onChanged});
  final String uid;
  final String role;
  final Map<String, dynamic> profile;
  final ValueChanged<Map<String, dynamic>> onChanged;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController name;
  late final TextEditingController address;
  late String state;
  bool loading = false;

  @override
  void initState() { super.initState(); name = TextEditingController(text: '${widget.profile['name'] ?? ''}'); address = TextEditingController(text: '${widget.profile['address'] ?? ''}'); state = '${widget.profile['state'] ?? sudanStates.first}'; }
  @override
  void dispose() { name.dispose(); address.dispose(); super.dispose(); }
  Future<void> save() async {
    try { setState(() => loading = true); await AppDataService().updateProfile(uid: widget.uid, name: name.text, state: state, address: address.text); widget.onChanged({...widget.profile, 'name': name.text.trim(), 'state': state, 'address': address.text.trim()}); if (mounted) showInfo(context, 'تم حفظ الملف'); } catch (e) { if (mounted) showError(context, cleanException(e)); } finally { if (mounted) setState(() => loading = false); }
  }
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [
        Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
          const CircleAvatar(radius: 34, backgroundColor: kYellow, child: Icon(Icons.person, size: 34, color: kBlack)),
          const SizedBox(height: 10),
          Text('${widget.profile['phone'] ?? '-'}', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم')),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(value: state, isExpanded: true, decoration: const InputDecoration(labelText: 'الولاية'), items: sudanStates.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) => setState(() => state = v ?? state)),
          const SizedBox(height: 12),
          TextField(controller: address, maxLines: 2, decoration: const InputDecoration(labelText: 'العنوان')),
          const SizedBox(height: 18),
          FilledButton(onPressed: loading ? null : save, style: FilledButton.styleFrom(backgroundColor: kBlack, minimumSize: const Size.fromHeight(50)), child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text('حفظ التغييرات')),
          const SizedBox(height: 12),
          OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SupportPage(uid: widget.uid, role: widget.role))), icon: const Icon(Icons.support_agent), label: const Text('الدعم')),
          const SizedBox(height: 6),
          TextButton.icon(onPressed: () => JawanAuthService().signOut(), icon: const Icon(Icons.logout), label: const Text('تسجيل الخروج')),
        ]))),
      ]);

class AccountStatusScreen extends StatelessWidget {
  const AccountStatusScreen({super.key, required this.status});
  final String status;
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min, children: [const BrandHeader(), const SizedBox(height: 24), Icon(status == 'suspended' ? Icons.block : Icons.hourglass_top, size: 56, color: kYellow), const SizedBox(height: 14), Text(status == 'pending' ? 'حسابك قيد المراجعة' : status == 'rejected' ? 'تم رفض الحساب' : 'الحساب موقوف', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)), const SizedBox(height: 10), const Text('سيتم تحديث صلاحية الحساب من خلال الإدارة. يمكنك تسجيل الخروج والعودة لاحقًا.', textAlign: TextAlign.center), const SizedBox(height: 18), OutlinedButton(onPressed: () => JawanAuthService().signOut(), child: const Text('تسجيل الخروج'))])));
}

class MissingProfileScreen extends StatelessWidget {
  const MissingProfileScreen({super.key, required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.person_off_outlined, size: 60), const SizedBox(height: 12), const Text('ملف الحساب غير موجود', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text('معرّف الحساب: $uid', style: const TextStyle(color: Colors.black45)), const SizedBox(height: 18), OutlinedButton(onPressed: () => JawanAuthService().signOut(), child: const Text('تسجيل الخروج'))])));
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(message, textAlign: TextAlign.center))));
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 58, color: Colors.black38), const SizedBox(height: 14), Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54))])));
}

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Row(children: [const Icon(Icons.info_outline, color: kYellow), const SizedBox(width: 10), Expanded(child: Text(text))]));
}

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});
  @override
  Widget build(BuildContext context) => const Column(children: [Text('عايز', style: TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: kBlack)), Text('للتوصيل', style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w700))]);
}

Future<void> showMoneyRequest(BuildContext context, String uid, bool topup) async {
  final amount = TextEditingController();
  final bank = TextEditingController();
  try {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: Text(topup ? 'طلب شحن' : 'طلب سحب'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ')), if (!topup) ...[const SizedBox(height: 10), TextField(controller: bank, decoration: const InputDecoration(labelText: 'تفاصيل وسيلة الاستلام'))]], actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('إرسال'))]));
    if (ok != true) return;
    final value = int.tryParse(amount.text.trim()) ?? 0;
    if (value <= 0) throw StateError('أدخل مبلغًا صحيحًا');
    final service = AppDataService();
    if (topup) {
      await service.createTopupRequest(uid: uid, amount: value);
    } else {
      if (bank.text.trim().isEmpty) throw StateError('أدخل تفاصيل وسيلة الاستلام');
      await service.createWithdrawalRequest(uid: uid, amount: value, bankDetails: {'method': bank.text.trim()});
    }
    if (context.mounted) showInfo(context, 'تم إرسال الطلب للإدارة للمراجعة');
  } catch (e) { if (context.mounted) showError(context, cleanException(e)); } finally { amount.dispose(); bank.dispose(); }
}

Future<void> showRatingDialog(BuildContext context, {required String orderId, required String customerId}) async {
  int rating = 5;
  final comment = TextEditingController();
  final ok = await showDialog<bool>(context: context, builder: (dialogContext) => StatefulBuilder(builder: (context, setState) => AlertDialog(title: const Text('تقييم الخدمة'), content: Column(mainAxisSize: MainAxisSize.min, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => IconButton(onPressed: () => setState(() => rating = i + 1), icon: Icon(i < rating ? Icons.star : Icons.star_border, color: kYellow, size: 34)))), TextField(controller: comment, maxLines: 3, decoration: const InputDecoration(labelText: 'تعليق اختياري'))]), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('لاحقًا')), FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('إرسال'))])));
  if (ok == true) {
    try { await AppDataService().createRating(orderId: orderId, customerId: customerId, rating: rating, comment: comment.text); if (context.mounted) showInfo(context, 'شكراً لتقييمك'); } catch (e) { if (context.mounted) showError(context, cleanException(e)); }
  }
  comment.dispose();
}

void showError(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red.shade700));
void showInfo(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
String cleanException(Object e) => e is FirebaseException ? (e.message ?? e.code) : e.toString().replaceFirst('Exception: ', '').replaceFirst('StateError: ', '').replaceFirst('Invalid argument(s): ', '');
String firebaseAuthMessage(FirebaseAuthException e) => switch (e.code) { 'invalid-credential' || 'wrong-password' || 'user-not-found' => 'رقم الهاتف أو كلمة المرور غير صحيحة', 'email-already-in-use' => 'هذا الرقم مستخدم من قبل', 'weak-password' => 'كلمة المرور ضعيفة', _ => e.message ?? 'تعذر تنفيذ العملية' };
String shortId(String id) => id.length <= 8 ? id : id.substring(0, 8);
String money(double n) => n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
String vehicleLabel(dynamic value) => passengerVehicles[value] ?? cargoVehicles[value] ?? value?.toString() ?? '-';
String statusLabel(String status) => {'pending': 'بانتظار سائق', 'accepted': 'تم القبول', 'picked_up': 'تم الاستلام', 'delivering': 'جاري التوصيل', 'awaiting_confirmation': 'بانتظار التأكيد', 'not_delivered': 'لم يتم التسليم', 'completed': 'مكتمل', 'cancelled': 'ملغي', 'rejected': 'مرفوض'}[status] ?? status;
Color statusColor(String status) => {'pending': const Color(0xFFFFF3CD), 'accepted': const Color(0xFFE9D8FD), 'picked_up': const Color(0xFFD1ECF1), 'delivering': const Color(0xFFCFE2FF), 'awaiting_confirmation': const Color(0xFFFFE5B4), 'completed': const Color(0xFFD1E7DD), 'cancelled': const Color(0xFFF8D7DA), 'not_delivered': const Color(0xFFF8D7DA)}[status] ?? Colors.white;
IconData transactionIcon(dynamic type) => {'commission': Icons.percent, 'cancellation_penalty': Icons.warning_amber_outlined, 'topup': Icons.add, 'withdrawal': Icons.arrow_upward}.containsKey(type) ? {'commission': Icons.percent, 'cancellation_penalty': Icons.warning_amber_outlined, 'topup': Icons.add, 'withdrawal': Icons.arrow_upward}[type]! : Icons.swap_horiz;
String transactionType(dynamic type) => {'commission': 'عمولة', 'cancellation_penalty': 'غرامة إلغاء', 'topup': 'شحن', 'withdrawal': 'سحب'}[type] ?? 'عملية';
