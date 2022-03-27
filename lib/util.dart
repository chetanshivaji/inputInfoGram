import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inputgram/consts.dart';

String userMail = "";
String adminVillage = "";
String adminPin = "";
String registerdName = "";

bool onPressedDrawerAddPerson = false;
bool onPressedDrawerReportPerson = false;
bool onPressedDrawerUpdatePerson = false;

bool onPressedDrawerApprove = false;
bool onPressedDrawerUpdate = false;
bool onPressedDrawerReport = false;

TextStyle getTableHeadingTextStyle() {
  return TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    fontFamily: tableHeadingFontFamily,
  );
}

Future<List<String>> getLoggedInUserVillagePin() async {
  List<String> lsVillagePin = [];
  String? email = FirebaseAuth.instance.currentUser!.email;
  String village = "";
  String pin = "";
  try {
    await FirebaseFirestore.instance
        .collection(collUsers)
        .doc(email)
        .get()
        .then(
      (value) {
        var y = value.data();
        village = y![keyVillage];
        pin = y[keyPin];
        lsVillagePin.add(village);
        lsVillagePin.add(pin);
      },
    );
  } catch (e) {
    print(e);
  }
  return lsVillagePin;
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

void popLogOutAlert(
    BuildContext context, String title, String subtitle, Widget imgRightWrong) {
  //shows alert dialog
  //paramaters, title, subtitle, imgRightWrong:image with right or wrong icon, popCount: how many times navigate back
  Widget cancelButton = TextButton(
    child: Text(optCancel),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget okButton = TextButton(
    child: Text(optOk),
    onPressed: () {
      FirebaseAuth.instance.signOut();
      Navigator.pop(context); //main screen of app
      Navigator.pop(context); //login or registeration screen
      Navigator.pop(context); //welcome screen
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
  if (type == actIn) {
    return TextStyle(
      color: Colors.green[900],
    );
  } else if (type == actPending) {
    return TextStyle(
      color: Colors.amber[900],
    );
  } else {
    return TextStyle(
      color: Colors.red[900],
    );
  }
}

/*
Future<List<String>> getMobileUidMapping(String mobile) async {
  //START create mobile -> multi UID mapping
  await FirebaseFirestore.instance
      .collection(adminVillage + adminPin)
      .doc(docMobileUidMap)
      .get()
      .then(
    (value) async {
      if (value.exists) {
        var y = value.data();
        if (y!.containsKey(value)) {
          return y[value];
        }
      }
    },
  );
  //END create mobile -> multi UID mapping
  List<String> s = []; //dummy
  return s;
}
*/
Future<void> deleteMobileUidMapping(int mobile, String uid) async {
  //START create mobile -> multi UID mapping
  await FirebaseFirestore.instance
      .collection(adminVillage + adminPin)
      .doc(docMobileUidMap)
      .get()
      .then(
    (value) async {
      if (value.exists) {
        await FirebaseFirestore.instance
            .collection(adminVillage + adminPin)
            .doc(docMobileUidMap)
            .update(
          {
            mobile.toString(): FieldValue.arrayRemove([uid])
          },
        );
      }
    },
  );
  await FirebaseFirestore.instance
      .collection(adminVillage + adminPin)
      .doc(docMobileUidMap)
      .get()
      .then(
    (value) async {
      if (value.exists) {
        var y = value.data();
        if (y!.containsKey(mobile.toString())) {
          if (y[mobile.toString()].length == 0) {
            y.remove(mobile.toString()); //removes key if no value present.
          }
        }
      }
    },
  );
  //END create mobile -> multi UID mapping
  return;
}

Future<void> createMobileUidMapping(int mobile, String uid) async {
  //START create mobile -> multi UID mapping
  await FirebaseFirestore.instance
      .collection(adminVillage + adminPin)
      .doc(docMobileUidMap)
      .get()
      .then(
    (value) async {
      if (value.exists) {
        await FirebaseFirestore.instance
            .collection(adminVillage + adminPin)
            .doc(docMobileUidMap)
            .update(
          {
            mobile.toString(): FieldValue.arrayUnion([uid])
          },
        );
      } else {
        await FirebaseFirestore.instance
            .collection(adminVillage + adminPin)
            .doc(docMobileUidMap)
            .set(
          {
            mobile.toString(): FieldValue.arrayUnion([uid])
          },
        );
      }
    },
  );
  //END create mobile -> multi UID mapping
  return;
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
    child: Text(optOk),
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
