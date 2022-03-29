import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inputgram/consts.dart';
import 'package:inputgram/util.dart';
import 'package:flutter/gestures.dart';

class updateInfo extends StatefulWidget {
  static String id = "updatescreen";
  const updateInfo({Key? key}) : super(key: key);

  @override
  _updateInfoState createState() => _updateInfoState();
}

class _updateInfoState extends State<updateInfo> {
  final _formKeyupdateForm = GlobalKey<FormState>();

  String name = "";
  String email = "";
  List<TextSpan> multiUidsTextSpan = [];
  List<TextSpan> multiUids = [];
  String uid = "";

  var mobileUids;
  String nameEntry = "";
  String uidEntry = "";
  String emailEntry = "";
  int mobile = 0;
  int newMobile = 0;

  String newEmail = "";
  int houseTax = 0;
  int waterTax = 0;
  bool houseGiven = false;
  bool waterGiven = false;
  var _textController_mobile = TextEditingController();
  var _textController_newMobile = TextEditingController();

  var _textController_newEmail = TextEditingController();

  Future<bool> mobileAlreadyUsed(String text) async {
    try {
      await FirebaseFirestore.instance
          .collection(adminVillage + adminPin)
          .doc(mainDb)
          .collection(mainDb + dropdownValueYear)
          .doc(text)
          .get()
          .then(
        (value) {
          var y = value.data();
          nameEntry = y![keyName];
          emailEntry = y[keyEmail];
          uidEntry = y[keyUid];
          //pop aler allready used by someone else.
          _textController_newMobile.clear();
          popAlert(
            context,
            kTitlePresent,
            "Already Used for $nameEntry $emailEntry $uidEntry , use another number",
            Icon(Icons.no_accounts),
            1,
          );
          return true;
        },
      );
    } catch (e) {
      print(e);
    }
    return false;
  }

  void setNameEmail(String uid) async {
    //fecth and display user info on screen

    await FirebaseFirestore.instance
        .collection(adminVillage + adminPin)
        .doc(mainDb)
        .collection(mainDb + dropdownValueYear)
        .doc(mobile.toString() + uid)
        .get()
        .then(
      (value) {
        if (value.exists) {
          var y = value.data();
          nameEntry = y![keyName];
          emailEntry = y[keyEmail];
          uidEntry = y[keyUid];
        }
        setState(
          () {
            name = nameEntry;
            email = emailEntry;
            uid = uidEntry;
          },
        );
      },
    );
  }

  Future<void> checkMobileUid(mobValue) async {
    String uids = "";
    mobile = int.parse(
        mobValue); //set here, otherewise this will be set in validator after click on submit.
    try {
      await FirebaseFirestore.instance
          .collection(adminVillage + adminPin)
          .doc(docMobileUidMap)
          .get()
          .then(
        (value) {
          if (value.exists) {
            var y = value.data();
            if (!y!.containsKey(mobValue)) {
              //mobile uid mapping not present.
              popAlert(
                context,
                kTitleMobileNotPresent,
                "",
                getWrongIcon(),
                1,
              );
              return;
            }
            mobileUids = y[mobValue];
            //get all uids. if only one directly display
            if (mobileUids.length == 1) {
              uids = mobileUids[0];
              setState(
                () {
                  uid = mobileUids[0];
                },
              );
              setNameEmail(mobileUids[0]);
            } else if (mobileUids.length > 1) {
              //display all uids and choose one.
              for (var id in mobileUids) {
                uids = uids + ", " + id;
                multiUidsTextSpan.add(
                  TextSpan(
                    text: id + " , ",
                    style: TextStyle(
                      color: Colors.red[300],
                      backgroundColor: Colors.yellow,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        //make use of Id which has go tapped.
                        setNameEmail(id);
                        uid = id;
                      },
                  ),
                );
              }

              //pop up message with all uids and setup hint text with uids.
              popAlert(
                context,
                kTitleMultiUids,
                uids,
                getMultiUidIcon(50),
                1,
              );

              setState(
                () {
                  multiUids = multiUidsTextSpan;
                },
              );
            } else if (mobileUids.length == 0) {
              popAlert(
                context,
                kTitleMobileNotPresent,
                "",
                getWrongIcon(),
                1,
              );
            }
          }
        },
      );
    } catch (e) {
      popAlert(
        context,
        kTitleMobileNotPresent,
        "",
        getWrongIcon(),
        1,
      );
      _textController_newMobile.clear();
      _textController_newEmail.clear();
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    onPressedDrawerUpdatePerson = false;
    bool onPressedUpdateInfo = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarHeadingUpdateInfo,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: clrBlue,
      ),
      body: Form(
        key: _formKeyupdateForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController_mobile,
                onChanged: (mobValue) async {
                  if (mobValue.length < 10) {
                    _textController_newMobile.clear();
                    _textController_newEmail.clear();
                    multiUidsTextSpan.clear();

                    setState(
                      () {
                        multiUids = [TextSpan()];
                        name = "";
                        email = "";
                        uid = "";
                        nameEntry = "";
                        emailEntry = "";
                        uidEntry = "";
                      },
                    );
                  }
                  if (mobValue.length == 10) {
                    try {
                      checkMobileUid(mobValue);
                    } catch (e) {
                      popAlert(
                        context,
                        kTitleMobileNotPresent,
                        "",
                        getWrongIcon(),
                        1,
                      );
                      _textController_newMobile.clear();
                      _textController_newEmail.clear();
                      multiUidsTextSpan.clear();
                      return;
                    }
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.mobile_friendly),
                    hintText: msgEnterMobileNumber,
                    labelText: labelMobile),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return msgEnterMobileNumber;
                  }
                  if (value.length != 10) {
                    return msgTenDigitNumber;
                  }
                  if (!isNumeric(value)) {
                    return msgOnlyNumber;
                  }
                  mobile = int.parse(value);
                  return null;
                },
              ),
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: multiUids,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(Icons.person),
                title: getPrefilledListTile(labelUid, uid),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(Icons.person),
                title: getPrefilledListTile(labelName, name),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(Icons.attach_money),
                title: getPrefilledListTile(labelEmail, email),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController_newMobile,
                onChanged: (text) async {
                  if (text.length == 10) {
                    var used = mobileAlreadyUsed(text);
                    if (used == true) {
                      return;
                    }
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.mobile_friendly),
                    hintText: msgEnterNewMobileNumber,
                    labelText: labelNewMobile),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return msgEnterNewMobileNumber;
                  }
                  if (value.length != 10) {
                    return msgTenDigitNumber;
                  }
                  if (!isNumeric(value)) {
                    return msgOnlyNumber;
                  }
                  newMobile = int.parse(value);
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController_newEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.mail_outline),
                    hintText: msgEnterUserNewMail,
                    labelText: labelNewEmail),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    newEmail = "";
                    return null;
                  }
                  newEmail = value;
                  return null;
                },
              ),
            ),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKeyupdateForm.currentState!.validate() &&
                        onPressedUpdateInfo == false) {
                      try {
                        onPressedUpdateInfo = true;
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msgProcessingData),
                          ),
                        );
                        for (var yr in items) {
                          String newEntry_email = "";
                          int newEntry_mobile = 0;
                          String newEntry_name = "";
                          int newEntry_house = 0;
                          bool newEntry_houseGiven = false;
                          int newEntry_water = 0;
                          String newEntry_uid = "";
                          bool newEntry_waterGiven = false;

                          //START remove old entry
                          var collection = FirebaseFirestore.instance
                              .collection(adminVillage + adminPin)
                              .doc(mainDb)
                              .collection(mainDb + yr);
                          await collection
                              .doc(mobile.toString() + uid)
                              .get()
                              .then(
                            (value) async {
                              if (value.exists) {
                                //START create new entry with copying field from old entry with new mobile and mail.
                                var y = value.data();
                                newEntry_name = y![keyName];
                                newEntry_house = y[keyHouse];
                                newEntry_houseGiven = y[keyHouseGiven];
                                newEntry_water = y[keyWater];
                                newEntry_waterGiven = y[keyWaterGiven];
                                newEntry_uid = y[keyUid];
                                newEntry_mobile = newMobile;
                                if (newEmail == "") {
                                  newEntry_email = y[keyEmail];
                                } else {
                                  newEntry_email = newEmail;
                                }
                                //END create new entry with copying field from old entry with new mobile and mail.

                                //START delete old entry to replace
                                await FirebaseFirestore.instance
                                    .collection(adminVillage + adminPin)
                                    .doc(mainDb)
                                    .collection(mainDb + yr)
                                    .doc(mobile.toString() + uid)
                                    .delete();

                                //After deleting entry create new entry
                                //END delete old entry to replace

                                //START create new Entry
                                await FirebaseFirestore.instance
                                    .collection(adminVillage + adminPin)
                                    .doc(mainDb)
                                    .collection(mainDb + yr)
                                    .doc(newMobile.toString() + uid)
                                    .set(
                                  {
                                    keyHouse: newEntry_house,
                                    keyHouseGiven: newEntry_houseGiven,
                                    keyEmail: newEntry_email,
                                    keyMobile: newMobile,
                                    keyName: newEntry_name,
                                    keyWater: newEntry_water,
                                    keyWaterGiven: newEntry_waterGiven,
                                    keyUid: newEntry_uid
                                  },
                                );
                                //END create new Entry
                              }
                            },
                          );
                          //END remove old entry
                        }
                        //remove uid from mobile to uids map
                        deleteMobileUidMapping(mobile, uid);
                        //create new mapping.
                        createMobileUidMapping(newMobile, uid);
                        popAlert(context, titleSuccess, subtitleSuccess,
                            getRightIcon(), 3);
                      } catch (e) {
                        onPressedUpdateInfo = false;
                        popAlert(context, kTitleTryCatchFail, e.toString(),
                            getWrongIcon(), 1);
                      }
                    }
                  },
                  child: Text(
                    bLabelSubmit,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
