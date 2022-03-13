import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inputgram/screen/approve.dart';
import 'package:inputgram/screen/inputInfo.dart';
import 'package:inputgram/screen/removeInfo.dart';
import 'consts.dart';
import 'package:inputgram/util.dart';
import 'package:inputgram/consts.dart';

class MyApp extends StatelessWidget {
  static String id = "myappscreen";

  MyApp({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarMainAppInfo),
        actions: <Widget>[
          IconButton(
            splashColor: clrIconSpalsh,
            splashRadius: iconSplashRadius,
            tooltip: kTitleSignOut,
            onPressed: () {
              //logout
              popLogOutAlert(context, kTitleSignOut,
                  kSubtitleLogOutConfirmation, Icon(Icons.power_settings_new));
            },
            icon: Icon(Icons.power_settings_new),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Stack(
                children: <Widget>[
                  Text(
                    dHeading,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.yellow,
                    ),
                  ), //gree
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text(dAddEntry),
              tileColor: clrGreen, //green
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, inputInfo.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text(dRemoveEntry),
              tileColor: clrRed, //green
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, removeInfo.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.approval),
              title: Text(dApprove),
              tileColor: clrAmber, //red
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, approve.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
