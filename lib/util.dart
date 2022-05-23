import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inputgram/constants.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late BuildContext gContext;
Locale gLocale = Locale('en');

String userMail = "";
String adminVillage = "";
String adminPin = "";
String registerdName = "";

bool flagCreateVillageDB = false;

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
    child: Text(AppLocalizations.of(gContext)!.optCancel),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget okButton = TextButton(
    child: Text(AppLocalizations.of(gContext)!.optOk),
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

Future<void> deleteMobileUidMapping(String mobile, String uid) async {
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
            mobile: FieldValue.arrayRemove([uid])
          },
        );
      }
    },
  );
  /*
  await FirebaseFirestore.instance
      .collection(adminVillage + adminPin)
      .doc(docMobileUidMap)
      .get()
      .then(
    (value) async {
      if (value.exists) {
        var y = value.data();
        if (y!.containsKey(mobile)) {
          if (y[mobile].length == 0) {
            y.remove(mobile); //removes key if no value present.
          }
        }
      }
    },
  );
  */
  //END create mobile -> multi UID mapping
  return;
}

ListTile getListTile(Icon leadingIcon, String lhs, String rhs) {
  return ListTile(
    minLeadingWidth: 0,
    leading: leadingIcon,
    title: getPrefilledListTile(lhs, rhs),
  );
}

Widget getPadding() {
  return Padding(
    padding: EdgeInsets.only(top: 20),
  );
}

Widget getPrefilledListTile(String LHS, String RHS) {
  return Row(
    children: [
      Text(
        "$LHS = ",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "$RHS",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.blue,
        ),
      ),
    ],
  );
}

Future<void> createMobileUidMapping(String mobile, String uid) async {
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
            mobile: FieldValue.arrayUnion([uid])
          },
        );
      } else {
        await FirebaseFirestore.instance
            .collection(adminVillage + adminPin)
            .doc(docMobileUidMap)
            .set(
          {
            mobile: FieldValue.arrayUnion([uid])
          },
        );
      }
    },
  );
  //END create mobile -> multi UID mapping
  return;
}

TextStyle getTableFirstColStyle() {
  return TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
}

TableBorder getTableBorder() {
  return TableBorder(
    horizontalInside: BorderSide(
      width: 1,
      color: clrTableHorizontalBorder,
    ),
    verticalInside: BorderSide(
      width: 1,
      color: clrTableVerticleBorder,
    ),
  );
}

Icon getWrongIcon() {
  return Icon(
    Icons.cancel,
    size: 50.0,
    color: Colors.red,
  );
}

Icon getMultiUidIcon(double iconSize) {
  return Icon(
    Icons.multiple_stop,
    size: iconSize,
    color: Colors.blue,
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
    child: Text(AppLocalizations.of(gContext)!.optOk),
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

Future<void> createDBOfVillages() async {
  try {
    //For the first time making entire database ready. to choose from state->districts-> talukas->village for admin users

    var states = [
      "Maharashtra",
      "Karnataka",
    ];
    Map<String, List<String>> districts = {
      "Maharashtra": [
        "Kolhapur",
        "Sangali",
        "Satara",
      ],
      "Karnataka": [
        "Belgaum",
        "Bagalkot",
      ],
    };
    Map<String, List<String>> talukas = {
      "Kolhapur": [
        "Gadhinglaj",
        "Ajara",
        "Chandgad",
      ],
      "Sangali": [
        "Ashta",
        "Vita",
      ],
      "Satara": [
        "Mahabaleshwar",
        "Karad",
      ],
      "Belgaum": ["Gokak", "Hukkeri"],
      "Bagalkot": ["Badami", "Mudhol"],
    };
    Map<String, List<String>> villages = {
      "Gadhinglaj": ["Vadarage", "Nangnur", "Noor", "Kadgaon"],
      "Chandgad": ["Adkur", "Dholgarwadi"],
      "Ajara": ["Dardewadi", "Hajgoli"],
      "Karad": ["Belwadi", "Atake"],
      "Mahabaleshwar": ["Ahire", "Danvali"],
      "Gokak": ["Arbhavi", "Ankalgi"],
      "Hukkeri": ["Nipani", "Ammangi"],
      "Badami": ["Adagal", "Gonal"],
      "Mudhol": ["Saidapur", "Bisanal"],
    };

    for (var s in states) {
      if (districts.containsKey(s)) {
        var d = districts[s];
        if (d!.isNotEmpty) {
          for (var dist in d) {
            if (talukas.containsKey(dist)) {
              var t = talukas[dist];
              if (t!.isNotEmpty) {
                for (var tal in t) {
                  if (villages.containsKey(tal)) {
                    var v = villages[tal];
                    if (v!.isNotEmpty)
                      for (var vlg in v) {
                        if (vlg.isNotEmpty) {
                          await FirebaseFirestore.instance
                              .collection(collIndia)
                              .doc(collStates)
                              .collection(s)
                              .doc(dist)
                              .get()
                              .then(
                            (value) async {
                              if (value.exists) {
                                await FirebaseFirestore.instance
                                    .collection(collIndia)
                                    .doc(collStates)
                                    .collection(s)
                                    .doc(dist)
                                    .update(
                                  {
                                    tal: FieldValue.arrayUnion([vlg])
                                  },
                                );
                              } else {
                                await FirebaseFirestore.instance
                                    .collection(collIndia)
                                    .doc(collStates)
                                    .collection(s)
                                    .doc(dist)
                                    .set(
                                  {
                                    tal: FieldValue.arrayUnion([vlg])
                                  },
                                );
                              }
                            },
                          );
                        }
                      }
                  }
                }
              }
            }
          }
        }
      }
    }
  } catch (e) {
    print(e);
  }
}
