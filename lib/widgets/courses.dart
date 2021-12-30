import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home/http.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Courses extends StatefulWidget {
  Courses({Key? key}) : super(key: key);

  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  List<String> imgList = [];
  // get_image(var id) {
  //   imgList.clear();
  //   for (var item in widget.Images) {
  //     if (item['any_id'] == id) {
  //       var image = item['image'];
  //       var full = widget.url.toString() + image;
  //       imgList.add(full);
  //     }
  //   }
  //   return imgList;
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Courses').snapshots(),
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
                        backgroundImage: AssetImage('assets/images/logo.jpg'),
                      ),
                      title: Text(snapshot.data!.docs[index]['title']),
                      subtitle: Text(snapshot.data!.docs[index]['m_name']),
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
                              child: Text(
                                  snapshot.data!.docs[index]['description']),
                            )),
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
                                        imageUrl: snapshot.data!.docs[index]
                                            ['image'][0],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        value: downloadProgress
                                                            .progress)),
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
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
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
                                              ),
                                            ))
                                        .toList(),
                                  ),
                        ButtonBar(
                            alignment: MainAxisAlignment.spaceAround,
                            buttonHeight: 52.0,
                            buttonMinWidth: 90.0,
                            children: <Widget>[
                              TextButton(
                                  style: flatButtonStyle,
                                  onPressed: () async {
                                    var url =
                                        snapshot.data!.docs[index]['link'];
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
                                        padding: const EdgeInsets.symmetric(
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
          }
        });
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );
}
