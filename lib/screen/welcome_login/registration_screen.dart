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
  String address = "";

  Future<void> setAdminUserInfoInDb(
      String village, String pin, String address, String email) async {
    await FirebaseFirestore.instance
        .collection(village + pin)
        .doc("villageInfo")
        .set(
      {
        'village': village,
        'pin': pin,
        'address': address,
        'adminMail': email,
      },
    );

    //Add entry of new user to users
    await FirebaseFirestore.instance.collection("users").doc(email).set(
      {
        'village': village,
        "pin": pin,
        //by default approved for admin
        'approved': true,
        //access level set by admin decided type of use, eg .viewer, collector, admin, spender
        'accessLevel': accessItems[accessLevel.SuperUser.index],
        'mail': email,
        'isAdmin': true,
      },
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    bool pressed = true;
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
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  email = value;
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: "AdminEmail *",
                  hintText: 'Enter admin email',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter minimum 6 digit password';
                  }
                  password = value;
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.password),
                  labelText: "AdminPassword *",
                  hintText: 'Enter admin password',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter minimum 6 digit password';
                  }
                  reEnterPassword = value;
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.password),
                  labelText: "AdminPassword *",
                  hintText: 'Re enter admin password again',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter village name';
                  }
                  village = value;
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.holiday_village),
                  labelText: "Village *",
                  hintText: 'Enter village name',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter village pin';
                  }
                  pin = value;
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.pin),
                  labelText: "Pin *",
                  hintText: 'Enter pin',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter village address';
                  }
                  address = value;
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.holiday_village),
                  labelText: "VillageAddress *",
                  hintText: 'Enter village address',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
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
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: pressed
                        ? () async {
                            if (_formRegKey.currentState!.validate()) {
                              if (password != reEnterPassword) {
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
                                final newUser =
                                    await _auth.createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );

                                if (newUser != null) {
                                  userMail = email;

                                  await setAdminUserInfoInDb(
                                    village,
                                    pin,
                                    address,
                                    email,
                                  );

                                  Navigator.pushNamed(context, MyApp.id);
                                  popAlert(
                                    context,
                                    registerSuccess,
                                    kSubTitleLoginSuccess,
                                    getRightIcon(),
                                    1,
                                  );
                                }
                              } catch (e) {
                                popAlert(
                                  context,
                                  kTitleFail,
                                  e.toString(),
                                  getWrongIcon(),
                                  2,
                                );
                                return;
                              }
                              pressed = false;
                            }
                          }
                        : null,
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
