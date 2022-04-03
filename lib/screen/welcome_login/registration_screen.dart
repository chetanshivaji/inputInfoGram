import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inputgram/consts.dart';
import 'package:inputgram/util.dart';
import 'package:inputgram/myApp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "registerationscreen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formRegKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  String reEnterPassword = "";
  String village = "";
  String pin = "";

  bool onPressedRegister = false;
  String registeredName = "";

  Future<void> setAdminUserInfoInDb(
      String village,
      String pin,
      String email,
      String registeredName,
      String state,
      String district,
      String taluka) async {
    adminVillage = village;
    adminPin = pin;
    //access = accessItems[accessLevel.SuperUser.index];
    await FirebaseFirestore.instance
        .collection(village + pin)
        .doc(docVillageInfo)
        .set(
      {
        keyVillage: village,
        keyPin: pin,
        keyAdminMail: email,
        keyRegisteredName: registeredName,
        keyState: state,
        keyDistrict: district,
        keyTaluka: taluka,
      },
    );

    //Add entry of new user to users
    await FirebaseFirestore.instance.collection(collUsers).doc(email).set(
      {
        keyVillage: village,
        keyPin: pin,
        //access level set by admin decided type of use, eg .viewer, collector, admin, spender
        keyAccessLevel: accessItems[accessLevel.SuperUser.index],
        keyMail: email,
        keyIsAdmin: true,
        keyRegisteredName: registeredName,
        keyState: state,
        keyDistrict: district,
        keyTaluka: taluka,
      },
    );
    //Add village name in hierarchy, state-> district->taluka->villages

    await FirebaseFirestore.instance.collection(state).doc(district).get().then(
      (value) async {
        if (value.exists) {
          await FirebaseFirestore.instance
              .collection(state)
              .doc(district)
              .update(
            {
              taluka: FieldValue.arrayUnion([village])
            },
          );
        } else {
          await FirebaseFirestore.instance.collection(state).doc(district).set(
            {
              taluka: FieldValue.arrayUnion([village])
            },
          );
        }
      },
    );
    return;
  }

  String state = "";
  String dist = "";
  String tal = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formRegKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 60),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return msgEnterUser;
                    }
                    registeredName = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: labelName,
                    hintText: msgEnterUser,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return msgEnterEmail;
                    }
                    email = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: labelAdminEmail,
                    hintText: msgEnterEmail,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return msgEnterPassword;
                    }
                    password = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.password),
                    labelText: labelAdminPassword,
                    hintText: msgEnterPassword,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return msgReEnterPassword;
                    }
                    reEnterPassword = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.password),
                    labelText: labelAdminPassword,
                    hintText: msgReEnterPassword,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return msgEnterVillageName;
                    }
                    village = value.toLowerCase();
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.holiday_village),
                    labelText: labelVillage,
                    hintText: msgEnterVillageName,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return msgEnterVillagePin;
                    }
                    if (!isNumeric(value)) {
                      return msgOnlyNumber;
                    }

                    pin = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.pin),
                    labelText: labelPin,
                    hintText: msgEnterVillagePin,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "State - ",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton(
                      borderRadius: BorderRadius.circular(12.0),
                      dropdownColor: clrBlue,

                      //alignment: Alignment.topRight,

                      // Initial Value
                      value: sState,
                      // Down Arrow Icon
                      icon: Icon(
                        Icons.sort,
                        color: clrBlue,
                      ),
                      // Array list of items
                      items: states.map(
                        (String states) {
                          return DropdownMenuItem(
                            value: states,
                            child: Text(states),
                          );
                        },
                      ).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newAccessValue) async {
                        if (newAccessValue != access) {
                          setState(
                            () {
                              sState = newAccessValue.toString();
                            },
                          );
                        }
                      },
                    ),
                    /*
                    Text(
                      state,
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    */
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "District - ",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton(
                      borderRadius: BorderRadius.circular(12.0),
                      dropdownColor: clrBlue,

                      //alignment: Alignment.topRight,

                      // Initial Value
                      value: sDistrict,
                      // Down Arrow Icon
                      icon: Icon(
                        Icons.sort,
                        color: clrBlue,
                      ),
                      // Array list of items
                      items: districts.map(
                        (String districts) {
                          return DropdownMenuItem(
                            value: districts,
                            child: Text(districts),
                          );
                        },
                      ).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newAccessValue) async {
                        if (newAccessValue != access) {
                          setState(
                            () {
                              sDistrict = newAccessValue.toString();
                            },
                          );
                        }
                      },
                    ),
                    /*
                    Text(
                      dist,
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    */
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "Taluka - ",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton(
                      borderRadius: BorderRadius.circular(12.0),
                      dropdownColor: clrBlue,

                      //alignment: Alignment.topRight,

                      // Initial Value
                      value: sTaluka,
                      // Down Arrow Icon
                      icon: Icon(
                        Icons.sort,
                        color: clrBlue,
                      ),
                      // Array list of items
                      items: talukas.map(
                        (String talukas) {
                          return DropdownMenuItem(
                            value: talukas,
                            child: Text(talukas),
                          );
                        },
                      ).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newAccessValue) async {
                        if (newAccessValue != access) {
                          setState(
                            () {
                              sTaluka = newAccessValue.toString();
                            },
                          );
                        }
                      },
                    ),
                    /*
                    Text(
                      tal,
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    */
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    splashColor: clrBSplash,
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      labelRegister,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formRegKey.currentState!.validate() &&
                          onPressedRegister == false) {
                        onPressedRegister = true;

                        if (password != reEnterPassword) {
                          onPressedRegister = false;
                          popAlert(
                            context,
                            titlePasswordMismatch,
                            subtitlePasswordMismatch,
                            getWrongIcon(),
                            1,
                          ); //one time pop navigation
                          return;
                        }
                        //Implement registration functionality.
                        try {
                          //check if village pin already present then return;
                          bool villagePresent = false;
                          await FirebaseFirestore.instance
                              .collection(village + pin)
                              .doc(docVillageInfo)
                              .get()
                              .then(
                            (docVillageInfo) async {
                              if (docVillageInfo.exists) {
                                //already present pop and return.
                                onPressedRegister = false;
                                popAlert(
                                  context,
                                  kTitleVillageAlreadyPresent,
                                  "",
                                  getWrongIcon(),
                                  1,
                                );
                                villagePresent = true;
                                return;
                              }
                            },
                          );
                          if (villagePresent == true) {
                            return;
                          }

                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          if (newUser != null) {
                            userMail = email;

                            await setAdminUserInfoInDb(village, pin, email,
                                registeredName, sState, sDistrict, sTaluka);

                            Navigator.pushNamed(context, MyApp.id);
                            popAlert(
                              context,
                              registerSuccess,
                              '',
                              getRightIcon(),
                              1,
                            );
                          }
                        } catch (e) {
                          onPressedRegister = false;
                          popAlert(
                            context,
                            kTitleFail,
                            e.toString(),
                            getWrongIcon(),
                            1,
                          );
                          return;
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
