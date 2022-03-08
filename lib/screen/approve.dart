import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inputgram/consts.dart';
import 'package:inputgram/util.dart';
import 'package:inputgram/approvalList.dart';

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
    return Container(
      width: double.infinity,
      color: Colors.grey[350],
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Expanded(
            child: approvalList(),
          ),
        ],
      ),
    );
  }
}
