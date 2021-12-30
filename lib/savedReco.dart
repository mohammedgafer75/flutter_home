import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedReco extends StatefulWidget {
  SavedReco({Key? key}) : super(key: key);

  @override
  _SavedRecoState createState() => _SavedRecoState();
}

class _SavedRecoState extends State<SavedReco> {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  @override
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
            title: Text('Saved Recommended package'),
            backgroundColor: Color.fromRGBO(19, 26, 44, 1.0),
          ),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('SaveRecommend')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return snapshot.data!.docs.isEmpty
                      ? Center(
                          child: Text('no Data Founded'),
                        )
                      : ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return ExpansionTileCard(
                                //key: cardA,
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/logo.jpg'),
                                ),
                                title:
                                    Text(snapshot.data!.docs[index]['title']),
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
                                  snapshot.data!.docs[index]['image'].length ==
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
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          (Icon(Icons.error)),
                                                  width: 1000,
                                                ),
                                              ))
                                          : CarouselSlider(
                                              options: CarouselOptions(
                                                //aspectRatio: 2.0,
                                                enlargeCenterPage: true,
                                              ),
                                              items:
                                                  snapshot.data!
                                                      .docs[index]['image']
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
                                                                            child:
                                                                                CircularProgressIndicator(strokeWidth: 2, value: downloadProgress.progress)),
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
                                  ButtonBar(
                                      alignment: MainAxisAlignment.spaceAround,
                                      buttonHeight: 52.0,
                                      buttonMinWidth: 90.0,
                                      children: <Widget>[
                                        // Consumer<A>(builder: (context, a, child) {
                                        //   return TextButton(
                                        //     style: flatButtonStyle,
                                        //     onPressed: () {
                                        //       make_save(reco[index]['_id']);
                                        //       a.DoSomethings();
                                        //     },
                                        //     child: Column(
                                        //       children: <Widget>[
                                        //         Icon(
                                        //           Icons.turned_in,
                                        //           color: get_save(reco[index]['_id']),
                                        //         ),
                                        //         Padding(
                                        //           padding: const EdgeInsets.symmetric(
                                        //               vertical: 2.0),
                                        //         ),
                                        //         Text('Save'),
                                        //       ],
                                        //     ),
                                        //   );
                                        // }),
                                        TextButton(
                                            style: flatButtonStyle,
                                            onPressed: () async {
                                              var url = snapshot
                                                  .data!.docs[index]['link'];
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
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 2.0),
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
              }),
        ));
  }
}

class A with ChangeNotifier {
  DoSomethings() {
    notifyListeners();
  }
}
