import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chicaparts/api/api_operation.dart';
import 'package:chicaparts/models/user/user.dart';
import 'package:chicaparts/widgets/menu/bottomMenu.dart';

import 'package:percent_indicator/percent_indicator.dart';

import '../../methods.dart';

class MaintenanceWidget extends StatefulWidget {
  const MaintenanceWidget({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<MaintenanceWidget> createState() => _MaintenanceWidgetState();
}

class _MaintenanceWidgetState extends State<MaintenanceWidget> {
  bool isSwitched = false;
  bool pending = false;
  String? natureValue;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final apiOperation = new ApiOperation();
    Future<dynamic> getMaintenances(partner, pending, nature) {
      if (nature == null) nature = '';
      return apiOperation.getMaintenances(partner, pending, nature);
    }

    var natures = [
      'clear',
      'masonry',
      'plumbing',
      'electricity',
      'renovation',
      'maintenance',
      'carpentry',
      'equipment',
      'other',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF05A8CF),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => BottomMenu(index: 3)));
            }),
        title: Text("MAINTENANCE"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                      width: 170,
                      height: 35,
                      margin: EdgeInsets.only(left: 10, top: 10),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Filter by nature",
                          contentPadding: EdgeInsets.all(5.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                        ),
                        value: natureValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            natureValue = newValue!;
                            loading = true;
                          });
                        },
                        items: natures
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(allWordsCapitilize(value)),
                          );
                        }).toList(),
                      )),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        pending = pending ? false : true;
                        setState(() {
                          isSwitched = value;
                          loading = true;
                        });
                      },
                      activeTrackColor: Colors.grey,
                      activeColor: Color(0xFF05A8CF),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text("Only pending")),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Divider(
                  height: 1,
                  thickness: 2,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.grey,
                ),
              ),
              FutureBuilder(
                  future: getMaintenances(
                      widget.user.thirdParty["id"], pending, natureValue),
                  builder: (context, AsyncSnapshot snap) {
                    List<String> accommodations = [];

                    if (snap.data == null ||
                        snap.connectionState == ConnectionState.waiting) {
                      return Container(
                        child: Center(
                          child: Text("Loading..."),
                        ),
                      );
                    } else {
                      // Map<dynamic, dynamic> values = snap.data;
                      if (snap.data.length > 0)
                        snap.data.forEach((key, values) {
                          accommodations.add(key);
                        });
                      return snap.data.length > 0
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: accommodations.length,
                                          itemBuilder: (context, i) {
                                            var maintenances =
                                                snap.data[accommodations[i]];
                                            return ExpansionTile(
                                              title: Text(accommodations[i]),
                                              children: [
                                                ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        maintenances.length,
                                                    itemBuilder: (context, j) {
                                                      return GestureDetector(
                                                          onTap: () {
                                                            showMaintenance(
                                                                context,
                                                                maintenances[j]
                                                                    ["id"]);
                                                          },
                                                          child: Container(
                                                            height: 145,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0.5),
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          5.0) //         <--- border radius here
                                                                      ),
                                                            ),
                                                            margin:
                                                                EdgeInsets.all(
                                                                    8),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    child: RichText(
                                                                        overflow: TextOverflow.ellipsis,
                                                                        text: TextSpan(
                                                                          text: maintenances[j]['ref'] +
                                                                              " - " +
                                                                              maintenances[j]['title'],
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        )),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Flexible(
                                                                    child:
                                                                        Container(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                          "Status: "),
                                                                      Text(
                                                                          allWordsCapitilize(maintenances[j]
                                                                              [
                                                                              'status']),
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold)),
                                                                      // Container(
                                                                      //   child: Text(
                                                                      //       maintenances[
                                                                      //               j]
                                                                      //           [
                                                                      //           'status'],
                                                                      //       style: TextStyle(
                                                                      //           fontSize:
                                                                      //               12,
                                                                      //           color:
                                                                      //               Colors.white)),
                                                                      //   padding:
                                                                      //       EdgeInsets
                                                                      //           .all(
                                                                      //               5),
                                                                      //   decoration:
                                                                      //       BoxDecoration(
                                                                      //     shape: BoxShape
                                                                      //         .rectangle,
                                                                      //     color: Colors
                                                                      //         .grey,
                                                                      //     borderRadius:
                                                                      //         BorderRadius.circular(
                                                                      //             10),
                                                                      //   ),
                                                                      // ),
                                                                      Spacer(),
                                                                      Text(
                                                                          "Priority: "),
                                                                      Text(
                                                                          maintenances[j]
                                                                              [
                                                                              'priority'],
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold))
                                                                      // Container(
                                                                      //   child: Text(
                                                                      //       maintenances[
                                                                      //               j]
                                                                      //           [
                                                                      //           'priority'],
                                                                      //       style: TextStyle(
                                                                      //           fontSize:
                                                                      //               12,
                                                                      //           color:
                                                                      //               Colors.white)),
                                                                      //   padding:
                                                                      //       EdgeInsets
                                                                      //           .all(
                                                                      //               5),
                                                                      //   decoration:
                                                                      //       BoxDecoration(
                                                                      //     shape: BoxShape
                                                                      //         .rectangle,
                                                                      //     color: Colors
                                                                      //         .grey,
                                                                      //     borderRadius:
                                                                      //         BorderRadius.circular(
                                                                      //             10),
                                                                      //   ),
                                                                      // ),
                                                                    ],
                                                                  ),
                                                                )),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Flexible(
                                                                    child:
                                                                        Container(
                                                                  child: Text("Log date: " +
                                                                      DateFormat(
                                                                              'yyyy-MM-dd')
                                                                          .format(DateTime.parse(maintenances[j]
                                                                              [
                                                                              'log_date']))),
                                                                )),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Flexible(
                                                                  child:
                                                                      LinearPercentIndicator(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        50,
                                                                    animation:
                                                                        true,
                                                                    lineHeight:
                                                                        20.0,
                                                                    animationDuration:
                                                                        2500,
                                                                    percent:
                                                                        int.parse(maintenances[j]['fixed_percentage']) /
                                                                            100,
                                                                    center:
                                                                        Text(
                                                                      maintenances[j]
                                                                              [
                                                                              'fixed_percentage'] +
                                                                          " %",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    // ignore: deprecated_member_use
                                                                    linearStrokeCap:
                                                                        // ignore: deprecated_member_use
                                                                        LinearStrokeCap
                                                                            .roundAll,
                                                                    progressColor:
                                                                        Color(
                                                                            0xFF05A8CF),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ));
                                                    })
                                              ],
                                            );
                                          }))
                                ],
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Center(
                                child: Text("Noting to display"),
                              ));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  Color colorPriority(prty) {
    Color color;
    switch (prty) {
      case 'Normal':
        color = Colors.green;
        break;
      case 'Low':
        color = Colors.greenAccent;
        break;
      case 'Negligible':
        color = Colors.grey;
        break;
      case 'High':
        color = Colors.redAccent;
        break;
      default:
        color = Colors.red;
    }
    return color;
  }

  String allWordsCapitilize(String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  showMaintenance(context, id) {
    final apiOperation = ApiOperation();
    Future<dynamic> callApiOperation(id) {
      return apiOperation.getOneMaintenance(id);
    }

    final methods = Methods();
    return showDialog(
        context: context,
        builder: (context) => Center(
                child: Material(
                    child: SingleChildScrollView(
                        child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Maintenance Details",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Divider(
                      height: 1,
                      thickness: 2,
                      indent: 10,
                      endIndent: 0,
                      color: Colors.grey,
                    ),
                  ),
                  FutureBuilder(
                      future: callApiOperation(id),
                      builder: (context, AsyncSnapshot snap) {
                        var maintenance = snap.data;

                        if (snap.data == null) {
                          return Container(
                            child: Center(
                              child: Text("Loading..."),
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              Row(children: <Widget>[
                                methods.label("Reference: "),
                                SizedBox(
                                  width: 20,
                                ),
                                methods.element(maintenance.ref),
                                SizedBox(
                                  height: 10,
                                ),
                              ]),
                              Row(
                                children: [
                                  methods.label("Accommodation:"),
                                  SizedBox(
                                    width: 0,
                                  ),
                                  methods.element(maintenance.refAccommodation +
                                      " - " +
                                      maintenance.accommodation),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  methods.label("Title:"),
                                  SizedBox(
                                    width: 60,
                                  ),
                                  methods.element(maintenance.title),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  methods.label("Estimation:"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  methods.element(
                                      maintenance.estimation.toString() +
                                          " " +
                                          maintenance.currency),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  methods.label("Real cost:"),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  methods.element(
                                      maintenance.realCost.toString() +
                                          " " +
                                          maintenance.currency),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  methods.label("Handler:"),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  methods.element(
                                      allWordsCapitilize(maintenance.handler)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  methods.label("Priority:"),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  methods.element(maintenance.priority),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  methods.label("Step:"),
                                  SizedBox(
                                    width: 55,
                                  ),
                                  methods.element(maintenance.step),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  methods.label("Nature:"),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  methods.element(
                                      allWordsCapitilize(maintenance.nature)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  methods.label("Status:"),
                                  SizedBox(
                                    width: 45,
                                  ),
                                  methods.element(
                                      allWordsCapitilize(maintenance.status)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  methods.label("Fixed date:"),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  if (maintenance.fixedDate != "")
                                    methods.element(DateFormat('yyyy-MM-dd')
                                        .format(DateTime.parse(
                                            maintenance.fixedDate))),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  methods.label("Completion:"),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  methods.element(
                                      maintenance.completion.toString() + " %"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  methods.label("Log date:"),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  methods.element(DateFormat('yyyy-MM-dd')
                                      .format(
                                          DateTime.parse(maintenance.logDate))),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  methods.label("Description:"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  methods.elementText(maintenance.description),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      })
                ],
              ),
            )))));
  }
}
