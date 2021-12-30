import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Setup extends StatefulWidget {
  Setup({Key? key}) : super(key: key);

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: height / 4,
      ),
      padding:
          EdgeInsets.only(top: height / 40, left: width / 8, right: width / 8),
      child: Center(
        child: GridView.count(
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            crossAxisCount: 2,
            childAspectRatio: .90,
            children: [
              Card_d(
                icon: Icon(Icons.addchart, size: 30, color: Colors.white),
                title: 'Doc',
                nav: 'https://flutter.dev/docs/get-started/install',
              ),
              Card_d(
                icon: Icon(Icons.recommend_rounded,
                    size: 30, color: Colors.white),
                title: 'Video  ',
                nav: 'https://www.youtube.com/watch?v=uCnLDDwLxVA',
              ),
            ]),
      ),
    );
  }
}

class Card_d extends StatelessWidget {
  void showBar(BuildContext context, String msg) {
    var bar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  const Card_d(
      {Key? key, required this.title, required this.icon, required this.nav})
      : super(key: key);
  final String title;
  final icon;
  final nav;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bool a = await canLaunch(nav);
        if (a == false) {
          showBar(context, 'link can not launch');
        } else {
          launch(nav);
        }
      },
      child: Card(
        color: Color.fromRGBO(91, 55, 185, 1.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(child: icon),
              SizedBox(
                height: 10,
              ),
              Text(title, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
