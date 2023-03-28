import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chicaparts/api/api_finance.dart';
import 'package:chicaparts/models/user/user.dart';
import 'package:chicaparts/widgets/menu/bottomMenu.dart';

import '../../methods.dart';

class PayoutWidget extends StatefulWidget {
  const PayoutWidget({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<PayoutWidget> createState() => _PayoutWidgetState();
}

class _PayoutWidgetState extends State<PayoutWidget> {
  TextEditingController searchController = new TextEditingController();
  String filter = "";

  @override
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
    final methods = new Methods();
    final apiFinance = new ApiFinance();
    Future<dynamic> getPayouts(partner, filter) {
      return apiFinance.getPayouts(partner, filter);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF05A8CF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => BottomMenu(index: 2)));
          },
        ),
        title: Text("PAYOUTS"),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    width: 300,
                    height: 45,
                    child: Padding(
                      padding: new EdgeInsets.all(5.0),
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
                              EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                    ),
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
                      future: getPayouts(widget.user.thirdParty["id"], filter),
                      builder: (context, AsyncSnapshot snap) {
                        List<String> accommodations = [];
                        if (snap.data == null) {
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: Column(
                                    children: [
                                      Expanded(
                                          child: ListView.builder(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: accommodations.length,
                                              itemBuilder: (context, i) {
                                                var payouts = snap
                                                    .data[accommodations[i]];
                                                return ExpansionTile(
                                                  title:
                                                      Text(accommodations[i]),
                                                  children: [
                                                    ListView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount:
                                                            payouts.length,
                                                        itemBuilder:
                                                            (context, j) {
                                                          return GestureDetector(
                                                              onTap: () {
                                                                showPayout(
                                                                    context,
                                                                    payouts[j]
                                                                        ['id']);
                                                              },
                                                              child: Container(
                                                                height: 100,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          0.5),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5.0) //         <--- border radius here
                                                                          ),
                                                                ),
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
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
                                                                        child: Row(
                                                                            children: [
                                                                          Text(
                                                                              "Offer: "),
                                                                          Text(
                                                                            payouts[j]['offer'],
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          )
                                                                        ])),
                                                                    SizedBox(
                                                                        height:
                                                                            15),
                                                                    Flexible(
                                                                        child: Row(
                                                                            children: [
                                                                          Text(
                                                                              "Payout: "),
                                                                          Text(
                                                                            payouts[j]['amount'].toString() +
                                                                                " " +
                                                                                payouts[j]['code'],
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          )
                                                                        ])),
                                                                    SizedBox(
                                                                        height:
                                                                            15),
                                                                    Flexible(
                                                                        child:
                                                                            Row(
                                                                      children: [
                                                                        Text(
                                                                            "Périod: "),
                                                                        Text(
                                                                          DateFormat('dd.MM.yyyy').format(DateTime.parse(payouts[j]['period_start'])) +
                                                                              " - " +
                                                                              DateFormat('dd.MM.yyyy').format(DateTime.parse(payouts[j]['period_end'])),
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Spacer(),
                                                                        Text(
                                                                            "Status: "),
                                                                        Text(
                                                                            methods.allWordsCapitilize(payouts[j][
                                                                                'status']),
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold)),
                                                                      ],
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
                ])),
      ),
    );
  }

  showPayout(context, id) {
    final methods = new Methods();
    ApiFinance apiFinance = new ApiFinance();
    Future<dynamic> getOnePayout(id) {
      return apiFinance.getOnePayout(id);
    }

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
                              Text("Payout Details",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
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
                                future: getOnePayout(id),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.data == null) {
                                    return Container(
                                      child: Center(
                                        child: Text("Loading..."),
                                      ),
                                    );
                                  } else {
                                    var payout = snapshot.data;
                                    return Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              methods.label("Reference:"),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              methods.element(payout.ref),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              methods.label("Contract:"),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              methods.element(
                                                  payout.contractRef +
                                                      " - " +
                                                      payout.accommodationRef +
                                                      " - " +
                                                      payout.internalName),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              methods.label("Period start:"),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              methods.element(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.parse(
                                                payout.periodStart,
                                              )))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              methods.label("Period end:"),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              methods.element(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.parse(
                                                payout.periodEnd,
                                              )))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              methods.label("Payout:"),
                                              SizedBox(
                                                width: 45,
                                              ),
                                              methods.element(
                                                  payout.amount.toString() +
                                                      " " +
                                                      payout.currency),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              methods.label("Supplies:"),
                                              SizedBox(
                                                width: 35,
                                              ),
                                              methods.element(payout.supplies +
                                                  " " +
                                                  payout.currency),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              methods.label("Chic partner:"),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              methods.element(payout.chicPartner
                                                      .toString() +
                                                  " " +
                                                  payout.currency),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              methods.label("Occasional gain:"),
                                              SizedBox(
                                                width: 0,
                                              ),
                                              methods.element(payout
                                                      .occasionalGain
                                                      .toString() +
                                                  " " +
                                                  payout.currency),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              methods.label("Occasional fees:"),
                                              SizedBox(
                                                width: 0,
                                              ),
                                              methods.element(payout
                                                      .occasionalFees
                                                      .toString() +
                                                  " " +
                                                  payout.currency),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              methods.label("Payout date:"),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              methods.element(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.parse(
                                                payout.payoutDate,
                                              )))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              )
                            ]))))));
  }
}
