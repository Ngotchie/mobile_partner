import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chicaparts/api/api_accommodation.dart';
import 'package:chicaparts/models/model_accommodation.dart';
import 'package:chicaparts/models/user/user.dart';
import 'package:chicaparts/widgets/menu/appBar.dart';
import 'package:chicaparts/widgets/menu/drawer.dart';

import '../../methods.dart';

class AccommodationIndexWidget extends StatefulWidget {
  const AccommodationIndexWidget({Key? key, required this.user})
      : super(key: key);
  final User user;
  @override
  _AccommodationIndexWidgetState createState() =>
      _AccommodationIndexWidgetState();
}

class _AccommodationIndexWidgetState extends State<AccommodationIndexWidget> {
  final apiAcc = ApiAccommodation();

  Future<dynamic> callApiAcc(id) {
    return apiAcc.getOneAccommodations(id);
  }

  Future<dynamic> callApiListAcc(partner) {
    return apiAcc.getAccommodations(partner);
  }

  Future<List<SpaceAccommodation>> callApiSpcAcc(id) {
    return apiAcc.spacesAccommodation(id);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
      appBar: appBar("ACCOMMODATIONS", context, 0),
      drawer: drawer(widget.user, context),
      body: Container(
          color: Colors.white,
          child: Column(children: <Widget>[
            FutureBuilder(
                future: callApiListAcc(widget.user.thirdParty["id"]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: Text("Loading..."),
                      ),
                    );
                  } else {
                    final accommodations = snapshot.data["accommodations"];
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: SingleChildScrollView(
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    tileColor: Colors.grey[200],
                                    leading: Icon(Icons.house),
                                    title: Text("My Accommodations"),
                                  ),
                                  Container(
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: accommodations.length,
                                        itemBuilder: (context, i) {
                                          return GestureDetector(
                                              onTap: () {
                                                showAccommodation(
                                                    context, accommodations[i]);
                                              },
                                              child: Container(
                                                height: 75,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 0.5),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          5.0) //         <--- border radius here
                                                      ),
                                                ),
                                                margin: EdgeInsets.all(8),
                                                padding: EdgeInsets.all(2),
                                                child: Row(
                                                  children: <Widget>[
                                                    Column(
                                                      children: [
                                                        Flexible(
                                                          child: Container(
                                                            width: 100,
                                                            height: 50,
                                                            child: Center(
                                                                child: Text(
                                                                    accommodations[
                                                                            i][
                                                                        "ref"])),
                                                          ),
                                                        ),
                                                        Flexible(
                                                            child: Container(
                                                                child: Center(
                                                          child:
                                                              _statusAccommodation(
                                                                  accommodations[
                                                                          i][
                                                                      "status"]),
                                                        )))
                                                      ],
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(2.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                                accommodations[
                                                                        i][
                                                                    "internal_name"],
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    // color: Colors.grey,
                                                                    fontWeight: FontWeight.bold)),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              width: width,
                                                              child: Text(
                                                                address(
                                                                    accommodations[
                                                                        i]),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  // color: Colors.grey[500],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              width: width,
                                                              child: RichText(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  text:
                                                                      TextSpan(
                                                                    text: accommodations[
                                                                            i][
                                                                        "external_name"],
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        }),
                                  )
                                ],
                              ),
                            ),
                            Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ListTile(
                                    tileColor: Colors.grey[200],
                                    leading: Icon(Icons.book),
                                    title: Text("Contracts"),
                                  ),
                                  Container(
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              snapshot.data["contracts"].length,
                                          itemBuilder: (context, i) {
                                            return GestureDetector(
                                                onTap: () {
                                                  showContract(
                                                      context,
                                                      snapshot.data["contracts"]
                                                          [i]["id"]);
                                                },
                                                child: Container(
                                                  height: 78,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 0.5),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            5.0) //         <--- border radius here
                                                        ),
                                                  ),
                                                  margin: EdgeInsets.all(8),
                                                  padding: EdgeInsets.all(2),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Column(
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              width: 100,
                                                              height: 50,
                                                              child: Center(
                                                                  child: Text(snapshot
                                                                              .data[
                                                                          "contracts"]
                                                                      [
                                                                      i]["ref"])),
                                                            ),
                                                          ),
                                                          Flexible(
                                                              child: Container(
                                                                  child: Center(
                                                            child: _statusContract(
                                                                snapshot.data[
                                                                        "contracts"][i]
                                                                    [
                                                                    "contract_status"]),
                                                          )))
                                                        ],
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                  snapshot.data["contracts"]
                                                                              [
                                                                              i]
                                                                          [
                                                                          "internal_name"] +
                                                                      " (" +
                                                                      snapshot.data["contracts"]
                                                                              [
                                                                              i]
                                                                          [
                                                                          "name"] +
                                                                      ") ",
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      // color: Colors.grey,
                                                                      fontWeight: FontWeight.bold)),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Container(
                                                                width: width,
                                                                child: Text(
                                                                  "Start date: " +
                                                                      snapshot.data["contracts"]
                                                                              [
                                                                              i]
                                                                          [
                                                                          "start_date"] +
                                                                      "  \nEnd date:   " +
                                                                      snapshot.data["contracts"]
                                                                              [
                                                                              i]
                                                                          [
                                                                          "end_date"],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    height: 1.5,
                                                                    // color: Colors.grey[500],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Container(
                                                                width: width,
                                                                child: Text(
                                                                  "",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    // color: Colors.grey[500],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                          })),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                })
          ])),
    );
  }
}

String address(accommodation) {
  String add1 =
      accommodation["address1"] != null ? accommodation["address1"] : "";
  String add2 =
      accommodation["address2"] != null ? accommodation["address2"] : "";
  String add3 =
      accommodation["address3"] != null ? accommodation["address3"] : "";

  return add1 + ", " + add2 + ", " + add3;
}

showAccommodation(context, accomodation) {
  //print(accomodation.hosting);
  final apiAcc = ApiAccommodation();
  Future<List<SpaceAccommodation>> callApiSpcAcc(id) {
    return apiAcc.spacesAccommodation(id);
  }

  Future<dynamic> callApiAcc(id) {
    return apiAcc.getOneAccommodations(id);
  }

  var chMethodController = TextEditingController();
  var chInFrMethodController = TextEditingController();
  var chInEnMethodController = TextEditingController();
  var chOutFrMethodController = TextEditingController();
  var chOutEnMethodController = TextEditingController();
  var wifiIdentifierController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        final methods = Methods();
        return Center(
          child: Material(
            type: MaterialType.transparency,
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
                  children: <Widget>[
                    FutureBuilder(
                        future: callApiAcc(accomodation["id"]),
                        builder: (context, AsyncSnapshot snap) {
                          if (snap.data == null) {
                            return Container(
                              child: Center(
                                child: Text("Loading..."),
                              ),
                            );
                          } else {
                            var accomodation = snap.data;
                            chMethodController.text = allWordsCapitilize(
                                accomodation.checkingMethod
                                    .replaceAll(RegExp('_'), ' '));
                            chInFrMethodController.text =
                                accomodation.accessInstructionFr.data;
                            chInEnMethodController.text =
                                accomodation.accessInstructionEn.data;
                            chOutFrMethodController.text =
                                accomodation.checkoutInstructionFr.data;
                            chOutEnMethodController.text =
                                accomodation.checkoutInstructionEn.data;
                            wifiIdentifierController.text =
                                accomodation.wifiIdentifiers.data;
                            // print(accomodation);
                            return Column(children: <Widget>[
                              ExpansionTile(
                                title: Text(
                                  "Accommodation Description",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    methods.label("Reference: "),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    methods.element(accomodation.ref),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    methods.label("Status: "),
                                    SizedBox(
                                      width: 45,
                                    ),
                                    methods.element(methods.allWordsCapitilize(
                                        accomodation.status)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Internal Name: "),
                                      methods
                                          .element(accomodation.internalName),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("External Name: "),
                                      methods
                                          .element(accomodation.externalName),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Type: "),
                                      SizedBox(
                                        width: 55,
                                      ),
                                      methods.element(
                                          methods.allWordsCapitilize(
                                              accomodation.typeAccommodation)),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Entire Palace: "),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      methods.element(accomodation.entirePlace
                                          ? "True"
                                          : "False"),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Capacity: "),
                                      SizedBox(
                                        width: 35,
                                      ),
                                      methods.element(
                                          accomodation.capacity.toString()),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Area(m²): "),
                                      SizedBox(
                                        width: 35,
                                      ),
                                      methods.element(
                                          accomodation.area.toString()),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Floor Number: "),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      methods.element(
                                          accomodation.floorNumber.toString()),
                                      SizedBox(
                                        height: 40,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Door Number: "),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      methods.element(accomodation.doorNumber),
                                      SizedBox(
                                        height: 40,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Has Elevator: "),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      methods.element(accomodation.hasElevator
                                          ? "True"
                                          : "False"),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Desabled Acces: "),
                                      methods.element(accomodation.hasElevator
                                          ? "True"
                                          : "False"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Description: "),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      methods.elementText(
                                          accomodation.description),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                title: Text(
                                  "Checks Instructions",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      methods.elementCheck("Check-in Method",
                                          chMethodController, context),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.elementCheck(
                                          "Check-in Instructions-Fr",
                                          chInFrMethodController,
                                          context),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.elementCheck(
                                          "Check-in Instructions-EN",
                                          chInEnMethodController,
                                          context),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.elementCheck(
                                          "Check-out Instructions-FR",
                                          chOutFrMethodController,
                                          context),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.elementCheck(
                                          "Check-out Instructions-EN",
                                          chOutEnMethodController,
                                          context),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                title: Text(
                                  "Location and other informations",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      methods.label("Address: "),
                                      methods.elementAdresseMap(
                                          accomodation.adresse1 +
                                              ", " +
                                              accomodation.adresse2 +
                                              ", " +
                                              accomodation.adresse3),
                                      TextButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                    text: accomodation
                                                            .adresse1 +
                                                        ", " +
                                                        accomodation.adresse2 +
                                                        ", " +
                                                        accomodation.adresse3))
                                                .then((value) {
                                              //only if ->
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text('Copied')),
                                              );
                                            });
                                          },
                                          child: Icon(
                                            Icons.copy,
                                            size: 20,
                                            color: Colors.black,
                                          )),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Geolocalisation: "),
                                      methods.element("Lat: " +
                                          accomodation.latitude.toString()),
                                      methods.element("Long: " +
                                          accomodation.longitude.toString()),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Mailbox Name: "),
                                      methods
                                          .element(accomodation.mailBoxeName),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Mailbox Number: "),
                                      methods
                                          .element(accomodation.mailBoxNumber),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Mailbox Location: "),
                                      methods.elementText(
                                          accomodation.mailBoxLocation),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Heating System: "),
                                      methods.elementText(
                                          accomodation.headingSystem),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods
                                          .label("Public Transport Nearby: "),
                                      methods.elementText(
                                          accomodation.publicTransportNearby),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods
                                          .label("Energie Line Identifier: "),
                                      methods.elementText(
                                          accomodation.energyLineIdentifiere),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods
                                          .label("Telecom Line Identifier: "),
                                      methods.elementText(
                                          accomodation.telecomLineIdentifiere),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Hotplate System: "),
                                      methods.elementText(
                                          accomodation.hotplatesystem),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Coffee Machine Type: "),
                                      methods.elementText(
                                          accomodation.coffeeMachineType),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Wifi Identifiers: "),
                                      methods.elementText(
                                          accomodation.wifiIdentifiers),
                                      TextButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                    text: accomodation
                                                        .wifiIdentifiers.data))
                                                .then((value) {
                                              //only if ->
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text('Copied')),
                                              );
                                            });
                                          },
                                          child: Icon(
                                            Icons.copy,
                                            size: 20,
                                            color: Colors.black,
                                          )),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Trash Location: "),
                                      methods.elementText(
                                          accomodation.transactionLocation),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Profil Selection Level: "),
                                      methods.element(
                                          accomodation.profilSelection),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Photos: "),
                                      methods.elementHyperLink(
                                          accomodation.photos),
                                      TextButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                    text: accomodation.photos))
                                                .then((value) {
                                              //only if ->
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text('Copied')),
                                              );
                                            });
                                          },
                                          child: Icon(
                                            Icons.copy,
                                            size: 20,
                                            color: Colors.black,
                                          )),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                title: Text(
                                  "Pricing Plan",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: [
                                  accomodation.pricingPlan,
                                  TextButton(
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                                text: accomodation
                                                    .pricingPlan.data))
                                            .then((value) {
                                          //only if ->
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text('Copied')),
                                          );
                                        });
                                      },
                                      child: Icon(
                                        Icons.copy,
                                        size: 20,
                                        color: Colors.black,
                                      )),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                              ExpansionTile(
                                title: Text(
                                  "Spaces",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: <Widget>[
                                  FutureBuilder(
                                      future: callApiSpcAcc(accomodation.id),
                                      builder: (context, AsyncSnapshot snap) {
                                        if (snap.data == null) {
                                          return Container(
                                            child: Center(
                                              child: Text("Loading..."),
                                            ),
                                          );
                                        } else {
                                          return Center(
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: snap.data.length,
                                              itemBuilder: (context, i) {
                                                return Card(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: [
                                                          methods
                                                              .label("Name: "),
                                                          methods.element(snap
                                                              .data[i].name),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(children: [
                                                        methods.label("Type: "),
                                                        methods.element(
                                                            snap.data[i].type),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ]),
                                                      Row(
                                                        children: [
                                                          methods.label(
                                                              "Size(m²): "),
                                                          methods.element(snap
                                                              .data[i].size
                                                              .toString()),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      if (snap.data[i].heigh !=
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.label(
                                                                "Heigh(m): "),
                                                            methods.element(snap
                                                                .data[i].heigh
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbAirConditioner >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Air Condionner: "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbHeater
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbHeater >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Heater: "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbHeater
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbSingleBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Single Beds(90): "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbSingleBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbDoubleBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Double Beds(140): "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbDoubleBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbLargeBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Large Beds(160): "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbLargeBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbExtraLargeBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Extra Large Beds(180): "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbExtraLargeBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbSingleSofaBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Sofa Beds: "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbSingleSofaBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbDoubleSofaBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number Double Sofa Beds: "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbDoubleSofaBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i].nbSofa >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number Sofa: "),
                                                            methods.element(snap
                                                                .data[i].nbSofa
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbSingleFloorMattress >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Single Floor Mattress: "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbSingleFloorMattress
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbDoubleFloorMattress >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Double Floor Mattress: "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbDoubleFloorMattress
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbSingleAirMattress >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Single Air Mattress: "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbSingleAirMattress
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbDoubleAirMattress >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Double Air Mattress: "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbDoubleAirMattress
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i].nbCrib >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Cribs: "),
                                                            methods.element(snap
                                                                .data[i].nbCrib
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbToddlerBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Toddler Beds: "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbToddlerBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbWaterBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Water Beds: "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbWaterBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbHammock >
                                                          0)
                                                        Row(
                                                          children: [
                                                            methods.labelFlex(
                                                                "Number of Hammocks: "),
                                                            methods.element(snap
                                                                .data[i]
                                                                .nbHammock
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      })
                                ],
                              ),
                            ]);
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

Widget _statusAccommodation(status) {
  if (status == "exploiting") {
    return Container(
      child: Text(status, style: TextStyle(fontSize: 10, color: Colors.white)),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  } else if (status == "prospecting") {
    return Container(
      child: Text(
        status,
        style: TextStyle(fontSize: 10, color: Colors.white),
      ),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  } else {
    return Container(
      child: Text(status, style: TextStyle(fontSize: 10, color: Colors.white)),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

String allWordsCapitilize(String str) {
  return str.toLowerCase().split(' ').map((word) {
    String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
    return word[0].toUpperCase() + leftText;
  }).join(' ');
}

showContract(context, id) {
  final apiAcc = ApiAccommodation();
  Future<dynamic> callApiContract(id) {
    return apiAcc.getOneContract(id);
  }

  final methods = Methods();
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
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
                      future: callApiContract(id),
                      builder: (context, AsyncSnapshot snap) {
                        var contract = snap.data;
                        if (snap.data == null) {
                          return Container(
                            child: Center(
                              child: Text("Loading..."),
                            ),
                          );
                        } else {
                          return Column(children: [
                            ExpansionTile(
                                title: Text(
                                  "Base Information",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: [
                                  Row(
                                    children: <Widget>[
                                      methods.label("Reference: "),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      methods.element(contract.ref),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Status: "),
                                      SizedBox(
                                        width: 45,
                                      ),
                                      methods.element(methods
                                          .allWordsCapitilize(contract.status)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Offer: "),
                                      SizedBox(
                                        width: 55,
                                      ),
                                      methods.element(contract.offer),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Currency: "),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      methods.element(contract.currency),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Accommodation: "),
                                      SizedBox(
                                        width: 0,
                                      ),
                                      methods.element(contract.accommodation),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Partner: "),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      methods.element(contract.partner),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Partner type: "),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      methods.element(
                                          methods.allWordsCapitilize(
                                              contract.partnerType)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Start date: "),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      methods.element(contract.startDate),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("End date: "),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      methods.element(contract.endDate),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Commitment period: "),
                                      SizedBox(
                                        width: 0,
                                      ),
                                      methods.element(
                                          contract.commitmentPeriod.toString()),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      methods.label("Signing date: "),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      methods.element(contract.endDate),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ]),
                            ExpansionTile(
                              title: Text(
                                "Cost Information",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              children: [
                                Row(
                                  children: [
                                    methods.label("Commission:"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    methods.element(contract.offer == "Chic'Zen"
                                        ? contract.commission.toString() +
                                            " " +
                                            contract.currency
                                        : contract.commission.toString() +
                                            " %"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("Guaranteed deposit:"),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    methods.element(
                                        contract.guaranteedDeposit.toString() +
                                            " " +
                                            contract.currency),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    methods.label("Cleaning fees:"),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    methods.element(
                                        contract.cleaningFees.toString() +
                                            " " +
                                            contract.currency),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    methods.label("Cleaning fees for partner:"),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    methods.element(contract
                                            .cleaningFeesForPartner
                                            .toString() +
                                        " " +
                                        contract.currency),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    methods.label("Travelers deposit:"),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    methods.element(
                                        contract.travelersDeposit.toString() +
                                            " " +
                                            contract.currency),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    methods.label("Emergency envelope:"),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    methods.element(
                                        contract.emergencyEnvelop.toString() +
                                            " " +
                                            contract.currency),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    methods.label("Supplies base price:"),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    methods.element(
                                        contract.suppliesBasePrise.toString() +
                                            " " +
                                            contract.currency),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text(
                                "Payment Process Details",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              children: [
                                Row(
                                  children: [
                                    methods.label("IBAN:"),
                                    SizedBox(
                                      width: 45,
                                    ),
                                    methods.element(contract.iban),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("BIC:"),
                                    SizedBox(
                                      width: 55,
                                    ),
                                    methods.element(contract.bic),
                                    SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("Bank Owner:"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    methods.element(contract.bankOwner),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("Bank name:"),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    methods.element(contract.bankName),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("Bank country:"),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    methods.element(contract.bankCountry),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("Payment Date :"),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    methods.element(contract.paymentDate +
                                        " (day in month)"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text(
                                "Additional Details",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              children: [
                                Row(
                                  children: [
                                    methods.label("Is breakfast included ? :"),
                                    SizedBox(
                                      width: 17,
                                    ),
                                    methods.element(contract.breakfastIncluded
                                        ? "True"
                                        : "False"),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    methods.label("Supplies managed by :"),
                                    SizedBox(
                                      width: 17,
                                    ),
                                    methods.element(contract.suppliesManageBy),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    methods.label("Retraction delay :"),
                                    SizedBox(
                                      width: 17,
                                    ),
                                    methods.element(
                                        contract.retractionDelay.toString() +
                                            " days"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("Cleaning duration  :"),
                                    SizedBox(
                                      width: 17,
                                    ),
                                    methods.element(
                                        contract.cleaningDuration.toString() +
                                            " minutes per person"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods
                                        .label("Termination notice duration :"),
                                    SizedBox(
                                      width: 17,
                                    ),
                                    methods.element(
                                        contract.terminaisonNotice.toString() +
                                            " months"),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    methods
                                        .label("Reservation notice duration :"),
                                    SizedBox(
                                      width: 17,
                                    ),
                                    methods.element(
                                        contract.reservationNotice.toString() +
                                            " months"),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    methods.label("Partner booking range :"),
                                    SizedBox(
                                      width: 17,
                                    ),
                                    methods.element(contract.partnerBookingRange
                                            .toString() +
                                        " months"),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    methods.label("Special clauses :"),
                                    SizedBox(
                                      width: 17,
                                    ),
                                    methods.elementText(contract.specialClose),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text(
                                "Supplies List",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              children: [
                                Center(
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: contract.supplies.length,
                                      itemBuilder: (context, i) {
                                        return Card(
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    methods.label("Name:"),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    methods.element(contract
                                                        .supplies[i]["name"]),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    methods.label("Price:"),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    methods.element(contract
                                                            .supplies[i]
                                                                ["price"]
                                                            .toString() +
                                                        " " +
                                                        contract.currency),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    methods.label("Quantity:"),
                                                    SizedBox(
                                                      width: 0,
                                                    ),
                                                    methods.element(contract
                                                        .supplies[i]["quantity"]
                                                        .toString()),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    methods.label("Total:"),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    methods.element(product(
                                                                int.parse(contract
                                                                    .supplies[i]
                                                                        [
                                                                        "quantity"]
                                                                    .toString()),
                                                                double.parse(contract
                                                                    .supplies[i]
                                                                        [
                                                                        "price"]
                                                                    .toString()))
                                                            .toString() +
                                                        " " +
                                                        contract.currency),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              ],
                            )
                          ]);
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _statusContract(status) {
  if (status == "active") {
    return Container(
      child: Text(status, style: TextStyle(fontSize: 12, color: Colors.white)),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  } else if (status == "draft") {
    return Container(
      child: Text(
        status,
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  } else {
    return Container(
      child: Text(status, style: TextStyle(fontSize: 12, color: Colors.white)),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

double product(int a, double b) {
  double temp = 0;
  while (a != 0) {
    temp += b;
    a--;
  }
  return temp;
}
