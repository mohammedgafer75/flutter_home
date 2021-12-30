import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_home/SavedPost.dart';
import 'package:flutter_home/login.dart';
import 'package:flutter_home/savedReco.dart';
import 'package:flutter_home/feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drawer_w extends StatefulWidget {
  const Drawer_w({
    Key? key,
  }) : super(key: key);

  @override
  _Drawer_wState createState() => _Drawer_wState();
}

class _Drawer_wState extends State<Drawer_w> {
  @override
  Widget build(BuildContext context) {
    auth.User? user = FirebaseAuth.instance.currentUser;
    String url = user!.photoURL!;
    final data = MediaQuery.of(context);
    return SafeArea(
      child: Container(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  //color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: url,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) => (Icon(Icons.error)),
                  width: 1000,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SavedPost()));
                },
                leading: Icon(Icons.turned_in),
                title: Text('My Posts'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FeedBack()));
                },
                leading: Icon(Icons.feedback_outlined),
                title: Text('FeedBack'),
              ),
              Spacer(),
              Column(
                children: [
                  SizedBox(
                    height: data.size.height * 0.02,
                  ),
                  ListTile(
                    title: Text(
                      'LogOut',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    //leading: Icon(
                    //   Icons.input,
                    //  color: Colors.black,
                    // ),
                    onTap: () async {
                      go();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                          (Route<dynamic> route) => false);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  late SharedPreferences sharedpreference;

  Future go() async {
    SharedPreferences sharedpreference = await SharedPreferences.getInstance();

    sharedpreference.setString("login", '');
  }
}
