import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Recommended extends StatefulWidget {
  Recommended({Key? key}) : super(key: key);

  @override
  _RecommendedState createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  @override
  void initState() {
    super.initState();
    get_data();
  }



  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
    return ChangeNotifierProvider(
        create: (context) {
          return A();
        },
        child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () =>
                        showSearch(context: context, delegate: search(list)),
                    icon: Icon(Icons.search))
              ],
              title: Text('Recommended Package'),
              backgroundColor: Color.fromRGBO(19, 26, 44, 1.0),
            ),
            body: Consumer<A>(builder: (context, a, child) {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Recommend')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return ExpansionTileCard(
                              //key: cardA,
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/logo.jpg'),
                              ),
                              title: Text(snapshot.data!.docs[index]['title']),
                              subtitle: Text('tab to get more information'),
                              children: <Widget>[
                                Divider(
                                  thickness: 1.0,
                                  height: 1.0,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 8.0,
                                      ),
                                      child: Text(snapshot.data!.docs[index]
                                          ['description']),
                                    )),
                                (snapshot.data!.docs[index]['image'].length == 0
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
                                                imageUrl: snapshot.data!
                                                    .docs[index]['image'][0],
                                                progressIndicatorBuilder: (context,
                                                        url,
                                                        downloadProgress) =>
                                                    Center(
                                                        child: CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            value:
                                                                downloadProgress
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
                                            items:
                                                snapshot
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
                                                                      Center(
                                                                          child: CircularProgressIndicator(
                                                                              strokeWidth: 2,
                                                                              value: downloadProgress.progress)),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      (Icon(Icons
                                                                          .error)),
                                                                  width: 1000,
                                                                ),
                                                              ),
                                                            ))
                                                    .toList(),
                                          )),
                                ButtonBar(
                                    alignment: MainAxisAlignment.spaceAround,
                                    buttonHeight: 52.0,
                                    buttonMinWidth: 90.0,
                                    children: <Widget>[
                                      TextButton(
                                          style: flatButtonStyle,
                                          onPressed: () async {
                                            var url = snapshot.data!.docs[index]
                                                ['link'];
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              print("can not launch $url");
                                            }
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Icon(Icons.share),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2.0),
                                              ),
                                              Text('Open'),
                                            ],
                                          )),
                                    ])
                              ]);
                        },
                        itemCount: snapshot.data!.docs.length,
                      );
                    }
                  });
            })));
  }

  List finalData = [];
  List<String> list = [];
  // ignore: non_constant_identifier_names
  Future get_data() async {
    var res = await FirebaseFirestore.instance.collection('Recommend').get();
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

    print(list);
    return list;
  }
}
class A with ChangeNotifier {
  // ignore: non_constant_identifier_names
  DoSomethings() {
    notifyListeners();
  }
}
// ignore: camel_case_types
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
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
    return Scaffold(
        appBar: AppBar(title: Text('Search Result'),),
        body: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Recommend')
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

                        return ExpansionTileCard(
                          //key: cardA,
                            leading: CircleAvatar(
                              backgroundImage:
                              AssetImage('assets/images/logo.jpg'),
                            ),
                            title: Text(snapshot.data!.docs[index]['title']),
                            subtitle: Text('tab to get more information'),
                            children: <Widget>[
                              Divider(
                                thickness: 1.0,
                                height: 1.0,
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    child: Text(snapshot.data!.docs[index]
                                    ['description']),
                                  )),
                              (snapshot.data!.docs[index]['image'].length == 0
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
                                      imageUrl: snapshot.data!
                                          .docs[index]['image'][0],
                                      progressIndicatorBuilder: (context,
                                          url,
                                          downloadProgress) =>
                                          Center(
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  value:
                                                  downloadProgress
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
                                items:
                                snapshot
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
                                              Center(
                                                  child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      value: downloadProgress.progress)),
                                          errorWidget: (context,
                                              url,
                                              error) =>
                                          (Icon(Icons
                                              .error)),
                                          width: 1000,
                                        ),
                                      ),
                                    ))
                                    .toList(),
                              )),
                              ButtonBar(
                                  alignment: MainAxisAlignment.spaceAround,
                                  buttonHeight: 52.0,
                                  buttonMinWidth: 90.0,
                                  children: <Widget>[
                                    TextButton(
                                        style: flatButtonStyle,
                                        onPressed: () async {
                                          var url = snapshot.data!.docs[index]
                                          ['link'];
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            print("can not launch $url");
                                          }
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Icon(Icons.share),
                                            Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 2.0),
                                            ),
                                            Text('Open'),
                                          ],
                                        )),
                                  ])
                            ]);
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