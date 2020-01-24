import '../requests/location_path.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  final String email;
  MyHomePage({this.email});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Mapz(widget.email));
  }
}

class Mapz extends StatefulWidget {
  final String email;
  int online=0;
  Mapz(this.email);
  
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
  static DateTime now =  DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  final Set<Polyline> _polyline = {};
  String hospitalName;

  @override
  void deactivate() {
    String emailz = widget.email.replaceAll('.', ',');
    String jsonUrl2 = "https://ambu-lights.firebaseio.com/users/"+ emailz + "/online.json";
     widget.online = 0;
     http.delete(jsonUrl2); 
     print(widget.online.toString());
     http.put(jsonUrl2,body: json.encode(widget.online));
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    String emailz = widget.email.replaceAll('.', ',');
    print(emailz);
    http.get("https://ambu-lights.firebaseio.com/users/"+ emailz + "/timestamp.json").then((http.Response response){
      hospitalName = json.decode(response.body);
    });
    print("Thissss HospitalName " + hospitalName);
    String jsonUr3l = "https://ambu-lights.firebaseio.com/users/"+ emailz + "/timestamp.json";

    http.put(jsonUr3l,body: json.encode(formattedDate));
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
            drawer: _buildSideDrawer(),
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _initialPosition, zoom: 17.0),
                  onMapCreated: onCreated,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  markers: _markers,
                  onCameraMove: _onCameraMove,
                  polylines: _polyline,
                ),
                Positioned(
                  top: 50.0,
                  right: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10,
                            spreadRadius: 3)
                      ],
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: locationController,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, top: 5),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "pick up",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 105.0,
                  right: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10,
                            spreadRadius: 3)
                      ],
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: destinationController,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) {
                        sendRequest(value);
                      },
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, top: 5),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.airport_shuttle,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "destination?",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildSideDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          SizedBox(height: 70.0,),
          Text("User",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(widget.email),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_hospital),
            title: Text(hospitalName)
          )
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

  void _addMarker(LatLng location, String address) {
    setState(() {
      print(" Marker is called");
      _markers.clear();
      _markers.add(
        Marker(
            markerId: MarkerId(_finalPosition.toString()),
            position: location,
            infoWindow: InfoWindow(title: address, snippet: "Go Here"),
            icon: BitmapDescriptor.defaultMarker),
      )
      ;
    });
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void createRoute(String encodedPoly) {
    setState(() {
      _polyline.clear();
      widget.online=1;
      List pointss = _decodePoly(encodedPoly);
      String emailz = widget.email.replaceAll('.', ',');
      String jsonUrl4 = "https://ambu-lights.firebaseio.com/users/"+ emailz + "/routes.json";
      String jsonUrl2 = "https://ambu-lights.firebaseio.com/users/"+ emailz + "/online.json";
      http.delete(jsonUrl4).then((_){
        http.put(jsonUrl4,body: json.encode(pointss));
        });
      http.put(jsonUrl2,body: json.encode(widget.online));
      print("This is the points " + pointss.toString());
      //http.put("https://ambu-lights.firebaseio.com/routes/WRCtoArchalBot.json",body: json.encode(pointss));
      _polyline.add(
        Polyline(
            polylineId: PolylineId(_finalPosition.toString()),
            width: 6,
            points: convertToLatLng(
              _decodePoly(encodedPoly),
            ),
            color: Colors.blue),
      );
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _finalPosition = position.target;
    });
  }

  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  void sendRequest(String intendedLocation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    Locationpath _locationpath = Locationpath(email:widget.email);
    LatLng destination = LatLng(latitude, longitude);
    //String emailz = widget.email.replaceAll('.', ',');
    String locationz = latitude.toString() +", "+longitude.toString();
    String jsonUrl3 = "https://ambu-lights.firebaseio.com/visits.json";
    http.post(jsonUrl3,body: jsonEncode(intendedLocation));
    _addMarker(destination, intendedLocation);
    String route = await _locationpath.getRouteCoordinates(_initialPosition, destination);
    createRoute(route);
  }  
}
