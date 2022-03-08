import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inputgram/screen/approve.dart';
import 'package:inputgram/screen/inputInfo.dart';
import 'package:inputgram/screen/registerInfo.dart';
import 'package:inputgram/screen/removeInfo.dart';
import 'consts.dart';

class MyApp extends StatelessWidget {
  static String id = "myappscreen";
  MyApp({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;

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
              _auth.signOut();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            icon: Icon(Icons.power_settings_new),
          ),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              width: 20.0,
              height: 100.0,
            ),
            const Text(
              '',
              style: TextStyle(fontSize: 43.0),
            ),
            const SizedBox(
              width: 20.0,
              height: 100.0,
            ),
          ],
        ),
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
              tileColor: clrGreen, //red
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
