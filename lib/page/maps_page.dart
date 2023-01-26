import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../theme/colors.dart';

class MapsPage extends StatefulWidget {
  final String namaMitra;
  final String foto;
  final GeoPoint koordinatLokasi;
  const MapsPage({Key? key, required this.namaMitra, required this.foto, required this.koordinatLokasi})
      : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  Location location = Location();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Stack(
            children: [
              mapLokasi(),
              imageFoto(),
            ],
          ),
        ),
      ),
    );
  }

  Widget mapLokasi() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.koordinatLokasi.latitude,
                widget.koordinatLokasi.longitude),
            zoom: 16),
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        markers: _markers,
        zoomControlsEnabled: true,
      ),
    );
  }

  Widget imageFoto() {
    return Positioned.fill(
        child: Align(
      alignment: Alignment.topRight,
      child: Container(
          margin: const EdgeInsets.only(top: 40, right: 60, bottom: 40),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(widget.foto))),
    ));
  }

  _onMapCreated(GoogleMapController googleMapController) {
    setState(() {
      _markers.add(Marker(
          markerId: const MarkerId("1"),
          position: LatLng(widget.koordinatLokasi.latitude,
              widget.koordinatLokasi.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: "Nama Mitra Binaan : ${widget.namaMitra}",
          )));
    });
  }
}
