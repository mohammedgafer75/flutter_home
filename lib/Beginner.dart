import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home/http.dart';
import 'package:flutter_home/models/app.dart';
import 'package:flutter_home/widgets/apps.dart';
import 'package:flutter_home/widgets/courses.dart';
import 'package:flutter_home/widgets/setup.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:url_launcher/url_launcher.dart';

class Beginner extends StatefulWidget {
  Beginner({Key? key}) : super(key: key);

  @override
  _BeginnerState createState() => _BeginnerState();
}

class _BeginnerState extends State<Beginner> {
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Body = Setup();
    return ChangeNotifierProvider(
        create: (context) {
          return A();
        },
        child: Scaffold(
            appBar: AppBar(

              title: Text('Beginner'),
              backgroundColor: Color.fromRGBO(19, 26, 44, 1.0),
            ),
            body: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    color: Color.fromRGBO(19, 26, 44, 1.0),
                  ),
                  child: DefaultTabController(
                      length: 3,
                      child: Consumer<A>(
                        builder: (context, a, child) {
                          return TabBar(
                            onTap: (int index) {
                              switch (index) {
                                case 0:
                                  Body = Setup();
                                  a.DoSomethings();
                                  break;
                                case 1:
                                  Body = Courses();
                                  a.DoSomethings();
                                  break;
                                case 2:
                                  Body = Apps();
                                  a.DoSomethings();
                                  break;
                              }
                            },
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                            indicatorSize: TabBarIndicatorSize.label,
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.white,
                            isScrollable: true,
                            //indicator: BoxDecoration(
                            //borderRadius: BorderRadius.circular(10),
                            // color: Colors.white,
                            //),
                            tabs: [
                              Tab(
                                text: 'Setup',
                              ),
                              Tab(
                                text: 'Courses',
                              ),
                              Tab(
                                text: 'UseFull Apps',
                              ),
                            ],
                          );
                        },
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        // color: Color.fromRGBO(19, 26, 44, 1.0),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Consumer<A>(builder: (context, a, child) {
                          return Body;
                        })))
              ],
            )));
  }

  late Widget Body;
//  var Courses_list;
//  late Stream<QuerySnapshot<Map<String, dynamic>>> Search;
//
//
//  List finalData = [];
//  List<String> list = [];
//  Future get_data() async {
//    var  res = await FirebaseFirestore.instance.collection('Apps').get();
//    var  res2 = await FirebaseFirestore.instance.collection('Courses').get();
//    List<String> name1 = [];
//    List<String> name2 = [];
//    res.docs.forEach((element) {
//      name1.add(element['name']);
//    });
//    res2.docs.forEach((element) {
//      name2.add(element['title']);
//    });
//    setState(() {
//      finalData = name1 + name2;
//    });
//    if (finalData.isNotEmpty) {
//      setState(() {
//        list =
//            List.generate(finalData.length, (index) => "${finalData[index]}");
//      });
//    }
//
//    return list;
//  }
//
//  // Future<void> getAllImages() async {
//  //   var res3 = await http_get('api/images');
//  //   if (res.ok) {
//  //     return UImages = res.data;
//  //   }
//  // }
}

class A with ChangeNotifier {
  DoSomethings() {
    notifyListeners();
  }
}

//class search extends SearchDelegate {
//  @override
//  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
//    shape: const RoundedRectangleBorder(
//      borderRadius: BorderRadius.all(Radius.circular(4.0)),
//    ),
//  );
//  List<Widget> buildActions(BuildContext context) {
//    return <Widget>[
//      IconButton(
//        icon: Icon(Icons.close),
//        onPressed: () {
//          query = "";
//        },
//      ),
//    ];
//  }
//
//  @override
//  Widget buildLeading(BuildContext context) {
//    return IconButton(
//      icon: Icon(Icons.arrow_back),
//      onPressed: () {
//        Navigator.pop(context);
//      },
//    );
//  }
//
// late String selectedResult ;
// dynamic Full ;
//
//  @override
//  Widget buildResults(BuildContext context) {
//    return StreamBuilder(
//        stream:Full.where('title',isEqualTo: selectedResult).snapshots(),
//        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//          if (!snapshot.hasData) {
//            return Center(
//              child: CircularProgressIndicator(),
//            );
//          } else {
//            if (snapshot.data!.docs.isEmpty) {
//              return Center(
//                child: Text('No Data Founded'),
//              );
//            } else {
//              return ListView.builder(
//                itemBuilder: (BuildContext context, int index) {
//                  return ExpansionTileCard(
//                    //key: cardA,
//                      leading: CircleAvatar(
//                        backgroundImage: AssetImage('assets/images/logo.jpg'),
//                      ),
//                      title: Text(snapshot.data!.docs[index]['title']),
//                      subtitle: Text(snapshot.data!.docs[index]['m_name']),
//                      children: <Widget>[
//                        Divider(
//                          thickness: 1.0,
//                          height: 1.0,
//                        ),
//                        Align(
//                            alignment: Alignment.centerLeft,
//                            child: Padding(
//                              padding: const EdgeInsets.symmetric(
//                                horizontal: 16.0,
//                                vertical: 8.0,
//                              ),
//                              child: Text(
//                                  snapshot.data!.docs[index]['description']),
//                            )),
//                        snapshot.data!.docs[index]['image'].length == 0
//                            ? Container()
//                            : snapshot.data!.docs[index]['image'].length == 1
//                            ? Container(
//                            decoration: BoxDecoration(
//                              borderRadius: BorderRadius.circular(29),
//                            ),
//                            padding: EdgeInsets.all(15),
//                            child: Center(
//                              child: CachedNetworkImage(
//                                imageUrl: snapshot.data!.docs[index]
//                                ['image'][0],
//                                imageBuilder:
//                                    (context, imageProvider) =>
//                                    Container(
//                                      decoration: BoxDecoration(
//                                        image: DecorationImage(
//                                          image: imageProvider,
//                                          fit: BoxFit.cover,
//                                        ),
//                                      ),
//                                    ),
//                                progressIndicatorBuilder: (context, url,
//                                    downloadProgress) =>
//                                    Center(
//                                        child:
//                                        CircularProgressIndicator(
//                                            strokeWidth: 2,
//                                            value: downloadProgress
//                                                .progress)),
//                                // errorWidget: (context, url, error) =>
//                                //     (Icon(Icons.error)),
//                                width: 1000,
//                              ),
//                            ))
//                            : CarouselSlider(
//                          options: CarouselOptions(
//                            //aspectRatio: 2.0,
//                            enlargeCenterPage: true,
//                          ),
//                          items: snapshot.data!.docs[index]['image']
//                              .map<Widget>((item) => Container(
//                            child: Center(
//                              child: CachedNetworkImage(
//                                imageUrl: item,
//                                imageBuilder: (context,
//                                    imageProvider) =>
//                                    Container(
//                                      decoration: BoxDecoration(
//                                        image: DecorationImage(
//                                          image: imageProvider,
//                                          fit: BoxFit.cover,
//                                        ),
//                                      ),
//                                    ),
//                                progressIndicatorBuilder: (context,
//                                    url,
//                                    downloadProgress) =>
//                                    Center(
//                                        child: CircularProgressIndicator(
//                                            strokeWidth: 2,
//                                            value:
//                                            downloadProgress
//                                                .progress)),
//                                // errorWidget:
//                                //     (context, url, error) =>
//                                //         (Icon(Icons.error)),
//                                width: 1000,
//                              ),
//                            ),
//                          ))
//                              .toList(),
//                        ),
//                        ButtonBar(
//                            alignment: MainAxisAlignment.spaceAround,
//                            buttonHeight: 52.0,
//                            buttonMinWidth: 90.0,
//                            children: <Widget>[
//                              TextButton(
//                                  style: flatButtonStyle,
//                                  onPressed: () async {
//                                    var url =
//                                    snapshot.data!.docs[index]['link'];
//                                    if (await canLaunch(url)) {
//                                      await launch(url);
//                                    } else {
//                                      print("can not launch $url");
//                                    }
//                                  },
//                                  child: Column(
//                                    children: <Widget>[
//                                      Icon(Icons.share),
//                                      Padding(
//                                        padding: const EdgeInsets.symmetric(
//                                            vertical: 2.0),
//                                      ),
//                                      Text('Open'),
//                                    ],
//                                  )),
//                            ])
//                      ]);
//                },
//                itemCount: snapshot.data!.docs.length,
//              );
//            }
//          }
//        });
//  }
//
//  List<String> listExample = [];
//  List<String> recentList = [];
//  search(this.listExample,this.Full);
//
//  @override
//  Widget buildSuggestions(BuildContext context) {
//    List<String> suggestionList = [];
//    query.isEmpty
//        ? suggestionList = recentList //In the true case
//        : suggestionList.addAll(listExample.where(
//            // In the false case
//            (element) => element.contains(query),
//          ));
//    return ListView.builder(
//      itemCount: suggestionList.length == 0
//          ? suggestionList.length + 1
//          : suggestionList.length,
//      itemBuilder: (context, index) {
//        return Conditional.single(
//          context: context,
//          conditionBuilder: (BuildContext context) => suggestionList.isEmpty,
//          widgetBuilder: (BuildContext context) {
//            return ListTile(
//              title: Text("No Mission Founded"),
//              leading: SizedBox(),
//            );
//          },
//          fallbackBuilder: (BuildContext context) {
//            return ListTile(
//              title: Text(
//                suggestionList[index],
//              ),
//              leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
//              onTap: () {
//
//                selectedResult = suggestionList[index];
//                print(selectedResult);
//              },
//            );
//          },
//        );
//      },
//    );
//  }
//}
