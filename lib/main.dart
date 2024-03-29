import 'package:flutter/material.dart';
import 'package:smartpoint/page/splash_page.dart';
// import 'package:yourpackage/pages/splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: Color(0xffe9ebee),
            primaryColor: Colors.blue,
            accentColor: Colors.pinkAccent),
        title: 'SmartPoint',
        home: SplashPage());
  }
}

