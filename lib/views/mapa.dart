import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapa extends StatefulWidget {
  Mapa({Key key, this.position, this.markers}) : super(key: key);
  final Position position;
  final Set<Marker> markers;
  @override
  _MapaState createState() => _MapaState(position: position, markers: markers);
}

class _MapaState extends State<Mapa> {
  _MapaState({this.position, this.markers});
  final Position position;
  final Set<Marker> markers;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 16),
      markers: markers,
    );
  }
}
