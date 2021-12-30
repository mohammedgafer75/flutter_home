import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home/http.dart';
import 'package:flutter_home/login.dart';
import 'package:flutter_home/services/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'dart:io';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Center(
          child: SpinKitFadingCube(
            color: Colors.blue,
            size: 50,
          ),
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('register'),
          backgroundColor: Color.fromRGBO(19, 26, 44, 1.0),
        ),
        body: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                        Colors.blue.withOpacity(.9),
                        Colors.blue.withOpacity(.4),
                      ])),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: ListView(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                maxRadius: 70,
                                backgroundImage: _imageFile == null
                                    ? AssetImage('assets/images/user.png')
                                    : Image.file(_imageFile!).image,
                                child: Icon(Icons.add_a_photo,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            imageSelect();
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          padding: EdgeInsets.only(
                              right: width / 8, left: width / 8),
                          height: height * 0.08,
                          width: width * 1.0,

                          // decoration: BoxDecoration(
                          //   color: Colors.grey[500].withOpacity(0.5),
                          //   borderRadius: BorderRadius.circular(16),
                          // ),
                          child: TextFormField(
                            controller: name,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "please enter your Name";
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
                          padding: EdgeInsets.only(
                              right: width / 8, left: width / 8),
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
                                return "please enter your email";
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

                              labelText: 'Email',

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
                          padding: EdgeInsets.only(
                              right: width / 8, left: width / 8),
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
                                return "please enter your Password";
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
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.only(
                                      top: height / 40,
                                      bottom: height / 40,
                                      left: width / 8,
                                      right: width / 8)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      side: BorderSide(color: Colors.white)))),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_imageFile == null) {
                                showBar(context, "Please Add image !!!", 0);
                              } else {
                                setState(() {
                                  showLoadingDialog(context);
                                });
                                dynamic res =
                                    await CreateUserwithEmailAndPassword(
                                        name.text.trim(),
                                        email.text.trim(),
                                        password.text);

                                if (res.ch == 0) {
                                  setState(() {
                                    Navigator.of(context).pop();
                                    showBar(context, res.data, 0);
                                  });
                                } else {
                                  uploadImageToFirebase(context);

                                  setState(() {
                                    Navigator.of(context).pop();
                                    showBar(context,
                                        "User created !! Back to Login", 1);
                                  });
                                }
                              }
                            }
                          },
                          child: Text(
                            'SignUp',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50)),
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Center(
                            child: Text(
                          "Already have an account",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Center(
                              child: Text(
                            "Login",
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

  void showBar(BuildContext context, String msg, int ch) {
    var bar = SnackBar(
      backgroundColor: ch == 0 ? Colors.red : Colors.green,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  late int check;
  Future CreateUser(BuildContext context) async {
    showLoadingDialog(context);
    print(email.text);
    dynamic res = await CreateUserwithEmailAndPassword(
        name.text.trim(), email.text.trim(), password.text.trim());
    if (res.ch == 0) {
      setState(() {
        Navigator.of(context).pop();
        showBar(context, res.data, 0);
      });
    } else {
      setState(() {
        Navigator.of(context).pop();
        print(res.data);
        showBar(context, "User created !! Back to Login", 1);
      });
    }
  }

  String? url;
  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile!.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
    url = await taskSnapshot.ref.getDownloadURL();
    if (url!.isNotEmpty) {
      auth.User? user = FirebaseAuth.instance.currentUser;
      user!.updatePhotoURL(url);
      await user.reload();
      print('this is result:$user');
      return user;
    } else {}
  }

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  void imageSelect() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage!.path.isNotEmpty) {
      setState(() {
        _imageFile = File(selectedImage.path);
      });
    }
  }
}
