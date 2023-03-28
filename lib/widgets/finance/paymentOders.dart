import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chicaparts/api/api_finance.dart';
import 'package:chicaparts/models/user/user.dart';
import 'package:chicaparts/widgets/menu/bottomMenu.dart';

import '../../methods.dart';

class PaymentOrderWidget extends StatefulWidget {
  const PaymentOrderWidget({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<PaymentOrderWidget> createState() => _PaymentOrderWidgetState();
}

class _PaymentOrderWidgetState extends State<PaymentOrderWidget> {
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
    Future<dynamic> getPaymentOrders(partner, filter) {
      return apiFinance.getPaymentOrders(partner, filter);
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
        title: Text("PAYMENT ORDERS"),
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
                    future:
                        getPaymentOrders(widget.user.thirdParty["id"], filter),
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
                                              var orders =
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
                                                      itemCount: orders.length,
                                                      itemBuilder:
                                                          (context, j) {
                                                        return GestureDetector(
                                                            onTap: () {
                                                              showPaymentOrder(
                                                                  context,
                                                                  orders[j]);
                                                            },
                                                            child: Container(
                                                              height: orders[j][
                                                                          'payment_date'] !=
                                                                      null
                                                                  ? 165
                                                                  : 150,
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
                                                              margin: EdgeInsets
                                                                  .all(8),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Flexible(
                                                                    child: Container(
                                                                        child: RichText(
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            text: TextSpan(
                                                                              text: orders[j]['ref'] + " - " + orders[j]['title'],
                                                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                                                                            ))),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          15),
                                                                  Flexible(
                                                                      child:
                                                                          Row(
                                                                    children: [
                                                                      Text(
                                                                          "Accounting date: "),
                                                                      Text(
                                                                        orders[j]
                                                                            [
                                                                            'start_date'],
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      Spacer(),
                                                                      Text(
                                                                          "Type: "),
                                                                      Text(
                                                                        methods.allWordsCapitilize(orders[j]
                                                                            [
                                                                            'type']),
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  )),
                                                                  SizedBox(
                                                                      height:
                                                                          15),
                                                                  Flexible(
                                                                      child:
                                                                          Text(
                                                                    "Amount: " +
                                                                        orders[j]['amount']
                                                                            .toString() +
                                                                        " " +
                                                                        orders[j]
                                                                            [
                                                                            'code'],
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )),
                                                                  SizedBox(
                                                                      height:
                                                                          15),
                                                                  Flexible(
                                                                      child:
                                                                          Row(
                                                                    children: [
                                                                      Text(
                                                                          "Payment status: "),
                                                                      Text(
                                                                        methods.allWordsCapitilize(orders[j]
                                                                            [
                                                                            'payment_status']),
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  )),
                                                                  orders[j]['payment_date'] !=
                                                                          null
                                                                      ? SizedBox(
                                                                          height:
                                                                              15)
                                                                      : Container(),
                                                                  orders[j]['payment_date'] !=
                                                                          null
                                                                      ? Flexible(
                                                                          child:
                                                                              Row(
                                                                          children: [
                                                                            Text("Payment date: "),
                                                                            Text(
                                                                              DateFormat('yyyy-MM-dd').format(DateTime.parse(
                                                                                orders[j]['payment_date'],
                                                                              )),
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            )
                                                                          ],
                                                                        ))
                                                                      : Text(
                                                                          ""),
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
            )),
      ),
    );
  }

  showPaymentOrder(context, order) {
    final methods = new Methods();
    String partner = order['partner_ref'];
    order['first_name'] != null
        ? partner = partner + " - " + order['first_name']
        : partner = partner;
    order['last_name'] != null
        ? partner = partner + " " + order['last_name']
        : partner = partner;
    order['business_name'] != null
        ? partner = partner + " - " + order['business_name']
        : partner = partner;
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
                  Text("Payment Order Details",
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
                  Column(
                    children: [
                      Row(
                        children: [
                          methods.label("Reference:"),
                          SizedBox(
                            width: 0,
                          ),
                          methods.element(order['ref'])
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          methods.label("Title:"),
                          SizedBox(
                            width: 35,
                          ),
                          methods.element(order['title'])
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          methods.label("Partner:"),
                          SizedBox(
                            width: 15,
                          ),
                          methods.element(partner)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          methods.label("Accommodation:"),
                          SizedBox(
                            width: 0,
                          ),
                          methods.element(order['accommodation_ref'] +
                              " - " +
                              order['internal_name'])
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          methods.label("Type:"),
                          SizedBox(
                            width: 55,
                          ),
                          methods.element(
                              methods.allWordsCapitilize(order['type']))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          methods.label("Amount:"),
                          SizedBox(
                            width: 35,
                          ),
                          methods.element(
                              order['amount'].toString() + " " + order['code'])
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          methods.label("Accounting date:"),
                          SizedBox(
                            width: 0,
                          ),
                          methods.element(order['start_date'])
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          methods.label("Payment date:"),
                          SizedBox(
                            width: 0,
                          ),
                          order['payment_date'] != null
                              ? methods.element(DateFormat('yyyy-MM-dd')
                                  .format(DateTime.parse(
                                  order['payment_date'],
                                )))
                              : Text("")
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          methods.label("Payment status:"),
                          SizedBox(
                            width: 0,
                          ),
                          methods.element(methods
                              .allWordsCapitilize(order['payment_status']))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          methods.label("Comment:"),
                          SizedBox(
                            width: 20,
                          ),
                          order['comment'] != null
                              ? methods.element(order['comment'])
                              : Text("")
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                ],
              ),
            )))));
  }
}
