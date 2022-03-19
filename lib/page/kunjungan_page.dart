import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_emonit/page/pdf_page.dart';
import 'package:web_emonit/page/petugas_page.dart';
import 'package:web_emonit/theme/colors.dart';
import 'package:web_emonit/theme/padding.dart';

final Stream<QuerySnapshot> _streamKunjungan = FirebaseFirestore.instance
    .collection("kunjungan")
    .orderBy("tanggal kunjungan")
    .snapshots();

class KunjunganPage extends StatefulWidget {
  const KunjunganPage({Key? key}) : super(key: key);

  @override
  _KunjunganPageState createState() => _KunjunganPageState();
}

class _KunjunganPageState extends State<KunjunganPage> {
  @override
  Widget build(BuildContext context) {
    String title = "Data Kunjungan";

    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style:
                const TextStyle(color: kBlack54, fontWeight: FontWeight.bold)),
        backgroundColor: kWhite,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: paddingDefault),
            child: IconButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PdfPage())),
                icon: const Icon(
                  Icons.print,
                  color: kBlack54,
                )),
          )
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: streamBuilder(),
      ),
    );
  }

  Widget streamBuilder() {
    return StreamBuilder<QuerySnapshot>(
        stream: _streamKunjungan,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error!"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Belum Ada Data!",
                style: TextStyle(color: kBlack54),
              ),
            );
          } else {
            return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot data) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailKunjunganPage(
                              docId: data['docId'],
                              uid: data['uid'],
                              tanggalKunjungan: data['tanggal kunjungan'],
                              nomorHp: data['nomor HP'],
                              namaMB: data['nama mitra binaan'],
                              namaLokasi: data['nama lokasi'],
                              koordinatLokasi: data['koordinat lokasi'],
                              kodeMB: data['kode mitra binaan'],
                              keterangan: data['keterangan'],
                              fileFoto: data['file foto'],
                              alamat: data['alamat'],
                              statusVerifikasi: data['status verifikasi']))),
                  title: Row(
                    children: [
                      Text(
                        "${data['nama mitra binaan']}",
                        style: const TextStyle(
                            color: kBlack54, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Text("|"),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "${data['kode mitra binaan']}",
                        style: const TextStyle(
                          color: kBlack54,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text("${data['nama lokasi']}"),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${data['tanggal kunjungan']}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      data['status verifikasi'] == ""
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.timelapse,
                                  size: 16,
                                  color: kRed,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Dalam Proses Pemeriksaan",
                                  style: TextStyle(color: kRed, fontSize: 12),
                                ),
                              ],
                            )
                          : Row(
                              children: const [
                                Icon(
                                  Icons.check,
                                  size: 16,
                                  color: kGreen,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text("Telah Diperiksa",
                                    style:
                                        TextStyle(color: kGreen, fontSize: 12)),
                              ],
                            ),
                      const Divider(
                        thickness: 2,
                      )
                    ],
                  ),
                ),
              );
            }).toList());
          }
        }));
  }
}

class DetailKunjunganPage extends StatefulWidget {
  final String docId;
  final String uid;
  final String tanggalKunjungan;
  final String nomorHp;
  final String namaMB;
  final String namaLokasi;
  final GeoPoint koordinatLokasi;
  final String kodeMB;
  final String keterangan;
  final String fileFoto;
  final String alamat;
  final String statusVerifikasi;
  const DetailKunjunganPage(
      {Key? key,
      required this.docId,
      required this.uid,
      required this.tanggalKunjungan,
      required this.nomorHp,
      required this.namaMB,
      required this.namaLokasi,
      required this.koordinatLokasi,
      required this.kodeMB,
      required this.keterangan,
      required this.fileFoto,
      required this.alamat,
      required this.statusVerifikasi})
      : super(key: key);

  @override
  _DetailKunjunganPageState createState() => _DetailKunjunganPageState();
}

class _DetailKunjunganPageState extends State<DetailKunjunganPage> {
  String statusVerifikasi1 = "Terverifikasi";
  String statusVerifikasi2 = "Tidak Terverifikasi";

  String tglVerifikasi = DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now());

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    String title = "Detail Data Kunjungan";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kRed,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(paddingDefault),
        child: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Ada yang Salah!");
                } else if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("Dokument tidak ada!");
                } else if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  String _uid = data['uid'];
                  String _fullname = data['nama lengkap'];
                  String _username = data['username'];
                  String _email = data['email'];
                  String _nik = data['nik'];
                  String _phoneNumber = data['nomor hp'];
                  String _workLocation = data['lokasi kerja'];
                  String _noKtp = data['ktp'];
                  String _noKk = data['kk'];
                  String _gender = data['jenis kelamin'];
                  String _religion = data['agama'];
                  String _placeBirth = data['tempat tanggal lahir'];
                  String _address = data['alamat'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                          child: Text(
                        "Petugas",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Nama Petugas",
                            style: TextStyle(color: kBlack54),
                          ),
                          Flexible(
                              child: Text(
                            _fullname,
                            style: const TextStyle(
                                color: kBlack54, fontWeight: FontWeight.bold),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailPetugasPage(
                                          uid: _uid,
                                          username: _username,
                                          email: _email,
                                          namaPetugas: _fullname,
                                          lokasiKerja: _workLocation,
                                          nomorHp: _phoneNumber,
                                          alamat: _address,
                                          agama: _religion,
                                          jenisKelamin: _gender,
                                          nik: _nik,
                                          noKk: _noKk,
                                          noKtp: _noKtp,
                                          ttl: _placeBirth))),
                              child: const Text(
                                "Lihat Detail",
                                style: TextStyle(color: kGreen),
                              ))
                        ],
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "ID Kunjungan",
                            style: TextStyle(color: kBlack54),
                          ),
                          Text(widget.docId)
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Center(
                          child: Text(
                        "Mitra Binaan",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "Kode Mitra Binaan",
                        style: TextStyle(color: kBlack54),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.kodeMB,
                        style: const TextStyle(
                          color: kBlack54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "Nama Mitra Binaan",
                        style: TextStyle(color: kBlack54),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.namaMB,
                        style: const TextStyle(
                          color: kBlack54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "Lokasi",
                        style: TextStyle(color: kBlack54),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.namaLokasi,
                        style: const TextStyle(
                          color: kBlack54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "Koordinat",
                        style: TextStyle(color: kBlack54),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Lat: ${widget.koordinatLokasi.latitude}, Lon: ${widget.koordinatLokasi.longitude}",
                        style: const TextStyle(
                          color: kBlack54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "Tanggal Kunjungan",
                        style: TextStyle(color: kBlack54),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.tanggalKunjungan,
                        style: const TextStyle(
                          color: kBlack54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "Alamat",
                        style: TextStyle(color: kBlack54),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.alamat,
                        style: const TextStyle(
                          color: kBlack54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "Nomor HP Mitra Binaan",
                        style: TextStyle(color: kBlack54),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.nomorHp,
                        style: const TextStyle(
                          color: kBlack54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "Keterangan",
                        style: TextStyle(color: kBlack54),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.keterangan,
                        style: const TextStyle(
                            color: kBlack54, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Foto Kunjungan",
                            style: TextStyle(color: kBlack54),
                          ),
                          TextButton(
                              onPressed: () => lihatFoto(widget.fileFoto),
                              child: const Text(
                                "Lihat Foto",
                                style: TextStyle(color: kGreen),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      widget.statusVerifikasi == ""
                          ? Column(
                              children: [
                                buttonValid(),
                                const SizedBox(
                                  height: 8,
                                ),
                                buttonInvalid()
                              ],
                            )
                          : Visibility(
                              visible: isVisible,
                              child: Column(
                                children: [
                                  buttonValid(),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  buttonInvalid()
                                ],
                              ))
                    ],
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }

  lihatFoto(fileFoto) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              title: Column(
            children: [
              Container(
                width: 640,
                height: 320,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(fileFoto), fit: BoxFit.cover)),
              ),
            ],
          ));
        });
  }

  Widget buttonValid() {
    return ElevatedButton(
        onPressed: terverifikasi,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(kGreen),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)))),
        child: Container(
            width: double.infinity,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Center(
              child: Text(
                "Valid",
                style: TextStyle(color: kWhite),
              ),
            )));
  }

  Widget buttonInvalid() {
    return ElevatedButton(
        onPressed: penolakan,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(kWhite),
            side: MaterialStateProperty.all(const BorderSide(color: kRed)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)))),
        child: Container(
            width: double.infinity,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Center(
              child: Text(
                "Invalid",
                style: TextStyle(color: kRed),
              ),
            )));
  }

  Future<void> updateStatusKunjungan1() {
    CollectionReference kunjungan =
        FirebaseFirestore.instance.collection("kunjungan");
    return kunjungan
        .doc(widget.docId)
        .update({
          'status verifikasi': statusVerifikasi1,
          'tanggal verifikasi': tglVerifikasi
        })
        .then((value) => "Updated")
        .catchError((error) => "Failed to updated: $error");
  }

  Future<void> updateStatusKunjungan2() {
    CollectionReference kunjungan =
        FirebaseFirestore.instance.collection("kunjungan");
    return kunjungan
        .doc(widget.docId)
        .update({
          'status verifikasi': statusVerifikasi2,
          'tanggal verifikasi': tglVerifikasi
        })
        .then((value) => "Updated")
        .catchError((error) => "Failed to updated: $error");
  }

  Future<void> updateStatusUsersKunjungan1() {
    CollectionReference usersKunjungan =
        FirebaseFirestore.instance.collection("users");
    return usersKunjungan
        .doc(widget.uid)
        .collection("kunjungan")
        .doc(widget.docId)
        .update({
          'status verifikasi': statusVerifikasi1,
          'tanggal verifikasi': tglVerifikasi
        })
        .then((value) => "Updated")
        .catchError((error) => "Failed to updated: $error");
  }

  Future<void> updateStatusUsersKunjungan2() {
    CollectionReference usersKunjungan =
        FirebaseFirestore.instance.collection("users");
    return usersKunjungan
        .doc(widget.uid)
        .collection("kunjungan")
        .doc(widget.docId)
        .update({
          'status verifikasi': statusVerifikasi2,
          'tanggal verifikasi': tglVerifikasi
        })
        .then((value) => "Updated")
        .catchError((error) => "Failed to updated: $error");
  }

  Future<dynamic> terverifikasi() async {
    await FirebaseFirestore.instance
        .collection("terverifikasi")
        .doc(widget.docId)
        .set({
      'docId': widget.docId,
      'uid': widget.uid,
      'tanggal kunjungan': widget.tanggalKunjungan,
      'nomor hp': widget.nomorHp,
      'nama mitra binaan': widget.namaMB,
      'nama lokasi': widget.namaLokasi,
      'koordinat lokasi': widget.koordinatLokasi,
      'kode mitra binaan': widget.kodeMB,
      'keterangan': widget.keterangan,
      'file foto': widget.fileFoto,
      'alamat': widget.alamat,
      'status verifikasi': statusVerifikasi1,
      'tanggal verifikasi': tglVerifikasi
    }).then((_) {
      updateStatusKunjungan1();
      updateStatusUsersKunjungan1();
      Future.delayed(const Duration(seconds: 2), () {
        alertDialog();
      });
    });
  }

  Future<dynamic> penolakan() async {
    await FirebaseFirestore.instance
        .collection("penolakan")
        .doc(widget.docId)
        .set({
      'docId': widget.docId,
      'uid': widget.uid,
      'tanggal kunjungan': widget.tanggalKunjungan,
      'nomor hp': widget.nomorHp,
      'nama mitra binaan': widget.namaMB,
      'nama lokasi': widget.namaLokasi,
      'koordinat lokasi': widget.koordinatLokasi,
      'kode mitra binaan': widget.kodeMB,
      'keterangan': widget.keterangan,
      'file foto': widget.fileFoto,
      'alamat': widget.alamat,
      'status verifikasi': statusVerifikasi2,
      'tanggal verifikasi': tglVerifikasi
    }).then((_) {
      updateStatusKunjungan2();
      updateStatusUsersKunjungan2();
      Future.delayed(const Duration(seconds: 2), () {
        alertDialog();
      });
    });
  }

  alertDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.check_circle_rounded,
                  color: kGreen,
                  size: 48,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Berhasil Diverifikasi",
                  style: TextStyle(color: kBlack54),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Center(child: Text("OK", style: TextStyle(color: kBlack54),)))
            ],
          );
        });
  }
}
