import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_home/Home.dart';
import 'package:flutter_home/http.dart';
import 'package:flutter_home/loading.dart';
import 'package:flutter_home/register.dart';
import 'package:flutter_home/homepage.dart';
import 'package:flutter_home/services/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  ConnectivityResult? _connectivityResult;
  Future check_connect(BuildContext context) async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi) {
      print('Connected to a Wi-Fi network');
    } else if (result == ConnectivityResult.mobile) {
      print('Connected to a mobile network');
    } else {
      showBar(context, 'No internet access', 1);
    }
    // try {
    //   final result = await InternetAddress.lookup('example.com');
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     print('connected');
    //   }
    // } on SocketException catch (_) {
    //   showBar(context, 'no internet access', 1);
    // }
  }

  void showBar(BuildContext context, String msg, int ch) {
    var bar = SnackBar(
      backgroundColor: ch == 0 ? Colors.red : Colors.green,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  showLoadingDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.white.withOpacity(.1),
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(.1),
        content: Center(
          child: SpinKitFadingCube(
            color: Colors.blue,
            size: 50,
          ),
        ),
      ),
    );
  }

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
        body: Builder(
      builder: (context) => Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    Colors.blue.withOpacity(.9),
                    Colors.blue.withOpacity(.3),
                  ])),
            ),
            Padding(
              padding: EdgeInsets.only(top: height / 4),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.end,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 27.0,
                      color: Colors.white,
                    ),
                  )),
                  SizedBox(
                    height: 4,
                  ),
                  Center(
                      child: Text(
                    'Join Flutter Home!',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  )),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      padding:
                          EdgeInsets.only(right: width / 8, left: width / 8),
                      height: height * 0.08,
                      width: width * 1.0,

                      // decoration: BoxDecoration(
                      //   color: Colors.grey[500].withOpacity(0.5),
                      //   borderRadius: BorderRadius.circular(16),
                      // ),
                      child: TextFormField(
                        controller: email,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "please enter your Name";
                          }
                        },
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 3.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white70.withOpacity(.7),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            size: 28,
                            color: Colors.white,
                          ),

                          labelText: 'Name',

                          labelStyle: TextStyle(color: Colors.white),
                          // hintText: hint,
                          //  hintStyle: kBodyText,
                        ),
                        //  style: kBodyText,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      padding:
                          EdgeInsets.only(right: width / 8, left: width / 8),
                      height: height * 0.08,
                      width: width * 1.0,

                      // decoration: BoxDecoration(
                      //   color: Colors.grey[500].withOpacity(0.5),
                      //   borderRadius: BorderRadius.circular(16),
                      // ),
                      child: TextFormField(
                        controller: password,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "please enter your password";
                          }
                        },
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white70.withOpacity(.7),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            size: 28,
                            color: Colors.white,
                          ),

                          labelText: 'Password',

                          labelStyle: TextStyle(color: Colors.white),
                          // hintText: hint,
                          //  hintStyle: kBodyText,
                        ),
                        //  style: kBodyText,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: height / 40,
                              bottom: height / 40,
                              left: width / 8,
                              right: width / 8)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      side: BorderSide(color: Colors.white)))),
                      onPressed: () {
                        login(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Center(
                        child: Text(
                      "Don't have an account",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Center(
                          child: Text(
                        "Create account",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  late int check;
  Future login(BuildContext context) async {
    setState(() {
      showLoadingDialog(context);
    });
    dynamic res =
        await signInwithEmailAndPassword2(email.text.trim(), password.text);
    if (res.ch == 0) {
      setState(() {
        Navigator.of(context).pop();
        showBar(context, res.data, 0);
      });
    } else {
      setState(() {
        print(res.data);
        Navigator.of(context).pop();
        go(res, context);
      });
    }
  }

  Future go(dynamic res, BuildContext context) async {
    SharedPreferences sharedpreference = await SharedPreferences.getInstance();
    sharedpreference.setString("u_id", res.data.uid);
    sharedpreference.setString("login", "ok");
    // sharedpreference.setString("url", res.data.photoURL);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Home()),
        (Route<dynamic> route) => false);
  }
}
