import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_emonit/login_view.dart';
import 'package:web_emonit/theme/colors.dart';
import 'package:web_emonit/theme/padding.dart';

final Stream<QuerySnapshot> _streamPetugas =
    FirebaseFirestore.instance.collection("users").snapshots();

final Stream<QuerySnapshot> _streamKunjungan =
    FirebaseFirestore.instance.collection("kunjungan").snapshots();

final Stream<QuerySnapshot> _streamTerverifikasi =
    FirebaseFirestore.instance.collection("terverifikasi").snapshots();

final Stream<QuerySnapshot> _streamPenolakan =
    FirebaseFirestore.instance.collection("penolakan").snapshots();

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? _uid;
  String? _name;
  String? _email;

  @override
  void initState() {
    getAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = "Dashboard";
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: kBlack54, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kWhite,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: logout,
              icon: const Icon(
                Icons.exit_to_app,
                color: kRed,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 4,
          childAspectRatio: 1.5,
          children: [
            cardPetugas(),
            cardKunjungan(),
            cardTerverifikasi(),
            cardPenolakan()
          ],
        ),
      ),
    );
  }

  popupMenuButton() {
    PopupMenuButton(itemBuilder: (context) {
      return <PopupMenuEntry<String>>[
        PopupMenuItem<String>(child: Text("$_name"))];
    });
  }

  Widget drawerHeader() {
    return UserAccountsDrawerHeader(
        decoration: const BoxDecoration(color: kRed),
        currentAccountPicture: const ClipOval(
          child:
              Image(fit: BoxFit.cover, image: AssetImage("assets/admin.jpg")),
        ),
        accountName: Text(
          "$_name",
          style: const TextStyle(color: kWhite),
        ),
        accountEmail: Text(
          "$_email",
          style: const TextStyle(color: kWhite),
        ));
  }

  Widget cardPetugas() {
    return StreamBuilder<QuerySnapshot>(
        stream: _streamPetugas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error!"),
            );
          } else {
            int totalData = snapshot.data!.docs.length;
            return Card(
              color: kOrange,
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(
                            top: paddingDefault, left: paddingDefault),
                        child: Icon(
                          Icons.account_circle,
                          size: 48.0,
                          color: kWhite,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${int.parse(totalData.toString())}",
                    style: const TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        color: kWhite),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text('Petugas',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kWhite,
                          fontSize: 20))
                ],
              ),
            );
          }
        });
  }

  Widget cardKunjungan() {
    return StreamBuilder<QuerySnapshot>(
        stream: _streamKunjungan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error!"),
            );
          } else {
            int totalData = snapshot.data!.docs.length;
            return Card(
              color: kBlue,
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(
                            top: paddingDefault, left: paddingDefault),
                        child: Icon(Icons.timelapse, size: 48.0, color: kWhite),
                      ),
                    ],
                  ),
                  Text(
                    "${int.parse(totalData.toString())}", //dashboardModel.totalProduct.toString(),
                    style: const TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        color: kWhite),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Kunjungan',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                        fontSize: 20),
                  )
                ],
              ),
            );
          }
        });
  }

  Widget cardTerverifikasi() {
    return StreamBuilder<QuerySnapshot>(
        stream: _streamTerverifikasi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error!"),
            );
          } else {
            int totalData = snapshot.data!.docs.length;
            return Card(
              color: kGreen,
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(
                            top: paddingDefault, left: paddingDefault),
                        child: Icon(Icons.verified, size: 48.0, color: kWhite),
                      ),
                    ],
                  ),
                  Text(
                    "${int.parse(totalData.toString())}",
                    style: const TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        color: kWhite),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Terverifikasi',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                        fontSize: 20),
                  )
                ],
              ),
            );
          }
        });
  }

  Widget cardPenolakan() {
    return StreamBuilder<QuerySnapshot>(
        stream: _streamPenolakan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error!"),
            );
          } else {
            int totalData = snapshot.data!.docs.length;
            return Card(
              color: kRed,
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(
                            top: paddingDefault, left: paddingDefault),
                        child: Icon(Icons.close, size: 48.0, color: kWhite),
                      ),
                    ],
                  ),
                  Text(
                    "${int.parse(totalData.toString())}",
                    style: const TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        color: kWhite),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Penolakan',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                        fontSize: 20),
                  )
                ],
              ),
            );
          }
        });
  }

  Future getAdmin() async {
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

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut().then((_) =>
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
            (route) => false));
  }
}
