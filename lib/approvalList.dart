import 'package:flutter/material.dart';
import 'package:inputgram/constants.dart';
import 'package:inputgram/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class approvalList extends StatefulWidget {
  const approvalList({Key? key}) : super(key: key);

  @override
  _approvalListState createState() => _approvalListState();
}

class _approvalListState extends State<approvalList> {
  String pendingType = "";
  String orderType = "";
  String yeardropdownValueYear = "";

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> docSnapshot) {
    List<DataRow> ldataRow = [];
    int srNo = 0;
    for (var l in docSnapshot) {
      String adminVillagePin = adminVillage + adminPin;
      String userVillagePin = l.get(keyVillage) + l.get(keyPin);
      if (adminVillagePin == userVillagePin) {
        List<DataCell> ldataCell = [];
        srNo = srNo + 1;
        ldataCell.add(DataCell(Text(
          srNo.toString(),
          style: getTableFirstColStyle(),
        )));
        ldataCell.add(DataCell(Text(l.get(keyRegisteredName))));
        ldataCell.add(DataCell(Text(l.get(keyMail))));

        ldataCell.add(
          DataCell(
            Row(
              children: <Widget>[
                DropdownButton(
                  borderRadius: BorderRadius.circular(12.0),
                  dropdownColor: clrAmber,

                  //alignment: Alignment.topRight,

                  // Initial Value
                  value: access,
                  // Down Arrow Icon
                  icon: Icon(
                    Icons.sort,
                    color: clrAmber,
                  ),
                  // Array list of items
                  items: accessItems.map(
                    (String accessItems) {
                      return DropdownMenuItem(
                        value: accessItems,
                        child: Text(accessItems),
                      );
                    },
                  ).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newAccessValue) async {
                    if (newAccessValue != access) {
                      //START update the access level in Db

                      await FirebaseFirestore.instance
                          .collection(collUsers)
                          .doc(l.get(keyMail))
                          .update({keyAccessLevel: newAccessValue});
                      //END update the access level in Db
                    }
                  },
                ),
                Text(
                  l.get(keyAccessLevel),
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );

        ldataRow.add(DataRow(cells: ldataCell));
      }
    }
    return ldataRow;
  }

  SingleChildScrollView getApprovalTable(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: getTableHeadingTextStyle(),
          border: getTableBorder(),
          dataTextStyle: TextStyle(
            color: Colors.indigoAccent,
          ),
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeading_srNum,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingName,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingEmail,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingStatus,
                style: getStyle(actPending),
              ),
            ),
          ],
          rows: _buildList(context, snapshot.data!.docs),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    gContext = context;
    Stream<QuerySnapshot<Object?>> stm;

    stm = FirebaseFirestore.instance.collection(collUsers).snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stm,
      //Async snapshot.data-> query snapshot.docs -> docuemnt snapshot,.data["key"]
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(AppLocalizations.of(gContext)!.msgNoExpense);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(msgLoading);
        }

        return getApprovalTable(context, snapshot);
      },
    );
  }
}
