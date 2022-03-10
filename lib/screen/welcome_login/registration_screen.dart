import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inputgram/util.dart';
import 'package:inputgram/myApp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "registerationscreen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  String reEnterPassword = "";
  String village = "";
  String pin = "";
  String address = "";

  @override
  Widget build(BuildContext context) {
    bool pressed = false;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter admin email',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter admin password',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                reEnterPassword = value;
              },
              decoration: InputDecoration(
                hintText: 'Re enter admin password again',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            TextField(
              onChanged: (value) {
                village = value;
                adminVillage = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter village name',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                pin = value;
                adminPin = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter pin',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                address = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter village address',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
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
                  onPressed: () async {
                    if (pressed == false) {
                      pressed = true;
                      if (password != reEnterPassword) {
                        popAlert(
                            context,
                            titlePasswordMismatch,
                            subtitlePasswordMismatch,
                            getWrongIcon(),
                            1); //one time pop navigation
                        return;
                      }
                      //Implement registration functionality.
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          userMail = email;

                          //*********START create village+pin colection and admin */
                          var usersRef = await FirebaseFirestore.instance
                              .collection(village + pin)
                              .doc("admin");

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
                                        1,
                                      )
                                    }
                                  else
                                    {
                                      //if entry not present in db then add
                                      FirebaseFirestore.instance
                                          .collection(village + pin)
                                          .doc("admin")
                                          .set(
                                        {
                                          'village': village,
                                          'pin': pin,
                                          'address': address,
                                          'adminMail': email,
                                          'userUid': FirebaseAuth
                                              .instance.currentUser!.uid
                                              .toString(),
                                        },
                                      ),
                                    }
                                },
                              );
                          //Add entry of new user to users, village pin
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(email)
                              .set(
                            {'village': village, "pin": pin},
                          );
                          FirebaseFirestore.instance
                              .collection(village + pin)
                              .doc("pendingApproval")
                              .collection("pending")
                              .doc(email)
                              .set(
                            {
                              'approved': true, //by default approved for admin
                              'accessLevel':
                                  "SuperUser", //access level set by admin decided type of use, eg .viewer, collector, admin, spender
                              'mail': email,
                            },
                          );
                          //*********END create village+pin colection and admin */

                          Navigator.pushNamed(context, MyApp.id);
                          popAlert(context, registerSuccess,
                              kSubTitleLoginSuccess, getRightIcon(), 1);
                        }
                      } catch (e) {
                        popAlert(context, kTitleFail, e.toString(),
                            getWrongIcon(), 2);
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
    );
  }
}
