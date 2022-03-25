import 'package:flutter/material.dart';
import 'package:inputgram/consts.dart';
import 'package:inputgram/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<DataRow> gLdr = [];

class reportInfo extends StatefulWidget {
  static String id = "reportscreen";
  const reportInfo({Key? key}) : super(key: key);

  @override
  _reportInfoState createState() => _reportInfoState();
}

class _reportInfoState extends State<reportInfo> {
  final _formKeyreportForm = GlobalKey<FormState>();

  ListTile getYearTile(Color clr) {
    return ListTile(
      trailing: DropdownButton(
        borderRadius: BorderRadius.circular(12.0),
        dropdownColor: clr,
        alignment: Alignment.topLeft,
        // Initial Value
        value: dropdownValueYear,
        // Down Arrow Icon
        icon: Icon(
          Icons.date_range,
          color: clr,
        ),
        // Array list of items
        items: items.map(
          (String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          },
        ).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) async {
          var ldr = await _buildList();
          if (ldr.isEmpty) {
            gLdr = ldr;
            dropdownValueYear = newValue!;
            return;
          }
          setState(
            () {
              dropdownValueYear = newValue!;
              gLdr = ldr;
            },
          );
        },
      ),
    );
  }

  Future<List<DataRow>> _buildList() async {
    List<DataRow> ldataRow = [];

    for (var yr in formulaYears) {
      List<DataCell> ldataCell = [];
      //get formula+yr from list of data cell put in dataRow.
      var formulaRef;
      //START create Formula in each year once
      try {
        await FirebaseFirestore.instance
            .collection(adminVillage + adminPin)
            .doc(mainDb)
            .collection(collFormula + yr)
            .doc(docCalcultion)
            .get()
            .then(
          (value) async {
            if (value.exists) {
              //if already present get and update.
              int totalHouse,
                  pendingHouse,
                  collectedHouse,
                  totalWater,
                  pendingWater,
                  collectedWater;
              totalHouse = pendingHouse = collectedHouse =
                  totalWater = pendingWater = collectedWater = 0;

              var y = value.data();
              totalHouse = y![keyYfTotalHouse];
              pendingHouse = y[keyYfPendingHouse];
              collectedHouse = y[keyYfCollectedHouse];

              totalWater = y[keyYfTotalWater];
              pendingWater = y[keyYfPendingWater];
              collectedWater = y[keyYfCollectedWater];

              double percentCollectedHouse = 0.0;

              percentCollectedHouse = (100 * collectedHouse) / totalHouse;
              int intPCH = percentCollectedHouse.floor();

              double percentCollectedWater = 0.0;
              percentCollectedWater = (100 * collectedWater) / totalWater;
              int intPCW = percentCollectedWater.floor();

              ldataCell.add(DataCell(Text(yr)));
              ldataCell.add(DataCell(Text(totalHouse.toString())));
              ldataCell.add(DataCell(Text(pendingHouse.toString())));
              ldataCell.add(
                DataCell(
                  Text(
                    collectedHouse.toString() +
                        " " +
                        "(%" +
                        (intPCH).toString() +
                        ")",
                  ),
                ),
              );

              ldataCell.add(DataCell(Text(totalWater.toString())));
              ldataCell.add(DataCell(Text(pendingWater.toString())));
              ldataCell.add(
                DataCell(
                  Text(
                    collectedWater.toString() +
                        " " +
                        "(%" +
                        (intPCW).toString() +
                        ")",
                  ),
                ),
              );

              ldataRow.add(DataRow(cells: ldataCell));
            }
          },
        );
      } catch (e) {
        print(e);
      }
    }
    return ldataRow;
  }

  @override
  Widget build(BuildContext context) {
    onPressedDrawerReport = false;
    bool pressed = true;

    return WillPopScope(
      onWillPop: () {
        //trigger leaving and use own data
        Navigator.pop(context, false);
        gLdr = [];
        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarHeadingReportInfo,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: clrRed,
        ),
        body: Form(
          key: _formKeyreportForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //getYearTile(clrRed),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      child: Text(
                        bLabelSubmitRefresh,
                      ),
                      onPressed: pressed
                          ? () async {
                              var ldr = await _buildList();
                              if (ldr.isEmpty) {
                                gLdr = ldr;
                                return;
                              }
                              setState(
                                () {
                                  gLdr = ldr;
                                },
                              );
                              pressed = false;
                            }
                          : null,
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingTextStyle: getTableHeadingTextStyle(),
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
                          tableHeading_year,
                          style: getStyle(actIn),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          tableHeading_totalHouse,
                          style: getStyle(actIn),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          tableHeading_pendingHouse,
                          style: getStyle(actIn),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          tableHeading_collectedHouse,
                          style: getStyle(actIn),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          tableHeading_totalWater,
                          style: getStyle(actIn),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          tableHeading_pendingWater,
                          style: getStyle(actIn),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          tableHeading_collectedWater,
                          style: getStyle(actIn),
                        ),
                      ),
                    ],
                    rows: gLdr,
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
