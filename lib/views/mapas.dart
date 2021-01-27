import 'package:flutter/material.dart';
import '../util/databaseHelper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'mapa.dart';

class Mapas extends StatefulWidget {
  @override
  _MapasState createState() => _MapasState();
}

class _MapasState extends State<Mapas> {
  DataBaseHelper db = DataBaseHelper();
  Set<Marker> _markers = Set<Marker>();
  @override
  void initState() {
    _determinePosition();
    getLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _determinePosition(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error));
            }

            Position position = snapshot.data;
            return Mapa(
              position: position,
              markers: _markers,
            );
          }),
    );
  }

  Future getLocations() async {
    List<Map> data = await db.getContatos();
    //List<Contato> contatos;
    data.forEach((element) {
      _markers.add(Marker(
          markerId: MarkerId(element['nome']),
          infoWindow:
              InfoWindow(title: element['nome'], snippet: element['endereco']),
          position: LatLng(
              double.parse(element['latlong'].toString().split(',')[0]),
              double.parse(element['latlong'].toString().split(',')[1]))));
      print(_markers);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
