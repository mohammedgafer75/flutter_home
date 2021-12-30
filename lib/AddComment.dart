import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_home/services/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddComment extends StatefulWidget {
  AddComment({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  void initState() {
    super.initState();
  }

  TextEditingController title = new TextEditingController();
  TextEditingController code = new TextEditingController();

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(_imageFileList!.length);
    final data = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Answer'),
          backgroundColor: Color.fromRGBO(19, 26, 44, 1.0),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: data.size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Color(0xFFF1E6FF),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: TextFormField(
                    cursorColor: Color(0xFF6F35A5),
                    maxLines: null,
                    controller: title,
                    decoration: InputDecoration(
                      labelText: "Your Anwser",
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return "please Add your Answer";
                      //if (!regex.hasMatch(value))
                      // return getTranslate(
                      // context, "eEmail");
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: data.size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Color(0xFFF1E6FF),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: TextFormField(
                    cursorColor: Color(0xFF6F35A5),
                    maxLines: null,
                    controller: code,
                    decoration: InputDecoration(
                      labelText: "Code",
                      hintText: 'You Can Add A Code',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return "please Add A code ";
                      //if (!regex.hasMatch(value))
                      // return getTranslate(
                      // context, "eEmail");
                      return null;
                    },
                  ),
                ),
                _imageFileList!.length == 0
                    ? Container()
                    : _imageFileList!.length == 1
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(29),
                            ),
                            padding: EdgeInsets.all(15),
                            child: Center(
                                child: Image.file(File(_imageFileList![0].path),
                                    fit: BoxFit.cover, width: 1000)),
                          )
                        : CarouselSlider(
                            options: CarouselOptions(
                              //aspectRatio: 2.0,
                              enlargeCenterPage: true,
                            ),
                            items: _imageFileList!
                                .map<Widget>((item) => Container(
                                      child: Center(
                                          child: Image.file(File(item.path),
                                              fit: BoxFit.cover, width: 1000)),
                                    ))
                                .toList(),
                          ),
                Center(
                  child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: 10, bottom: 10, left: 15, right: 15)),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(19, 26, 44, 1.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      side: BorderSide(
                                          color: Color.fromRGBO(
                                              19, 26, 44, 1.0))))),
                      onPressed: () {
                        imageSelect();
                      },
                      child: Text('add image',
                          style: TextStyle(color: Colors.white))),
                ),
                Center(
                  child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: 10, bottom: 10, left: 15, right: 15)),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(19, 26, 44, 1.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      side: BorderSide(
                                          color: Color.fromRGBO(
                                              19, 26, 44, 1.0))))),
                      onPressed: () {
                        setState(() {
                          showLoadingDialog(context);
                        });
                        setState(() async {
                          await uploadImageToFirebase();
                          if (images_url.length == _imageFileList!.length) {
                            add_comment(widget.id, context);
                          }
                        });
                      },
                      child:
                          Text('Post', style: TextStyle(color: Colors.white))),
                ),
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

  int ch1 = 0;
  Future<void> add_comment(String id, context) async {
    auth.User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    print(id);
    var res = await addComment(
        user_id: uid,
        post_id: id,
        title: title.text,
        code: code.text,
        image: images_url);
    if (res.ch == 1) {
      setState(() {
        title.clear();
        code.clear();
        _imageFileList = [];
        images_url = [];
        Navigator.of(context).pop();
        showBar(context, "Comment Added!!", 1);
      });
    } else {
      setState(() {
        Navigator.of(context).pop();
        showBar(context, res.data, 0);
      });
    }
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList = [];
  late File _imageFile;
  List images_url = [];
  void imageSelect() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage!.path.isNotEmpty) {
      setState(() {
        _imageFileList!.add(selectedImage);
      });
    }
  }

  Future uploadImageToFirebase() async {
    for (var item in _imageFileList!) {
      String fileName = basename(item.path);

      _imageFile = File(item.path);

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      await taskSnapshot.ref.getDownloadURL().then(
            (value) => images_url.add(value),
          );
    }
    setState(() {
      images_url;
    });
  }

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
}
