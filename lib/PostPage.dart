import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostPage extends StatefulWidget {
  PostPage({
    Key? key,
    required this.Data,
    required this.Post_id,
  }) : super(key: key);
  final dynamic Data;
  final String Post_id;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  void initState() {
    super.initState();
  }

  bool colors = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return A();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Answers Page'),
              backgroundColor: Color.fromRGBO(19, 26, 44, 1.0),
            ),
            body: Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Comment')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        //  print(answers);
                        return snapshot.data!.docs.isEmpty
                            ? Center(
                                child: Text('No Answers Founded'),
                              )
                            : ListView.builder(
                                // shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return snapshot.data!.docs.isEmpty
                                      ? Center(child: Text('no answer founded'))
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 20,
                                              bottom: 0),
                                          margin: EdgeInsets.only(bottom: 20),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF1E6FF),
                                                  // borderRadius: BorderRadius.circular(29),
                                                ),
                                                padding: EdgeInsets.all(10),
                                                child: Text(snapshot.data!
                                                    .docs[index]['comment']),
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF1E6FF),
                                                  // borderRadius: BorderRadius.circular(29),
                                                ),
                                                child: Text(snapshot
                                                    .data!.docs[index]['code']),
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              snapshot
                                                          .data!
                                                          .docs[index]['image']
                                                          .length ==
                                                      0
                                                  ? Container()
                                                  : snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ['image']
                                                              .length ==
                                                          1
                                                      ? Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        29),
                                                          ),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: Center(
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['image'][0],
                                                              progressIndicatorBuilder: (context,
                                                                      url,
                                                                      downloadProgress) =>
                                                                  CircularProgressIndicator(
                                                                      value: downloadProgress
                                                                          .progress),
                                                              // errorWidget: (context,
                                                              //         url,
                                                              //         error) =>
                                                              //     (Icon(Icons
                                                              //         .error)),
                                                              width: 1000,
                                                            ),
                                                          ))
                                                      : CarouselSlider(
                                                          options:
                                                              CarouselOptions(
                                                            //aspectRatio: 2.0,
                                                            enlargeCenterPage:
                                                                true,
                                                          ),
                                                          items: snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ['image']
                                                              .map<Widget>(
                                                                  (item) =>
                                                                      Container(
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                item,
                                                                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                                                CircularProgressIndicator(value: downloadProgress.progress),
                                                                            // errorWidget: (context, url, error) => (Icon(Icons.error)),
                                                                            width:
                                                                                1000,
                                                                          ),
                                                                        ),
                                                                      ))
                                                              .toList(),
                                                        ),
                                            ],
                                          ),
                                        );
                                });
                      }
                    }))));
  }
}

class A with ChangeNotifier {
  DoSomethings() {
    notifyListeners();
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('image')),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.asset(
              'assets/images/1.jpg',
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
