import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart' as legacy;

const kAyezBlack = Color(0xFF080808);
const kAyezBlack2 = Color(0xFF111111);
const kAyezBlack3 = Color(0xFF1A1A1A);
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingPage();
        }
        return snapshot.hasData ? const legacy.AuthGate() : const AyezWelcomePage();
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
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _BrandHeader()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _HeroCard(),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(child: _PrimaryButton(label: 'تسجيل الدخول', icon: Icons.login_rounded, onPressed: () => _openAuth(context, true))),
                        const SizedBox(width: 10),
                        Expanded(child: _SecondaryButton(label: 'إنشاء حساب', icon: Icons.person_add_alt_1_rounded, onPressed: () => _openAuth(context, false))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const _AboutCard(),
                    const SizedBox(height: 20),
                    const Text('لماذا عايز؟', textAlign: TextAlign.right, style: TextStyle(color: kAyezWhite, fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    const _FeatureCard(icon: Icons.speed_rounded, title: 'سهل وسريع', text: 'اطلب الخدمة وتابع حالة الطلب من مكان واحد.'),
                    const _FeatureCard(icon: Icons.local_shipping_outlined, title: 'خدمات متعددة', text: 'نقل ركاب وبضائع بمركبات مختلفة حسب الحاجة.'),
                    const _FeatureCard(icon: Icons.support_agent_rounded, title: 'دعم مباشر', text: 'تواصل مع الدعم عند الحاجة دون تعقيد.'),
                    const SizedBox(height: 12),
                    const Text('باستخدامك عايز أنت جزء من منصة سودانية تهدف لتسهيل النقل والتوصيل.', textAlign: TextAlign.center, style: TextStyle(color: kAyezGrayDark, fontSize: 11, height: 1.6)),
                    const SizedBox(height: 10),
                    Text('© ${DateTime.now().year} عايز', textAlign: TextAlign.center, style: const TextStyle(color: kAyezGrayDark, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _openAuth(BuildContext context, bool login) {
    Navigator.of(context).push(_fadeRoute(AyezAuthPage(loginMode: login)));
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: kAyezYellow, borderRadius: BorderRadius.circular(15)),
            child: Image.asset('assets/branding/jawan-logo.png', fit: BoxFit.contain),
          ),
          const Spacer(),
          const Text('عايز', style: TextStyle(color: kAyezWhite, fontSize: 20, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kAyezBlack2,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0x16FFFFFF)),
        boxShadow: const [BoxShadow(color: Color(0x35000000), blurRadius: 35, offset: Offset(0, 15))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 150,
              height: 150,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x0EF5C400),
                border: Border.all(color: const Color(0x45F5C400)),
              ),
              child: Image.asset('assets/branding/jawan-logo.png', fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 18),
          const Text('توصيلك يبدأ من هنا', textAlign: TextAlign.right, style: TextStyle(color: kAyezYellow, fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          const Text('عايز', textAlign: TextAlign.right, style: TextStyle(color: kAyezWhite, fontSize: 48, height: .95, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('منصة سودانية للتوصيل والنقل تساعدك تطلب، تتابع، وتتواصل بسهولة.', textAlign: TextAlign.right, style: TextStyle(color: kAyezGray, fontSize: 15, height: 1.8)),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: kAyezBlack2, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0x12FFFFFF))),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('من نحن؟', textAlign: TextAlign.right, style: TextStyle(color: kAyezWhite, fontSize: 23, fontWeight: FontWeight.w900)),
          SizedBox(height: 8),
          Text('عايز منصة محلية صُممت لتسهيل التوصيل والنقل وربط العميل بالسائق بطريقة واضحة وعملية، مع متابعة الطلب ودعم المستخدم في كل خطوة.', textAlign: TextAlign.right, style: TextStyle(color: kAyezGray, fontSize: 14, height: 1.8)),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const _FeatureCard({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: kAyezBlack2, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0x10FFFFFF))),
      child: Row(
        children: [
          Container(width: 46, height: 46, decoration: BoxDecoration(color: const Color(0x12F5C400), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: kAyezYellow)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text(title, textAlign: TextAlign.right, style: const TextStyle(color: kAyezWhite, fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(text, textAlign: TextAlign.right, style: const TextStyle(color: kAyezGrayDark, fontSize: 12, height: 1.5))])),
        ],
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
        await _auth.login(_phone.text.trim(), _password.text);
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
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'privacyAccepted': true,
            'termsAccepted': true,
            'privacyAcceptedAt': FieldValue.serverTimestamp(),
            'termsAcceptedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }
    } catch (e) {
      if (mounted) _showError(legacy.cleanError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    if (!_loginMode && (!_privacy || !_terms)) {
      _showError('يجب الموافقة على سياسة الخصوصية وبنود الخدمة أولاً.');
      return;
    }
    setState(() => _busy = true);
    try {
      final googleUser = await GoogleSignIn(scopes: const ['email']).signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await FirebaseAuth.instance.signInWithCredential(credential);
      final ref = FirebaseFirestore.instance.collection('users').doc(result.user!.uid);
      final snap = await ref.get();
      if (!snap.exists) {
        await ref.set({
          'role': 'customer',
          'name': googleUser.displayName ?? 'مستخدم عايز',
          'phone': '',
          'email': googleUser.email,
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
      } else {
        await ref.set({'lastActiveAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
      }
    } catch (e) {
      if (mounted) _showError(_googleError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _googleError(Object error) {
    if (error is FirebaseException && error.code == 'account-exists-with-different-credential') {
      return 'هذا البريد مرتبط بطريقة دخول أخرى. استخدم طريقة الدخول المسجلة للحساب.';
    }
    return legacy.cleanError(error);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAyezBlack,
      appBar: AppBar(
        backgroundColor: kAyezBlack,
        foregroundColor: kAyezWhite,
        title: const Text('عايز', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AuthModeSwitch(loginMode: _loginMode, onLogin: () => setState(() => _loginMode = true), onRegister: () => setState(() => _loginMode = false)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: kAyezBlack2, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0x14FFFFFF))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(child: Container(width: 70, height: 70, padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: kAyezYellow, borderRadius: BorderRadius.circular(20)), child: Image.asset('assets/branding/jawan-logo.png', fit: BoxFit.contain))),
                        const SizedBox(height: 12),
                        Text(_loginMode ? 'مرحباً بعودتك' : 'أنشئ حسابك في عايز', textAlign: TextAlign.center, style: const TextStyle(color: kAyezWhite, fontSize: 25, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(_loginMode ? 'أدخل رقم الهاتف وكلمة المرور للمتابعة.' : 'أكمل بياناتك ثم اختر نوع الحساب.', textAlign: TextAlign.center, style: const TextStyle(color: kAyezGray, fontSize: 13)),
                        const SizedBox(height: 18),
                        if (!_loginMode) ...[
                          _field(_name, 'الاسم الكامل', Icons.person_outline_rounded),
                          const SizedBox(height: 10),
                          _dropdown<String>(value: _state, label: 'الولاية', items: _states.map((s) => DropdownMenuItem<String>(value: s, child: Text(s))).toList(), onChanged: (v) => setState(() => _state = v ?? _state)),
                          const SizedBox(height: 10),
                          _field(_address, 'مكان السكن', Icons.location_on_outlined),
                          const SizedBox(height: 8),
                          CheckboxListTile(
                            value: _driver,
                            onChanged: _busy ? null : (v) => setState(() => _driver = v ?? false),
                            activeColor: kAyezYellow,
                            checkColor: Colors.black,
                            side: const BorderSide(color: Color(0x45FFFFFF)),
                            contentPadding: EdgeInsets.zero,
                            title: const Text('أريد التسجيل كسائق', style: TextStyle(color: kAyezWhite, fontWeight: FontWeight.w800)),
                            subtitle: const Text('سيحتاج الحساب إلى اعتماد الإدارة قبل استقبال الطلبات.', style: TextStyle(color: kAyezGrayDark, fontSize: 11)),
                          ),
                          if (_driver) ...[
                            const SizedBox(height: 4),
                            _field(_age, 'العمر', Icons.calendar_month_outlined, keyboard: TextInputType.number),
                            const SizedBox(height: 10),
                            _dropdown<String>(value: _vehicle, label: 'نوع المركبة', items: [...legacy.OrderService.passenger, ...legacy.OrderService.cargo].map((v) => DropdownMenuItem<String>(value: v, child: Text(legacy.vehicleLabel(v)))).toList(), onChanged: (v) => setState(() => _vehicle = v ?? _vehicle)),
                          ],
                          const SizedBox(height: 8),
                        ],
                        _field(_phone, 'رقم الهاتف', Icons.phone_outlined, keyboard: TextInputType.phone),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _password,
                          obscureText: _obscure,
                          enabled: !_busy,
                          style: const TextStyle(color: kAyezWhite),
                          decoration: _inputDecoration('كلمة المرور', Icons.lock_outline_rounded).copyWith(
                            suffixIcon: IconButton(onPressed: () => setState(() => _obscure = !_obscure), icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: kAyezGray)),
                          ),
                        ),
                        if (!_loginMode) ...[
                          const SizedBox(height: 10),
                          _ConsentRow(label: 'أوافق على سياسة الخصوصية', value: _privacy, onChanged: (v) => setState(() => _privacy = v), onOpen: () => _showLegal('سياسة الخصوصية', _privacyText)),
                          _ConsentRow(label: 'أوافق على بنود الخدمة', value: _terms, onChanged: (v) => setState(() => _terms = v), onOpen: () => _showLegal('بنود الخدمة', _termsText)),
                        ],
                        const SizedBox(height: 14),
                        _PrimaryButton(label: _busy ? 'جارٍ التنفيذ...' : (_loginMode ? 'تسجيل الدخول' : 'إنشاء الحساب'), icon: _loginMode ? Icons.login_rounded : Icons.person_add_alt_1_rounded, onPressed: _busy ? null : _submit),
                        const SizedBox(height: 10),
                        Row(children: const [Expanded(child: Divider(color: Color(0x18FFFFFF))), Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('أو', style: TextStyle(color: kAyezGrayDark))), Expanded(child: Divider(color: Color(0x18FFFFFF)))]),
                        const SizedBox(height: 10),
                        _SecondaryButton(label: 'المتابعة باستخدام Google', icon: Icons.account_circle_outlined, onPressed: _busy ? null : _signInWithGoogle),
                        const SizedBox(height: 12),
                        TextButton(onPressed: _busy ? null : () => setState(() => _loginMode = !_loginMode), child: Text(_loginMode ? 'ليس لديك حساب؟ إنشاء حساب جديد' : 'لديك حساب بالفعل؟ تسجيل الدخول', style: const TextStyle(color: kAyezYellow, fontWeight: FontWeight.w800))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label, IconData icon, {TextInputType? keyboard}) {
    return TextField(controller: controller, enabled: !_busy, keyboardType: keyboard, style: const TextStyle(color: kAyezWhite), decoration: _inputDecoration(label, icon));
  }

  Widget _dropdown<T>({required T value, required String label, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged}) {
    return DropdownButtonFormField<T>(initialValue: value, items: items, onChanged: _busy ? null : onChanged, dropdownColor: kAyezBlack2, style: const TextStyle(color: kAyezWhite), decoration: _inputDecoration(label, Icons.keyboard_arrow_down_rounded));
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: kAyezGrayDark),
      prefixIcon: Icon(icon, color: kAyezYellow),
      filled: true,
      fillColor: kAyezBlack3,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: const BorderSide(color: Color(0x16FFFFFF))),
      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: const BorderSide(color: Color(0x10FFFFFF))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: const BorderSide(color: kAyezYellow, width: 1.2)),
    );
  }

  Future<void> _showLegal(String title, String body) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: kAyezBlack2,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (sheetContext) {
        final height = MediaQuery.sizeOf(sheetContext).height * .78;
        return SafeArea(
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [Expanded(child: Text(title, textAlign: TextAlign.right, style: const TextStyle(color: kAyezWhite, fontSize: 20, fontWeight: FontWeight.w900))), IconButton(onPressed: () => Navigator.pop(sheetContext), icon: const Icon(Icons.close, color: kAyezWhite))]),
                  const Divider(color: Color(0x16FFFFFF)),
                  Expanded(child: SingleChildScrollView(child: Text(body, textAlign: TextAlign.right, style: const TextStyle(color: kAyezGray, height: 1.9, fontSize: 13)))),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static const _privacyText = 'نحترم خصوصيتك. تستخدم عايز بيانات الحساب والطلب والتواصل فقط لتقديم الخدمة وتشغيل ميزات الأمان والدعم وتحسين التجربة. قد تُحفظ بيانات الطلبات وسجلات النشاط وفق متطلبات التشغيل والأمن والقانون. لا نطلب كلمات مرورك ولا نعرضها للمستخدمين الآخرين.';
  static const _termsText = 'باستخدام عايز فإنك توافق على تقديم بيانات صحيحة، والمحافظة على بيانات الدخول، واستخدام المنصة في الأغراض المشروعة. الخدمات متاحة وفق الحالة التشغيلية وقواعد المنصة، وقد تحتاج بعض الحسابات إلى اعتماد الإدارة. يلتزم العملاء والسائقون بقواعد السلامة والاحترام وعدم إساءة استخدام الخدمة.';
}

class _AuthModeSwitch extends StatelessWidget {
  final bool loginMode;
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  const _AuthModeSwitch({required this.loginMode, required this.onLogin, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: kAyezBlack2, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0x14FFFFFF))),
      child: Row(
        children: [
          Expanded(child: _ModeButton(active: loginMode, label: 'دخول', onPressed: onLogin)),
          Expanded(child: _ModeButton(active: !loginMode, label: 'حساب جديد', onPressed: onRegister)),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final bool active;
  final String label;
  final VoidCallback onPressed;
  const _ModeButton({required this.active, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(backgroundColor: active ? kAyezYellow : Colors.transparent, foregroundColor: active ? Colors.black : kAyezWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class _ConsentRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onOpen;
  const _ConsentRow({required this.label, required this.value, required this.onChanged, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: (v) => onChanged(v ?? false), activeColor: kAyezYellow, checkColor: Colors.black, side: const BorderSide(color: Color(0x45FFFFFF))),
        Expanded(child: InkWell(onTap: onOpen, child: Text(label, style: const TextStyle(color: kAyezWhite, fontSize: 12, decoration: TextDecoration.underline)))),
      ],
    );
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage();
  @override
  Widget build(BuildContext context) => const Scaffold(backgroundColor: kAyezBlack, body: Center(child: CircularProgressIndicator(color: kAyezYellow)));
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  const _PrimaryButton({required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black),
        label: Text(label),
        style: ElevatedButton.styleFrom(backgroundColor: kAyezYellow, foregroundColor: Colors.black, disabledBackgroundColor: const Color(0x55F5C400), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), textStyle: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  const _SecondaryButton({required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: kAyezYellow),
        label: Text(label, style: const TextStyle(color: kAyezWhite)),
        style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0x35F5C400)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), textStyle: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }
}

Route<T> _fadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
    transitionDuration: const Duration(milliseconds: 220),
  );
}
