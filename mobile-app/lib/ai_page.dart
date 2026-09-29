import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';

class AyezAiPage extends StatefulWidget {
  const AyezAiPage({super.key});
  @override State<AyezAiPage> createState() => _AyezAiPageState();
}

class _AiLine {
  const _AiLine(this.text, this.user);
  final String text;
  final bool user;
}

class _AyezAiPageState extends State<AyezAiPage> {
  final input = TextEditingController();
  final scroll = ScrollController();
  final messages = <_AiLine>[];
  ChatSession? chat;
  bool busy = false;

  static const systemPrompt = '''
أنت AI JWAN داخل منصة عايز للتوصيل والنقل في السودان.
ساعد المستخدم في إنشاء الطلبات، اختيار المركبة، متابعة الطلب، قبول الطلب، التفاوض على السعر، المحفظة، الشحن، الحساب، الدعم والإلغاء.
تحدث بالعربية بأسلوب بسيط وودود وواضح.
لا تخترع أسعارًا أو رسومًا أو سياسات.
لا تطلب كلمات المرور أو رموز OTP أو بيانات الدفع السرية.
إذا كان السؤال خارج نطاق عايز، وضح ذلك ثم وجّه المستخدم إلى الدعم.
''';

  Future<void> ensureChat() async {
    if (chat != null) return;
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.8-flash',
      systemInstruction: Content.system(systemPrompt),
    );
    chat = model.startChat(maxTurns: 30);
  }

  Future<void> send() async {
    final text = input.text.trim();
    if (text.isEmpty || busy) return;
    input.clear();
    setState(() { messages.add(_AiLine(text, true)); busy = true; });
    _scrollBottom();
    try {
      await ensureChat();
      final response = await chat!.sendMessage(Content.text(text));
      final answer = response.text?.trim();
      if (answer == null || answer.isEmpty) throw StateError('لم يصل رد من المساعد.');
      if (!mounted) return;
      setState(() => messages.add(_AiLine(answer, false)));
    } catch (e) {
      if (!mounted) return;
      setState(() => messages.add(_AiLine('تعذر تشغيل مساعد عايز حاليًا.\n\n' + e.toString(), false)));
    } finally {
      if (mounted) setState(() => busy = false);
      _scrollBottom();
    }
  }

  void _scrollBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scroll.hasClients) return;
      scroll.animateTo(scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 220), curve: Curves.easeOut);
    });
  }

  @override void dispose() { input.dispose(); scroll.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('مساعد عايز'), backgroundColor: const Color(0xFF0A0A0A), foregroundColor: Colors.white),
    body: Column(children: [
      Expanded(
        child: messages.isEmpty
            ? const Center(child: Padding(padding: EdgeInsets.all(30), child: Text('أهلاً بك في مساعد عايز. اسأل عن الطلبات، التفاوض، المحفظة أو الدعم.', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, height: 1.7))))
            : ListView.builder(
                controller: scroll,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final item = messages[index];
                  return Align(
                    alignment: item.user ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 430),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: item.user ? const Color(0xFF151515) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x15000000)),
                      ),
                      child: Text(item.text, style: TextStyle(color: item.user ? Colors.white : Colors.black87, height: 1.6)),
                    ),
                  );
                },
              ),
      ),
      SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(children: [
            Expanded(child: TextField(controller: input, maxLength: 1000, onSubmitted: (_) => send(), decoration: const InputDecoration(labelText: 'اكتب سؤالك هنا'))),
            const SizedBox(width: 8),
            IconButton.filled(onPressed: busy ? null : send, icon: const Icon(Icons.send_rounded)),
          ]),
        ),
      ),
    ]),
  );
}