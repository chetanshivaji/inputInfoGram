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
  int amount = 0;

  String nameEntry = "";
  int amountEntry = 0;

  int mobile = 0;
  int houseTax = 0;
  int waterTax = 0;
  bool houseGiven = false;
  bool waterGiven = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Person Gram"),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKeyremoveForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: TextFormField(
                onChanged: (text) async {
                  if (text.length == 10) {
                    try {
                      nameEntry = await FirebaseFirestore.instance
                          .collection(dbYear)
                          .doc(text)
                          .get()
                          .then(
                        (value) {
                          var y = value.data();
                          nameEntry = y!["name"];
                          amountEntry = y["house"];
                          return y["name"];
                        },
                      );
                    } catch (e) {
                      print(e);
                    }

                    setState(
                      () {
                        name = nameEntry;
                        amount = amountEntry;
                      },
                    );
                  }
                },
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
              child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    "Name = $name",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(Icons.attach_money),
                title: Text(
                  "Amount = $amount",
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
                    if (_formKeyremoveForm.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );
                      var collection =
                          FirebaseFirestore.instance.collection(dbYear);
                      await collection.doc(mobile.toString()).delete();

                      showAlertDialog(context, titleSuccess, subtitleSuccess,
                          getRightIcon());
                    }
                  },
                  child: const Text(
                    'Submit',
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
