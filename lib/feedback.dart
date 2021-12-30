import 'package:flutter/material.dart';
import 'package:flutter_home/http.dart';
import 'package:flutter_home/services/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FeedBack extends StatefulWidget {
  FeedBack({Key? key}) : super(key: key);

  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  TextEditingController title = new TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Sent FeedBack'),
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
                      labelText: "Your Feed Back",
                      border: InputBorder.none,
                    ),
                    // validator: (value) {
                    //   if (value.isEmpty) return getTranslate(context, "pEmail");
                    //   //if (!regex.hasMatch(value))
                    //   // return getTranslate(
                    //   // context, "eEmail");
                    //   return null;
                    // },
                  ),
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
                          add_comment(context);
                        });
                      },
                      child:
                          Text('Add', style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> add_comment(context) async {
    showLoadingDialog(context);

    late int ch;
    var res = await addFeddback(title: title.text);
    if (res.ch == 1) {
      setState(() {
        title.clear();
        Navigator.of(context).pop();
        showBar(context, "FedBack Added!!", 1);
      });
    } else {
      setState(() {
        Navigator.of(context).pop();
        showBar(context, res.data, 0);
      });
    }
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
