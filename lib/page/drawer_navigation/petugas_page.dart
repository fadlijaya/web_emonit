import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_emonit/theme/colors.dart';
import 'package:web_emonit/theme/padding.dart';

final Stream<QuerySnapshot> _streamPetugas =
    FirebaseFirestore.instance.collection('users').snapshots();

class PetugasPage extends StatefulWidget {
  const PetugasPage({Key? key}) : super(key: key);

  @override
  _PetugasPageState createState() => _PetugasPageState();
}

class _PetugasPageState extends State<PetugasPage> {
  String title = "Data Petugas";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kRed,
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: StreamBuilder<QuerySnapshot>(
            stream: _streamPetugas,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error!'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum Ada Data!",
                  ),
                );
              } else {
                return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPetugasPage(
                                  uid: data['uid'],
                                  username: data['username'],
                                  email: data['email'],
                                  namaPetugas: data['nama lengkap'],
                                  lokasiKerja: data['lokasi kerja'],
                                  nomorHp: data['nomor hp'],
                                  alamat: data['alamat'],
                                  agama: data['agama'],
                                  jenisKelamin: data['jenis kelamin'],
                                  nik: data['nik'],
                                  noKk: data['kk'],
                                  noKtp: data['ktp'],
                                  ttl: data['tempat tanggal lahir']))),
                      leading: const Icon(
                        Icons.account_circle,
                        size: 36,
                      ),
                      title: Text(
                        "${data['nama lengkap']}",
                        style: const TextStyle(
                            color: kBlack54, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            "${data['lokasi kerja']}",
                            style: const TextStyle(
                              color: kBlack54,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
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
            }),
      ),
    );
  }
}

class DetailPetugasPage extends StatefulWidget {
  final String uid;
  final String username;
  final String email;
  final String namaPetugas;
  final String lokasiKerja;
  final String nomorHp;
  final String alamat;
  final String agama;
  final String jenisKelamin;
  final String nik;
  final String noKk;
  final String noKtp;
  final String ttl;

  const DetailPetugasPage(
      {Key? key,
      required this.uid,
      required this.username,
      required this.email,
      required this.namaPetugas,
      required this.lokasiKerja,
      required this.nomorHp,
      required this.alamat,
      required this.agama,
      required this.jenisKelamin,
      required this.nik,
      required this.noKk,
      required this.noKtp,
      required this.ttl})
      : super(key: key);

  @override
  _DetailPetugasPageState createState() => _DetailPetugasPageState();
}

class _DetailPetugasPageState extends State<DetailPetugasPage> {
  String title = "Detail Data Petugas";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kRed,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(paddingDefault),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "UID",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.uid,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Username",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.username,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Email",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.email,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Nama Lengkap",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.namaPetugas,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Lokasi Kerja",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.lokasiKerja,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Nomor HP",
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
                "Agama",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.agama,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Jenis Kelamin",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.jenisKelamin,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "NIK",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.nik,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "No. KK",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.noKk,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Jenis Kelamin",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.noKtp,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Tempat Tanggal Lahir",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.ttl,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
