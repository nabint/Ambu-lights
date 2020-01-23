import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Mapz());
  } 
}

class Mapz extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
  
}

class _MapState extends State<Mapz> {
  GoogleMapController mapController;
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  static LatLng _initialPosition;
  LatLng _finalPosition = _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  
  @override
  void initState() {
    super.initState();
    _getUserLocation();
    
  }

  @override
  Widget build(BuildContext context) {
    return _initialPosition == null
        ? Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _initialPosition, zoom: 20.0),
                  onMapCreated: onCreated,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  markers: _markers,
                  polylines: _polyline,
                ),
              ],
            ),
          );
  }


  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      locationController.text = placemark[0].name;
    });
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
