import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inputgram/consts.dart';
import 'package:inputgram/util.dart';

class inputInfo extends StatefulWidget {
  static String id = "inputscreen";
  const inputInfo({Key? key}) : super(key: key);

  @override
  _inputInfoState createState() => _inputInfoState();
}

class _inputInfoState extends State<inputInfo> {
  final _formKeyInputForm = GlobalKey<FormState>();
  String name = "";
  String email = "";
  int mobile = 0;
  int houseTax = 0;
  int waterTax = 0;
  bool houseGiven = false;
  bool waterGiven = false;
  bool onPressedInputInfo = false;
  var _textController_name = TextEditingController();
  var _textController_mail = TextEditingController();
  var _textController_mobile = TextEditingController();
  var _textController_houseTax = TextEditingController();
  var _textController_waterTax = TextEditingController();

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
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    onPressedDrawerAddPerson = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarHeadingInputInfo,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: clrGreen,
      ),
      body: Form(
        key: _formKeyInputForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getYearTile(clrGreen),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController_mobile,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.mobile_friendly),
                    hintText: msgEnterMobileNumber,
                    labelText: labelMobile),
                onChanged: (value) async {
                  if (value.length < 10) {
                    _textController_name.text = "";
                    _textController_mail.text = "";
                    _textController_houseTax.text = "";
                    _textController_waterTax.text = "";
                  }
                  if (value.length == 10) {
                    //fetch data and assign it to controller.
                    try {
                      await FirebaseFirestore.instance
                          .collection(adminVillage + adminPin)
                          .doc(mainDb)
                          .collection(mainDb +
                              (int.parse(dropdownValueYear) - 1).toString())
                          .doc(value.toString())
                          .get()
                          .then(
                        (value) {
                          var y = value.data();
                          _textController_name.text = y![keyName];
                          _textController_mail.text = y[keyEmail];
                          _textController_houseTax.text =
                              y[keyHouse].toString();
                          _textController_waterTax.text =
                              y[keyWater].toString();
                        },
                      );
                    } catch (e) {
                      print(e);
                    }
                  }
                },
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
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController_name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.person),
                    hintText: msgEnterFullName,
                    labelText: labelName),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return msgEnterFullName;
                  }
                  name = value;
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController_mail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.person),
                    hintText: msgEnterUserMail,
                    labelText: labelEmail),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return msgEnterUserMail;
                  }

                  email = value;
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController_houseTax,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.house),
                    hintText: msgEnterHouseTax,
                    labelText: labelHouseTax),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return msgHouseTaxAmount;
                  }
                  if (!isNumeric(value)) {
                    return msgOnlyNumber;
                  }
                  houseTax = int.parse(value);
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController_waterTax,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.water),
                    hintText: msgWaterTax,
                    labelText: labelWaterTax),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return msgWaterTax;
                  }
                  if (!isNumeric(value)) {
                    return msgOnlyNumber;
                  }
                  waterTax = int.parse(value);
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    var formulaRef;
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKeyInputForm.currentState!.validate() &&
                        onPressedInputInfo == false) {
                      try {
                        onPressedInputInfo = true;
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msgProcessingData),
                          ),
                        );
                        //get admin mail
                        //from users, get admin village and pin

                        //read villagePin-> mainDb-> mainDb2020=> add

                        var usersRef = await FirebaseFirestore.instance
                            .collection(adminVillage + adminPin)
                            .doc(mainDb)
                            .collection(mainDb + dropdownValueYear)
                            .doc(mobile.toString());

                        usersRef.get().then(
                          (docSnapshot) async {
                            if (docSnapshot.exists) {
                              //if allready present
                              onPressedInputInfo = false;
                              popAlert(
                                context,
                                kTitlePresent,
                                kSubTitleEntryAlreadyPresent,
                                Icon(Icons.person_search_rounded),
                                1,
                              );
                              return;
                            } else {
                              //if entry not present in db then add
                              await FirebaseFirestore.instance
                                  .collection(adminVillage + adminPin)
                                  .doc(mainDb)
                                  .collection(mainDb + dropdownValueYear)
                                  .doc(mobile.toString())
                                  .set(
                                {
                                  keyHouse: houseTax,
                                  keyHouseGiven: false,
                                  keyEmail: email,
                                  keyMobile: mobile,
                                  keyName: name,
                                  keyWater: waterTax,
                                  keyWaterGiven: false,
                                },
                              );
                              //START create Formula in each year once
                              formulaRef = await FirebaseFirestore.instance
                                  .collection(adminVillage + adminPin)
                                  .doc(mainDb)
                                  .collection(collFormula)
                                  .doc(docCalcultion);

                              formulaRef.get().then(
                                (docSnapshot) async {
                                  if (docSnapshot.exists) {
                                    /*
                                  //if allready present
                                  showAlertDialog(
                                      context,
                                      kTitlePresent,
                                      kSubTitleEntryAlreadyPresent,
                                      Icon(Icons.person_search_rounded))
                                      */
                                  } else {
                                    //if entry not present in db then add
                                    await FirebaseFirestore.instance
                                        .collection(adminVillage + adminPin)
                                        .doc(mainDb)
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
                              //END create Formula in each year once
                              popAlert(context, titleSuccess, subtitleSuccess,
                                  getRightIcon(), 2);
                            }
                          },
                        );
                      } catch (e) {
                        onPressedInputInfo = false;
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
