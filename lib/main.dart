import 'package:flutter/material.dart';
import './screens/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        accentColor: Colors.redAccent,
      buttonColor: Colors.white),
      routes: {
        '/': (BuildContext context) => Splash(),
      },
      title: 'Ambulights',
    );
  }
}