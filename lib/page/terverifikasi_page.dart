import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_emonit/theme/colors.dart';
import 'package:web_emonit/theme/padding.dart';

final Stream<QuerySnapshot> _streamTerverifikasi =
    FirebaseFirestore.instance.collection("terverifikasi").snapshots();

class TerverifikasiPage extends StatefulWidget {
  const TerverifikasiPage({Key? key}) : super(key: key);

  @override
  _TerverifikasiPageState createState() => _TerverifikasiPageState();
}

class _TerverifikasiPageState extends State<TerverifikasiPage> {
  @override
  Widget build(BuildContext context) {
    String title = "Data Terverifikasi";

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: kBlack54, fontWeight: FontWeight.bold)),
        backgroundColor: kWhite,
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
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum Ada Data!", style: TextStyle(color: kBlack54),));
          } else {
            return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot data) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailVerifikasiPage(
                              docId: data['docId'],
                              uid: data['uid'],
                              tanggalKunjungan: data['tanggal kunjungan'],
                              nomorHp: data['nomor hp'],
                              namaMB: data['nama mitra binaan'],
                              namaLokasi: data['nama lokasi'],
                              koordinatLokasi: data['koordinat lokasi'],
                              kodeMB: data['kode mitra binaan'],
                              keterangan: data['keterangan'],
                              fileFoto: data['file foto'],
                              alamat: data['alamat'],
                              status: data['status verifikasi'],
                              tanggalVerifikasi: data['tanggal verifikasi']))),
                  title: Text(
                    "${data['kode mitra binaan']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${data['nama lokasi']}"),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${data['tanggal verifikasi']}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.verified,
                            color: kGreen,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "${data['status verifikasi']}",
                            style: const TextStyle(color: kGreen, fontSize: 12),
                          )
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
        });
  }
}

class DetailVerifikasiPage extends StatefulWidget {
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
  final String status;
  final String tanggalVerifikasi;
  const DetailVerifikasiPage(
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
      required this.status,
      required this.tanggalVerifikasi})
      : super(key: key);

  @override
  _DetailVerifikasiPageState createState() => _DetailVerifikasiPageState();
}

class _DetailVerifikasiPageState extends State<DetailVerifikasiPage> {
  @override
  Widget build(BuildContext context) {
    String title = "Detail Data Terverifikasi";

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
          child: Column(
            children: [
              statusVerifikasi(),
              const SizedBox(
                height: 24,
              ),
              idKunjungan(),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 12,
              ),
              idPetugas(),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 12,
              ),
              dataMB()
            ],
          ),
        ),
      ),
    );
  }

  Widget statusVerifikasi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.verified,
          size: 72,
          color: kGreen,
        ),
        const SizedBox(height: 16),
        Text(widget.status,
            style: const TextStyle(
                color: kGreen, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 8,
        ),
        Text(
          widget.tanggalVerifikasi,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget idKunjungan() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "ID Kunjungan",
          style: TextStyle(color: kBlack54),
        ),
        Text(widget.docId)
      ],
    );
  }

  Widget idPetugas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "ID Petugas",
          style: TextStyle(color: kBlack54),
        ),
        const SizedBox(height: 8),
        Text(widget.uid),
      ],
    );
  }

  Widget dataMB() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          style: const TextStyle(color: kBlack54, fontWeight: FontWeight.bold),
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
            color: kBlack54,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "Foto Kunjungan",
          style: TextStyle(color: kBlack54),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(widget.fileFoto))),
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
