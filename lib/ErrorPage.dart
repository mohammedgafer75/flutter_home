import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, required this.Data}) : super(key: key);
  final dynamic Data;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            SizedBox(
              height: data.size.height * 0.03,
            ),
            Text(
              Data['title'],
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            ),
            SizedBox(
              height: data.size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(Data['description']),
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
                  child: Text(Data['error_code']),
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
                  child: Text(Data['solve_code']),
                )
              ],
            ),
            Data['image'].length == 0
                ? Container()
                : Data['image'].length == 1
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(29),
                        ),
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: Data['image'][0],
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
                        items: Data['image']
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
  }
}
