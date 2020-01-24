import 'package:ambulights/screens/reflog.dart';
import 'package:flutter/material.dart';
import './screens/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        accentColor: Colors.redAccent,
      buttonColor: Colors.white),
      routes: {
        '/': (BuildContext context) => RefLoginPage(),
      },
      title: 'Ambulights',
    );
  }
}