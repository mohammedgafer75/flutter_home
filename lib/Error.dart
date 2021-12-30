import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_home/ErrorPage.dart';
import 'package:flutter_home/http.dart';
import 'package:provider/provider.dart';

class Error extends StatefulWidget {
  Error({Key? key}) : super(key: key);

  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<Error> {
  @override
  void initState() {
    super.initState();
    get_data();
  }

  int ch = 1;
  @override
  Widget build(BuildContext context) {
    // Body = Ui_list;
    return ChangeNotifierProvider(
        create: (context) {
          return A();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Error Page'),
              backgroundColor: Color.fromRGBO(19, 26, 44, 1.0),
              actions: [
                IconButton(
                    onPressed: () =>
                        showSearch(context: context, delegate: search(list)),
                    icon: Icon(Icons.search))
              ],
            ),
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Error')
                    .where("type", isEqualTo: ch)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    print(snapshot.data!.docs.length);
                    Body = snapshot.data!.docs;
                    return Column(
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
                                child:
                                    Consumer<A>(builder: (context, a, child) {
                                  // Body = Ui_list;
                                  return TabBar(
                                    onTap: (int index) {
                                      switch (index) {
                                        case 0:
                                          setState(() {
                                            ch = 1;
                                          });

                                          a.DoSomethings();
                                          break;
                                        case 1:
                                          setState(() {
                                            ch = 2;
                                          });
                                          a.DoSomethings();
                                          break;
                                        case 2:
                                          setState(() {
                                            ch = 3;
                                          });
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
                                    //  borderRadius: BorderRadius.circular(7),
                                    //color: Colors.white,
                                    //),
                                    tabs: [
                                      Tab(
                                        text: 'UI Error',
                                      ),
                                      Tab(
                                        text: 'PackEnd Error',
                                      ),
                                      Tab(
                                        text: 'Gradle Error',
                                      ),
                                    ],
                                  );
                                }))),
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
                                child:
                                    Consumer<A>(builder: (context, a, child) {
                                  return Body.isEmpty
                                      ? Center(
                                          child: Text('No Errors Founded'),
                                        )
                                      : ListView.builder(
                                          itemCount: Body.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ExpansionTileCard(
                                                //key: cardA,
                                                title:
                                                    Text(Body[index]['title']),
                                                // subtitle: Text('tab to get more information'),
                                                children: <Widget>[
                                                  Divider(
                                                    thickness: 1.0,
                                                    height: 1.0,
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 8.0,
                                                        ),
                                                        child: Text(Body[index]
                                                            ['description']),
                                                      )),
                                                  ButtonBar(
                                                      alignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      buttonHeight: 52.0,
                                                      buttonMinWidth: 90.0,
                                                      children: <Widget>[
                                                        TextButton(
                                                            style:
                                                                flatButtonStyle,
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ErrorPage(
                                                                              Data: Body[index],
                                                                            )),
                                                              );
                                                            },
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Icon(Icons
                                                                    .open_in_new_rounded),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          2.0),
                                                                ),
                                                                Text('Open'),
                                                              ],
                                                            )),
                                                      ])
                                                ]);
                                          });
                                })))
                      ],
                    );
                  }
                })));
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );
  dynamic Body;

  List finalData = [];
  List<String> list = [];
  Future get_data() async {
    var res = await FirebaseFirestore.instance.collection('Error').get();
    List<String> name1 = [];
    res.docs.forEach((element) {
      name1.add(element['title']);
    });
    setState(() {
      finalData = name1;
    });
    if (finalData.isNotEmpty) {
      setState(() {
        list =
            List.generate(finalData.length, (index) => "${finalData[index]}");
      });
    }
    // Apps_list = res;
    // Courses_list = res2;

    // setState(() {
    //   if (res) {
    //     Data = List.generate(
    //         res.data.length, (index) => "${res.data[index]['title']}");
    //   }
    //   if (res2.data.isNotEmpty) {
    //     Data2 = List.generate(
    //         res2.data.length, (index) => "${res2.data[index]['name']}");
    //   }
    //   finalData = Data + Data2;
    //   print(finalData);
    // });
    // if (finalData.isNotEmpty) {
    //   setState(() {
    //     list =
    //         List.generate(finalData.length, (index) => "${finalData[index]}");
    //   });
    // }
    print(list);
    return list;
  }
}

class A with ChangeNotifier {
  DoSomethings() {
    notifyListeners();
  }
}

class search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";
  @override
  Widget buildResults(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
        appBar: AppBar(title: Text('Search Result'),),
        body: Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Error')
              .where("title", isEqualTo: selectedResult)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No Data Founded'),
                );
              } else {
            return ListView.builder(
                itemBuilder: (BuildContext context, int index) {

        return Container(
          height: height /2,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                SizedBox(
                  height: data.size.height * 0.03,
                ),
                Text(
                  snapshot.data!.docs[index]['title'],
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                ),
                SizedBox(
                  height: data.size.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(snapshot.data!.docs[index]['description'],style: TextStyle(color: Colors.black, fontSize: 16.0),),
                ),
                SizedBox(
                  height: data.size.height * 0.02,
                ),
                Column(
                  children: [
                    Text('Error code:'),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF1E6FF),
                        borderRadius: BorderRadius.circular(29),
                      ),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(snapshot.data!.docs[index]['error_code']),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text('solve code:'),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF1E6FF),
                        borderRadius: BorderRadius.circular(29),
                      ),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(snapshot.data!.docs[index]['solve_code']),
                    )
                  ],
                ),
                snapshot.data!.docs[index]['image'].length == 0
                    ? Container()
                    : snapshot.data!.docs[index]['image'].length == 1
                    ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(29),
                    ),
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data!.docs[index]['image'][0],
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: downloadProgress.progress)),
                        // errorWidget: (context, url, error) =>
                        //     (Icon(Icons.error)),
                        width: 1000,
                      ),
                    ))
                    : CarouselSlider(
                  options: CarouselOptions(
                    //aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: snapshot.data!.docs[index]['image']
                      .map<Widget>((item) => Container(
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: item,
                        progressIndicatorBuilder: (context, url,
                            downloadProgress) =>
                            Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value: downloadProgress
                                        .progress)),
                        errorWidget: (context, url, error) =>
                        (Icon(Icons.error)),
                        width: 1000,
                      ),
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },itemCount: snapshot.data!.docs.length,);}}}),
    ));
  }

  List<String> listExample = [];
  List<String> recentList = [];
  search(this.listExample);

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList //In the true case
        : suggestionList.addAll(listExample.where(
            // In the false case
            (element) => element.contains(query),
          ));
    return ListView.builder(
      itemCount: suggestionList.length == 0
          ? suggestionList.length + 1
          : suggestionList.length,
      itemBuilder: (context, index) {
        return Conditional.single(
          context: context,
          conditionBuilder: (BuildContext context) => suggestionList.isEmpty,
          widgetBuilder: (BuildContext context) {
            return ListTile(
              title: Text("No Error Founded"),
              leading: SizedBox(),
            );
          },
          fallbackBuilder: (BuildContext context) {
            return ListTile(
              title: Text(
                suggestionList[index],
              ),
              leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
              onTap: () {
                selectedResult = suggestionList[index];
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return buildResults(context);
                }));
              },
            );
          },
        );
      },
    );
  }
}
