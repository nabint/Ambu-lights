import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import './mainpage.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 4,
      image:Image.asset('assets/images/ambo.png'),
      backgroundColor: Colors.white,
      photoSize: 100.0,
      navigateAfterSeconds: MainPage(),
    );
  }
}