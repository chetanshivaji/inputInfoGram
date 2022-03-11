import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inputgram/consts.dart';
import 'package:inputgram/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class approvalList extends StatefulWidget {
  const approvalList({Key? key}) : super(key: key);

  @override
  _approvalListState createState() => _approvalListState();
}

class _approvalListState extends State<approvalList> {
  String pendingType = "";
  String orderType = "";
  String yearDropDownValue = "";

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> docSnapshot) {
    List<DataRow> ldataRow = [];

    for (var l in docSnapshot) {
      List<DataCell> ldataCell = [];

      ldataCell.add(DataCell(Text(l.get(keyMail))));

      ldataCell.add(
        DataCell(
          DropdownButton(
            borderRadius: BorderRadius.circular(12.0),
            dropdownColor: clrAmber,

            alignment: Alignment.topLeft,

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
        ),
      );
      ldataCell.add(
        DataCell(
          Text(
            l.get(keyAccessLevel),
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      );
      ldataCell.add(DataCell(Text(l.get(keyApproved).toString())));

      ldataCell.add(
        DataCell(
          IconButton(
            onPressed: () async {
              //approve Status.
              String mail = l.get(keyMail);
              bool statusApproved = l.get(keyApproved);
              if (statusApproved == false) {
                await FirebaseFirestore.instance
                    .collection(collUsers)
                    .doc(mail)
                    .update({keyApproved: true});
              } else {
                await FirebaseFirestore.instance
                    .collection(collUsers)
                    .doc(mail)
                    .update({keyApproved: false});
              }
            },
            icon: Icon(
              Icons.change_circle_outlined,
              color: Colors.black,
            ),
            splashColor: Colors.blue,
            tooltip: msgToogleToApproveDis,
          ),
        ),
      );
      ldataRow.add(DataRow(cells: ldataCell));
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
          columnSpacing: 5.0,
          border: TableBorder(
            horizontalInside: BorderSide(
              width: 1.5,
              color: Colors.black,
            ),
          ),
          dataTextStyle: TextStyle(
            color: Colors.indigoAccent,
          ),
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                tableHeadingEmail,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                '',
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                tableHeadingStatus,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                tableHeadingAccess,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                tableHeadingChangeStatus,
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
    Stream<QuerySnapshot<Object?>> stm;

    String? email = FirebaseAuth.instance.currentUser!.email;

    stm = FirebaseFirestore.instance.collection(collUsers).snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stm,
      //Async snapshot.data-> query snapshot.docs -> docuemnt snapshot,.data["key"]
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(msgNoExpense);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(msgLoading);
        }

        return getApprovalTable(context, snapshot);
      },
    );
  }
}
