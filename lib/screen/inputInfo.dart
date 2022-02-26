import 'package:flutter/material.dart';

class inputInfo extends StatefulWidget {
  static String id = "inputscreen";
  const inputInfo({Key? key}) : super(key: key);

  @override
  _inputInfoState createState() => _inputInfoState();
}

class _inputInfoState extends State<inputInfo> {
  final _formKeyInputForm = GlobalKey<FormState>();
  String name = "";
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
        key: _formKeyInputForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                  houseTax = int.parse(value);
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
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKeyInputForm.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );
                      /*
                    FirebaseFirestore.instance.collection("inExtra").add(
                      {
                        'reason': reason,
                        'amount': amount,
                        'date': DateTime.now().toString(),
                        'user': userMail,
                      },
                    );
                    updateFormulaValues(amount.toString(),
                        "in"); //fetch exisiting value from formula and update new value.
                    showAlertDialog(
                        context, titleSuccess, subtitleSuccess, getRightIcon());
                  */
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
