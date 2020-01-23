import 'package:ambulights/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import './home.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 4,
      image:Image.asset('assets/images/ambo.png'),
      backgroundColor: Colors.white,
      photoSize: 100.0,
      navigateAfterSeconds: LoginPage(),
    );
  }
}