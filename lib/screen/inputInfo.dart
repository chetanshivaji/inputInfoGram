import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inputgram/constants.dart';
import 'package:inputgram/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class inputInfo extends StatefulWidget {
  static String id = "inputscreen";
  const inputInfo({Key? key}) : super(key: key);

  @override
  _inputInfoState createState() => _inputInfoState();
}

class _inputInfoState extends State<inputInfo> {
  List<TextSpan> multiUidsTextSpan = [];
  List<TextSpan> multiUids = [];
  String uid = "";

  final _formKeyInputForm = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String mobile = "";

  int houseTax = 0;
  int waterTax = 0;

  int electricityTax = 0;
  int healthTax = 0;
  int extraLandTax = 0;
  int otherTax = 0;

  String extraInfo = "";
  bool houseGiven = false;
  bool waterGiven = false;
  bool onPressedInputInfo = false;
  var _textController_name = TextEditingController();
  var _textController_mail = TextEditingController();
  var _textController_mobile = TextEditingController();
  var _textController_houseTax = TextEditingController();
  var _textController_waterTax = TextEditingController();

  var _textController_ElectricityTax = TextEditingController();
  var _textController_HealthTax = TextEditingController();
  var _textController_ExtraLandTax = TextEditingController();
  var _textController_OtherTax = TextEditingController();

  var _textController_uid = TextEditingController();
  var _textController_extraInfo = TextEditingController();

  ListTile getYearTile(Color clr) {
    return ListTile(
      trailing: DropdownButton(
        borderRadius: BorderRadius.circular(12.0),
        dropdownColor: clr,

        alignment: Alignment.topLeft,

        // Initial Value
        value: dropdownValueYear,
        // Down Arrow Icon
        icon: Icon(
          Icons.date_range,
          color: clr,
        ),
        // Array list of items
        items: items.map(
          (String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          },
        ).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) {
          setState(
            () {
              dropdownValueYear = newValue!;
              _textController_name.clear();
              _textController_mail.clear();
              _textController_mobile.clear();
              _textController_houseTax.clear();
              _textController_waterTax.clear();

              _textController_ElectricityTax.clear();
              _textController_HealthTax.clear();
              _textController_ExtraLandTax.clear();
              _textController_OtherTax.clear();

              _textController_uid.clear();
              _textController_extraInfo.clear();
              multiUids = [TextSpan()];
            },
          );
        },
      ),
    );
  }

  Future<void> createTotalFormula() async {
    var formulaRef;
    //START create Formula in each year once
    formulaRef = await FirebaseFirestore.instance
        .collection(adminVillage + adminPin)
        .doc(docMainDb)
        .collection(collFormula)
        .doc(docCalcultion);

    await formulaRef.get().then(
      (docSnapshot) async {
        if (docSnapshot.exists) {
          /*
                                  //if allready present
                                  showAlertDialog(
                                      context,
                                      AppLocalizations.of(gContext)!.kTitlePresent,
                                      AppLocalizations.of(gContext)!.kSubTitleEntryAlreadyPresent,
                                      Icon(Icons.person_search_rounded))
                                      */
        } else {
          //if entry not present in db then add
          await FirebaseFirestore.instance
              .collection(adminVillage + adminPin)
              .doc(docMainDb)
              .collection(collFormula)
              .doc(docCalcultion)
              .set(
            {
              keyTotalBalance: 0,
              keyTotalIn: 0,
              keyTotalOut: 0,
            },
          );
        }
      },
    );
  }

  Future<void> updateYearWiseFormula(int houseTax, int waterTax) async {
    var formulaRef;
    //START create Formula in each year once
    formulaRef = await FirebaseFirestore.instance
        .collection(adminVillage + adminPin)
        .doc(docMainDb)
        .collection(collFormula + dropdownValueYear)
        .doc(docCalcultion);

    await formulaRef.get().then(
      (value) async {
        if (value.exists) {
          //if already present get and update.
          int pendingHouse,
              totalHouse,
              totalHouseAfterDiscountFine,
              pendingWater,
              totalWater;

          pendingHouse = totalHouse =
              totalHouseAfterDiscountFine = pendingWater = totalWater = 0;

          var y = value.data();
          totalHouse = y![keyYfTotalHouse];
          totalHouseAfterDiscountFine = y![keyYfTotalHouseAfterDiscountFine];
          pendingHouse = y![keyYfPendingHouse];
          totalWater = y![keyYfTotalWater];
          pendingWater = y![keyYfPendingWater];

          await formulaRef.update(
            {
              keyYfTotalHouse: totalHouse + houseTax,
              keyYfTotalHouseAfterDiscountFine:
                  totalHouseAfterDiscountFine + houseTax,
              keyYfPendingHouse: pendingHouse + houseTax,
              keyYfTotalWater: totalWater + waterTax,
              keyYfPendingWater: pendingWater + waterTax,
            },
          );
        } else {
          //if entry not present in db then add
          await FirebaseFirestore.instance
              .collection(adminVillage + adminPin)
              .doc(docMainDb)
              .collection(collFormula + dropdownValueYear)
              .doc(docCalcultion)
              .set(
            {
              keyYfTotalHouse: houseTax,
              keyYfTotalHouseAfterDiscountFine: houseTax,
              keyYfCollectedHouse: 0,
              keyYfPendingHouse: houseTax,
              keyYfTotalWater: waterTax,
              keyYfCollectedWater: 0,
              keyYfPendingWater: waterTax,
            },
          );
        }
      },
    );
  }

  //check if already present.
  //if no add
  //if yes check for same mobile it is present
  //if yes add.
  //if no failure out.
  Future<bool> checkIfUidPresent(String mobile, String uid) async {
    bool present = false;
    await FirebaseFirestore.instance
        .collection(adminVillage + adminPin)
        .doc(docUids)
        .get()
        .then(
      (uidDoc) async {
        if (uidDoc.exists) {
          //uids doc present
          var y = uidDoc.data();
          if (y!.containsKey(keyUids + dropdownValueYear)) {
            //key present
            var arr = y[keyUids + dropdownValueYear];
            if (arr.contains(uid)) {
              //present pop
              onPressedInputInfo = false;
              popAlert(
                  context,
                  AppLocalizations.of(gContext)!.kTitleTryCatchFail,
                  AppLocalizations.of(gContext)!.txtUidPresentForYearForVillage,
                  getWrongIcon(),
                  1);
              present = true;
              return;
            } else {
              //create key.
              await FirebaseFirestore.instance
                  .collection(adminVillage + adminPin)
                  .doc(docUids)
                  .update(
                {
                  keyUids + dropdownValueYear: FieldValue.arrayUnion([uid]),
                },
              );
            }
          } else {
            await FirebaseFirestore.instance
                .collection(adminVillage + adminPin)
                .doc(docUids)
                .update(
              {
                keyUids + dropdownValueYear: FieldValue.arrayUnion([uid]),
              },
            );
          }
        } else {
          //doc village uids not present
          //as well as key in doc villageUids not present.
          //create doc and create key.
          await FirebaseFirestore.instance
              .collection(adminVillage + adminPin)
              .doc(docUids)
              .set(
            {
              keyUids + dropdownValueYear: FieldValue.arrayUnion([uid]),
            },
          );
        }
      },
    );
    return present;

//we want to know if that uid allready used in village for that year in village.
//make year wise lists.
  }

  @override
  Widget build(BuildContext context) {
    gContext = context;
    onPressedDrawerAddPerson = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(gContext)!.appBarHeadingInputInfo,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: clrGreen,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Container(
            child: Form(
              key: _formKeyInputForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  getYearTile(clrGreen),
                  //getPadding(),
                  Expanded(
                    child: TextFormField(
                      controller: _textController_mobile,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.mobile_friendly),
                          hintText: AppLocalizations.of(gContext)!
                              .msgEnterMobileNumber,
                          labelText:
                              AppLocalizations.of(gContext)!.labelMobile +
                                  txtStar),
                      onChanged: (value) async {
                        if ((value.length < 10) || (value.length > 10)) {
                          _textController_name.text = "";
                          _textController_mail.text = "";
                          _textController_houseTax.text = "";
                          _textController_waterTax.text = "";

                          _textController_ElectricityTax.text = "";
                          _textController_HealthTax.text = "";
                          _textController_ExtraLandTax.text = "";
                          _textController_OtherTax.text = "";

                          _textController_uid.text = "";
                          _textController_extraInfo.text = "";
                          multiUidsTextSpan.clear();

                          setState(() {
                            uid = "";
                            multiUids = [TextSpan()];
                          });
                        }
                        if (value.length == 10) {
                          //fetch data and assign it to controller.
                          try {
                            mobile = value;

                            await FirebaseFirestore.instance
                                .collection(adminVillage + adminPin)
                                .doc(docYrsMobileUids)
                                .collection(collYrs)
                                .doc((int.parse(dropdownValueYear) - 1)
                                    .toString())
                                .get()
                                .then(
                              (mapMobUid) async {
                                if (mapMobUid.exists) {
                                  var y = mapMobUid.data();
                                  if (y!.containsKey(value)) {
                                    var uids = y[value];
                                    if (uids.length == 1) {
                                      //one uid in last year
                                      uid = uids[0];
                                      //fetch info from last year

                                      await FirebaseFirestore.instance
                                          .collection(adminVillage + adminPin)
                                          .doc(docMainDb)
                                          .collection(docMainDb +
                                              (int.parse(dropdownValueYear) - 1)
                                                  .toString())
                                          .doc(value.toString() + uids[0])
                                          .get()
                                          .then(
                                        (person) {
                                          var y = person.data();
                                          uid = y![keyUid];
                                          _textController_name.text =
                                              y[keyName];
                                          _textController_mail.text =
                                              y[keyEmail];
                                          _textController_houseTax.text =
                                              y[keyHouse].toString();
                                          _textController_waterTax.text =
                                              y[keyWater].toString();

                                          _textController_ElectricityTax.text =
                                              y[keyElectricity].toString();
                                          _textController_HealthTax.text =
                                              y[keyHealth].toString();
                                          _textController_ExtraLandTax.text =
                                              y[keyExtraLand].toString();
                                          _textController_OtherTax.text =
                                              y[keyOtherTax].toString();

                                          _textController_uid.text = y[keyUid];
                                          _textController_extraInfo.text =
                                              y[keyExtraInfo];
                                        },
                                      );
                                    }
                                    if (uids.length > 1) {
                                      //multi uid found in last year
                                      //pop up
                                      //display all uids and click one.
                                      String strUids = "";
                                      for (var id in uids) {
                                        strUids = strUids + ", " + id;
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
                                                uid = id;
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        adminVillage + adminPin)
                                                    .doc(docMainDb)
                                                    .collection(docMainDb +
                                                        (int.parse(dropdownValueYear) -
                                                                1)
                                                            .toString())
                                                    .doc(mobile + id)
                                                    .get()
                                                    .then(
                                                  (person) {
                                                    if (person.exists) {
                                                      var y = person.data();
                                                      _textController_name
                                                          .text = y![keyName];
                                                      _textController_mail
                                                          .text = y[keyEmail];
                                                      _textController_houseTax
                                                              .text =
                                                          y[keyHouse]
                                                              .toString();
                                                      _textController_waterTax
                                                              .text =
                                                          y[keyWater]
                                                              .toString();

                                                      _textController_ElectricityTax
                                                              .text =
                                                          y[keyElectricity]
                                                              .toString();
                                                      _textController_HealthTax
                                                              .text =
                                                          y[keyHealth]
                                                              .toString();
                                                      _textController_ExtraLandTax
                                                              .text =
                                                          y[keyExtraLand]
                                                              .toString();
                                                      _textController_OtherTax
                                                              .text =
                                                          y[keyOtherTax]
                                                              .toString();

                                                      _textController_uid.text =
                                                          y[keyUid];
                                                      _textController_extraInfo
                                                              .text =
                                                          y[keyExtraInfo];
                                                    }
                                                  },
                                                );
                                              },
                                          ),
                                        );
                                      }
                                      setState(
                                        () {
                                          multiUids = multiUidsTextSpan;
                                        },
                                      );
                                      popAlert(
                                        context,
                                        AppLocalizations.of(gContext)!
                                            .kTitleMultiUids_AddPerson,
                                        strUids,
                                        getMultiUidIcon(50),
                                        1,
                                      );
                                    }
                                    uids = "";
                                  }
                                }
                              },
                            );

                            //var lsUids = getMobileUidMapping(value);

                          } catch (e) {
                            //print(e);
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(gContext)!
                              .msgEnterMobileNumber;
                        }
                        if (value.length != 10) {
                          return AppLocalizations.of(gContext)!
                              .msgTenDigitNumber;
                        }
                        if (!isNumeric(value)) {
                          return AppLocalizations.of(gContext)!.msgOnlyNumber;
                        }
                        if (value.startsWith('0')) {
                          return AppLocalizations.of(gContext)!.msgNoStartZero;
                        }
                        mobile = value;
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
                  //getPadding(),
                  Expanded(
                    child: TextFormField(
                      controller: _textController_uid,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.wb_incandescent_outlined),
                          hintText: AppLocalizations.of(gContext)!.msgEnterUid,
                          labelText: AppLocalizations.of(gContext)!.labelUid +
                              txtStar),
                      onFieldSubmitted: (val) {
                        uid = val;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(gContext)!.msgEnterUid;
                        }

                        uid = value;
                        return null;
                      },
                    ),
                  ),
                  //getPadding(),
                  Expanded(
                    child: TextFormField(
                      controller: _textController_name,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.person),
                          hintText:
                              AppLocalizations.of(gContext)!.msgEnterFullName,
                          labelText: AppLocalizations.of(gContext)!.labelName +
                              txtStar),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(gContext)!
                              .msgEnterFullName;
                        }
                        name = value;
                        return null;
                      },
                    ),
                  ),
                  //getPadding(),
                  Expanded(
                    child: TextFormField(
                      controller: _textController_mail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.email),
                          hintText:
                              AppLocalizations.of(gContext)!.msgEnterUserMail,
                          labelText: AppLocalizations.of(gContext)!.labelEmail +
                              txtStar),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(gContext)!
                              .msgEnterUserMail;
                        }

                        email = value;
                        return null;
                      },
                    ),
                  ),
                  //getPadding(),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _textController_houseTax,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.house),
                              hintText: AppLocalizations.of(gContext)!
                                  .msgEnterHouseTax,
                              labelText:
                                  AppLocalizations.of(gContext)!.labelHouseTax +
                                      txtStar),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(gContext)!
                                  .msgHouseTaxAmount;
                            }
                            if (!isNumeric(value)) {
                              return AppLocalizations.of(gContext)!
                                  .msgOnlyNumber;
                            }
                            houseTax = int.parse(value);
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _textController_waterTax,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.water),
                              hintText:
                                  AppLocalizations.of(gContext)!.msgWaterTax,
                              labelText:
                                  AppLocalizations.of(gContext)!.labelWaterTax +
                                      txtStar),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(gContext)!.msgWaterTax;
                            }
                            if (!isNumeric(value)) {
                              return AppLocalizations.of(gContext)!
                                  .msgOnlyNumber;
                            }
                            waterTax = int.parse(value);
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  getPadding(),

                  //START electricity tax, health tax, extra land tax, other tax
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _textController_ElectricityTax,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.electrical_services),
                              hintText: AppLocalizations.of(gContext)!
                                  .msgEnterElectricityTax,
                              labelText: AppLocalizations.of(gContext)!
                                      .labelElectricityTax +
                                  txtStar),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(gContext)!
                                  .msgEnterElectricityTax;
                            }
                            if (!isNumeric(value)) {
                              return AppLocalizations.of(gContext)!
                                  .msgOnlyNumber;
                            }
                            electricityTax = int.parse(value);
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _textController_HealthTax,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.health_and_safety_outlined),
                              hintText: AppLocalizations.of(gContext)!
                                  .msgEnterHealthTax,
                              labelText: AppLocalizations.of(gContext)!
                                      .labelHealthTax +
                                  txtStar),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(gContext)!
                                  .msgEnterHealthTax;
                            }
                            if (!isNumeric(value)) {
                              return AppLocalizations.of(gContext)!
                                  .msgOnlyNumber;
                            }
                            healthTax = int.parse(value);
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  getPadding(),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _textController_ExtraLandTax,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.landscape_outlined),
                              hintText: AppLocalizations.of(gContext)!
                                  .msgExtraLandTaxAmount,
                              labelText: AppLocalizations.of(gContext)!
                                      .labelExtraLandTax +
                                  txtStar),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(gContext)!
                                  .msgExtraLandTaxAmount;
                            }
                            if (!isNumeric(value)) {
                              return AppLocalizations.of(gContext)!
                                  .msgOnlyNumber;
                            }
                            extraLandTax = int.parse(value);
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _textController_OtherTax,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.movie_creation),
                              hintText: AppLocalizations.of(gContext)!
                                  .msgOtherTaxAmount,
                              labelText:
                                  AppLocalizations.of(gContext)!.labelOtherTax +
                                      txtStar),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(gContext)!
                                  .msgOtherTaxAmount;
                            }
                            if (!isNumeric(value)) {
                              return AppLocalizations.of(gContext)!
                                  .msgOnlyNumber;
                            }
                            otherTax = int.parse(value);
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  getPadding(),
                  //END electricity tax, health tax, extra land tax, other tax

                  Expanded(
                    child: TextFormField(
                      controller: _textController_extraInfo,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.holiday_village),
                          hintText: AppLocalizations.of(gContext)!.msgExtraInfo,
                          labelText:
                              AppLocalizations.of(gContext)!.labelExtraInfo +
                                  txtStar),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(gContext)!.msgExtraInfo;
                        }
                        extraInfo = value;
                        return null;
                      },
                    ),
                  ),
                  //getPadding(),
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKeyInputForm.currentState!.validate() &&
                              onPressedInputInfo == false) {
                            try {
                              onPressedInputInfo = true;
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(gContext)!
                                      .msgProcessingData),
                                ),
                              );
                              //get admin mail
                              //from users, get admin village and pin
                              //read villagePin-> docMainDb-> docMainDb2020=> add
                              var usersRef = await FirebaseFirestore.instance
                                  .collection(adminVillage + adminPin)
                                  .doc(docMainDb)
                                  .collection(docMainDb + dropdownValueYear)
                                  .doc(mobile + uid);

                              await usersRef.get().then(
                                (docSnapshot) async {
                                  if (docSnapshot.exists) {
                                    //if allready present
                                    onPressedInputInfo = false;
                                    popAlert(
                                      context,
                                      AppLocalizations.of(gContext)!
                                          .kTitlePresent,
                                      AppLocalizations.of(gContext)!
                                          .kSubTitleEntryAlreadyPresent,
                                      Icon(Icons.person_search_rounded),
                                      1,
                                    );
                                    return;
                                  } else {
                                    //check if already present.
                                    //if no add
                                    //if yes check for same mobile it is present
                                    //if yes add.
                                    //if no failure out.
                                    int totalTaxExceptWater = houseTax +
                                        electricityTax +
                                        healthTax +
                                        extraLandTax +
                                        otherTax;
                                    var present =
                                        await checkIfUidPresent(mobile, uid);
                                    if (present == false) {
                                      //if uid absent in village do further
                                      //await createMobileUidMapping(mobile, uid);
                                      await createYearMobileUidMap(
                                          dropdownValueYear, mobile, uid);

                                      //if entry not present in db then add
                                      await FirebaseFirestore.instance
                                          .collection(adminVillage + adminPin)
                                          .doc(docMainDb)
                                          .collection(
                                              docMainDb + dropdownValueYear)
                                          .doc(mobile + uid)
                                          .set(
                                        {
                                          keyHouse: houseTax,
                                          keyHouseGiven: false,
                                          keyEmail: email,
                                          keyMobile: mobile,
                                          keyUid: uid,
                                          keyName: name,
                                          keyWater: waterTax,
                                          keyElectricity: electricityTax,
                                          keyHealth: healthTax,
                                          keyExtraLand: extraLandTax,
                                          keyOtherTax: otherTax,
                                          keyTotalTaxOtherThanWater:
                                              totalTaxExceptWater,
                                          keyWaterGiven: false,
                                          keyExtraInfo: extraInfo,
                                          keyRemindCount: 2,
                                        },
                                      );
                                      await createTotalFormula(); //good
                                      await updateYearWiseFormula(
                                        //good
                                        totalTaxExceptWater,
                                        waterTax,
                                      );
                                      //END create Formula in each year once
                                      popAlert(
                                          context,
                                          AppLocalizations.of(gContext)!
                                              .titleSuccess,
                                          AppLocalizations.of(gContext)!
                                              .subtitleSuccess,
                                          getRightIcon(),
                                          2);
                                    }
                                  }
                                },
                              );
                            } catch (e) {
                              onPressedInputInfo = false;
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
