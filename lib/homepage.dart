import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home/AddComment.dart';
import 'package:flutter_home/AddScreen.dart';
import 'package:flutter_home/PostPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_home/http.dart';
import 'package:flutter_home/services/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  late SharedPreferences sharedpreference;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool colors = false;
  @override
  Widget build(BuildContext context) {
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
              title: Text('Post Page'),
              actions: [Icon(Icons.search)],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color.fromRGBO(19, 26, 44, 1.0),
              child: Icon(Icons.add),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddScreen())),
            ),
            body: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('Post').snapshots(),
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
                              // comment(Data[index]['_id']);
                              // get_save(snapshot.data!.docs[index].reference.id);
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
                                                imageUrl: snapshot.data!
                                                    .docs[index]['user_image'],
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
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['user_name'],
                                                  style: TextStyle(
                                                      color: Colors.grey[900],
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                        child: Text(snapshot.data!.docs[index]
                                            ['title'])),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              // text: Data[index]['title'],
                                              style: TextStyle(
                                                  color: Colors.grey[900],
                                                  letterSpacing: 1)),
                                          TextSpan(
                                              text: snapshot.data!.docs[index]
                                                  ['description'],
                                              style: TextStyle(
                                                  color: Colors.grey[900],
                                                  letterSpacing: 1)),
                                          TextSpan(
                                            text: 'view answers..',
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
                })));
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

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg',
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
