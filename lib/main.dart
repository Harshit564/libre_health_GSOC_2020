import 'package:flutter/material.dart';
import 'package:librehealth/Constant/constant.dart';
import 'package:librehealth/Pages/IntroPage.dart';
import 'package:librehealth/Pages/LoginPage.dart';
import 'package:librehealth/Pages/SplashScreen.dart';
import 'package:librehealth/Screens/BirthList.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'LibreHealth',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData.light(),
      home: AnimatedSplashScreen(),
      routes: <String, WidgetBuilder>{
        SPLASH_SCREEN: (BuildContext context) => AnimatedSplashScreen(),
        HOME_SCREEN: (BuildContext context) => NoteList(),
        LOGIN_SCREEN: (BuildContext context) => LoginPage(),
        INTRO_SCREEN:(BuildContext context) => IntroPage(),
      },
    );
  }
}
