import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chicaparts/api/api_operation.dart';
import 'package:chicaparts/methods.dart';
import 'package:chicaparts/models/user/user.dart';
import 'package:chicaparts/widgets/menu/bottomMenu.dart';

class SinisterWidget extends StatefulWidget {
  const SinisterWidget({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<SinisterWidget> createState() => _SinisterWidgetState();
}

class _SinisterWidgetState extends State<SinisterWidget> {
  bool isSwitched = false;
  bool pending = false;

  TextEditingController searchController = new TextEditingController();
  String filter = "";

  void initState() {
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final apiOperation = new ApiOperation();
    Future<dynamic> getSinisters(partner, filter) {
      return apiOperation.getSinisters(partner, pending, filter);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF05A8CF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => BottomMenu(index: 3)));
          },
        ),
        title: Text("SINISTERS"),
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
                  width: 200,
                  height: 55,
                  child: Padding(
                    padding: new EdgeInsets.all(8.0),
                    child: new TextField(
                      onChanged: (value) {
                        setState(() {
                          filter = value.toLowerCase();
                        });
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(top: 0),
                  child: Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      pending = pending ? false : true;
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    activeTrackColor: Colors.grey,
                    activeColor: Color(0xFF05A8CF),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Text(
                      "Only pending",
                      style: TextStyle(fontSize: 12),
                    )),
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
                future: getSinisters(widget.user.thirdParty["id"], filter),
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
                                          var sinisters =
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
                                                  itemCount: sinisters.length,
                                                  itemBuilder: (context, j) {
                                                    return GestureDetector(
                                                        onTap: () {
                                                          showSinister(
                                                              context,
                                                              sinisters[j]
                                                                  ['id']);
                                                        },
                                                        child: Container(
                                                          height: 130,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0.5),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        5.0) //         <--- border radius here
                                                                    ),
                                                          ),
                                                          margin:
                                                              EdgeInsets.all(8),
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
                                                                        text: sinisters[j]['ref'] +
                                                                            " - " +
                                                                            sinisters[j]['title'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
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
                                                                        allWordsCapitilize(sinisters[j]
                                                                            [
                                                                            'status']),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                    Spacer(),
                                                                    Text(
                                                                        "Paiment status: "),
                                                                    Text(
                                                                        allWordsCapitilize(sinisters[j]
                                                                            [
                                                                            'payment_status']),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold))
                                                                  ],
                                                                ),
                                                              )),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Flexible(
                                                                  child:
                                                                      Container(
                                                                child: Text("Found date: " +
                                                                    DateFormat(
                                                                            'yyyy-MM-dd')
                                                                        .format(DateTime.parse(sinisters[j]
                                                                            [
                                                                            'found_date']))),
                                                              )),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Flexible(
                                                                  child:
                                                                      Container(
                                                                child: Text(
                                                                    "Request amount: " +
                                                                        sinisters[j]['required_amount']
                                                                            .toString() +
                                                                        " " +
                                                                        sinisters[j]
                                                                            [
                                                                            'code'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              )),
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
      )),
    );
  }

  String allWordsCapitilize(String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  showSinister(context, id) {
    final apiOperation = ApiOperation();
    Future<dynamic> callApiOperation(id) {
      return apiOperation.getOneSinister(id);
    }

    final methods = new Methods();
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
                  FutureBuilder(
                      future: callApiOperation(id),
                      builder: (context, AsyncSnapshot snap) {
                        if (snap.data == null) {
                          return Container(
                            child: Center(
                              child: Text("Loading..."),
                            ),
                          );
                        } else {
                          var sinister = snap.data;
                          var notes = jsonDecode(sinister.actions);
                          return Column(
                            children: [
                              ExpansionTile(
                                title: Text("Sinister Details"),
                                children: [
                                  Row(children: <Widget>[
                                    methods.label("Reference:"),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    methods.element(sinister.ref),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    methods.label("Requester:"),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    methods.element(
                                        allWordsCapitilize(sinister.requester)),
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
                                      methods.element(
                                          sinister.refAccommodation +
                                              " - " +
                                              sinister.accommodation),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Booking:"),
                                      SizedBox(
                                        width: 45,
                                      ),
                                      methods.element(sinister.referer +
                                          " - " +
                                          sinister.apiReference +
                                          " - " +
                                          sinister.guestFirstName +
                                          " - " +
                                          sinister.guestName +
                                          " - " +
                                          DateFormat('yyyy-MM-dd').format(
                                              DateTime.parse(
                                                  sinister.firstNight)) +
                                          " -> " +
                                          DateFormat('yyyy-MM-dd').format(
                                              DateTime.parse(
                                                  sinister.lastNight))),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(children: <Widget>[
                                    methods.label("Currency:"),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    methods.element(sinister.currency),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    methods.label("Title:"),
                                    SizedBox(
                                      width: 65,
                                    ),
                                    methods.element(sinister.title),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    methods.label("Status:"),
                                    SizedBox(
                                      width: 55,
                                    ),
                                    methods.element(
                                        allWordsCapitilize(sinister.status)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]),
                                  Row(
                                    children: [
                                      methods.label("Found date:"),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      methods.element(DateFormat('yyyy-MM-dd')
                                          .format(DateTime.parse(
                                              sinister.foundDate))),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Folder link:"),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      methods.element(sinister.folderLink),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Description:"),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      methods.elementText(sinister.description),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Guarantee type:"),
                                      SizedBox(
                                        width: 0,
                                      ),
                                      methods.element(allWordsCapitilize(
                                          sinister.guaranteeType)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Payment status:"),
                                      SizedBox(
                                        width: 0,
                                      ),
                                      methods.element(allWordsCapitilize(
                                          sinister.paymentStatus)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Refunded amount:"),
                                      SizedBox(
                                        width: 0,
                                      ),
                                      methods.element(
                                          sinister.refundedAmount.toString() +
                                              " " +
                                              sinister.currency),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                title: Text("Ticket Details"),
                                children: [
                                  Row(
                                    children: [
                                      methods.label("Ticket reference:"),
                                      SizedBox(
                                        width: 0,
                                      ),
                                      methods.element(sinister.ticketRef),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Ticket link:"),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      methods.element(sinister.ticketLink),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Requested amount:"),
                                      SizedBox(
                                        width: 0,
                                      ),
                                      methods.element(
                                          sinister.refundedAmount.toString() +
                                              " " +
                                              sinister.currency),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Start date:"),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      methods.element(DateFormat('yyyy-MM-dd')
                                          .format(DateTime.parse(
                                              sinister.startDate))),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Close date:"),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      methods.element(DateFormat('yyyy-MM-dd')
                                          .format(DateTime.parse(
                                              sinister.closeDate))),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                title: Text("Follow-up"),
                                children: [
                                  notes.length > 0
                                      ? Container(
                                          child: ListView.builder(
                                            reverse: true,
                                            itemCount: notes.length,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, j) {
                                              return Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 0,
                                                        right: 0,
                                                        top: 0,
                                                        bottom: 0),
                                                    child: Align(
                                                      alignment:
                                                          (Alignment.topRight),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors
                                                                .grey.shade200),
                                                        padding:
                                                            EdgeInsets.all(16),
                                                        child: Text(
                                                          notes[j]
                                                              ["description"],
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 10),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Text(DateFormat(
                                                              'yyyy-MM-dd')
                                                          .format(DateTime
                                                              .parse(notes[j][
                                                                  "timestamp"]))),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Center(
                                            child: Text("Nothing to display."),
                                          ),
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
