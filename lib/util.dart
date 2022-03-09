import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String userMail = "";
String registerSubtitleSuccess = "Register success!";
String registerSuccess = "Admin and village regsitered successfully";
String kTitleFail = "Login/registeration failed";
String kSubtitleFail = "Try again with correct username & password";
String kTitleLoginSuccess = "login success";
String kSubTitleLoginSuccess = "login success";
String kSubTitleOnlyAdmin = "Only Admin allowed";
String titlePasswordMismatch = "Password mismatch";
String subtitlePasswordMismatch =
    "password and re entered password should match";

String kTitleEntryRemoved = "Entry Removed";

String adminVillage = "";
String adminPin = "";

TextStyle getTableHeadingTextStyle() {
  return TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    fontFamily: "RobotoMono",
  );
}

Future<List<String>> getLoggedInUserVillagePin() async {
  List<String> lsVillagePin = [];
  String? email = FirebaseAuth.instance.currentUser!.email;
  String village = "";
  String pin = "";
  try {
    await FirebaseFirestore.instance.collection('users').doc(email).get().then(
      (value) {
        var y = value.data();
        village = y!['village'];
        pin = y['pin'];
        lsVillagePin.add(village);
        lsVillagePin.add(pin);
      },
    );
  } catch (e) {
    print(e);
  }
  return lsVillagePin;
}

void popLogOutAlert(
    BuildContext context, String title, String subtitle, Widget imgRightWrong) {
  //shows alert dialog
  //paramaters, title, subtitle, imgRightWrong:image with right or wrong icon, popCount: how many times navigate back
  Widget cancelButton = TextButton(
    child: Text("cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      FirebaseAuth.instance.signOut();
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    content: submitPop(title, subtitle, imgRightWrong),
    actions: [
      cancelButton,
      okButton, //pops twice returns to home page
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

TextStyle getStyle(String type) {
  if (type == "IN") {
    return TextStyle(
      color: Colors.green[900],
    );
  } else if (type == "PENDING") {
    return TextStyle(
      color: Colors.amber[900],
    );
  } else {
    return TextStyle(
      color: Colors.red[900],
    );
  }
}

Icon getWrongIcon() {
  return Icon(
    Icons.cancel,
    size: 50.0,
    color: Colors.red,
  );
}

Icon getRightIcon() {
  return Icon(
    Icons.done,
    size: 50.0,
    color: Colors.green,
  );
}

Widget submitPop(String res, String info, Widget childWid) {
  return ListTile(
    leading: childWid,
    title: Text(res),
    subtitle: Text(info),
  );
}

void popAlert(BuildContext context, String title, String subtitle,
    Widget imgRightWrong, int popCount) {
  //shows alert dialog
  //paramaters, title, subtitle, imgRightWrong:image with right or wrong icon, popCount: how many times navigate back

  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      for (int i = 0; i < popCount; i++) {
        Navigator.pop(context);
      }
    },
  );

  AlertDialog alert = AlertDialog(
    content: submitPop(title, subtitle, imgRightWrong),
    actions: [
      okButton, //pops twice returns to home page
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
