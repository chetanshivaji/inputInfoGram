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

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            ListTile(
              leading: Icon(Icons.date_range),
              title: Text(
                labelYear,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: DropdownButton(
                borderRadius: BorderRadius.circular(12.0),
                dropdownColor: clrGreen,

                alignment: Alignment.topLeft,

                // Initial Value
                value: dropdownvalue,
                // Down Arrow Icon
                icon: Icon(
                  Icons.sort,
                  color: Colors.green,
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
                      dropdownvalue = newValue!;
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: TextFormField(
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
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: TextFormField(
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
                            .collection(mainDb + dropdownvalue)
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
                                  .collection(mainDb + dropdownvalue)
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
                            getWrongIcon(), 2);
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
