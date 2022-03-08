import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

      ldataCell.add(DataCell(Text(l.get("mail"))));
      ldataCell.add(DataCell(Text(l.get("accessLevel").toString())));
      ldataCell.add(DataCell(Text(l.get("approved").toString())));

      ldataCell.add(
        DataCell(
          IconButton(
            onPressed: () async {
              //approve Status.
              var ls = await getLoggedInUserVillagePin();
              String mail = l.get("mail");
              bool statusApproved = l.get("approved");
              if (statusApproved == false) {
                await FirebaseFirestore.instance
                    //.collection(adminVillage + adminPin)
                    .collection(ls[0] + ls[1])
                    .doc("pendingApproval")
                    .collection("pending")
                    .doc(mail)
                    .update({'approved': true});
              } else {
                await FirebaseFirestore.instance
                    //.collection(adminVillage + adminPin)
                    .collection(ls[0] + ls[1])
                    .doc("pendingApproval")
                    .collection("pending")
                    .doc(mail)
                    .update({'approved': false});
              }
            },
            icon: Icon(
              Icons.change_circle_outlined,
              color: Colors.black,
            ),
            splashColor: Colors.blue,
            tooltip: "Send notification to Pay",
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
                'Email',
                style: getStyle("PENDING"),
              ),
            ),
            DataColumn(
              label: Text(
                'AccessLevel',
                style: getStyle("PENDING"),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: getStyle("PENDING"),
              ),
            ),
            DataColumn(
              label: Text(
                'ChangeStatus',
                style: getStyle("PENDING"),
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

    stm = FirebaseFirestore.instance
        .collection(adminVillage + adminPin)
        .doc("pendingApproval")
        .collection("pending")
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stm,
      //Async snapshot.data-> query snapshot.docs -> docuemnt snapshot,.data["key"]
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("There is no expense");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("loading");
        }

        return getApprovalTable(context, snapshot);
      },
    );
  }
}
