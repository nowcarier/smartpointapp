import 'package:flutter/material.dart';
// import 'package:smartpoint/home.dart';
import 'package:smartpoint/main_page.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 3,
        navigateAfterSeconds: DashboardScreen(),
        // title: Text(
        //   'Smart Point',
        //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        // ),
        image: Image.asset('assets/logo2.png'),
        photoSize: 250,
        );
  }
}



