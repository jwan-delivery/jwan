import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart' as legacy;

const kAyezBlack = Color(0xFF080808);
const kAyezBlack2 = Color(0xFF101010);
const kAyezBlack3 = Color(0xFF181818);
const kAyezYellow = Color(0xFFF5C400);
const kAyezYellowLight = Color(0xFFFFD83D);
const kAyezWhite = Color(0xFFFFFFFF);
const kAyezGray = Color(0xFFB8B8B8);
const kAyezGrayDark = Color(0xFF858585);

class AyezEntry extends StatelessWidget {
  const AyezEntry({super.key});

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _AyezLoading();
          }
          return snapshot.hasData
              ? const legacy.AuthGate()
              : const AyezWelcomePage();
        },
      );
}

class AyezWelcomePage extends StatelessWidget {
  const AyezWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAyezBlack,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _AyezHeader()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeroVisual(),
                    const SizedBox(height: 18),
                    const _TrustStrip(),
                    const SizedBox(height: 22),
                    const Text(
                      'توصيلك يبدأ من هنا',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: kAyezYellow, fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'عايز',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: kAyezWhite, fontSize: 48, height: .95, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'منصة محلية للتوصيل والنقل داخل السودان. اطلب خدمتك، تابع رحلتك، وتواصل مع السائق بسهولة.',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: kAyezGray, fontSize: 15, height: 1.8),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _PrimaryButton(
                            label: 'تسجيل الدخول',
                            icon: Icons.login_rounded,
                            onPressed: () => Navigator.push(context, _fadeRoute(const AyezAuthPage(loginMode: true))),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _OutlineButton(
                            label: 'حساب جديد',
                            icon: Icons.person_add_alt_1_rounded,
                            onPressed: () => Navigator.push(context, _fadeRoute(const AyezAuthPage(loginMode: false))),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _AboutSection(),
                    const SizedBox(height: 18),
                    const Text(
                      'خدماتنا',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: kAyezWhite, fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 12),
                    const _FeatureCard(icon: Icons.local_shipping_outlined, title: 'توصيل ونقل', text: 'خدمات للركاب والبضائع بمركبات متعددة.'),
                    const _FeatureCard(icon: Icons.speed_rounded, title: 'سرعة ووضوح', text: 'ابدأ الطلب وتابع حالته خطوة بخطوة.'),
                    const _FeatureCard(icon: Icons.support_agent_rounded, title: 'دعم مباشر', text: 'تواصل مع الدعم عند الحاجة بسهولة.'),
                    const SizedBox(height: 14),
                    Text(
                      '© ${DateTime.now().year} عايز — جميع الحقوق محفوظة',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: kAyezGrayDark, fontSize: 12),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AyezHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: kAyezYellow,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(color: Color(0x20F5C400), blurRadius: 26, spreadRadius: 1)],
              ),
              child: Image.asset('assets/branding/jawan-logo.png', fit: BoxFit.contain),
            ),
            const Spacer(),
            const Text('عايز', style: TextStyle(color: kAyezWhite, fontSize: 19, fontWeight: FontWeight.w900)),
          ],
        ),
      );
}

class _HeroVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 235,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0x16FFFFFF)),
          gradient: const RadialGradient(center: Alignment(0, -.25), radius: .9, colors: [Color(0x30F5C400), kAyezBlack2]),
          boxShadow: const [BoxShadow(color: Color(0x50000000), blurRadius: 38, offset: Offset(0, 18))],
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 145,
                height: 145,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0x45F5C400)),
                  boxShadow: const [BoxShadow(color: Color(0x19F5C400), blurRadius: 0, spreadRadius: 22)],
                ),
                child: Image.asset('assets/branding/jawan-logo.png', fit: BoxFit.contain),
              ),
            ),
            const Positioned(right: 16, top: 16, child: _FloatingPill(title: 'خدمة محلية', icon: Icons.location_on_outlined)),
            const Positioned(left: 16, bottom: 16, child: _FloatingPill(title: 'سريع وموثوق', icon: Icons.verified_outlined)),
          ],
        ),
      );
}

class _FloatingPill extends StatelessWidget {
  final String title;
  final IconData icon;
  const _FloatingPill({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xD90B0B0B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0x16FFFFFF)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 5),
            Icon(icon, color: kAyezYellow, size: 17),
            const SizedBox(width: 6),
            Text(title, style: const TextStyle(color: kAyezWhite, fontSize: 11, fontWeight: FontWeight.w700)),
          ],
        ),
      );
}

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0x08FFFFFF),
          border: Border.all(color: const Color(0x12FFFFFF)),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _TrustItem(icon: Icons.flash_on_rounded, text: 'سريع'),
            _TrustItem(icon: Icons.lock_outline_rounded, text: 'آمن'),
            _TrustItem(icon: Icons.headset_mic_outlined, text: 'دعم'),
          ],
        ),
      );
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _TrustItem({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, color: kAyezYellow, size: 18), const SizedBox(width: 6), Text(text, style: const TextStyle(color: kAyezGray, fontSize: 12, fontWeight: FontWeight.w700))]);
}

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0x08FFFFFF),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0x12FFFFFF)),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('من نحن؟', textAlign: TextAlign.right, style: TextStyle(color: kAyezWhite, fontSize: 23, fontWeight: FontWeight.w900)),
            SizedBox(height: 8),
            Text('عايز منصة سودانية صُممت لتسهيل التوصيل والنقل وربط العميل بالسائق بطريقة واضحة وعملية. هدفنا أن يكون طلب الخدمة ومتابعتها أسهل، وأن تصل إلى ما تحتاجه بأقل خطوات.', textAlign: TextAlign.right, style: TextStyle(color: kAyezGray, height: 1.8, fontSize: 14)),
          ],
        ),
      );
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const _FeatureCard({required this.icon, required this.title, required this.text});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: kAyezBlack2, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0x10FFFFFF))),
        child: Row(
          children: [
            Container(width: 46, height: 46, decoration: BoxDecoration(color: const Color(0x12F5C400), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: kAyezYellow)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text(title, textAlign: TextAlign.right, style: const TextStyle(color: kAyezWhite, fontWeight: FontWeight.w900)), const SizedBox(height: 2), Text(text, textAlign: TextAlign.right, style: const TextStyle(color: kAyezGrayDark, fontSize: 12, height: 1.5))])),
          ],
        ),
      );
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
  String _state = 'البحر الأحمر';
  String _vehicle = 'motorcycle';
  bool _driver = false;
  bool _privacy = false;
  bool _terms = false;
  bool _busy = false;
  bool _obscure = true;
  late bool _loginMode;

  static const _states = ['الخرطوم','الجزيرة','القضارف','كسلا','البحر الأحمر','نهر النيل','الشمالية','النيل الأبيض','النيل الأزرق','سنار','شمال كردفان','جنوب كردفان','غرب كردفان','شمال دارفور','جنوب دارفور','غرب دارفور','وسط دارفور','شرق دارفور'];

  @override
  void initState() {
    super.initState();
    _loginMode = widget.loginMode;
  }

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    _name.dispose();
    _address.dispose();
    _age.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_loginMode && (!_privacy || !_terms)) {
      _showError('يجب الموافقة على سياسة الخصوصية وبنود الخدمة أولاً.');
      return;
    }
    setState(() => _busy = true);
    try {
      if (_loginMode) {
        await _auth.login(_phone.text, _password.text);
      } else {
        await _auth.register(
          name: _name.text,
          phone: _phone.text,
          password: _password.text,
          role: _driver ? 'driver' : 'customer',
          state: _state,
          address: _address.text,
          age: int.tryParse(_age.text),
          vehicleType: _driver ? _vehicle : null,
        );
        final uid = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'privacyAccepted': true,
          'termsAccepted': true,
          'privacyAcceptedAt': FieldValue.serverTimestamp(),
          'termsAcceptedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      if (mounted) _showError(legacy.cleanError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _google() async {
    setState(() => _busy = true);
    try {
      if (!_loginMode && (!_privacy || !_terms)) {
        _showError('يجب الموافقة على سياسة الخصوصية وبنود الخدمة أولاً.');
        return;
      }
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final result = await FirebaseAuth.instance.signInWithCredential(credential);
      final ref = FirebaseFirestore.instance.collection('users').doc(result.user!.uid);
      final snap = await ref.get();
      if (!snap.exists) {
        await ref.set({
          'role': 'customer',
          'name': googleUser.displayName ?? 'مستخدم عايز',
          'phone': googleUser.email ?? '',
          'address': '',
          'state': _state,
          'status': 'active',
          'privacyAccepted': true,
          'termsAccepted': true,
          'privacyAcceptedAt': FieldValue.serverTimestamp(),
          'termsAcceptedAt': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'lastActiveAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      if (mounted) _showError(legacy.cleanError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: kAyezBlack,
        appBar: AppBar(
          backgroundColor: kAyezBlack,
          foregroundColor: kAyezWhite,
          elevation: 0,
          title: const Text('عايز', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: kAyezBlack2, borderRadius: BorderRadius.circular(26), border: Border.all(color: const Color(0x14FFFFFF))),
                      child: Column(
                        children: [
                          Container(width: 82, height: 82, padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: kAyezYellow, borderRadius: BorderRadius.circular(24)), child: Image.asset('assets/branding/jawan-logo.png', fit: BoxFit.contain)),
                          const SizedBox(height: 14),
                          Text(_loginMode ? 'مرحباً بعودتك' : 'أنشئ حسابك في عايز', style: const TextStyle(color: kAyezWhite, fontSize: 25, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 5),
                          Text(_loginMode ? 'سجّل الدخول لمتابعة طلباتك وخدماتك.' : 'اختر نوع حسابك وأكمل بيانات التسجيل.', style: const TextStyle(color: kAyezGray, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (!_loginMode) ...[
                      _field(_name, 'الاسم الكامل', Icons.person_outline_rounded),
                      const SizedBox(height: 10),
                      _dropdown<String>(value: _state, label: 'الولاية', items: _states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) => setState(() => _state = v!)),
                      const SizedBox(height: 10),
                      _field(_address, 'مكان السكن', Icons.location_on_outlined),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        value: _driver,
                        onChanged: (v) => setState(() => _driver = v ?? false),
                        activeColor: kAyezYellow,
                        checkColor: Colors.black,
                        side: const BorderSide(color: Color(0x40FFFFFF)),
                        title: const Text('أريد التسجيل كسائق', style: TextStyle(color: kAyezWhite, fontWeight: FontWeight.w800)),
                        subtitle: const Text('سيكون الحساب بانتظار اعتماد الإدارة قبل استقبال الطلبات.', style: TextStyle(color: kAyezGrayDark, fontSize: 11)),
                        contentPadding: EdgeInsets.zero,
                      ),
                      if (_driver) ...[
                        const SizedBox(height: 6),
                        _field(_age, 'العمر', Icons.calendar_month_outlined, keyboard: TextInputType.number),
                        const SizedBox(height: 10),
                        _dropdown<String>(value: _vehicle, label: 'نوع المركبة', items: [...legacy.OrderService.passenger, ...legacy.OrderService.cargo].map((v) => DropdownMenuItem(value: v, child: Text(legacy.vehicleLabel(v)))).toList(), onChanged: (v) => setState(() => _vehicle = v!)),
                      ],
                      const SizedBox(height: 10),
                    ],
                    _field(_phone, 'رقم الهاتف', Icons.phone_outlined, keyboard: TextInputType.phone),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _password,
                      obscureText: _obscure,
                      style: const TextStyle(color: kAyezWhite),
                      decoration: _decoration('كلمة المرور', Icons.lock_outline_rounded).copyWith(suffixIcon: IconButton(onPressed: () => setState(() => _obscure = !_obscure), icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: kAyezGray))),
                    ),
                    if (!_loginMode) ...[
                      const SizedBox(height: 10),
                      _consentRow(
                        value: _privacy,
                        label: 'أوافق على سياسة الخصوصية',
                        onTap: () => _showLegal('سياسة الخصوصية', _privacyText),
                        onChanged: (v) => setState(() => _privacy = v ?? false),
                      ),
                      _consentRow(
                        value: _terms,
                        label: 'أوافق على بنود الخدمة',
                        onTap: () => _showLegal('بنود الخدمة', _termsText),
                        onChanged: (v) => setState(() => _terms = v ?? false),
                      ),
                    ],
                    const SizedBox(height: 14),
                    _PrimaryButton(label: _busy ? 'جارٍ التنفيذ...' : (_loginMode ? 'تسجيل الدخول' : 'إنشاء الحساب'), icon: Icons.arrow_forward_rounded, onPressed: _busy ? null : _submit),
                    const SizedBox(height: 10),
                    Row(children: [const Expanded(child: Divider(color: Color(0x18FFFFFF))), Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('أو', style: const TextStyle(color: kAyezGrayDark))), const Expanded(child: Divider(color: Color(0x18FFFFFF)))]),
                    const SizedBox(height: 10),
                    _OutlineButton(label: 'المتابعة باستخدام Google', icon: Icons.account_circle_outlined, onPressed: _busy ? null : _google),
                    const SizedBox(height: 12),
                    TextButton(onPressed: _busy ? null : () => setState(() => _loginMode = !_loginMode), child: Text(_loginMode ? 'ليس لديك حساب؟ إنشاء حساب جديد' : 'لديك حساب بالفعل؟ تسجيل الدخول', style: const TextStyle(color: kAyezYellow, fontWeight: FontWeight.w800))),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _field(TextEditingController controller, String label, IconData icon, {TextInputType? keyboard}) => TextField(controller: controller, keyboardType: keyboard, style: const TextStyle(color: kAyezWhite), decoration: _decoration(label, icon));

  Widget _dropdown<T>({required T value, required String label, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged}) => DropdownButtonFormField<T>(value: value, items: items, onChanged: onChanged, dropdownColor: kAyezBlack2, style: const TextStyle(color: kAyezWhite), decoration: _decoration(label, Icons.keyboard_arrow_down_rounded));

  InputDecoration _decoration(String label, IconData icon) => InputDecoration(labelText: label, labelStyle: const TextStyle(color: kAyezGrayDark), prefixIcon: Icon(icon, color: kAyezYellow), filled: true, fillColor: kAyezBlack2, enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: const BorderSide(color: Color(0x16FFFFFF))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: const BorderSide(color: kAyezYellow, width: 1.2)));

  Widget _consentRow({required bool value, required String label, required VoidCallback onTap, required ValueChanged<bool?> onChanged}) => Row(children: [Checkbox(value: value, onChanged: onChanged, activeColor: kAyezYellow, checkColor: Colors.black, side: const BorderSide(color: Color(0x40FFFFFF))), Expanded(child: InkWell(onTap: onTap, child: Text(label, style: const TextStyle(color: kAyezWhite, fontSize: 12, decoration: TextDecoration.underline)))), const SizedBox(width: 10)]);

  Future<void> _showLegal(String title, String body) async {
    await showModalBottomSheet<void>(context: context, backgroundColor: kAyezBlack2, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))), builder: (_) => SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [Row(children: [Expanded(child: Text(title, textAlign: TextAlign.right, style: const TextStyle(color: kAyezWhite, fontSize: 20, fontWeight: FontWeight.w900))), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: kAyezWhite))]), const Divider(color: Color(0x16FFFFFF)), Flexible(child: SingleChildScrollView(child: Text(body, textAlign: TextAlign.right, style: const TextStyle(color: kAyezGray, height: 1.8, fontSize: 13))))])));
  }

  static const _privacyText = 'نحترم خصوصيتك. تستخدم عايز بيانات الحساب والطلب والتواصل فقط لتقديم الخدمة وتحسينها وتشغيل ميزات الأمان والدعم. لا نطلب منك كلمات المرور ولا نعرضها لأي شخص. قد تُحفظ بيانات الطلبات وسجلات النشاط وفق متطلبات تشغيل المنصة وأمنها.';
  static const _termsText = 'باستخدام عايز فإنك توافق على تقديم بيانات صحيحة، والمحافظة على بيانات الدخول، واستخدام المنصة في الأغراض المشروعة. تخضع الخدمات المتاحة للتوفر والقواعد التشغيلية واعتماد الإدارة عندما يلزم، ويجب الالتزام بقواعد السلامة والتعامل المحترم بين العملاء والسائقين.';
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  const _PrimaryButton({required this.label, required this.icon, required this.onPressed});
  @override
  Widget build(BuildContext context) => SizedBox(height: 54, child: ElevatedButton.icon(onPressed: onPressed, icon: Icon(icon, color: Colors.black), label: Text(label), style: ElevatedButton.styleFrom(backgroundColor: kAyezYellow, foregroundColor: Colors.black, disabledBackgroundColor: const Color(0x55F5C400), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), textStyle: const TextStyle(fontWeight: FontWeight.w900))));
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  const _OutlineButton({required this.label, required this.icon, required this.onPressed});
  @override
  Widget build(BuildContext context) => SizedBox(height: 54, child: OutlinedButton.icon(onPressed: onPressed, icon: Icon(icon, color: kAyezYellow), label: Text(label, style: const TextStyle(color: kAyezWhite)), style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0x35F5C400)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), textStyle: const TextStyle(fontWeight: FontWeight.w800))));
}

class _AyezLoading extends StatelessWidget {
  const _AyezLoading();
  @override
  Widget build(BuildContext context) => const Scaffold(backgroundColor: kAyezBlack, body: Center(child: CircularProgressIndicator(color: kAyezYellow, strokeWidth: 3)));
}

Route<T> _fadeRoute<T>(Widget page) => PageRouteBuilder<T>(pageBuilder: (_, __, ___) => page, transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child), transitionDuration: const Duration(milliseconds: 220));
