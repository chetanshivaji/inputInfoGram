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

  await FirebaseFirestore.instance.collection('users').doc(email).get().then(
    (value) {
      var y = value.data();
      village = y!['village'];
      pin = y['pin'];
      lsVillagePin.add(village);
      lsVillagePin.add(pin);
    },
  );
  return lsVillagePin;
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

void showAlertDialog(
    BuildContext context, String title, String subtitle, Widget img) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    //TODO: print success or failure and image, depending on processing
    content: submitPop(title, subtitle, img),
    actions: [
      cancelButton, //pops once return to same page
      continueButton, //pops twice returns to home page
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showRegLoginAlertDialogSuccess(
    BuildContext context, String title, String subtitle) {
  // set up the buttons

  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    //TODO: print success or failure and image, depending on processing
    content: submitPop(title, subtitle, getRightIcon()),
    actions: [
      okButton, //pops twice returns to home page
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showRegLoginAlertDialogFail(
    BuildContext context, String title, String subtitle) {
  // set up the buttons
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    //TODO: print success or failure and image, depending on processing
    content: submitPop(title, subtitle, getWrongIcon()),
    actions: [
      okButton, //pops twice returns to home page
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
