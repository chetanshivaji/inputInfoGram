import 'package:flutter/material.dart';

import 'package:inputgram/approvalList.dart';
import 'package:inputgram/consts.dart';

class approve extends StatefulWidget {
  static String id = "approvescreen";
  const approve({Key? key}) : super(key: key);

  @override
  _approveState createState() => _approveState();
}

class _approveState extends State<approve> {
  final _formKeyInputForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Approve/Remove"),
      ),
      backgroundColor: clrAmber,
      body: Container(
        width: double.infinity,
        color: Colors.grey[350],
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Text("Please approve or remove clicking toggle icon"),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: approvalList(),
            ),
          ],
        ),
      ),
    );
  }
}
