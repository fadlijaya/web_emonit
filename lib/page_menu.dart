import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:web_emonit/theme/colors.dart';
import 'package:web_emonit/theme/padding.dart';

import 'page/dashboard_page.dart';
import 'page/kunjungan_page.dart';
import 'page/penolakan_page.dart';
import 'page/petugas_page.dart';
import 'page/terverifikasi_page.dart';

final _availablePages = <String, WidgetBuilder>{
  'Dashboard': (_) => const DashboardPage(),
  'Data Petugas': (_) => const PetugasPage(),
  'Data Kunjungan': (_) => const KunjunganPage(),
  'Data Terverifikasi': (_) => const TerverifikasiPage(),
  'Data Penolakan': (_) => const PenolakanPage(),
};

void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
  // only change the state if we have selected a different page
  if (ref.read(selectedPageNameProvider.state).state != pageName) {
    ref.read(selectedPageNameProvider.state).state = pageName;
  }
}

final selectedPageNameProvider = StateProvider<String>((ref) {
  // default value
  return _availablePages.keys.first;
});

final selectedPageBuilderProvider = Provider<WidgetBuilder>((ref) {
  // watch for state changes inside selectedPageNameProvider
  final selectedPageKey = ref.watch(selectedPageNameProvider.state).state;
  // return the WidgetBuilder using the key as index
  return _availablePages[selectedPageKey]!;
});

// 1. extend from ConsumerWidget
class PageMenu extends ConsumerWidget {
  const PageMenu({Key? key}) : super(key: key);

  // 2. Add a WidgetRef argument
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. watch the provider's state
    final selectedPageName = ref.watch(selectedPageNameProvider.state).state;
    return Scaffold(
      backgroundColor: kRed,
      appBar: AppBar(
        leading: Image.asset(
          "assets/logo_telkom.png",
          width: 30,
        ),
        title: const Text('ADMIN PAGE'),
        backgroundColor: kRed,
      ),
      body: Column(
        children: [
          GetAdmin(name: _name.toString(), email: _email.toString()),
          Expanded(
            child: ListView(
              children: <Widget>[
                for (var pageName in _availablePages.keys)
                  PageListTile(
                    // 4. pass the selectedPageName as an argument
                    selectedPageName: selectedPageName,
                    pageName: pageName,
                    onPressed: () => _selectPage(context, ref, pageName),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageListTile extends StatelessWidget {
  const PageListTile({
    Key? key,
    this.selectedPageName,
    required this.pageName,
    this.onPressed,
  }) : super(key: key);
  final String? selectedPageName;
  final String pageName;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // show a check icon if the page is currently selected
      // note: we use Opacity to ensure that all tiles have a leading widget
      // and all the titles are left-aligned
      leading: Opacity(
        opacity: selectedPageName == pageName ? 1.0 : 0.0,
        child: const Icon(
          Icons.check,
          color: kWhite,
        ),
      ),
      title: Text(
        pageName,
        style: const TextStyle(color: kWhite, fontWeight: FontWeight.w500),
      ),
      onTap: onPressed,
    );
  }
}

String? _uid;
String? _name;
String? _email;

class GetAdmin extends StatefulWidget {
  final String name;
  final String email;
  const GetAdmin({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  State<GetAdmin> createState() => _GetAdminState();
}

class _GetAdminState extends State<GetAdmin> {

  Future<dynamic> getAdmin() async {
    await FirebaseFirestore.instance
        .collection('admin')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        setState(() {
          _uid = result.docs[0].data()['uid'];
          _name = result.docs[0].data()['nama'];
          _email = result.docs[0].data()['email'];
        });
      }
    });
  }

  @override
  void initState() {
    getAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: paddingDefault),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: kWhite,
            child: Image.asset("assets/admin.jpg", width: 48,)
          ),
          const SizedBox(height: 12,),
          Text("$_name", style: const TextStyle(color: kWhite, fontSize: 16),), 
          const SizedBox(height: 4),
          Text("$_email", style: const TextStyle(color: kWhite),),
          const SizedBox(height: 12,),
          const Divider(thickness: 0.1, color: kWhite,)
        ],
      ),
    );
  }
}
