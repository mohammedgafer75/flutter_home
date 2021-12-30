import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home/AddComment.dart';
import 'package:flutter_home/AddScreen.dart';
import 'package:flutter_home/PostPage.dart';
import 'package:flutter_home/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedPost extends StatefulWidget {
  SavedPost({Key? key}) : super(key: key);

  @override
  _SavedPostState createState() => _SavedPostState();
}

class _SavedPostState extends State<SavedPost> {
  late SharedPreferences sharedpreference;
  int b = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool colors = false;
  @override
  Widget build(BuildContext context) {
    auth.User? user = FirebaseAuth.instance.currentUser;
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;

    return ChangeNotifierProvider(
        create: (context) {
          return A();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(19, 26, 44, 1.0),
            title: Text('Saved Post'),
            actions: [Icon(Icons.search)],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromRGBO(19, 26, 44, 1.0),
            child: Icon(Icons.add),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddScreen())),
          ),
          body: Consumer<A>(builder: (context, a, child) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Post')
                    .where("user_id", isEqualTo: user!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return snapshot.data!.docs.isEmpty
                        ? Center(
                            child: Text('No Data Founded'),
                          )
                        : ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFF1E6FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                                height: data.size.height / 10,
                                                width: data.size.width / 8,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  // image: DecorationImage(
                                                  //   image: Image.network(
                                                  //       "assets/images/house_01.jpg"),
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      snapshot.data!.docs[index]
                                                          ['user_image'],
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          (Icon(Icons.error)),
                                                  width: 500,
                                                )),
                                            SizedBox(
                                              width: width / 30,
                                            ),
                                            Text(
                                              snapshot.data!.docs[index]
                                                  ['user_name'],
                                              style: TextStyle(
                                                  color: Colors.grey[900],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: snapshot.data!.docs[index]
                                                  ['title'],
                                              style: TextStyle(
                                                  color: Colors.grey[900],
                                                  letterSpacing: 1)),
                                          TextSpan(
                                            text: 'read more..',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                letterSpacing: 1),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PostPage(
                                                              Data: snapshot
                                                                  .data!
                                                                  .docs[index],
                                                              Post_id: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .reference
                                                                  .id,
                                                            )));
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    snapshot.data!.docs[index]['image']
                                                .length ==
                                            0
                                        ? Container()
                                        : snapshot.data!.docs[index]['image']
                                                    .length ==
                                                1
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(29),
                                                ),
                                                padding: EdgeInsets.all(15),
                                                child: Center(
                                                  child: CachedNetworkImage(
                                                    imageUrl: snapshot
                                                            .data!.docs[index]
                                                        ['image'][0],
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        Center(
                                                            child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                value: downloadProgress
                                                                    .progress)),
                                                    // errorWidget:
                                                    //     (context, url, error) =>
                                                    //         (Icon(Icons.error)),
                                                    width: 1000,
                                                  ),
                                                ))
                                            : CarouselSlider(
                                                options: CarouselOptions(
                                                  //aspectRatio: 2.0,
                                                  enlargeCenterPage: true,
                                                ),
                                                items: snapshot
                                                    .data!.docs[index]['image']
                                                    .map<Widget>(
                                                        (item) => Container(
                                                              child: Center(
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl:
                                                                      item,
                                                                  progressIndicatorBuilder: (context,
                                                                          url,
                                                                          downloadProgress) =>
                                                                      Text(
                                                                          'loading...'),
                                                                  // errorWidget: (context,
                                                                  //         url,
                                                                  //         error) =>
                                                                  //     (Icon(Icons
                                                                  //         .error)),
                                                                  width: 1000,
                                                                ),
                                                              ),
                                                            ))
                                                    .toList(),
                                              ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddComment(
                                                            id: snapshot
                                                                .data!
                                                                .docs[index]
                                                                .reference
                                                                .id)));
                                          },
                                          child: makeCommentButton()),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: snapshot.data!.docs.length,
                          );
                  }
                });
          }),
          // body: Save == null
          //     ? Center(child: CircularProgressIndicator())
          //     : Container(
          //         padding:
          //             EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          //         child: ListView.builder(
          //             itemCount: Data.length,
          //             itemBuilder: (BuildContext context, int index) {
          //               return
          //             })),
        ));
  }
}

class A with ChangeNotifier {
  DoSomethings() {
    notifyListeners();
  }
}

Widget makeCommentButton() {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.chat, color: Colors.grey, size: 18),
          SizedBox(
            width: 5,
          ),
          Text(
            "Answer",
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    ),
  );
}
