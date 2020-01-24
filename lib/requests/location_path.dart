import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
const apiKey = "AIzaSyAHbxSS8nMi8aJb5kEUEW8Xvn654abk1gc";
class Locationpath {
  final String email;
  Locationpath({this.email});
  
  Future getRouteCoordinates(LatLng l1, LatLng l2)async{
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    http.Response response = await http.get(url);
    String emailz = email.replaceAll('.', ',');
    String jsonUrl = "https://ambu-lights.firebaseio.com/users/"+ emailz + ".json";
    Map values = jsonDecode(response.body);
    //http.post("https://ambulance-80283.firebaseio.com/routes/gg.json",body: json.encode(values['routes'][0]['legs'][0]['steps']));
    //print("This is Map Values " + values.toString());
    //print(values["routes"][0]["overview_polyline"]["points"]);
    print("https://ambu-lights.firebaseio.com/" + email + ".json");
    return values["routes"][0]["overview_polyline"]["points"];
  }
}