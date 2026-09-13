import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

const kBlack = Color(0xFF0B0B0B);
const kYellow = Color(0xFFFFC400);
const kBg = Color(0xFFF7F7F7);

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider: const bool.fromEnvironment('JAWAN_APPCHECK_DEBUG', defaultValue: false)
          ? AndroidProvider.debug
          : AndroidProvider.playIntegrity,
    );
  } catch (_) {}
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const JawanApp());
}

String cleanError(Object error) {
  if (error is FirebaseException) return error.message ?? error.code;
  return error.toString().replaceFirst('Exception: ', '');
}

String vehicleLabel(String value) {
  const values = {
    'car': 'سيارة', 'rickshaw': 'ركشة', 'motorcycle': 'موتر', 'tuk_tuk': 'تكتك',
    'truck': 'دفار', 'bus': 'حافلة', 'amjad': 'أمجاد', 'kreez': 'كريز',
    'taxi': 'تاكسي', 'tanker': 'تنكر', 'crane': 'كرين', 'tow_truck': 'رافعة',
    'lorry': 'لوري', 'limousine': 'ليموزين',
  };
  return values[value] ?? value;
}

String statusLabel(dynamic value) {
  const values = {
    'pending': 'بانتظار سائق', 'accepted': 'تفاوض على السعر', 'picked_up': 'تم الاستلام',
    'delivering': 'قيد التوصيل', 'awaiting_confirmation': 'بانتظار تأكيد العميل',
    'not_delivered': 'لم يتم التسليم', 'completed': 'مكتمل', 'cancelled': 'ملغي', 'rejected': 'مرفوض',
  };
  return values[value] ?? 'غير معروف';
}

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String phoneAlias(String phone) => '${phone.trim()}@jawan.app';

  Future<Map<String, dynamic>?> profile(String uid) async {
    final snapshot = await db.collection('users').doc(uid).get();
    return snapshot.data();
  }

  Future<void> login(String phone, String password) async {
    if (!RegExp(r'^\d{10}$').hasMatch(phone.trim())) {
      throw Exception('رقم الهاتف يجب أن يكون 10 أرقام فقط');
    }
    if (password.length < 6) throw Exception('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
    final credential = await auth.signInWithEmailAndPassword(
      email: phoneAlias(phone),
      password: password,
    );
    await db.collection('users').doc(credential.user!.uid).set(
      {'lastActiveAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  Future<void> register({
    required String name,
    required String phone,
    required String password,
    required String role,
    required String state,
    required String address,
    int? age,
    String? vehicleType,
  }) async {
    if (name.trim().isEmpty) throw Exception('الاسم الكامل مطلوب');
    if (!RegExp(r'^\d{10}$').hasMatch(phone.trim())) throw Exception('رقم الهاتف يجب أن يكون 10 أرقام فقط');
    if (password.length < 6) throw Exception('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
    if (!['customer', 'driver'].contains(role)) throw Exception('نوع الحساب غير صحيح');
    if (state.trim().isEmpty) throw Exception('اختر الولاية');
    if (address.trim().isEmpty) throw Exception('مكان السكن مطلوب');
    if (role == 'driver') {
      if ((age ?? 0) < 18) throw Exception('يجب أن يكون عمر السائق 18 سنة على الأقل');
      if (vehicleType == null || vehicleType.isEmpty) throw Exception('اختر نوع المركبة');
    }

    final credential = await auth.createUserWithEmailAndPassword(
      email: phoneAlias(phone),
      password: password,
    );
    await db.collection('users').doc(credential.user!.uid).set({
      'role': role,
      'name': name.trim(),
      'phone': phone.trim(),
      'address': address.trim(),
      'state': state.trim(),
      'age': role == 'driver' ? age : null,
      'vehicleType': role == 'driver' ? vehicleType : null,
      'status': role == 'customer' ? 'active' : 'pending',
      'privacyAccepted': true,
      'termsAccepted': true,
      'createdAt': FieldValue.serverTimestamp(),
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logout() => auth.signOut();
}

class OrderService {
  final db = FirebaseFirestore.instance;
  static const passenger = ['car', 'rickshaw', 'bus', 'amjad', 'taxi', 'limousine'];
  static const cargo = ['motorcycle', 'tuk_tuk', 'truck', 'kreez', 'tanker', 'crane', 'tow_truck', 'lorry'];

  Stream<QuerySnapshot<Map<String, dynamic>>> myOrders(String uid, String role) =>
      db.collection('orders').where(role == 'driver' ? 'driverId' : 'customerId', isEqualTo: uid)
          .orderBy('createdAt', descending: true).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> availableOrders(String state) =>
      db.collection('orders').where('state', isEqualTo: state).where('status', isEqualTo: 'pending')
          .where('driverId', isNull: true).orderBy('createdAt', descending: true).snapshots();

  Future<String> createOrder({
    required String uid,
    required String state,
    required String vehicleType,
    required String origin,
    required String destination,
    required String description,
    int? passengerCount,
    bool hasLuggage = false,
    String luggageDescription = '',
    String cargoType = '',
    String cargoDescription = '',
  }) async {
    final originText = origin.trim();
    final destinationText = destination.trim();
    if (originText.isEmpty || destinationText.isEmpty) throw Exception('مكان الاستلام والوجهة مطلوبان');
    if (originText == destinationText) throw Exception('مكان الاستلام والوجهة يجب أن يكونا مختلفين');
    final isPassenger = passenger.contains(vehicleType);
    final isCargo = cargo.contains(vehicleType);
    if (!isPassenger && !isCargo) throw Exception('نوع المركبة غير صحيح');
    if (isPassenger && (passengerCount == null || passengerCount < 1 || passengerCount > 100)) {
      throw Exception('عدد الركاب يجب أن يكون بين 1 و100');
    }
    if (isCargo && cargoType.trim().isEmpty) throw Exception('نوع البضاعة مطلوب');

    final ref = await db.collection('orders').add({
      'customerId': uid, 'driverId': null, 'state': state,
      'vehicleType': vehicleType, 'serviceCategory': isPassenger ? 'passenger' : 'cargo',
      'passengerCount': isPassenger ? passengerCount : null,
      'hasLuggage': isPassenger ? hasLuggage : null,
      'luggageDescription': isPassenger && hasLuggage ? luggageDescription.trim() : null,
      'cargoType': isCargo ? cargoType.trim() : null,
      'cargoDescription': isCargo ? cargoDescription.trim() : null,
      'description': description.trim().length > 1000 ? description.trim().substring(0, 1000) : description.trim(),
      'origin': originText, 'destination': destinationText,
      'deliveryFee': null, 'agreedFee': null, 'status': 'pending', 'negotiationStatus': 'none',
      'commissionCharged': false, 'cancellationPenaltyCharged': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Future<void> acceptOrder(String orderId, String driverId) async {
    await db.runTransaction((tx) async {
      final orderRef = db.collection('orders').doc(orderId);
      final negRef = db.collection('priceNegotiations').doc(orderId);
      final orderSnap = await tx.get(orderRef);
      final driverSnap = await tx.get(db.collection('users').doc(driverId));
      final walletSnap = await tx.get(db.collection('wallets').doc(driverId));
      if (!orderSnap.exists || !driverSnap.exists) throw Exception('الطلب أو حساب السائق غير موجود');
      final order = orderSnap.data()!;
      final driver = driverSnap.data()!;
      if (order['status'] != 'pending' || order['driverId'] != null) throw Exception('تم أخذ الطلب من سائق آخر');
      if (driver['role'] != 'driver' || driver['status'] != 'active' || driver['state'] != order['state']) {
        throw Exception('لا يمكنك قبول هذا الطلب');
      }
      if (!walletSnap.exists || ((walletSnap.data()?['balance'] as num?)?.toDouble() ?? 0) <= 0) {
        throw Exception('محفظتك غير مهيأة أو رصيدها صفر');
      }
      tx.update(orderRef, {'driverId': driverId, 'status': 'accepted', 'acceptedAt': FieldValue.serverTimestamp(), 'negotiationStatus': 'open'});
      tx.set(negRef, {
        'orderId': orderId, 'customerId': order['customerId'], 'driverId': driverId,
        'customerName': null, 'driverName': driver['name'] ?? 'السائق',
        'currentOffer': null, 'offeredBy': null, 'status': 'open', 'expiresAt': null,
        'updatedAt': FieldValue.serverTimestamp(), 'lastAction': 'accepted', 'lastMessageId': null,
      });
    });
  }

  Future<void> makeOffer({
    required String orderId, required String uid, required String role,
    required String name, required int amount,
  }) async {
    if (amount <= 0 || amount > 100000000) throw Exception('المبلغ غير صحيح');
    await db.runTransaction((tx) async {
      final orderRef = db.collection('orders').doc(orderId);
      final negRef = db.collection('priceNegotiations').doc(orderId);
      final orderSnap = await tx.get(orderRef);
      final negSnap = await tx.get(negRef);
      if (!orderSnap.exists || !negSnap.exists) throw Exception('المفاوضة غير موجودة');
      final order = orderSnap.data()!;
      final neg = negSnap.data()!;
      if (order['status'] != 'accepted' || neg['status'] != 'open') throw Exception('التفاوض غير متاح الآن');
      if (role == 'customer' && order['customerId'] != uid) throw Exception('ليس لديك صلاحية');
      if (role == 'driver' && order['driverId'] != uid) throw Exception('ليس لديك صلاحية');
      if (role == 'driver' && neg['currentOffer'] != null) throw Exception('يوجد عرض حالي بالفعل');
      if (role == 'customer' && neg['offeredBy'] == uid) throw Exception('انتظر رد السائق');

      Timestamp expiry;
      final existingExpiry = neg['expiresAt'];
      if (existingExpiry is Timestamp && existingExpiry.toDate().isAfter(DateTime.now())) {
        expiry = existingExpiry;
      } else {
        expiry = Timestamp.fromDate(DateTime.now().add(const Duration(minutes: 30)));
      }
      final messageRef = negRef.collection('messages').doc();
      tx.update(negRef, {
        'currentOffer': amount, 'offeredBy': uid, 'expiresAt': expiry,
        'updatedAt': FieldValue.serverTimestamp(), 'lastAction': 'offer', 'lastMessageId': messageRef.id,
        role == 'driver' ? 'driverName' : 'customerName': name,
      });
      tx.set(messageRef, {
        'orderId': orderId, 'amount': amount, 'action': 'offer', 'senderId': uid,
        'senderRole': role, 'senderName': name, 'createdAt': FieldValue.serverTimestamp(), 'expiresAt': expiry,
      });
    });
  }

  Future<void> respondToOffer({
    required String orderId, required String uid, required String role,
    required String name, required bool accept,
  }) async {
    await db.runTransaction((tx) async {
      final orderRef = db.collection('orders').doc(orderId);
      final negRef = db.collection('priceNegotiations').doc(orderId);
      final orderSnap = await tx.get(orderRef);
      final negSnap = await tx.get(negRef);
      if (!orderSnap.exists || !negSnap.exists) throw Exception('المفاوضة غير موجودة');
      final order = orderSnap.data()!;
      final neg = negSnap.data()!;
      if (order['status'] != 'accepted' || neg['status'] != 'open') throw Exception('التفاوض غير متاح');
      if (role == 'customer' && order['customerId'] != uid) throw Exception('ليس لديك صلاحية');
      if (role == 'driver' && order['driverId'] != uid) throw Exception('ليس لديك صلاحية');
      if (neg['offeredBy'] == uid) throw Exception('لا يمكنك قبول عرضك أنت');
      final offer = (neg['currentOffer'] as num?)?.toInt();
      if (offer == null || offer <= 0) throw Exception('العرض الحالي غير صالح');
      final messageRef = negRef.collection('messages').doc();

      if (!accept) {
        tx.set(messageRef, {
          'orderId': orderId, 'amount': offer, 'action': 'reject', 'senderId': uid,
          'senderRole': role, 'senderName': name, 'createdAt': FieldValue.serverTimestamp(),
          'expiresAt': neg['expiresAt'] ?? null,
        });
        tx.update(orderRef, {'driverId': null, 'status': 'pending', 'negotiationStatus': 'none'});
        tx.update(negRef, {'currentOffer': null, 'offeredBy': null, 'status': 'closed', 'updatedAt': FieldValue.serverTimestamp(), 'lastAction': 'reject', 'lastMessageId': messageRef.id});
        return;
      }

      final customerSnap = await tx.get(db.collection('users').doc(order['customerId'] as String));
      final driverSnap = await tx.get(db.collection('users').doc(order['driverId'] as String));
      if (!customerSnap.exists || !driverSnap.exists) throw Exception('بيانات أحد الطرفين غير موجودة');
      final customer = customerSnap.data()!;
      final driver = driverSnap.data()!;
      if (role == 'driver') {
        final walletSnap = await tx.get(db.collection('wallets').doc(order['driverId'] as String));
        final balance = (walletSnap.data()?['balance'] as num?)?.toInt() ?? 0;
        final commission = (offer * 0.05).round();
        if (!walletSnap.exists || balance < commission) throw Exception('رصيد المحفظة لا يكفي للعمولة');
      }
      tx.set(messageRef, {
        'orderId': orderId, 'amount': offer, 'action': 'accept', 'senderId': uid,
        'senderRole': role, 'senderName': name, 'createdAt': FieldValue.serverTimestamp(), 'expiresAt': neg['expiresAt'] ?? null,
      });
      tx.update(orderRef, {'deliveryFee': offer, 'agreedFee': offer, 'negotiationStatus': 'agreed', 'agreedAt': FieldValue.serverTimestamp(), 'agreedBy': uid});
      tx.update(negRef, {'status': 'agreed', 'currentOffer': offer, 'updatedAt': FieldValue.serverTimestamp(), 'agreedAt': FieldValue.serverTimestamp(), 'agreedBy': uid, 'lastAction': 'accept', 'lastMessageId': messageRef.id});
      tx.set(db.collection('orderContacts').doc(orderId), {
        'orderId': orderId, 'customerId': order['customerId'], 'driverId': order['driverId'],
        'customerPhone': '${customer['phone'] ?? ''}', 'driverPhone': '${driver['phone'] ?? ''}', 'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> updateStatus(String orderId, String status) async {
    final patch = <String, dynamic>{'status': status};
    final now = FieldValue.serverTimestamp();
    if (status == 'picked_up') patch['pickedUpAt'] = now;
    if (status == 'delivering') patch['startedAt'] = now;
    if (status == 'awaiting_confirmation') patch['deliveredAt'] = now;
    await db.collection('orders').doc(orderId).update(patch);
  }

  Future<void> customerConfirm(String orderId) async {
    await db.collection('orders').doc(orderId).update({'customerConfirmedAt': FieldValue.serverTimestamp()});
  }

  Future<void> rate(String orderId, String customerId, int stars, String comment) async {
    if (stars < 1 || stars > 5) throw Exception('التقييم بين 1 و5');
    final order = await db.collection('orders').doc(orderId).get();
    final driverId = order.data()?['driverId'];
    await db.collection('ratings').doc(orderId).set({
      'orderId': orderId, 'customerId': customerId, 'driverId': driverId,
      'stars': stars, 'comment': comment.trim().length > 500 ? comment.trim().substring(0, 500) : comment.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

class JawanApp extends StatelessWidget {
  const JawanApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'جوان للتوصيل',
        theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: kBg, colorScheme: ColorScheme.fromSeed(seedColor: kYellow)),
        home: const Directionality(textDirection: TextDirection.rtl, child: AuthGate()),
      );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, auth) {
          if (auth.connectionState == ConnectionState.waiting) return const SplashPage();
          if (!auth.hasData) return const LoginPage();
          return FutureBuilder<Map<String, dynamic>?>(
            future: AuthService().profile(auth.data!.uid),
            builder: (context, profile) {
              if (!profile.hasData) return const SplashPage();
              final data = profile.data;
              if (data == null) return const LoginPage(message: 'ملف الحساب غير موجود');
              final status = data['status'];
              if (status == 'suspended' || status == 'rejected') return const LoginPage(message: 'الحساب موقوف أو مرفوض');
              return HomePage(profile: data);
            },
          );
        },
      );
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class LoginPage extends StatefulWidget {
  final String? message;
  const LoginPage({super.key, this.message});
  @override State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = AuthService();
  final phone = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final address = TextEditingController();
  final age = TextEditingController();
  String state = 'البحر الأحمر';
  String vehicle = 'motorcycle';
  bool register = false, driver = false, busy = false, obscure = true;
  static const states = ['الخرطوم','الجزيرة','القضارف','كسلا','البحر الأحمر','نهر النيل','الشمالية','النيل الأبيض','النيل الأزرق','سنار','شمال كردفان','جنوب كردفان','غرب كردفان','شمال دارفور','جنوب دارفور','غرب دارفور','وسط دارفور','شرق دارفور'];

  Future<void> submit() async {
    setState(() => busy = true);
    try {
      if (register) {
        await auth.register(name: name.text, phone: phone.text, password: password.text, role: driver ? 'driver' : 'customer', state: state, address: address.text, age: int.tryParse(age.text), vehicleType: driver ? vehicle : null);
      } else {
        await auth.login(phone.text, password.text);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(cleanError(e))));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: kBlack, foregroundColor: kYellow, title: const Text('جوان للتوصيل', style: TextStyle(fontWeight: FontWeight.w900))),
        body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 520), child: Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('جوان', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
          const Text('توصيل أسرع وأسهل في بورتسودان'),
          if (widget.message != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(widget.message!, style: const TextStyle(color: Colors.red))),
          if (register) ...[
            const SizedBox(height: 16), TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم الكامل')),
            const SizedBox(height: 10), DropdownButtonFormField<String>(initialValue: state, items: states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) => setState(() => state = v!), decoration: const InputDecoration(labelText: 'الولاية')),
            const SizedBox(height: 10), TextField(controller: address, decoration: const InputDecoration(labelText: 'مكان السكن')),
            SwitchListTile(title: const Text('تسجيل كسائق'), value: driver, onChanged: (v) => setState(() => driver = v)),
            if (driver) ...[
              TextField(controller: age, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'العمر')),
              const SizedBox(height: 10), DropdownButtonFormField<String>(initialValue: vehicle, items: OrderService.cargo.map((v) => DropdownMenuItem(value: v, child: Text(vehicleLabel(v)))).toList(), onChanged: (v) => setState(() => vehicle = v!), decoration: const InputDecoration(labelText: 'نوع المركبة')),
            ],
          ],
          const SizedBox(height: 10), TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الهاتف')),
          const SizedBox(height: 10), TextField(controller: password, obscureText: obscure, decoration: InputDecoration(labelText: 'كلمة المرور', suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => obscure = !obscure)))),
          const SizedBox(height: 18), FilledButton(onPressed: busy ? null : submit, child: Text(busy ? 'جارٍ التنفيذ...' : (register ? 'إنشاء الحساب' : 'تسجيل الدخول'))),
          TextButton(onPressed: () => setState(() => register = !register), child: Text(register ? 'لدي حساب بالفعل' : 'إنشاء حساب جديد')),
        ]))))),
      );
}

class HomePage extends StatefulWidget {
  final Map<String, dynamic> profile;
  const HomePage({super.key, required this.profile});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final role = widget.profile['role'];
    final pages = role == 'driver'
        ? [DriverDashboard(profile: widget.profile), OrdersPage(profile: widget.profile)]
        : role == 'customer'
            ? [CustomerDashboard(profile: widget.profile), OrdersPage(profile: widget.profile)]
            : [AdminDashboard(profile: widget.profile), AdminOrdersPage()];
    return Scaffold(
      appBar: AppBar(backgroundColor: kBlack, foregroundColor: Colors.white, title: Text('جوان • ${widget.profile['name'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w800)), actions: [
        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())), icon: const Icon(Icons.notifications_none)),
        IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout)),
      ]),
      body: pages[index],
      bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (v) => setState(() => index = v), destinations: role == 'admin' || role == 'super_admin'
          ? const [NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'الإدارة'), NavigationDestination(icon: Icon(Icons.list_alt_outlined), label: 'الطلبات')]
          : const [NavigationDestination(icon: Icon(Icons.home_outlined), label: 'الرئيسية'), NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'طلباتي')]),
      floatingActionButton: role == 'customer' && index == 0
          ? FloatingActionButton.extended(backgroundColor: kYellow, foregroundColor: Colors.black, onPressed: () => showModalBottomSheet(isScrollControlled: true, context: context, builder: (_) => CreateOrderSheet(profile: widget.profile)), label: const Text('طلب جديد'))
          : null,
    );
  }
}

Widget heroCard(String title, String subtitle) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: kBlack, borderRadius: BorderRadius.circular(22)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(subtitle, style: const TextStyle(color: Colors.white70))]));

class CustomerDashboard extends StatelessWidget {
  final Map<String, dynamic> profile;
  const CustomerDashboard({super.key, required this.profile});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [
        heroCard('أهلاً ${profile['name'] ?? ''}', 'أنشئ طلبك واترك التسعير للتفاوض مع السائق.'),
        const SizedBox(height: 14),
        Card(child: ListTile(leading: const CircleAvatar(backgroundColor: kYellow, foregroundColor: Colors.black, child: Icon(Icons.local_shipping)), title: const Text('طلب جديد'), subtitle: const Text('مكان الاستلام • الوجهة • تفاصيل الخدمة'), onTap: () => showModalBottomSheet(isScrollControlled: true, context: context, builder: (_) => CreateOrderSheet(profile: profile)))),
      ]);
}

class DriverDashboard extends StatelessWidget {
  final Map<String, dynamic> profile;
  const DriverDashboard({super.key, required this.profile});
  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: OrderService().availableOrders('${profile['state'] ?? ''}'),
        builder: (context, snapshot) => ListView(padding: const EdgeInsets.all(18), children: [
          heroCard('لوحة السائق', '${profile['status'] ?? 'pending'} • ${profile['state'] ?? ''}'),
          const SizedBox(height: 14),
          if (profile['status'] != 'active') const Card(child: ListTile(title: Text('الحساب بانتظار اعتماد الإدارة'), subtitle: Text('بعد الاعتماد ستظهر الطلبات المتاحة.'), leading: Icon(Icons.info_outline))),
          if (snapshot.hasError) Text(cleanError(snapshot.error!)),
          ...snapshot.data?.docs.map((doc) => OrderCard(order: {'id': doc.id, ...doc.data()}, profile: profile, showAccept: true)).toList() ?? const [],
        ]),
      );
}

class OrdersPage extends StatelessWidget {
  final Map<String, dynamic> profile;
  const OrdersPage({super.key, required this.profile});
  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: OrderService().myOrders(FirebaseAuth.instance.currentUser!.uid, '${profile['role']}'),
        builder: (context, snapshot) => ListView(padding: const EdgeInsets.all(18), children: [
          const Text('طلباتي', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          if (snapshot.hasError) Text(cleanError(snapshot.error!)),
          ...snapshot.data?.docs.map((doc) => OrderCard(order: {'id': doc.id, ...doc.data()}, profile: profile)).toList() ?? const [],
        ]),
      );
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final Map<String, dynamic> profile;
  final bool showAccept;
  const OrderCard({super.key, required this.order, required this.profile, this.showAccept = false});
  @override
  Widget build(BuildContext context) => Card(child: ListTile(
        title: Text('${order['origin'] ?? ''} ← ${order['destination'] ?? ''}', maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text('${statusLabel(order['status'])}${order['agreedFee'] == null ? '' : ' • ${order['agreedFee']} ج.س'}'),
        trailing: showAccept ? FilledButton(onPressed: () async {
          try { await OrderService().acceptOrder('${order['id']}', FirebaseAuth.instance.currentUser!.uid); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم قبول الطلب وبدأت المفاوضة'))); }
          catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(cleanError(e)))); }
        }, child: const Text('قبول')) : const Icon(Icons.chevron_left),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsPage(orderId: '${order['id']}', profile: profile))),
      ));
}

class CreateOrderSheet extends StatefulWidget {
  final Map<String, dynamic> profile;
  const CreateOrderSheet({super.key, required this.profile});
  @override State<CreateOrderSheet> createState() => _CreateOrderSheetState();
}

class _CreateOrderSheetState extends State<CreateOrderSheet> {
  final origin = TextEditingController(), destination = TextEditingController(), description = TextEditingController();
  final cargo = TextEditingController(), cargoDescription = TextEditingController(), luggageDescription = TextEditingController();
  String vehicle = 'motorcycle';
  int passengers = 1;
  bool luggage = false, busy = false;
  @override
  Widget build(BuildContext context) {
    final isPassenger = OrderService.passenger.contains(vehicle);
    return Padding(padding: EdgeInsets.only(left: 18, right: 18, top: 18, bottom: MediaQuery.of(context).viewInsets.bottom + 18), child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Text('إنشاء طلب', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(initialValue: vehicle, items: [...OrderService.passenger, ...OrderService.cargo].map((v) => DropdownMenuItem(value: v, child: Text(vehicleLabel(v)))).toList(), onChanged: (v) => setState(() => vehicle = v!), decoration: const InputDecoration(labelText: 'نوع المركبة')),
      const SizedBox(height: 10), TextField(controller: origin, decoration: const InputDecoration(labelText: 'مكان الاستلام')),
      const SizedBox(height: 10), TextField(controller: destination, decoration: const InputDecoration(labelText: 'الوجهة')),
      if (isPassenger) ...[
        const SizedBox(height: 10), DropdownButtonFormField<int>(initialValue: passengers, items: List.generate(10, (i) => i + 1).map((v) => DropdownMenuItem(value: v, child: Text('$v'))).toList(), onChanged: (v) => setState(() => passengers = v!), decoration: const InputDecoration(labelText: 'عدد الركاب')),
        SwitchListTile(title: const Text('يوجد أمتعة'), value: luggage, onChanged: (v) => setState(() => luggage = v)),
        if (luggage) TextField(controller: luggageDescription, decoration: const InputDecoration(labelText: 'وصف الأمتعة')),
      ] else ...[
        const SizedBox(height: 10), TextField(controller: cargo, decoration: const InputDecoration(labelText: 'نوع البضاعة')),
        const SizedBox(height: 10), TextField(controller: cargoDescription, decoration: const InputDecoration(labelText: 'وصف البضاعة')),
      ],
      const SizedBox(height: 10), TextField(controller: description, decoration: const InputDecoration(labelText: 'ملاحظات إضافية')),
      const SizedBox(height: 16), FilledButton(onPressed: busy ? null : () async {
        setState(() => busy = true);
        try {
          await OrderService().createOrder(uid: FirebaseAuth.instance.currentUser!.uid, state: '${widget.profile['state'] ?? ''}', vehicleType: vehicle, origin: origin.text, destination: destination.text, description: description.text, passengerCount: isPassenger ? passengers : null, hasLuggage: luggage, luggageDescription: luggageDescription.text, cargoType: cargo.text, cargoDescription: cargoDescription.text);
          if (context.mounted) { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء الطلب'))); }
        } catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(cleanError(e)))); }
        finally { if (mounted) setState(() => busy = false); }
      }, child: Text(busy ? 'جارٍ الإنشاء...' : 'إنشاء الطلب')),
    ])));
  }
}

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> profile;
  const OrderDetailsPage({super.key, required this.orderId, required this.profile});
  @override State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final amount = TextEditingController();
  final comment = TextEditingController();
  int stars = 5;
  bool busy = false;
  final service = OrderService();

  Future<void> run(Future<void> Function() action) async {
    setState(() => busy = true);
    try { await action(); if (mounted) setState(() {}); }
    catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(cleanError(e)))); }
    finally { if (mounted) setState(() => busy = false); }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('orders').doc(widget.orderId).snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data();
          if (data == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
          final role = '${widget.profile['role']}';
          final uid = FirebaseAuth.instance.currentUser!.uid;
          return Scaffold(appBar: AppBar(title: const Text('تفاصيل الطلب')), body: ListView(padding: const EdgeInsets.all(18), children: [
            heroCard('${data['origin']} ← ${data['destination']}', statusLabel(data['status'])),
            const SizedBox(height: 12),
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text('السعر: ${data['agreedFee'] ?? 'لم يتم الاتفاق'} ج.س', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
              if (data['status'] == 'accepted' && data['negotiationStatus'] != 'agreed') ...[
                const SizedBox(height: 12),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('priceNegotiations').doc(widget.orderId).snapshots(), builder: (context, negSnapshot) {
                  final neg = negSnapshot.data?.data();
                  if (neg == null) return const Text('جاري تجهيز التفاوض...');
                  final offer = (neg['currentOffer'] as num?)?.toInt();
                  return Column(children: [
                    if (offer != null) Text('العرض الحالي: $offer ج.س', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    TextField(controller: amount, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: role == 'driver' ? 'عرضك الأول' : 'عرض مقابل')),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: FilledButton(onPressed: busy ? null : () => run(() => service.makeOffer(orderId: widget.orderId, uid: uid, role: role, name: '${widget.profile['name']}', amount: int.tryParse(amount.text) ?? 0)), child: const Text('إرسال العرض'))),
                      if (offer != null && neg['offeredBy'] != uid) ...[
                        const SizedBox(width: 8),
                        OutlinedButton(onPressed: busy ? null : () => run(() => service.respondToOffer(orderId: widget.orderId, uid: uid, role: role, name: '${widget.profile['name']}', accept: true)), child: const Text('قبول')),
                        const SizedBox(width: 8),
                        OutlinedButton(onPressed: busy ? null : () => run(() => service.respondToOffer(orderId: widget.orderId, uid: uid, role: role, name: '${widget.profile['name']}', accept: false)), child: const Text('رفض')),
                      ],
                    ]),
                  ]);
                }),
              ],
              if (data['status'] == 'accepted' && data['negotiationStatus'] == 'agreed' && role == 'driver') FilledButton(onPressed: busy ? null : () => run(() => service.updateStatus(widget.orderId, 'picked_up')), child: const Text('تم استلام الطلب')),
              if (data['status'] == 'picked_up' && role == 'driver') FilledButton(onPressed: busy ? null : () => run(() => service.updateStatus(widget.orderId, 'delivering')), child: const Text('بدء التوصيل')),
              if (data['status'] == 'delivering' && role == 'driver') FilledButton(onPressed: busy ? null : () => run(() => service.updateStatus(widget.orderId, 'awaiting_confirmation')), child: const Text('تم التسليم')),
              if (data['status'] == 'awaiting_confirmation' && role == 'customer') ...[
                FilledButton(onPressed: busy ? null : () => run(() => service.customerConfirm(widget.orderId)), child: const Text('تأكيد الاستلام')),
                const SizedBox(height: 8),
                if (data['customerConfirmedAt'] != null) ...[
                  DropdownButtonFormField<int>(initialValue: stars, items: List.generate(5, (i) => i + 1).map((v) => DropdownMenuItem(value: v, child: Text('$v نجوم'))).toList(), onChanged: (v) => setState(() => stars = v!), decoration: const InputDecoration(labelText: 'التقييم')),
                  const SizedBox(height: 8), TextField(controller: comment, decoration: const InputDecoration(labelText: 'تعليق مختصر')),
                  const SizedBox(height: 8), FilledButton(onPressed: busy ? null : () => run(() => service.rate(widget.orderId, uid, stars, comment.text)), child: const Text('حفظ التقييم')),
                ],
              ],
            ]))),
          ]);
        },
      );
}

class AdminDashboard extends StatelessWidget {
  final Map<String, dynamic> profile;
  const AdminDashboard({super.key, required this.profile});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [
        heroCard('لوحة الإدارة', '${profile['role']} • ${profile['status']}'),
        const SizedBox(height: 12),
        Card(child: ListTile(leading: const Icon(Icons.people_outline), title: const Text('المستخدمون'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminUsersPage())))),
        Card(child: ListTile(leading: const Icon(Icons.account_balance_wallet_outlined), title: const Text('طلبات الشحن'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminTopupsPage())))),
      ]);
}

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).limit(200).snapshots(),
        builder: (context, snapshot) => ListView(padding: const EdgeInsets.all(18), children: [
          const Text('كل الطلبات', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          ...snapshot.data?.docs.map((doc) => OrderCard(order: {'id': doc.id, ...doc.data()}, profile: const {'role': 'admin'})).toList() ?? const [],
        ]),
      );
}

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('المستخدمون')), body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').orderBy('createdAt', descending: true).limit(300).snapshots(),
        builder: (context, snapshot) => ListView(children: snapshot.data?.docs.map((doc) => ListTile(title: Text('${doc.data()['name'] ?? doc.id}'), subtitle: Text('${doc.data()['role'] ?? ''} • ${doc.data()['status'] ?? ''} • ${doc.data()['phone'] ?? ''}'))).toList() ?? const []),
      ));
}

class AdminTopupsPage extends StatelessWidget {
  const AdminTopupsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('طلبات الشحن')), body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('topupRequests').orderBy('createdAt', descending: true).limit(200).snapshots(),
        builder: (context, snapshot) => ListView(children: snapshot.data?.docs.map((doc) => ListTile(title: Text('${doc.data()['amount'] ?? ''} ج.س'), subtitle: Text('${doc.data()['status'] ?? ''} • ${doc.data()['driverId'] ?? ''}'))).toList() ?? const []),
      ));
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(appBar: AppBar(title: const Text('الإشعارات')), body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('notifications').where('userId', isEqualTo: uid).orderBy('createdAt', descending: true).limit(100).snapshots(),
      builder: (context, snapshot) => ListView(children: snapshot.data?.docs.map((doc) => ListTile(title: Text('${doc.data()['title'] ?? 'جوان'}'), subtitle: Text('${doc.data()['body'] ?? ''}'), onTap: () => doc.reference.update({'read': true}))).toList() ?? const []),
    ));
  }
}
