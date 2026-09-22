import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

const adminBlack = Color(0xFF0A0A0A);
const adminYellow = Color(0xFFF5C400);

class AyezAdminCenterPage extends StatelessWidget {
  const AyezAdminCenterPage({super.key, required this.profile, this.initialSection = 0});
  final Map<String, dynamic> profile;
  final int initialSection;

  @override
  Widget build(BuildContext context) {
    final hasManagers = profile['role'] == 'super_admin';
    final tabCount = hasManagers ? 6 : 5;
    final tabs = <Tab>[const Tab(text: 'الملخص'), const Tab(text: 'الطلبات'), const Tab(text: 'المستخدمون'), const Tab(text: 'الماليات'), const Tab(text: 'الدعم')];
    final views = <Widget>[const _AdminSummary(), const _AdminOrders(), _AdminUsers(superAdmin: hasManagers), const _AdminFinance(), const _AdminSupport()];
    if (hasManagers) { tabs.add(const Tab(text: 'المدراء')); views.add(const _AdminManagers()); }
    return DefaultTabController(
      length: tabCount,
      initialIndex: initialSection.clamp(0, tabCount - 1),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة عايز', style: TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: adminBlack,
          foregroundColor: Colors.white,
          bottom: TabBar(tabs: tabs),
          actions: [IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout))],
        ),
        body: TabBarView(children: views),
      ),
    );
  }
}

class _AdminSummary extends StatelessWidget {
  const _AdminSummary();
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    _count('الطلبات', FirebaseFirestore.instance.collection('orders').limit(200).snapshots()),
    _count('السائقون', FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'driver').limit(300).snapshots()),
    _count('العملاء', FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'customer').limit(300).snapshots()),
    const SizedBox(height: 12),
    const Card(child: ListTile(leading: Icon(Icons.percent), title: Text('عمولة النظام'), trailing: Text('5%'))),
    const Card(child: ListTile(leading: Icon(Icons.warning_amber_outlined), title: Text('غرامة إلغاء السائق بعد الاتفاق'), trailing: Text('10%'))),
  ]);
  Widget _count(String title, Stream<QuerySnapshot<Map<String,dynamic>>> stream) => StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream: stream,builder:(_,s)=>Card(child:ListTile(title:Text(title),trailing:Text('${s.data?.docs.length??0}',style:const TextStyle(fontSize:20,fontWeight:FontWeight.w900)))));
}

class _AdminOrders extends StatelessWidget {
  const _AdminOrders();
  @override Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
    stream: FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).limit(200).snapshots(),
    builder: (_, snap) {
      if (snap.hasError) return Center(child: Text('${snap.error}'));
      final docs=snap.data?.docs??const[];
      return ListView.builder(padding:const EdgeInsets.all(12),itemCount:docs.length,itemBuilder:(_,i){final d=docs[i];final o=d.data();final status='${o['status']??''}';return Card(child:ListTile(title:Text('#${d.id.substring(0,d.id.length>8?8:d.id.length)}'),subtitle:Text('${o['origin']??'-'} ← ${o['destination']??'-'}\n$status'),isThreeLine:true,trailing:(status=='pending'||status=='accepted')?IconButton(onPressed:()=>_cancel(context,d.id),icon:const Icon(Icons.cancel_outlined)):null));});
    },
  );
  static Future<void> _cancel(BuildContext context,String id) async {
    try { await FirebaseFirestore.instance.collection('orders').doc(id).update({'status':'cancelled','cancelledAt':FieldValue.serverTimestamp(),'cancelReason':'إلغاء بواسطة الإدارة'}); if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تم إلغاء الطلب'))); } catch(e) { if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('$e'))); }
  }
}

class _AdminUsers extends StatefulWidget {
  const _AdminUsers({this.superAdmin = false});
  final bool superAdmin;
  @override State<_AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<_AdminUsers> {
  bool drivers = true;

  @override
  Widget build(BuildContext context) {
    final role = drivers ? 'driver' : 'customer';
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text('السائقون')),
            ButtonSegment(value: false, label: Text('العملاء')),
          ],
          selected: {drivers},
          onSelectionChanged: (set) => setState(() => drivers = set.first),
        ),
      ),
      Expanded(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: role).limit(300).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Center(child: Text(snapshot.error.toString()));
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            final docs = snapshot.data?.docs ?? const [];
            if (docs.isEmpty) return const Center(child: Text('لا توجد حسابات.'));
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final doc = docs[index];
                final user = doc.data();
                final status = user['status']?.toString() ?? '';
                final isSelf = doc.id == FirebaseAuth.instance.currentUser?.uid;
                return Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(user['name']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                      const SizedBox(height: 4),
                      Text((user['phone']?.toString() ?? '-') + ' • ' + (user['state']?.toString() ?? '-') + ' • ' + status),
                      if (role == 'driver') Text('المركبة: ' + (user['vehicleType']?.toString() ?? '-')),
                      const SizedBox(height: 8),
                      Wrap(spacing: 6, runSpacing: 6, children: [
                        if (status != 'active') _action('تفعيل', () => _approve(context, doc.id, user)),
                        if (status != 'suspended') _action('إيقاف', () => _setStatus(context, doc.id, 'suspended')),
                        if (status != 'rejected') _action('رفض', () => _setStatus(context, doc.id, 'rejected')),
                        if (role == 'customer' || role == 'driver') _action('طلب تغيير كلمة المرور', () => _requestPasswordChange(context, doc.id)),
                        if (widget.superAdmin && !isSelf && user['role'] != 'super_admin') _action('حذف', () => _delete(context, doc.id), danger: true),
                      ]),
                    ]),
                  ),
                );
              },
            );
          },
        ),
      ),
    ]);
  }

  static Future<void> _setStatus(BuildContext context, String id, String status) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).update({'status': status});
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث الحالة')));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static Future<void> _approve(BuildContext context, String id, Map<String,dynamic> user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).update({'status':'active'});
      if (user['role'] == 'driver') {
        final wallet = FirebaseFirestore.instance.collection('wallets').doc(id);
        final snap = await wallet.get();
        if (!snap.exists) await wallet.set({'balance':10000,'totalCommission':0,'totalCancellationPenalties':0,'totalTopups':0,'totalWithdrawals':0,'updatedAt':FieldValue.serverTimestamp()});
      }
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم التفعيل')));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static Future<void> _requestPasswordChange(BuildContext context, String id) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(id).update({'mustChangePassword':true,'passwordChangeRequestedAt':FieldValue.serverTimestamp(),'passwordChangeRequestedBy':uid});
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم طلب تغيير كلمة المرور')));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static Future<void> _delete(BuildContext context, String id) async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text('حذف الحساب'),
      content: const Text('سيتم حذف ملف الحساب ومحفظته من Firestore. سجلات الطلبات لا تُحذف.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف')),
      ],
    ));
    if (ok != true) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).delete();
      await FirebaseFirestore.instance.collection('wallets').doc(id).delete().catchError((_) {});
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف ملف الحساب')));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
class _AdminFinance extends StatelessWidget {
  const _AdminFinance();
  @override Widget build(BuildContext context)=>DefaultTabController(length:2,child:Column(children:[const TabBar(tabs:[Tab(text:'الشحن'),Tab(text:'السحب')]),Expanded(child:TabBarView(children:[_topups(),_withdrawals()]))]));
  Widget _topups()=>StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseFirestore.instance.collection('topupRequests').orderBy('submittedAt',descending:true).limit(200).snapshots(),builder:(_,s){final docs=s.data?.docs??const[];return ListView.builder(itemCount:docs.length,itemBuilder:(_,i){final d=docs[i];final x=d.data();final st='${x['status']??''}';return ListTile(title:Text('${x['amount']??0} ج.س'),subtitle:Text('${x['driverId']??'-'} • ${x['paymentMethod']??'-'} • $st'),trailing:st=='pending'?Row(mainAxisSize:MainAxisSize.min,children:[IconButton(onPressed:()=>_reviewTopup(context,d.id,true),icon:const Icon(Icons.check)),IconButton(onPressed:()=>_reviewTopup(context,d.id,false),icon:const Icon(Icons.close))]):null);});});
  Widget _withdrawals()=>StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseFirestore.instance.collection('withdrawalRequests').orderBy('createdAt',descending:true).limit(200).snapshots(),builder:(_,s){final docs=s.data?.docs??const[];return ListView.builder(itemCount:docs.length,itemBuilder:(_,i){final d=docs[i];final x=d.data();final st='${x['status']??''}';return ListTile(title:Text('${x['amount']??0} ج.س'),subtitle:Text('${x['driverId']??'-'} • ${x['paymentMethod']??'-'} • $st'),trailing:st=='pending'?Row(mainAxisSize:MainAxisSize.min,children:[IconButton(onPressed:()=>_reviewWithdrawal(context,d.id,'paid'),icon:const Icon(Icons.paid)),IconButton(onPressed:()=>_reviewWithdrawal(context,d.id,'rejected'),icon:const Icon(Icons.close))]):null);});});
  static Future<void> _reviewTopup(BuildContext c,String id,bool approve) async { final admin=FirebaseAuth.instance.currentUser!.uid; try{await FirebaseFirestore.instance.runTransaction((tx)async{final rr=FirebaseFirestore.instance.collection('topupRequests').doc(id);final rs=await tx.get(rr);if(!rs.exists)throw StateError('طلب الشحن غير موجود');final r=rs.data()!;if(r['status']!='pending')throw StateError('تمت المراجعة');tx.update(rr,{'status':approve?'approved':'rejected','reviewedAt':FieldValue.serverTimestamp(),'reviewedBy':admin});if(!approve)return;final wid=r['driverId'];final amount=(r['amount']as num?)?.toDouble()??0;final wr=FirebaseFirestore.instance.collection('wallets').doc(wid);final ws=await tx.get(wr);if(!ws.exists)throw StateError('المحفظة غير موجودة');final w=ws.data()!;final before=(w['balance']as num?)?.toDouble()??0;final tr=FirebaseFirestore.instance.collection('walletTransactions').doc();tx.update(wr,{'balance':before+amount,'totalTopups':((w['totalTopups']as num?)?.toDouble()??0)+amount,'updatedAt':FieldValue.serverTimestamp(),'lastTopupRequestId':id});tx.set(tr,{'userId':wid,'type':'topup','amount':amount,'balanceBefore':before,'balanceAfter':before+amount,'orderId':null,'topupRequestId':id,'withdrawalRequestId':null,'createdAt':FieldValue.serverTimestamp(),'createdBy':admin});});if(c.mounted)ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('تمت مراجعة الشحن')));}catch(e){if(c.mounted)ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text('$e')));}}
  static Future<void> _reviewWithdrawal(BuildContext c,String id,String status) async { final admin=FirebaseAuth.instance.currentUser!.uid; try{await FirebaseFirestore.instance.runTransaction((tx)async{final rr=FirebaseFirestore.instance.collection('withdrawalRequests').doc(id);final rs=await tx.get(rr);if(!rs.exists)throw StateError('طلب السحب غير موجود');final r=rs.data()!;if(r['status']!='pending')throw StateError('تمت المراجعة');tx.update(rr,{'status':status,'reviewedAt':FieldValue.serverTimestamp(),'reviewedBy':admin});if(status!='paid')return;final wid=r['driverId'];final amount=(r['amount']as num?)?.toDouble()??0;final wr=FirebaseFirestore.instance.collection('wallets').doc(wid);final ws=await tx.get(wr);if(!ws.exists)throw StateError('المحفظة غير موجودة');final w=ws.data()!;final before=(w['balance']as num?)?.toDouble()??0;if(before<amount)throw StateError('الرصيد غير كافٍ');final tr=FirebaseFirestore.instance.collection('walletTransactions').doc();tx.update(wr,{'balance':before-amount,'totalWithdrawals':((w['totalWithdrawals']as num?)?.toDouble()??0)+amount,'updatedAt':FieldValue.serverTimestamp(),'lastWithdrawalRequestId':id});tx.set(tr,{'userId':wid,'type':'withdrawal','amount':-amount,'balanceBefore':before,'balanceAfter':before-amount,'orderId':null,'topupRequestId':null,'withdrawalRequestId':id,'createdAt':FieldValue.serverTimestamp(),'createdBy':admin});});if(c.mounted)ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('تمت مراجعة السحب')));}catch(e){if(c.mounted)ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text('$e')));}}
}

class _AdminSupport extends StatelessWidget {
  const _AdminSupport();
  @override Widget build(BuildContext context)=>StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseFirestore.instance.collection('supportMessages').orderBy('createdAt',descending:true).limit(200).snapshots(),builder:(_,s){final docs=s.data?.docs??const[];return ListView.builder(padding:const EdgeInsets.all(12),itemCount:docs.length,itemBuilder:(_,i){final d=docs[i];final x=d.data();final reply='${x['reply']??''}'.trim();return Card(child:ListTile(title:Text('${x['message']??''}',maxLines:3,overflow:TextOverflow.ellipsis),subtitle:Text(reply.isEmpty?'بانتظار الرد':'الرد: $reply'),trailing:reply.isEmpty?IconButton(onPressed:()=>_reply(context,d.id),icon:const Icon(Icons.reply)):null));});};
  static Future<void> _reply(BuildContext c,String id)async{final ctl=TextEditingController();final ok=await showDialog<bool>(context:c,builder:(_)=>AlertDialog(title:const Text('الرد'),content:TextField(controller:ctl,maxLines:5,maxLength:3000),actions:[TextButton(onPressed:()=>Navigator.pop(c,false),child:const Text('إلغاء')),FilledButton(onPressed:()=>Navigator.pop(c,true),child:const Text('إرسال'))]));if(ok==true){try{await FirebaseFirestore.instance.collection('supportMessages').doc(id).update({'reply':ctl.text.trim(),'status':'answered','repliedAt':FieldValue.serverTimestamp(),'repliedBy':FirebaseAuth.instance.currentUser!.uid});if(c.mounted)ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('تم إرسال الرد')));}catch(e){if(c.mounted)ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text('$e')));}}ctl.dispose();}
}
class _AdminManagers extends StatelessWidget {
  const _AdminManagers();
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(12),
    children: [
      FilledButton.icon(onPressed: () => _createManager(context), icon: const Icon(Icons.person_add), label: const Text('إنشاء مدير')),
      const SizedBox(height: 10),
      StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').where('role', whereIn: ['admin','super_admin']).snapshots(),
        builder: (_, snap) {
          if (snap.hasError) return Text(snap.error.toString());
          final docs = snap.data?.docs ?? const [];
          return Column(children: [
            for (final d in docs) Card(child: ListTile(
              title: Text(d.data()['name']?.toString() ?? '-'),
              subtitle: Text((d.data()['phone']?.toString() ?? '-') + ' • ' + (d.data()['role']?.toString() ?? '-') + ' • ' + (d.data()['status']?.toString() ?? '-')),
              trailing: d.id == FirebaseAuth.instance.currentUser!.uid ? const Chip(label: Text('أنت')) : PopupMenuButton<String>(
                onSelected: (v) => _setManager(context, d.id, v),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'active', child: Text('تفعيل')),
                  PopupMenuItem(value: 'suspended', child: Text('إيقاف')),
                  PopupMenuItem(value: 'admin', child: Text('Admin')),
                  PopupMenuItem(value: 'super_admin', child: Text('Super Admin')),
                ],
              ),
            )),
          ]);
        },
      ),
    ],
  );

  static Future<void> _setManager(BuildContext context, String id, String value) async {
    try {
      if (value == 'active' || value == 'suspended') {
        await FirebaseFirestore.instance.collection('users').doc(id).update({'status': value});
      } else {
        await FirebaseFirestore.instance.collection('users').doc(id).update({'role': value});
      }
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث المدير')));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static Future<void> _createManager(BuildContext context) async {
    final name = TextEditingController();
    final phone = TextEditingController();
    final password = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text('إنشاء مدير'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم')),
        TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'الهاتف')),
        TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('إنشاء')),
      ],
    ));
    if (ok != true) { name.dispose(); phone.dispose(); password.dispose(); return; }
    try {
      final p = phone.text.trim();
      if (!RegExp(r'^\d{10}$').hasMatch(p)) throw StateError('رقم الهاتف غير صحيح');
      if (password.text.length < 6) throw StateError('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      final app = await Firebase.initializeApp(name: 'manager_' + DateTime.now().microsecondsSinceEpoch.toString(), options: DefaultFirebaseOptions.currentPlatform);
      try {
        final managerAuth = FirebaseAuth.instanceFor(app: app);
        final cred = await managerAuth.createUserWithEmailAndPassword(email: p + '@jawan.app', password: password.text);
        await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
          'role':'admin','name':name.text.trim(),'phone':p,'address':null,'state':null,'age':null,'vehicleType':null,
          'status':'active','privacyAccepted':true,'termsAccepted':true,'createdAt':FieldValue.serverTimestamp(),'lastActiveAt':FieldValue.serverTimestamp(),
        });
      } finally { await app.delete(); }
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء المدير')));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally { name.dispose(); phone.dispose(); password.dispose(); }
  }
}