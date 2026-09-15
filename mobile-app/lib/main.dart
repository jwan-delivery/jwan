import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const JawanApp());
}

class JawanApp extends StatelessWidget {
  const JawanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'جوان للتوصيل',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFC400)),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: JawanHomePage(),
      ),
    );
  }
}

class JawanHomePage extends StatelessWidget {
  const JawanHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('جوان للتوصيل', style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      drawer: const JawanDrawer(),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: user == null
            ? null
            : FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data();
          final name = (data?['name'] as String?)?.trim();
          final role = data?['role'] as String?;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name?.isNotEmpty == true ? 'أهلاً، $name' : 'أهلاً بك في جوان',
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      role == 'driver'
                          ? 'لوحة السائق — طلباتك وتحديثاتها من Firebase مباشرة'
                          : 'توصيل أسرع وأسهل في بورتسودان',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _ActionCard(icon: Icons.local_shipping_outlined, title: 'إنشاء طلب', subtitle: 'اطلب خدمة توصيل جديدة'),
              _ActionCard(icon: Icons.receipt_long_outlined, title: 'طلباتي', subtitle: 'تابع حالة طلباتك'),
              _ActionCard(icon: Icons.notifications_none, title: 'الإشعارات', subtitle: 'آخر التنبيهات والتحديثات'),
              _ActionCard(icon: Icons.support_agent, title: 'الدعم', subtitle: 'تواصل مع جوان'),
            ],
          );
        },
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ActionCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFFC400),
          foregroundColor: Colors.black,
          child: Icon(icon),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_left),
      ),
    );
  }
}

class JawanDrawer extends StatelessWidget {
  const JawanDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              color: Colors.black,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('جوان', style: TextStyle(color: Color(0xFFFFC400), fontSize: 30, fontWeight: FontWeight.w900)),
                  SizedBox(height: 4),
                  Text('للتوصيل', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
            ListTile(leading: const Icon(Icons.home_outlined), title: const Text('الرئيسية'), onTap: () => Navigator.pop(context)),
            const ListTile(leading: Icon(Icons.local_shipping_outlined), title: Text('طلباتي')),
            const ListTile(leading: Icon(Icons.notifications_none), title: Text('الإشعارات')),
            const ListTile(leading: Icon(Icons.support_agent), title: Text('الدعم')),
            const ListTile(leading: Icon(Icons.person_outline), title: Text('حسابي')),
          ],
        ),
      ),
    );
  }
}
