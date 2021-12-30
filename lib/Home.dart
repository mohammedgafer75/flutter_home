import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_home/Error.dart';
import 'package:flutter_home/drawer.dart';
import 'package:flutter_home/homepage.dart';
import 'package:flutter_home/recommended.dart';
import 'package:flutter_home/Beginner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
  auth.User? user = FirebaseAuth.instance.currentUser;
  
    return AdvancedDrawer(
      drawer: Drawer_w(),
      backdropColor: Color.fromRGBO(19, 26, 44, 1.0),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(19, 26, 44, 1.0),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          title: Text('Flutter Home'),

        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: Container(color: Color.fromRGBO(19, 26, 44, 1.0)),
                  flex: 2,
                ),
                Expanded(
                  child: Container(color: Colors.transparent),
                  flex: 5,
                ),
              ],
            ),
            Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding:
                        EdgeInsets.only(left: 20, right: 20, top: 20),
                    title: Text(
                      'Welcome!!!',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    subtitle: Text(
                     "${user!.displayName}",
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                    trailing: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logo.jpg'),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: GridView.count(
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          crossAxisCount: 2,
                          childAspectRatio: .90,
                          children: [
                            Card_d(
                                icon: Icons.recommend_rounded,
                                title: 'Beginner Tips And Path',
                                nav: Beginner()),
                            Card_d(
                              icon: Icons.report_problem_rounded,
                              title: 'Popular Error',
                              nav: Error(),
                            ),
                            Card_d(
                              icon: Icons.question_answer_rounded,
                              title: 'Posts Page',
                              nav: HomePage(),
                            ),
                            Card_d(
                              icon: Icons.recommend_rounded,
                              title: 'Recommend Package',
                              nav: Recommended(),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}

class Card_d extends StatelessWidget {
  const Card_d(
      {Key? key, required this.title, required this.icon, required this.nav})
      : super(key: key);
  final String title;
  final IconData icon;
  final nav;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return nav;
        }));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, color: Colors.blue, size: 55),
              SizedBox(
                height: 10,
              ),
              Text(title)
            ],
          ),
        ),
      ),
    );
  }
}
