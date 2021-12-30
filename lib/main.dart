import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home/Home.dart';
import 'package:flutter_home/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  late SharedPreferences sharedpreference;
  var ch_Login;
  var name;
  Future check_login() async {
    await Firebase.initializeApp();
    var sharedpreference = await SharedPreferences.getInstance();
    var login = sharedpreference.getString("login");
    var na = sharedpreference.getString("user_name");

    name = na;

    return ch_Login = login;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplashScreen(
        splash: Image(
          image: AssetImage("assets/images/s.jpg"),
          width: double.maxFinite,
          height: double.maxFinite,
        ),
        nextScreen: FutureBuilder(
            future: check_login(),
            builder: (context, snapshot) {
              return ch_Login == "ok" ? Home() : Login();
            }),
        backgroundColor: Colors.black,
        splashIconSize: double.maxFinite,
        splashTransition: SplashTransition.sizeTransition,
        pageTransitionType: PageTransitionType.rightToLeftWithFade,
      ),
    );
  }
}
