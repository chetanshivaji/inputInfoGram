import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inputgram/screen/approve.dart';
import 'package:inputgram/screen/inputInfo.dart';
import 'package:inputgram/screen/removeInfo.dart';
import 'consts.dart';
import 'package:inputgram/util.dart';

class MyApp extends StatelessWidget {
  static String id = "myappscreen";
  MyApp({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;
  String welcomeString =
      "Welcome Admin! $userMail\n$access From $adminVillage $adminPin";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin, Register, approve, make db'),
        actions: <Widget>[
          IconButton(
            tooltip: "Log out",
            onPressed: () {
              //logout
              popLogOutAlert(context, "SignOut", "Do you want to log out?",
                  Icon(Icons.power_settings_new));
            },
            icon: Icon(Icons.power_settings_new),
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          Text(
            welcomeString,
          ),
          const SizedBox(
            width: 20.0,
            height: 100.0,
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
                    'Admin',
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
              title: Text('addEntry'),
              tileColor: clrGreen, //green
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, inputInfo.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text('removeEntry'),
              tileColor: clrRed, //green
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, removeInfo.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.approval),
              title: Text('Approve'),
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
