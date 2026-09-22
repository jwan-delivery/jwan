import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const adminBlack = Color(0xFF0A0A0A);
const adminYellow = Color(0xFFF5C400);

class AyezAdminCenterPage extends StatelessWidget {
  const AyezAdminCenterPage({super.key, required this.profile, this.initialSection = 0});
  final Map<String, dynamic> profile;
  final int initialSection;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: initialSection.clamp(0, 4),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة عايز', style: TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: adminBlack,
          foregroundColor: Colors.white,
          bottom: const TabBar(tabs: [Tab(text: 'الملخص'), Tab(text: 'الطلبات'), Tab(text: 'المستخدمون'), Tab(text: 'الماليات'), Tab(text: 'الدعم')]),
          actions: [IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout))],
        ),
        body: const TabBarView(children: [
          _AdminSummary(),
          _AdminOrders(),
          _AdminUsers(),
          _AdminFinance(),
          _AdminSupport(),
        ]),
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

class _AdminUsers extends StatefulWidget { const _AdminUsers(); @override State<_AdminUsers> createState()=>_AdminUsersState(); }
class _AdminUsersState extends State<_AdminUsers> {
  bool drivers=true;
  @override Widget build(BuildContext context){final role=drivers?'driver':'customer';return Column(children:[Padding(padding:const EdgeInsets.all(12),child:SegmentedButton<bool>(segments:const[ButtonSegment(value:true,label:Text('السائقون')),ButtonSegment(value:false,label:Text('العملاء'))],selected:{drivers},onSelectionChanged:(s)=>setState(()=>drivers=s.first))),Expanded(child:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseFirestore.instance.collection('users').where('role',isEqualTo:role).limit(300).snapshots(),builder:(_,s){if(s.hasError)return Center(child:Text('${s.error}'));final docs=s.data?.docs??const[];return ListView.separated(padding:const EdgeInsets.all(12),itemCount:docs.length,separatorBuilder:(_,__)=>const SizedBox(height:8),itemBuilder:(_,i){final d=docs[i];final u=d.data();final status='${u['status']??''}';return Card(child:ListTile(title:Text('${u['name']??'-'}'),subtitle:Text('${u['phone']??'-'} • ${u['state']??'-'} • $status'),trailing:PopupMenuButton<String>(onSelected:(v)=>_setStatus(context,d.id,v),itemBuilder:(_)=>const[PopupMenuItem(value:'active',child:Text('تفعيل')),PopupMenuItem(value:'suspended',child:Text('إيقاف')),PopupMenuItem(value:'rejected',child:Text('رفض'))])));});})))];}
  static Future<void> _setStatus(BuildContext context,String id,String status) async {try{await FirebaseFirestore.instance.collection('users').doc(id).update({'status':status});if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تم تحديث الحالة')));}catch(e){if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('$e')));}}
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