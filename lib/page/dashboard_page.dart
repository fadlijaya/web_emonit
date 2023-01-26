import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_emonit/login_view.dart';
import 'package:web_emonit/page/maps_page.dart';
import 'package:web_emonit/theme/colors.dart';
import 'package:web_emonit/theme/padding.dart';
import 'package:web_emonit/utils/constants.dart';

final Stream<QuerySnapshot> _streamPetugas =
    FirebaseFirestore.instance.collection("users").snapshots();

final Stream<QuerySnapshot> _streamKunjungan = FirebaseFirestore.instance
    .collection("kunjungan")
    .orderBy('tanggal kunjungan', descending: true)
    .snapshots();

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            buildHeaderDashboard(context),
            Positioned.fill(
              left: 0,
              top: 80,
              bottom: 0,
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1.7,
                children: [
                  cardPetugas(),
                  cardKunjungan(),
                  cardTerverifikasi(),
                  cardPenolakan()
                ],
              ),
            ),
            const Positioned.fill(
                left: 0,
                top: 320,
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.only(left: paddingDefault),
                  child: Text(
                    "Petugas Kunjungan Mitra Binaan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )),
            Positioned.fill(
                left: 0,
                top: 340,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(paddingDefault),
                    child: buildKunjunganPetugas(),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  popupMenuButton() {
    PopupMenuButton(itemBuilder: (context) {
      return <PopupMenuEntry<String>>[
        PopupMenuItem<String>(child: Text("$_name"))
      ];
    });
  }

  Widget buildHeaderDashboard(context) {
    return Container(
      padding: const EdgeInsets.all(paddingDefault),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            titleDashboard,
            style: TextStyle(
                color: kBlack, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(
              Icons.exit_to_app,
              color: kRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildKunjunganPetugas() {
    return StreamBuilder<QuerySnapshot>(
        stream: _streamKunjungan,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LinearProgressIndicator();
          }

          return DataTable(columns: const [
            DataColumn(
                label: Text(
              "Nama Petugas",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text("Hari/Tanggal",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Koordinat",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
              label:
                  Text("Lokasi", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
                label:
                    Text("Foto", style: TextStyle(fontWeight: FontWeight.bold)))
          ], rows: buildList(context, snapshot.data!.docs));
        });
  }

  List<DataRow> buildList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => buildListItem(context, data)).toList();
  }

  DataRow buildListItem(BuildContext context, DocumentSnapshot data) {
    return DataRow(cells: [
      DataCell(Text("${data['nama petugas']}")),
      DataCell(Text("${data['tanggal kunjungan']}")),
      DataCell(Text(
          "Lat : ${data['koordinat lokasi'].latitude}, Lon : ${data['koordinat lokasi'].longitude}")),
      DataCell(Text("${data['alamat']}")),
      DataCell(TextButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapsPage(
                      namaMitra: data['nama mitra binaan'],
                      foto: data['file foto'],
                      koordinatLokasi: data['koordinat lokasi']))),
          child: Text("Lihat"))),
    ]);
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
