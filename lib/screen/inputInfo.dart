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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Person to GramDB"),
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
                "Year",
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
                    hintText: "Enter Full Name",
                    labelText: "Name *"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
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
                    hintText: "Enter email Id",
                    labelText: "mail *"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please mail ID';
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
                    hintText: "Enter mobile Number",
                    labelText: "number *"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number';
                  }
                  if (value.length != 10) {
                    return "Please enter 10 digits!";
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
                    hintText: "Enter House tax",
                    labelText: "House Tax *"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter house tax amount';
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
                    hintText: "Enter Water tax",
                    labelText: "Water Tax *"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter water tax amount';
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
                    if (_formKeyInputForm.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );
                      //get admin mail
                      //from users, get admin village and pin

                      //read villagePin-> mainDb-> mainDb2020=> add

                      var ls = await getLoggedInUserVillagePin();
                      var usersRef = await FirebaseFirestore.instance
                          .collection(ls[0] + ls[1])
                          .doc(mainDb)
                          .collection(mainDb + dropdownvalue)
                          .doc(mobile.toString());

                      usersRef.get().then(
                            (docSnapshot) => {
                              if (docSnapshot.exists)
                                {
                                  //if allready present
                                  popAlert(
                                      context,
                                      "PRESENT",
                                      "Entry already present, can not add",
                                      Icon(Icons.person_search_rounded),
                                      1)
                                }
                              else
                                {
                                  //if entry not present in db then add
                                  FirebaseFirestore.instance
                                      .collection(ls[0] + ls[1])
                                      .doc(mainDb)
                                      .collection(mainDb + dropdownvalue)
                                      .doc(mobile.toString())
                                      .set(
                                    {
                                      'house': houseTax,
                                      'houseGiven': false,
                                      'email': email,
                                      'mobile': mobile,
                                      'name': name,
                                      'water': waterTax,
                                      'waterGiven': false,
                                    },
                                  ),
                                  //START create Formula in each year once
                                  formulaRef = FirebaseFirestore.instance
                                      .collection(ls[0] + ls[1])
                                      .doc(mainDb)
                                      .collection('formula')
                                      .doc('calculation'),

                                  formulaRef.get().then(
                                        (docSnapshot) => {
                                          if (docSnapshot.exists)
                                            {
                                              /*
                                  //if allready present
                                  showAlertDialog(
                                      context,
                                      "PRESENT",
                                      "Entry already present, can not add",
                                      Icon(Icons.person_search_rounded))
                                      */
                                            }
                                          else
                                            {
                                              //if entry not present in db then add
                                              FirebaseFirestore.instance
                                                  .collection(ls[0] + ls[1])
                                                  .doc(mainDb)
                                                  .collection('formula')
                                                  .doc('calculation')
                                                  .set(
                                                {
                                                  'totalBalance': 0,
                                                  'totalIn': 0,
                                                  'totalOut': 0,
                                                },
                                              ),
                                            }
                                        },
                                      ),
                                  //END create Formula in each year once
                                  popAlert(context, titleSuccess,
                                      subtitleSuccess, getRightIcon(), 2)
                                }
                            },
                          );
                    }
                  },
                  child: const Text(
                    'Submit',
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
