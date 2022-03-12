import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inputgram/consts.dart';
import 'package:inputgram/util.dart';

class removeInfo extends StatefulWidget {
  static String id = "removescreen";
  const removeInfo({Key? key}) : super(key: key);

  @override
  _removeInfoState createState() => _removeInfoState();
}

class _removeInfoState extends State<removeInfo> {
  final _formKeyremoveForm = GlobalKey<FormState>();

  String name = "";
  String email = "";

  String nameEntry = "";
  String emailEntry = "";

  int mobile = 0;
  int houseTax = 0;
  int waterTax = 0;
  bool houseGiven = false;
  bool waterGiven = false;

  @override
  Widget build(BuildContext context) {
    bool onPressedRemoveInfo = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarHeadingRemoveInfo,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: clrRed,
      ),
      body: Form(
        key: _formKeyremoveForm,
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
                dropdownColor: clrRed,

                alignment: Alignment.topLeft,

                // Initial Value
                value: dropdownvalue,
                // Down Arrow Icon
                icon: Icon(
                  Icons.sort,
                  color: Colors.red,
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
                onChanged: (text) async {
                  if (text.length == 10) {
                    try {
                      await FirebaseFirestore.instance
                          .collection(adminVillage + adminPin)
                          .doc(mainDb)
                          .collection(mainDb + dropdownvalue)
                          .doc(text)
                          .get()
                          .then(
                        (value) {
                          var y = value.data();
                          nameEntry = y![keyName];
                          emailEntry = y[keyEmail];
                        },
                      );
                    } catch (e) {
                      print(e);
                    }

                    setState(
                      () {
                        name = nameEntry;
                        email = emailEntry;
                      },
                    );
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
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKeyremoveForm.currentState!.validate() &&
                        onPressedRemoveInfo == false) {
                      try {
                        onPressedRemoveInfo = true;
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msgProcessingData),
                          ),
                        );

                        var collection = FirebaseFirestore.instance
                            .collection(adminVillage + adminPin)
                            .doc(mainDb)
                            .collection(mainDb + dropdownvalue);
                        await collection.doc(mobile.toString()).get().then(
                          (value) {
                            if (value.exists) {
                              FirebaseFirestore.instance
                                  .collection(adminVillage + adminPin)
                                  .doc(mainDb)
                                  .collection(mainDb + dropdownvalue)
                                  .doc(mobile.toString())
                                  .delete();
                              popAlert(context, titleSuccess, subtitleSuccess,
                                  getRightIcon(), 2);
                            } else {
                              onPressedRemoveInfo = false;
                              popAlert(context, msgAlreadyRemoved, "",
                                  getWrongIcon(), 2);
                            }
                          },
                        );
                      } catch (e) {
                        onPressedRemoveInfo = false;
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
