import 'package:flutter/material.dart';
import 'package:inputgram/approvalList.dart';
import 'package:inputgram/constants.dart';
import 'package:inputgram/util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    gContext = context;
    onPressedDrawerApprove = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(gContext)!.appBarHeadingApproveRemove,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: clrAmber,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Container(
            width: double.infinity,
            color: Colors.grey[350],
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Text(AppLocalizations.of(gContext)!.scafBeginInfoApproveRemove),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Expanded(
                  child: approvalList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
