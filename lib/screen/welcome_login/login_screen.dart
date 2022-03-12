import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inputgram/myApp.dart';
import 'package:inputgram/util.dart';
import 'package:inputgram/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  static String id = "loginscreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formLoginKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    bool pressed = true;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formLoginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 60),
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
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.text,
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
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      labelLogin,
                    ),
                    onPressed: pressed
                        ? () async {
                            if (_formLoginKey.currentState!.validate()) {
                              String adminMail = "";
                              //Implement registration functionality.
                              try {
                                //Only admin should login
                                adminMail = await FirebaseFirestore.instance
                                    .collection(collUsers)
                                    .doc(email)
                                    .get()
                                    .then(
                                  (value) async {
                                    if (!value.exists) {
                                      //if allready present
                                      popAlert(
                                        context,
                                        kTitleNotPresent,
                                        kSubTitleEmailPresent,
                                        getWrongIcon(),
                                        2,
                                      );
                                      return "";
                                    } else {
                                      var y = value.data();
                                      adminVillage = y![keyVillage];
                                      adminPin = y[keyPin];
                                      //access = y[keyAccess];

                                      if (y[keyIsAdmin]) {
                                        return y[keyMail];
                                      } else {
                                        return msgNotAdmin;
                                      }
                                    }
                                  },
                                );
                                if (adminMail == "") return;

                                if (adminMail == email) {
                                  final newUser =
                                      await _auth.signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  if (newUser != null) {
                                    userMail = email;
                                    Navigator.pushNamed(
                                      context,
                                      MyApp.id,
                                    );
                                  }
                                } else {
                                  popAlert(
                                    context,
                                    kTitleFail,
                                    kSubTitleOnlyAdmin,
                                    getWrongIcon(),
                                    2,
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
