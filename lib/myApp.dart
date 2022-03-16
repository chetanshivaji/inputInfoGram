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
  bool drawerOpen = false;

  MyApp({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (drawerOpen == true) {
          Navigator.pop(context);
        }

        popLogOutAlert(
          context,
          kTitleSignOut,
          kSubtitleLogOutConfirmation,
          Icon(Icons.power_settings_new),
        );
        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        onDrawerChanged: (isOpen) {
          drawerOpen = isOpen;
        },
        appBar: AppBar(
          title: Text(appBarMainAppInfo),
          actions: <Widget>[
            IconButton(
              splashColor: clrIconSpalsh,
              splashRadius: iconSplashRadius,
              tooltip: kTitleSignOut,
              onPressed: () {
                //logout
                popLogOutAlert(
                    context,
                    kTitleSignOut,
                    kSubtitleLogOutConfirmation,
                    Icon(Icons.power_settings_new));
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
                title: Text(dAddPerson),
                tileColor: clrGreen, //green
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (onPressedDrawerAddPerson == false) {
                    onPressedDrawerAddPerson = true;
                    Navigator.pushNamed(context, inputInfo.id);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.add_box),
                title: Text(dRemovePerson),
                tileColor: clrRed, //green
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (onPressedDrawerRemovePerson == false) {
                    onPressedDrawerRemovePerson = true;
                    Navigator.pushNamed(context, removeInfo.id);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.approval),
                title: Text(dApprove),
                tileColor: clrAmber, //red
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (onPressedDrawerApprove == false) {
                    onPressedDrawerApprove = true;
                    Navigator.pushNamed(context, approve.id);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
