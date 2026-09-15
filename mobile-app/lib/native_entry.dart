import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'ayez_app_shell.dart';
import 'main.dart' as legacy;

const kAyezBlack = Color(0xFF080808);
const kAyezBlack2 = Color(0xFF111111);
const kAyezYellow = Color(0xFFF5C400);
const kAyezWhite = Color(0xFFFFFFFF);
const kAyezGray = Color(0xFFB8B8B8);
const kAyezGrayDark = Color(0xFF858585);

class AyezEntry extends StatelessWidget {
  const AyezEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const _LoadingPage();
        return snapshot.hasData ? const AyezHomeGate() : const AyezWelcomePage();
      },
    );
  }
}

class AyezWelcomePage extends StatelessWidget {
  const AyezWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAyezBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Container(width: 50, height: 50, padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: kAyezYellow, borderRadius: BorderRadius.circular(15)), child: Image.asset('assets/branding/jawan-logo.png', fit: BoxFit.contain)),
                  const Spacer(),
                  const Text('عايز', style: TextStyle(color: kAyezWhite, fontSize: 22, fontWeight: FontWeight.w900)),
                ]),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: kAyezBlack2, borderRadius: BorderRadius.circular(28), border: Border.all(color: const Color(0x16FFFFFF))),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Container(width: 150, height: 150, padding: const EdgeInsets.all(18), decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0x0EF5C400), border: Border.all(color: const Color(0x45F5C400))), child: Image.asset('assets/branding/jawan-logo.png', fit: BoxFit.contain)),
                    const SizedBox(height: 20),
                    const Text('توصيلك يبدأ من هنا', textAlign: TextAlign.right, style: TextStyle(color: kAyezYellow, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    const Text('عايز', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 48, height: .95, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    const Text('منصة سودانية للتوصيل والنقل تساعدك تطلب، تفاوض، تتابع، وتتواصل بسهولة.', textAlign: TextAlign.right, style: TextStyle(color: kAyezGray, fontSize: 15, height: 1.8)),
                  ]),
                ),
                const SizedBox(height: 18),
                Row(children: [
                  Expanded(child: _PrimaryButton(label: 'تسجيل الدخول', icon: Icons.login_rounded, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AyezAuthPage(loginMode: true))))),
                  const SizedBox(width: 10),
                  Expanded(child: _SecondaryButton(label: 'إنشاء حساب', icon: Icons.person_add_alt_1_rounded, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AyezAuthPage(loginMode: false))))),
                ]),
                const SizedBox(height: 22),
                const _AboutCard(),
                const SizedBox(height: 16),
                const _FeatureCard(icon: Icons.speed_rounded, title: 'سهل وسريع', text: 'أنشئ طلبك وتابع حالته من مكان واحد.'),
                const _FeatureCard(icon: Icons.local_shipping_outlined, title: 'نقل ركاب وبضائع', text: 'نموذج الخدمة يطابق نموذج الويب وقواعد النظام.'),
                const _FeatureCard(icon: Icons.support_agent_rounded, title: 'دعم مباشر', text: 'افتح واتساب مباشرة من التطبيق.'),
                const SizedBox(height: 12),
                const Text('باستخدامك عايز أنت جزء من منصة سودانية للتوصيل والنقل.', textAlign: TextAlign.center, style: TextStyle(color: kAyezGrayDark, fontSize: 11, height: 1.6)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class AyezAuthPage extends StatefulWidget {
  final bool loginMode;
  const AyezAuthPage({super.key, required this.loginMode});
  @override
  State<AyezAuthPage> createState() => _AyezAuthPageState();
}

class _AyezAuthPageState extends State<AyezAuthPage> {
  final _auth = legacy.AuthService();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _age = TextEditingController();
  bool _loginMode = true;
  bool _driver = false;
  bool _privacy = false;
  bool _terms = false;
  bool _busy = false;
  bool _obscure = true;
  String _state = 'الخرطوم';
  String _vehicle = 'motorcycle';

  static const _states = ['الخرطوم','الجزيرة','القضارف','كسلا','البحر الأحمر','نهر النيل','الشمالية','النيل الأبيض','النيل الأزرق','سنار','شمال كردفان','جنوب كردفان','غرب كردفان','شمال دارفور','جنوب دارفور','غرب دارفور','وسط دارفور','شرق دارفور'];

  @override
  void initState() { super.initState(); _loginMode = widget.loginMode; }
  @override
  void dispose() { _phone.dispose(); _password.dispose(); _name.dispose(); _address.dispose(); _age.dispose(); super.dispose(); }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_loginMode && (!_privacy || !_terms)) { _showError('يجب الموافقة على سياسة الخصوصية وبنود الخدمة أولاً.'); return; }
    setState(() => _busy = true);
    try {
      if (_loginMode) {
        await _auth.login(_phone.text.trim(), _password.text);
      } else {
        await _auth.register(name: _name.text, phone: _phone.text, password: _password.text, role: _driver ? 'driver' : 'customer', state: _state, address: _address.text, age: int.tryParse(_age.text), vehicleType: _driver ? _vehicle : null);
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) await FirebaseFirestore.instance.collection('users').doc(user.uid).set({'privacyAccepted': true, 'termsAccepted': true, 'privacyAcceptedAt': FieldValue.serverTimestamp(), 'termsAcceptedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
      }
    } catch (e) {
      if (mounted) _showError(legacy.cleanError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _google() async {
    if (!_loginMode && (!_privacy || !_terms)) { _showError('يجب الموافقة على سياسة الخصوصية وبنود الخدمة أولاً.'); return; }
    setState(() => _busy = true);
    try {
      final googleUser = await GoogleSignIn(scopes: const ['email']).signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final result = await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken));
      final ref = FirebaseFirestore.instance.collection('users').doc(result.user!.uid);
      final snap = await ref.get();
      if (!snap.exists) {
        await ref.set({'role':'customer','name':googleUser.displayName ?? 'مستخدم عايز','phone':'','email':googleUser.email,'address':'','state':_state,'status':'active','privacyAccepted':true,'termsAccepted':true,'privacyAcceptedAt':FieldValue.serverTimestamp(),'termsAcceptedAt':FieldValue.serverTimestamp(),'createdAt':FieldValue.serverTimestamp(),'lastActiveAt':FieldValue.serverTimestamp()});
      } else {
        await ref.set({'lastActiveAt':FieldValue.serverTimestamp()}, SetOptions(merge:true));
      }
    } catch (e) { if (mounted) _showError(legacy.cleanError(e)); }
    finally { if (mounted) setState(() => _busy = false); }
  }

  void _showError(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final fill = const Color(0xFF171719);
    return Scaffold(
      backgroundColor: kAyezBlack,
      appBar: AppBar(backgroundColor: kAyezBlack, foregroundColor: Colors.white, title: const Text('عايز', style: TextStyle(fontWeight: FontWeight.w900))),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 10, 20, 30), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 540), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: kAyezBlack2, borderRadius: BorderRadius.circular(16)), child: Row(children: [Expanded(child: _ModeButton(active: _loginMode, label: 'دخول', onTap: () => setState(() => _loginMode = true))), Expanded(child: _ModeButton(active: !_loginMode, label: 'حساب جديد', onTap: () => setState(() => _loginMode = false)))])),
        const SizedBox(height: 14),
        Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: kAyezBlack2, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0x14FFFFFF))), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (!_loginMode) ...[
            _Field(controller: _name, label: 'الاسم الكامل', icon: Icons.person_outline_rounded, fill: fill),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(value: _state, dropdownColor: kAyezBlack3, style: const TextStyle(color: Colors.white), items: _states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) => setState(() => _state = v ?? _state), decoration: _decoration('الولاية', Icons.location_on_outlined)),
            const SizedBox(height: 10),
            _Field(controller: _address, label: 'مكان السكن', icon: Icons.home_outlined, fill: fill),
            const SizedBox(height: 4),
            CheckboxListTile(value: _driver, onChanged: (v) => setState(() => _driver = v ?? false), activeColor: kAyezYellow, checkColor: Colors.black, contentPadding: EdgeInsets.zero, title: const Text('التسجيل كسائق', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
            if (_driver) ...[
              _Field(controller: _age, label: 'العمر', icon: Icons.cake_outlined, fill: fill, keyboard: TextInputType.number),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(value: _vehicle, dropdownColor: kAyezBlack3, style: const TextStyle(color: Colors.white), items: [...legacy.OrderService.passenger, ...legacy.OrderService.cargo].map((v) => DropdownMenuItem(value: v, child: Text(legacy.vehicleLabel(v)))).toList(), onChanged: (v) => setState(() => _vehicle = v ?? _vehicle), decoration: _decoration('نوع المركبة', Icons.two_wheeler_outlined)),
            ],
            const SizedBox(height: 6),
            CheckboxListTile(value: _privacy, onChanged: (v) => setState(() => _privacy = v ?? false), activeColor: kAyezYellow, checkColor: Colors.black, contentPadding: EdgeInsets.zero, title: const Text('أوافق على سياسة الخصوصية', style: TextStyle(color: Colors.white, fontSize: 13)), subtitle: TextButton(onPressed: () => _legal(context, 'سياسة الخصوصية', 'نحافظ على بيانات الحساب ونستخدمها لتشغيل خدمات عايز وإدارة الطلبات والدعم.'), style: TextButton.styleFrom(alignment: Alignment.centerRight, padding: EdgeInsets.zero, foregroundColor: kAyezYellow), child: const Text('قراءة السياسة')),
            CheckboxListTile(value: _terms, onChanged: (v) => setState(() => _terms = v ?? false), activeColor: kAyezYellow, checkColor: Colors.black, contentPadding: EdgeInsets.zero, title: const Text('أوافق على بنود الخدمة', style: TextStyle(color: Colors.white, fontSize: 13)), subtitle: TextButton(onPressed: () => _legal(context, 'بنود الخدمة', 'استخدام عايز يعني الالتزام بقواعد الطلب والتفاوض والدفع وسياسات الاستخدام المعتمدة.'), style: TextButton.styleFrom(alignment: Alignment.centerRight, padding: EdgeInsets.zero, foregroundColor: kAyezYellow), child: const Text('قراءة البنود'))),
          ],
          _Field(controller: _phone, label: 'رقم الهاتف', icon: Icons.phone_outlined, fill: fill, keyboard: TextInputType.phone),
          const SizedBox(height: 10),
          _Field(controller: _password, label: 'كلمة المرور', icon: Icons.lock_outline_rounded, fill: fill, obscure: _obscure, suffix: IconButton(onPressed: () => setState(() => _obscure = !_obscure), icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: kAyezGray))),
          const SizedBox(height: 16),
          FilledButton(onPressed: _busy ? null : _submit, style: FilledButton.styleFrom(backgroundColor: kAyezYellow, foregroundColor: Colors.black, minimumSize: const Size.fromHeight(52)), child: Text(_busy ? 'جارٍ التنفيذ...' : (_loginMode ? 'تسجيل الدخول' : 'إنشاء الحساب'), style: const TextStyle(fontWeight: FontWeight.w900))),
          const SizedBox(height: 10),
          Row(children: [const Expanded(child: Divider(color: Color(0x22FFFFFF))), Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('أو', style: TextStyle(color: kAyezGrayDark))), const Expanded(child: Divider(color: Color(0x22FFFFFF)))]),
          const SizedBox(height: 10),
          OutlinedButton.icon(onPressed: _busy ? null : _google, icon: const Icon(Icons.account_circle_outlined), label: const Text('الدخول باستخدام Google'), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, minimumSize: const Size.fromHeight(50), side: const BorderSide(color: Color(0x35FFFFFF)))),
        ])),
      ]))))),
    );
  }

  InputDecoration _decoration(String label, IconData icon) => InputDecoration(labelText: label, labelStyle: const TextStyle(color: kAyezGray), prefixIcon: Icon(icon, color: kAyezGray), filled: true, fillColor: kAyezBlack2, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0x20FFFFFF))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0x20FFFFFF))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: kAyezYellow, width: 1.4)));

  void _legal(BuildContext context, String title, String text) {
    showModalBottomSheet<void>(context: context, backgroundColor: kAyezBlack2, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))), builder: (_) => SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(22, 18, 22, 28), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 12), Text(text, style: const TextStyle(color: kAyezGray, height: 1.8)), const SizedBox(height: 18), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق'))]))));
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Color fill;
  final bool obscure;
  final TextInputType? keyboard;
  final Widget? suffix;
  const _Field({required this.controller, required this.label, required this.icon, required this.fill, this.obscure = false, this.keyboard, this.suffix});
  @override
  Widget build(BuildContext context) => TextField(controller: controller, obscureText: obscure, keyboardType: keyboard, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: label, labelStyle: const TextStyle(color: kAyezGray), prefixIcon: Icon(icon, color: kAyezGray), suffixIcon: suffix, filled: true, fillColor: fill, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0x20FFFFFF))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0x20FFFFFF))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: kAyezYellow, width: 1.4))));
}

class _PrimaryButton extends StatelessWidget { final String label; final IconData icon; final VoidCallback onPressed; const _PrimaryButton({required this.label, required this.icon, required this.onPressed}); @override Widget build(BuildContext context) => FilledButton.icon(onPressed: onPressed, icon: Icon(icon, color: Colors.black), label: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)), style: FilledButton.styleFrom(backgroundColor: kAyezYellow, foregroundColor: Colors.black, minimumSize: const Size.fromHeight(52))); }
class _SecondaryButton extends StatelessWidget { final String label; final IconData icon; final VoidCallback onPressed; const _SecondaryButton({required this.label, required this.icon, required this.onPressed}); @override Widget build(BuildContext context) => OutlinedButton.icon(onPressed: onPressed, icon: Icon(icon), label: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Color(0x35FFFFFF)), minimumSize: const Size.fromHeight(52))); }
class _ModeButton extends StatelessWidget { final bool active; final String label; final VoidCallback onTap; const _ModeButton({required this.active, required this.label, required this.onTap}); @override Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 13), decoration: BoxDecoration(color: active ? kAyezYellow : Colors.transparent, borderRadius: BorderRadius.circular(12)), child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: active ? Colors.black : Colors.white, fontWeight: FontWeight.w900))); }
class _AboutCard extends StatelessWidget { const _AboutCard(); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: kAyezBlack2, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0x12FFFFFF))), child: const Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text('من نحن؟', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)), SizedBox(height: 7), Text('عايز منصة محلية لتسهيل التوصيل والنقل وربط العميل بالسائق بطريقة واضحة وعملية، مع متابعة الطلب ودعم المستخدم.', textAlign: TextAlign.right, style: TextStyle(color: kAyezGray, height: 1.8))])); }
class _FeatureCard extends StatelessWidget { final IconData icon; final String title; final String text; const _FeatureCard({required this.icon, required this.title, required this.text}); @override Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(top: 10), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: kAyezBlack2, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0x10FFFFFF))), child: Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0x12F5C400), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: kAyezYellow)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)), const SizedBox(height: 2), Text(text, style: const TextStyle(color: kAyezGrayDark, fontSize: 12, height: 1.5))]))])); }
class _LoadingPage extends StatelessWidget { const _LoadingPage(); @override Widget build(BuildContext context) => const Scaffold(backgroundColor: kAyezBlack, body: Center(child: CircularProgressIndicator(color: kAyezYellow))); }
