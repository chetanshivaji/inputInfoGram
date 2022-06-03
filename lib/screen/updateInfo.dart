import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inputgram/constants.dart';
import 'package:inputgram/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String extraInfo = "";
  List<TextSpan> multiUidsTextSpan = [];
  List<TextSpan> multiUids = [];
  String uid = "";

  //var mobileUids;
  String nameEntry = "";
  String uidEntry = "";
  String emailEntry = "";
  String extraInfoEntry = "";
  String mobile = "";
  String newMobile = "";

  String newEmail = "";
  String newName = "";
  String newExtraInfo = "";
  int houseTax = 0;
  int waterTax = 0;
  bool houseGiven = false;
  bool waterGiven = false;
  var _textController_mobile = TextEditingController();
  var _textController_newMobile = TextEditingController();

  var _textController_newEmail = TextEditingController();
  var _textController_extraInfo = TextEditingController();
  var _textController_newName = TextEditingController();

  /*
  Future<bool> mobileAlreadyUsed(String text) async {
    try {
      await FirebaseFirestore.instance
          .collection(adminVillage + adminPin)
          .doc(docMainDb)
          .collection(docMainDb + dropdownValueYear)
          .doc(text)
          .get()
          .then(
        (value) {
          var y = value.data();
          nameEntry = y![keyName];
          emailEntry = y[keyEmail];
          extraInfoEntry = y[keyExtraInfo];
          uidEntry = y[keyUid];
          //pop aler allready used by someone else.
          _textController_newMobile.clear();
          popAlert(
            context,
            AppLocalizations.of(gContext)!.kTitlePresent,
            "Already Used for $nameEntry $emailEntry $uidEntry , use another number",
            Icon(Icons.no_accounts),
            1,
          );
          return true;
        },
      );
    } catch (e) {
      //print(e);
      popAlert(context, AppLocalizations.of(gContext)!.kTitleTryCatchFail,
          e.toString(), getWrongIcon(), 1);
    }
    return false;
  }

  */
  Future<void> setNameEmail(String uid) async {
    //fecth and display user info on screen
    bool found = false;
    for (var yr in items) {
      await FirebaseFirestore.instance
          .collection(adminVillage + adminPin)
          .doc(docMainDb)
          .collection(docMainDb + yr)
          .doc(mobile + uid)
          .get()
          .then(
        (value) {
          if (value.exists) {
            found = true;
            var y = value.data();
            nameEntry = y![keyName];
            emailEntry = y[keyEmail];
            extraInfoEntry = y[keyExtraInfo];
            uidEntry = y[keyUid];
            setState(
              () {
                name = nameEntry;
                email = emailEntry;
                extraInfo = extraInfoEntry;
                uid = uidEntry;
              },
            );
            return;
          }
        },
      );
      if (found) {
        break;
      }
    }
  }

  Future<void> checkMobileUid(mobValue) async {
    String uids = "";
    mobile =
        mobValue; //set here, otherewise this will be set in validator after click on submit.
    Set<String> mobileUids = {};
    try {
      for (var yr in items) {
        await FirebaseFirestore.instance
            .collection(adminVillage + adminPin)
            .doc(docYrsMobileUids)
            .collection(collYrs)
            .doc(yr)
            .get()
            .then(
          (value) async {
            if (value.exists) {
              var y = value.data();
              if (!y!.containsKey(mobValue)) {
                //mobile uid mapping not present.
                return;
              }
              for (var element in y[mobValue]) {
                mobileUids.add(element);
              }
            }
          },
        );
      }
    } catch (e) {
      popAlert(
        context,
        AppLocalizations.of(gContext)!.kTitleMobileNotPresent,
        "",
        getWrongIcon(),
        1,
      );
      _textController_newMobile.clear();
      _textController_newEmail.clear();
      _textController_extraInfo.clear();
      _textController_newName.clear();
    }

    //if no mobile found in all yrs.
    if (mobileUids.isEmpty) {
      popAlert(
        context,
        AppLocalizations.of(gContext)!.kTitleMobileNotPresent,
        "",
        getWrongIcon(),
        1,
      );
      return;
    }

    //get all uids. if only one directly display
    if (mobileUids.length == 1) {
      uids = mobileUids.elementAt(0);
      setState(
        () {
          uid = mobileUids.elementAt(0);
        },
      );
      await setNameEmail(mobileUids.elementAt(0));
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
              ..onTap = () async {
                //make use of Id which has go tapped.
                await setNameEmail(id);
                uid = id;
              },
          ),
        );
      }

      //pop up message with all uids and setup hint text with uids.
      popAlert(
        context,
        AppLocalizations.of(gContext)!.kTitleMultiUids,
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
        AppLocalizations.of(gContext)!.kTitleMobileNotPresent,
        "",
        getWrongIcon(),
        1,
      );
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    gContext = context;
    onPressedDrawerUpdatePerson = false;
    bool onPressedUpdateInfo = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(gContext)!.appBarHeadingUpdateInfo,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: clrBlue,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Container(
            child: Form(
              key: _formKeyupdateForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  getPadding(),
                  TextFormField(
                    controller: _textController_mobile,
                    onChanged: (mobValue) async {
                      if ((mobValue.length < 10) || (mobValue.length > 10)) {
                        _textController_newMobile.clear();
                        _textController_newEmail.clear();
                        _textController_extraInfo.clear();
                        _textController_newName.clear();
                        multiUidsTextSpan.clear();

                        setState(
                          () {
                            multiUids = [TextSpan()];
                            name = "";
                            email = "";
                            extraInfo = "";
                            uid = "";
                            nameEntry = "";
                            emailEntry = "";
                            extraInfoEntry = "";
                            uidEntry = "";
                          },
                        );
                      }
                      if (mobValue.length == 10) {
                        try {
                          await checkMobileUid(mobValue);
                        } catch (e) {
                          popAlert(
                            context,
                            AppLocalizations.of(gContext)!
                                .kTitleMobileNotPresent,
                            "",
                            getWrongIcon(),
                            1,
                          );
                          _textController_newMobile.clear();
                          _textController_newEmail.clear();
                          _textController_extraInfo.clear();
                          _textController_newName.clear();
                          multiUidsTextSpan.clear();
                          return;
                        }
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.mobile_friendly),
                        hintText:
                            AppLocalizations.of(gContext)!.msgEnterMobileNumber,
                        labelText: AppLocalizations.of(gContext)!.labelMobile +
                            txtStar),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(gContext)!
                            .msgEnterMobileNumber;
                      }
                      if (value.length != 10) {
                        return AppLocalizations.of(gContext)!.msgTenDigitNumber;
                      }
                      if (!isNumeric(value)) {
                        return AppLocalizations.of(gContext)!.msgOnlyNumber;
                      }
                      mobile = value;
                      return null;
                    },
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: multiUids,
                      ),
                    ),
                  ),
                  //getPadding(),
                  getListTile(Icon(Icons.wb_incandescent_outlined),
                      AppLocalizations.of(gContext)!.labelUid, uid),
                  //getPadding(),
                  getListTile(Icon(Icons.person),
                      AppLocalizations.of(gContext)!.labelName, name),
                  //getPadding(),
                  getListTile(Icon(Icons.mail_outline),
                      AppLocalizations.of(gContext)!.labelEmail, email),
                  //getPadding(),
                  getListTile(Icon(Icons.holiday_village),
                      AppLocalizations.of(gContext)!.labelExtraInfo, extraInfo),
                  //getPadding(),
                  Expanded(
                    child: TextFormField(
                      controller: _textController_newMobile,
                      /*
                      onChanged: (text) async {
                        if (text.length == 10) {
                          var used = await mobileAlreadyUsed(text);
                          if (used == true) {
                            return;
                          }
                        }
                      },
                      */
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.mobile_friendly),
                          hintText: AppLocalizations.of(gContext)!
                              .msgEnterNewMobileNumber,
                          labelText:
                              AppLocalizations.of(gContext)!.labelNewMobile),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          //return AppLocalizations.of(gContext)!
                          //.msgEnterNewMobileNumber;
                          newMobile = "";
                          return null;
                        }
                        if (value.length != 10) {
                          return AppLocalizations.of(gContext)!
                              .msgTenDigitNumber;
                        }
                        if (!isNumeric(value)) {
                          return AppLocalizations.of(gContext)!.msgOnlyNumber;
                        }
                        newMobile = value;
                        return null;
                      },
                    ),
                  ),
                  //getPadding(),
                  Expanded(
                    child: TextFormField(
                      controller: _textController_newName,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.person_add_alt),
                          hintText: AppLocalizations.of(gContext)!.msgNewName,
                          labelText:
                              AppLocalizations.of(gContext)!.labelNewName),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          newName = "";
                          return null;
                        }
                        newName = value;
                        return null;
                      },
                    ),
                  ),

                  Expanded(
                    child: TextFormField(
                      controller: _textController_newEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.mail_outline),
                          hintText: AppLocalizations.of(gContext)!
                              .msgEnterUserNewMail,
                          labelText:
                              AppLocalizations.of(gContext)!.labelNewEmail),
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
                  //getPadding(),
                  Expanded(
                    child: TextFormField(
                      controller: _textController_extraInfo,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.holiday_village),
                          hintText: AppLocalizations.of(gContext)!.msgExtraInfo,
                          labelText:
                              AppLocalizations.of(gContext)!.labelExtraInfo),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          newExtraInfo = "";
                          return null;
                        }
                        newExtraInfo = value;
                        return null;
                      },
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKeyupdateForm.currentState!.validate() &&
                            onPressedUpdateInfo == false) {
                          try {
                            onPressedUpdateInfo = true;
                            if (newExtraInfo == "" &&
                                newEmail == "" &&
                                newName == "" &&
                                newMobile == "") {
                              //Everything is empty. pop up message and return back;
                              popAlert(
                                  context,
                                  AppLocalizations.of(gContext)!
                                      .kTitleNothingToUpdate,
                                  AppLocalizations.of(gContext)!
                                      .kSubtitleAllFieldsEmpty,
                                  getWrongIcon(),
                                  1);
                              return;
                            }
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(gContext)!
                                    .msgProcessingData),
                              ),
                            );
                            bool mobileFound = false;
                            for (var yr in items) {
                              String newEntry_email = "";
                              String newEntry_extraInfo = "";
                              String newEntry_mobile = "";
                              String newEntry_name = "";
                              int newEntry_house = 0;

                              int newEntry_electricity = 0;
                              int newEntry_health = 0;
                              int newEntry_extraLand = 0;
                              int newEntry_otherTax = 0;
                              int newEntry_totalTax = 0;

                              bool newEntry_houseGiven = false;
                              int newEntry_water = 0;
                              String newEntry_uid = "";
                              bool newEntry_waterGiven = false;

                              //START remove old entry
                              var collection = FirebaseFirestore.instance
                                  .collection(adminVillage + adminPin)
                                  .doc(docMainDb)
                                  .collection(docMainDb + yr);
                              await collection.doc(mobile + uid).get().then(
                                (value) async {
                                  if (value.exists) {
                                    mobileFound = true;
                                    //START create new entry with copying field from old entry with new mobile and mail.
                                    var y = value.data();
                                    newEntry_name = y![keyName];
                                    newEntry_house = y[keyHouse];
                                    newEntry_houseGiven = y[keyHouseGiven];
                                    newEntry_water = y[keyWater];
                                    newEntry_waterGiven = y[keyWaterGiven];
                                    newEntry_uid = y[keyUid];
                                    newEntry_mobile = y[keyMobile];

                                    newEntry_electricity = y[keyElectricity];
                                    newEntry_health = y[keyHealth];
                                    newEntry_extraLand = y[keyExtraLand];
                                    newEntry_otherTax = y[keyOtherTax];
                                    newEntry_totalTax =
                                        y[keyTotalTaxOtherThanWater];

                                    if (newEmail == "") {
                                      newEntry_email = y[keyEmail];
                                    } else {
                                      newEntry_email = newEmail;
                                    }

                                    if (newName == "") {
                                      newEntry_name = y[keyName];
                                    } else {
                                      newEntry_name = newName;
                                    }

                                    if (newExtraInfo == "") {
                                      newEntry_extraInfo = y[keyExtraInfo];
                                    } else {
                                      newEntry_extraInfo = newExtraInfo;
                                    }

                                    if (newMobile == "") {
                                      newEntry_mobile = y[keyMobile];
                                    } else {
                                      newEntry_mobile = newMobile;
                                    }

                                    //END create new entry with copying field from old entry with new mobile and mail.

                                    //START delete old entry to replace
                                    await FirebaseFirestore.instance
                                        .collection(adminVillage + adminPin)
                                        .doc(docMainDb)
                                        .collection(docMainDb + yr)
                                        .doc(mobile + uid)
                                        .delete();

                                    //After deleting entry create new entry
                                    //END delete old entry to replace

                                    //START create new Entry
                                    await FirebaseFirestore.instance
                                        .collection(adminVillage + adminPin)
                                        .doc(docMainDb)
                                        .collection(docMainDb + yr)
                                        .doc(newEntry_mobile + uid)
                                        .set(
                                      {
                                        keyHouse: newEntry_house,
                                        keyHouseGiven: newEntry_houseGiven,
                                        keyEmail: newEntry_email,
                                        keyExtraInfo: newEntry_extraInfo,
                                        keyMobile: newEntry_mobile,
                                        keyName: newEntry_name,
                                        keyWater: newEntry_water,
                                        keyWaterGiven: newEntry_waterGiven,
                                        keyUid: newEntry_uid,
                                        keyElectricity: newEntry_electricity,
                                        keyHealth: newEntry_health,
                                        keyExtraLand: newEntry_extraLand,
                                        keyOtherTax: newEntry_otherTax,
                                        keyTotalTaxOtherThanWater:
                                            newEntry_totalTax,
                                      },
                                    );
                                    //END create new Entry
                                    //START remove uid from yr mobile
                                    await deleteMobileUidMapping(
                                        yr, mobile, uid);
                                    //create new mapping.
                                    await createMobileUidMapping(
                                        yr, newEntry_mobile, uid);
                                    //END remove uid from yr mobile
                                  }
                                },
                              );
                              //END remove old entry

                            }

                            if (mobileFound) {
                              popAlert(
                                  context,
                                  AppLocalizations.of(gContext)!.titleSuccess,
                                  AppLocalizations.of(gContext)!
                                      .subtitleSuccess,
                                  getRightIcon(),
                                  3);
                            } else {
                              onPressedUpdateInfo = false;
                              popAlert(
                                context,
                                AppLocalizations.of(gContext)!
                                    .kTitleMobileNotPresent,
                                "",
                                getWrongIcon(),
                                1,
                              );
                            }
                          } catch (e) {
                            onPressedUpdateInfo = false;
                            popAlert(
                                context,
                                AppLocalizations.of(gContext)!
                                    .kTitleTryCatchFail,
                                e.toString(),
                                getWrongIcon(),
                                1);
                          }
                        }
                      },
                      child: Text(
                        AppLocalizations.of(gContext)!.bLabelSubmit,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
