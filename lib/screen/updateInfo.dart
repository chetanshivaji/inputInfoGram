import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inputgram/consts.dart';
import 'package:inputgram/util.dart';

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

  var mobileUids;
  String uidList = "";
  String nameEntry = "";
  String emailEntry = "";
  bool uidTextField = false;
  int mobile = 0;
  int newMobile = 0;
  String uid = "";
  String newEmail = "";
  int houseTax = 0;
  int waterTax = 0;
  bool houseGiven = false;
  bool waterGiven = false;
  var _textController_mobile = TextEditingController();
  var _textController_newMobile = TextEditingController();
  var _textController_Uid = TextEditingController();
  var _textController_newEmail = TextEditingController();

  String uidHintText = msgEnterUid;

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
          //pop aler allready used by someone else.
          _textController_newMobile.clear();
          popAlert(
            context,
            kTitlePresent,
            "Already Used for $nameEntry $emailEntry, use another number",
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
        }
        setState(
          () {
            name = nameEntry;
            email = emailEntry;
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
                  uidTextField =
                      true; //disale to edit , make enable false or read only true. check it.
                  _textController_Uid.text = mobileUids[0];
                },
              );
              setNameEmail(mobileUids[0]);
            } else {
              //display all uids and choose one.
              for (var id in mobileUids) {
                uids = uids + ", " + id;
              }
              //pop up message with all uids and setup hint text with uids.
              popAlert(
                context,
                kTitleMultiUids,
                uids,
                getWrongIcon(),
                1,
              );

              setState(
                () {
                  uidTextField =
                      false; //disale to edit , make enable false or read only true. check it.
                  uidList = uids;
                  uidHintText = uidList;
                },
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
                    _textController_Uid.clear();
                    setState(
                      () {
                        name = "";
                        email = "";
                        nameEntry = "";
                        emailEntry = "";
                      },
                    );
                  }
                  if (mobValue.length == 10) {
                    try {
                      checkMobileUid(mobValue);
                      uidTextField =
                          true; //after 10 digits make, uid text field enable to write.
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
            Expanded(
              child: Text(
                "UIDs Found = $uidList",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: TextFormField(
                readOnly:
                    uidTextField, //make read only according to 1. waiting for user to type uid in multiple uid case,OR 2. single uid per mobile, disable pop & disable case.
                controller: _textController_Uid,
                onChanged: (uidValue) async {
                  //search mobile+uid and display.//we calling this function for each value typed//check what is
                  setNameEmail(uidValue);
                },
                onEditingComplete: () {
                  print("on editing compeleted");
                },
                onFieldSubmitted: (String s) {
                  print("on field sub");
                },
                onSaved: (String? s) {
                  print("on field sub");
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.person_search_rounded),
                    hintText: uidHintText,
                    labelText: labelUid),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return msgEnterUid;
                  }
                  if (!isNumeric(value)) {
                    return msgOnlyNumber;
                  }
                  uid = value;
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "$labelName = $name",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(Icons.attach_money),
                title: Text(
                  "$labelEmail = $email",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
          ],
        ),
      ),
    );
  }
}
