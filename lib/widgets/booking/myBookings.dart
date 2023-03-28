import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chicaparts/api/api_accommodation.dart';
import 'package:chicaparts/api/api_booking.dart';
import 'package:chicaparts/methods.dart';
import 'package:chicaparts/models/model_booking.dart';
import 'package:chicaparts/models/user/user.dart';

class MyBookingWidget extends StatefulWidget {
  const MyBookingWidget({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _MyBookingWidgetState createState() => _MyBookingWidgetState();
}

class _MyBookingWidgetState extends State<MyBookingWidget> {
  final methods = Methods();
  final apiBooking = new ApiBooking();
  Future<List<Booking>> getBooking(range) {
    return apiBooking.getBookings(
        widget.user.thirdParty["id"], range, 'partner');
  }

  String _range = "a => b";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF05A8CF)),
                  ),
                  onPressed: () {
                    addBlockDate(context, widget.user.thirdParty["id"]);
                  },
                  child: Text(
                    ' + Block Dates ',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: 10, top: 10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF05A8CF)),
                  ),
                  onPressed: () {
                    addBooking(
                        context, "", widget.user.thirdParty["id"], false);
                  },
                  child: Text(
                    ' + Add Booking ',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )
            ],
          ),
          FutureBuilder(
              future: getBooking(
                _range,
              ),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text("Loading..."),
                    ),
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                      children: [
                        Expanded(
                            child: snapshot.data.length > 0
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, i) {
                                      String validationStatus =
                                          snapshot.data[i].validationStatus;
                                      String status = "";
                                      switch (snapshot.data[i].status) {
                                        case 0:
                                          status = "Cancelled";
                                          break;
                                        case 1:
                                          status = "Confirmed";
                                          break;
                                        case 2:
                                          status = "New";
                                          break;
                                        case 3:
                                          status = "Request";
                                          break;
                                        case 4:
                                          status = "Black";
                                          break;
                                        default:
                                          status = "";
                                      }
                                      int diff = DateTime.parse(
                                              snapshot.data[i].lastNight)
                                          .difference(DateTime.parse(
                                              snapshot.data[i].firstNight))
                                          .inDays;
                                      return GestureDetector(
                                        onTap: () {
                                          status == "Black"
                                              ? methods.showBooking(
                                                  context,
                                                  snapshot.data[i],
                                                  1,
                                                  widget.user.thirdParty["id"])
                                              : showAllBooking(
                                                  context,
                                                  snapshot.data[i],
                                                  widget.user.thirdParty["id"]);
                                        },
                                        child: Container(
                                          height: 155,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    5.0) //         <--- border radius here
                                                ),
                                          ),
                                          margin: EdgeInsets.all(8),
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  child: Text(
                                                    "Validation Status: " +
                                                        validationStatus.replaceFirst(
                                                            validationStatus[0],
                                                            validationStatus[0]
                                                                .toUpperCase()),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Flexible(
                                                child: Container(
                                                  child: Text(
                                                    "Booking status: " + status,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Flexible(
                                                child: Container(
                                                  child: Text(snapshot
                                                      .data[i].accommodation),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Flexible(
                                                  child: Container(
                                                      child: Row(children: [
                                                Text(DateFormat.MMMd('en_US')
                                                        .format(DateTime.parse(
                                                            snapshot.data[i]
                                                                .firstNight)) +
                                                    "  -  "),
                                                Text(DateFormat('MM').format(DateTime.parse(snapshot.data[i].firstNight)) ==
                                                        DateFormat('MM').format(
                                                            DateTime.parse(
                                                                snapshot.data[i]
                                                                    .lastNight))
                                                    ? DateFormat('d').format(
                                                        DateTime.parse(snapshot
                                                            .data[i].lastNight))
                                                    : DateFormat.MMMd('en_US')
                                                        .format(
                                                            DateTime.parse(snapshot.data[i].lastNight))),
                                                Text(" (" +
                                                    diff.toString() +
                                                    " nights)"),
                                                Spacer(),
                                                Text(
                                                  "Booked at: " +
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(DateTime
                                                              .parse(snapshot
                                                                  .data[i]
                                                                  .bookedAt)),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                              ]))),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                            color:
                                                                Colors.black),
                                                        text: snapshot.data[i]
                                                                .guestFirstName +
                                                            " " +
                                                            snapshot.data[i]
                                                                .guestName)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : Container(
                                    child: Center(
                                        child: Text("Nothing to display")),
                                  ))
                      ],
                    ),
                  );
                }
              }),
        ],
      ),
    ));
  }

  addBlockDate(context, partner) {
    ApiAccommodation apiAcc = ApiAccommodation();
    Future<dynamic> getProperties(partner) {
      return apiAcc.getAccommodations(partner);
    }

    String propId = '';
    String roomId = '';
    final format = DateFormat("yyyy-MM-dd");

    var _formkey = GlobalKey<FormState>();
    final bookedAtController = TextEditingController();
    bookedAtController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final startController = TextEditingController();
    final endController = TextEditingController();
    final noteController = TextEditingController();

    var listStatus = ['Black'];
    int? propertyValue;
    String statusValue = "Black";
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.all(6.0),
              title: Container(
                color: Color(0xFF05A8CF),
                child: Center(
                  child: Text(
                    "Add Block Date",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              content: Center(
                child: Material(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width * 1.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              FutureBuilder(
                                  future: getProperties(
                                      widget.user.thirdParty["id"]),
                                  builder: (context, AsyncSnapshot snap) {
                                    if (snap.data == null) {
                                      return Container(
                                        child: Center(
                                          child: Text("Loading..."),
                                        ),
                                      );
                                    } else {
                                      var data = snap.data["accommodations"];
                                      var properties = [];
                                      for (var item in data) {
                                        if (item["propId"] != null) {
                                          Property pt = new Property(
                                              item["id"],
                                              item["internal_name"],
                                              item["ref"],
                                              item["propId"],
                                              item["roomId"]);
                                          properties.add(pt);
                                        }
                                      }
                                      final propertyField =
                                          DropdownButtonFormField(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          labelText: "Choose property...",
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                        ),
                                        value: propertyValue,
                                        items: properties
                                            .map<DropdownMenuItem<int>>((item) {
                                          return DropdownMenuItem(
                                            value: item.id,
                                            child: Text(item.ref +
                                                "-" +
                                                item.internalName),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            propertyValue = newValue as int;
                                            final index = properties.indexWhere(
                                                (element) =>
                                                    element.id ==
                                                    propertyValue);
                                            roomId = properties[index]
                                                .roomId
                                                .toString();
                                            propId = properties[index]
                                                .propId
                                                .toString();
                                          });
                                        },
                                      );
                                      final bookedAtFormField = DateTimeField(
                                        readOnly: true,
                                        format: format,
                                        controller: bookedAtController,
                                        decoration: InputDecoration(
                                          labelText: "Booked at...",
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                        onShowPicker: (context, currentValue) {
                                          return showDatePicker(
                                              context: context,
                                              currentDate: DateTime.now(),
                                              firstDate: DateTime(2022),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime(2100));
                                        },
                                      );
                                      final startFormField = DateTimeField(
                                        format: format,
                                        controller: startController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          labelText: "Choose start date...",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                        onShowPicker: (context, currentValue) {
                                          return showDatePicker(
                                              context: context,
                                              firstDate: DateTime(2022),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime(2100));
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Start date can\'t be empty';
                                          }
                                          return null;
                                        },
                                      );
                                      final endFormField = DateTimeField(
                                        format: format,
                                        controller: endController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          labelText: "Choose end date...",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                        onShowPicker: (context, currentValue) {
                                          return showDatePicker(
                                              context: context,
                                              firstDate: DateTime(1900),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime(2100));
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'End date can\'t be empty';
                                          }
                                          if (DateTime.parse(
                                                      startController.text)
                                                  .compareTo(value) >
                                              0) {
                                            return 'End date must be greater than start date';
                                          }
                                          return null;
                                        },
                                      );

                                      final statusField =
                                          DropdownButtonFormField(
                                        onChanged: (value) => {},
                                        decoration: InputDecoration(
                                          labelText: "Status...",
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                        ),
                                        value: statusValue,
                                        items: listStatus
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      );
                                      final noteField = TextFormField(
                                        minLines: 3,
                                        maxLines: 8,
                                        keyboardType: TextInputType.multiline,
                                        controller: noteController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10, 20, 10, 10),
                                          labelText: "Booking note...",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                        validator: null,
                                      );
                                      return Form(
                                        key: _formkey,
                                        child: Column(
                                          children: [
                                            propertyField,
                                            SizedBox(
                                              height: 20,
                                            ),
                                            bookedAtFormField,
                                            SizedBox(
                                              height: 20,
                                            ),
                                            startFormField,
                                            SizedBox(
                                              height: 20,
                                            ),
                                            endFormField,
                                            SizedBox(
                                              height: 20,
                                            ),
                                            statusField,
                                            SizedBox(
                                              height: 20,
                                            ),
                                            noteField,
                                          ],
                                        ),
                                      );
                                    }
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                // ignore: deprecated_member_use
                Container(
                  margin: EdgeInsets.only(right: 10, top: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF05A8CF)),
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        var formData = <String, dynamic>{
                          'created_by_user_id': partner,
                          'firstNight': startController.text,
                          'lastNight': endController.text,
                          'notes': noteController.text,
                          'bookId': 0,
                          'propId': propId,
                          'roomId': roomId,
                          'unitId': 1,
                          'roomQty': 1,
                          'status': 4,
                          'substatus': 0,
                          'numAdult': 0,
                          'numChild': 0,
                          'guestTitle': 'Partenaire',
                          'guestFirstName': '',
                          'guestName': 'Partenaire',
                          'guestEmail': '',
                          'guestPhone': '',
                          'guestMobile': '',
                          'guestFax': '',
                          'guestCompany': '',
                          'guestAddress': '',
                          'guestCity': '',
                          'guestState': '',
                          'guestPostcode': '',
                          'guestCountry': '',
                          'guestArrivalTime': '',
                          'guestVoucher': '',
                          'guestComments': '',
                          'message': '',
                          'statusCode': 0,
                          'price': 0,
                          'deposit': 0,
                          'tax': 0,
                          'commission': 0,
                          'rateDescription': '',
                          'offerId': 0,
                          'referer': 'Partner',
                          'reference': '',
                          'apiSource': '0',
                          'apiMessage': '',
                          'apiReference': '',
                          'stripeToken': '',
                          'bookingTime': bookedAtController.text,
                          'modified': '',
                          'booking_fees': 0,
                          'transaction_fees': 0,
                          'currency_id': '47',
                          'converted_price': 0,
                          'validation_status': 'pending',
                          'cleaning_fees_partner': 0,
                          'seller': 'partner',
                          'payment_handler': 'partner',
                        };

                        postBlockDate(formData, context);
                      }
                    },
                    child: Text(
                      ' Confirm ',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10, top: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      ' Cancel ',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ));
  }

  addBooking(context, book, partner, bool edit) {
    ApiBooking apiBooking = ApiBooking();
    Future<dynamic> getData(partner) {
      return apiBooking.getData(partner);
    }

    int propId = 0;
    int roomId = 0;
    final format = DateFormat("yyyy-MM-dd");
    int? propertyValue;
    String guestTitleValue = '';
    String? countryValue;
    int currencyValue = 47;

    final bookedAtController = TextEditingController();
    bookedAtController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final startController = TextEditingController();
    final endController = TextEditingController();
    final adultController = TextEditingController();
    final childController = TextEditingController();
    final arrivalTimeController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final mobileController = TextEditingController();
    final faxController = TextEditingController();
    final companyController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final postCodeController = TextEditingController();
    final commentController = TextEditingController();
    final noteController = TextEditingController();
    final originalPriceController = TextEditingController();
    final depositController = TextEditingController();
    final commissionController = TextEditingController();
    final taxController = TextEditingController();
    final cleaningFeesController = TextEditingController();
    final transactionFeesController = TextEditingController();
    final bookingFeesController = TextEditingController();

    if (edit) {
      bookedAtController.text = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(book.bookedAt))
          .toString();
      startController.text = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(book.firstNight))
          .toString();
      endController.text = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(book.lastNight).add(const Duration(days: 1)))
          .toString();
      adultController.text = book.adult.toString();
      childController.text = book.child.toString();
      arrivalTimeController.text = book.arriveTime;

      firstNameController.text = book.guestFirstName;
      lastNameController.text = book.guestName;
      emailController.text = book.email;
      phoneController.text = book.phone;
      mobileController.text = book.mobile;
      faxController.text = book.fax;
      companyController.text = book.compagny;
      addressController.text = book.address;
      cityController.text = book.city;
      stateController.text = book.state;
      postCodeController.text = book.postCode;
      commentController.text = book.comment.data;
      noteController.text = book.note.data;
      originalPriceController.text = book.price.toString();
      depositController.text = book.deposit.toString();
      commissionController.text = book.commission.toString();
      taxController.text = book.tax.toString();
      cleaningFeesController.text = book.cleaningFees.toString();
      transactionFeesController.text = book.transactionFees.toString();
      bookingFeesController.text = book.bookingFees.toString();

      currencyValue = book.currencyId;
      guestTitleValue = book.title;
      propId = book.propId;
      roomId = book.roomId;
    }

    var _formkey = GlobalKey<FormState>();
    var listStatus = ['Confirmed', 'Cancelled'];
    String statusValue = 'Confirmed';
    var listTitle = ['Mr', 'Mme', 'Mlle'];

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.all(6.0),
              scrollable: true,
              title: Container(
                color: Color(0xFF05A8CF),
                child: Center(
                  child: Text(
                    !edit ? "Add New Booking" : "Edit Booking",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              content: SingleChildScrollView(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * 1.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FutureBuilder(
                              future: getData(widget.user.thirdParty["id"]),
                              builder: (context, AsyncSnapshot snap) {
                                if (snap.data == null) {
                                  return Container(
                                    child: Center(
                                      child: Text("Loading..."),
                                    ),
                                  );
                                } else {
                                  var data = snap.data["accommodations"];
                                  var properties = [];
                                  for (var item in data) {
                                    if (item["propId"] != null) {
                                      Property pt = new Property(
                                          item["id"],
                                          item["internal_name"],
                                          item["ref"],
                                          item["propId"],
                                          item["roomId"]);
                                      properties.add(pt);
                                      if (edit) {
                                        if (book.propId == item["propId"] &&
                                            book.roomId == item["roomId"]) {
                                          propertyValue = item["id"];
                                        }
                                      }
                                    }
                                  }
                                  var data2 = snap.data["countries"];
                                  var countries = [];
                                  for (var item in data2) {
                                    Country ct =
                                        new Country(item["id"], item["name"]);
                                    countries.add(ct);
                                  }
                                  var data3 = snap.data["curencies"];
                                  var currencies = [];
                                  for (var item in data3) {
                                    Currency cy = new Currency(
                                        item["id"], item["code"], item["name"]);
                                    currencies.add(cy);
                                  }
                                  final propertyField = DropdownButtonFormField(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText: "Choose property...",
                                      contentPadding: EdgeInsets.all(5.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                    ),
                                    value: propertyValue,
                                    items: properties
                                        .map<DropdownMenuItem<int>>((item) {
                                      return DropdownMenuItem(
                                        value: item.id,
                                        child: Text(
                                            item.ref + "-" + item.internalName),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        propertyValue = newValue as int;
                                        final index = properties.indexWhere(
                                            (element) =>
                                                element.id == propertyValue);
                                        roomId = properties[index].roomId;
                                        propId = properties[index].propId;
                                      });
                                    },
                                  );
                                  final bookedAtFormField = DateTimeField(
                                    readOnly: true,
                                    format: format,
                                    controller: bookedAtController,
                                    decoration: InputDecoration(
                                      labelText: "Booked at...",
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                          context: context,
                                          currentDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          initialDate:
                                              currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                  );
                                  final startFormField = DateTimeField(
                                    format: format,
                                    controller: startController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Choose start date...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(2000),
                                          initialDate:
                                              currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                    validator: (value) {
                                      if (value == null && !edit) {
                                        return 'Start date can\'t be empty';
                                      }
                                      if (!edit &&
                                          DateTime.parse(startController.text)
                                                  .compareTo(value!) >
                                              0) {
                                        return 'End date must be greater than start date';
                                      }
                                      return null;
                                    },
                                  );

                                  final endFormField = DateTimeField(
                                    format: format,
                                    controller: endController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Choose end date...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(2000),
                                          initialDate:
                                              currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                    validator: (value) {
                                      if (value == null && !edit) {
                                        return 'End date can\'t be empty';
                                      }
                                      return null;
                                    },
                                  );

                                  final statusField = DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: "Status...",
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                    ),
                                    value: statusValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        statusValue = newValue!;
                                      });
                                    },
                                    items: listStatus
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  );

                                  final adultField = TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: adultController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Number of adults...",
                                      // prefix: Text('*'),
                                      // prefixStyle: TextStyle(color: Colors.red, inherit: false),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    validator: (value) {
                                      if ((value == null || value.isEmpty) &&
                                          !edit) {
                                        return 'Number of adults can\'t be empty';
                                      }
                                      return null;
                                    },
                                  );

                                  final childField = TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: childController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Number of children...",
                                      // prefix: Text('*'),
                                      // prefixStyle: TextStyle(color: Colors.red, inherit: false),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    validator: (value) {
                                      if ((value == null || value.isEmpty) &&
                                          !edit) {
                                        return 'Number of children can\'t be empty';
                                      }
                                      return null;
                                    },
                                  );
                                  final arrivalTimeFormField = DateTimeField(
                                    format: DateFormat("HH:mm"),
                                    controller: arrivalTimeController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Choose arrival time...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    onShowPicker:
                                        (context, currentValue) async {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            currentValue ?? DateTime.now()),
                                      );
                                      return DateTimeField.convert(time);
                                    },
                                  );
                                  final guestTitleField =
                                      DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: "Guest title...",
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                    ),
                                    value: guestTitleValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        guestTitleValue = newValue!;
                                      });
                                    },
                                    items: listTitle
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  );
                                  final firstNameField = TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: firstNameController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Guest first name...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    validator: (value) {
                                      if ((value == null || value.isEmpty) &&
                                          !edit) {
                                        return 'Guest first name can\'t be empty';
                                      }
                                      return null;
                                    },
                                  );
                                  final lastNameField = TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: lastNameController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Guest last name...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  );
                                  final emailField = TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Guest email...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  );
                                  final phoneField = TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: phoneController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Guest phone...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  );
                                  final mobileField = TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: mobileController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Guest mobile...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  );
                                  final faxField = TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: faxController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Guest fax...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  );
                                  final companyField = TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: companyController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Guest company...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  );
                                  final countryField = DropdownButtonFormField(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText: "Choose country...",
                                      contentPadding: EdgeInsets.all(5.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                    ),
                                    value: countryValue,
                                    items: countries
                                        .map<DropdownMenuItem<String>>((item) {
                                      return DropdownMenuItem(
                                        value: item.name,
                                        child: Text(item.name),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        countryValue = newValue as String;
                                      });
                                    },
                                  );
                                  final addressField = TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: addressController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Guest address...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  );
                                  final cityField = TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: cityController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Guest city...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  );
                                  final stateField = TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: stateController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Guest state...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  );
                                  final postCodeField = TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: postCodeController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Guest post code...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  );
                                  final commentField = TextFormField(
                                    minLines: 3,
                                    maxLines: 8,
                                    keyboardType: TextInputType.multiline,
                                    controller: commentController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 20, 10, 10),
                                      labelText: "Guest comments...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    validator: null,
                                  );
                                  final noteField = TextFormField(
                                    minLines: 3,
                                    maxLines: 8,
                                    keyboardType: TextInputType.multiline,
                                    controller: noteController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 20, 10, 10),
                                      labelText: "Booking notes...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    validator: null,
                                  );
                                  final currencyField = DropdownButtonFormField(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText: "Choose currency...",
                                      contentPadding: EdgeInsets.all(5.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                    ),
                                    value: currencyValue,
                                    items: currencies
                                        .map<DropdownMenuItem<int>>((item) {
                                      return DropdownMenuItem(
                                        value: item.id,
                                        child: Text(item.name +
                                            " (" +
                                            item.code +
                                            ") "),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        currencyValue = newValue as int;
                                      });
                                    },
                                  );
                                  final originalPriceField = TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: originalPriceController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Price...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    validator: (value) {
                                      if ((value == null || value.isEmpty) &&
                                          !edit) {
                                        return 'Price can\'t be empty';
                                      }
                                      return null;
                                    },
                                  );
                                  final depositField = TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: depositController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Deposit...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    validator: (value) {
                                      if ((value == null || value.isEmpty) &&
                                          !edit) {
                                        return 'Deposit can\'t be empty';
                                      }
                                      return null;
                                    },
                                  );
                                  final taxField = TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: taxController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Tax...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    validator: (value) {
                                      if ((value == null || value.isEmpty) &&
                                          !edit) {
                                        return 'Tax can\'t be empty';
                                      }
                                      return null;
                                    },
                                  );
                                  final commissionField = TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: commissionController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Commission...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    validator: (value) {
                                      if ((value == null || value.isEmpty) &&
                                          !edit) {
                                        return 'Commission can\'t be empty';
                                      }
                                      return null;
                                    },
                                  );
                                  final cleaningFeesField = TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: cleaningFeesController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Cleaning fees...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    validator: (value) {
                                      if ((value == null || value.isEmpty) &&
                                          !edit) {
                                        return 'Cleaning fees can\'t be empty';
                                      }
                                      return null;
                                    },
                                  );
                                  final transactionFeesField = TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: transactionFeesController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Transaction fees...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    validator: (value) {
                                      if ((value == null || value.isEmpty) &&
                                          !edit) {
                                        return 'Transaction fees can\'t be empty';
                                      }
                                      return null;
                                    },
                                  );
                                  final bookingFeesField = TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: bookingFeesController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: "Booking Fees...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    validator: (value) {
                                      if ((value == null || value.isEmpty) &&
                                          !edit) {
                                        return 'Booking fees can\'t be empty';
                                      }
                                      return null;
                                    },
                                  );

                                  return Form(
                                      key: _formkey,
                                      child: Column(
                                        children: [
                                          propertyField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          bookedAtFormField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          startFormField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          endFormField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          statusField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          adultField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          childField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          arrivalTimeFormField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          guestTitleField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          firstNameField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          lastNameField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          emailField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          phoneField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          mobileField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          faxField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          companyField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          countryField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          addressField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          cityField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          stateField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          postCodeField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          commentField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          noteField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          currencyField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          originalPriceField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          depositField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          taxField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          commissionField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          cleaningFeesField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          transactionFeesField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          bookingFeesField,
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ));
                                }
                              })
                        ],
                      ))),
              actions: <Widget>[
                // ignore: deprecated_member_use
                Container(
                  margin: EdgeInsets.only(right: 10, top: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF05A8CF)),
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        var formData = <String, dynamic>{
                          'created_by_user_id': partner,
                          'firstNight': startController.text,
                          'lastNight': endController.text,
                          'notes': noteController.text,
                          'bookId': 0,
                          'propId': propId,
                          'roomId': roomId,
                          'unitId': 1,
                          'roomQty': 1,
                          'status': 1,
                          'substatus': 0,
                          'numAdult': adultController.text,
                          'numChild': childController.text,
                          'guestTitle': guestTitleValue,
                          'guestFirstName': firstNameController.text,
                          'guestName': lastNameController.text,
                          'guestEmail': emailController.text,
                          'guestPhone': phoneController.text,
                          'guestMobile': mobileController.text,
                          'guestFax': faxController.text,
                          'guestCompany': companyController.text,
                          'guestAddress': addressController.text,
                          'guestCity': cityController.text,
                          'guestState': stateController.text,
                          'guestPostcode': postCodeController.text,
                          'guestCountry': countryValue,
                          'guestArrivalTime': arrivalTimeController.text,
                          'guestVoucher': '',
                          'guestComments': commentController.text,
                          'message': '',
                          'statusCode': 0,
                          'price': originalPriceController.text,
                          'deposit': depositController.text,
                          'tax': taxController.text,
                          'commission': commissionController.text,
                          'rateDescription': '',
                          'offerId': 0,
                          'referer': 'Partner',
                          'reference': '',
                          'apiSource': '0',
                          'apiMessage': '',
                          'apiReference': '',
                          'stripeToken': '',
                          'bookingTime': bookedAtController.text,
                          'modified': '',
                          'booking_fees': bookingFeesController.text,
                          'transaction_fees': transactionFeesController.text,
                          'currency_id': currencyValue,
                          'converted_price': 0,
                          'validation_status': 'pending',
                          'cleaning_fees_partner': cleaningFeesController.text,
                          'seller': 'partner',
                          'payment_handler': 'partner',
                        };

                        !edit
                            ? postBlockDate(formData, context)
                            : methods.editBlockDate(formData, context, book.id);
                      }
                    },
                    child: Text(
                      ' Confirm ',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10, top: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      ' Cancel ',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ));
  }

  showAllBooking(context, booking, partner) {
    final apiBook = ApiBooking();
    Future<dynamic> callApiBooking(id) {
      return apiBook.getOneBooking(id);
    }

    final methods = Methods();
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
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
                          future: callApiBooking(booking.id),
                          builder: (context, AsyncSnapshot snap) {
                            var book = snap.data;

                            if (snap.data == null) {
                              return Container(
                                child: Center(
                                  child: Text("Loading..."),
                                ),
                              );
                            } else {
                              return Column(
                                children: [
                                  ExpansionTile(
                                    title: Text("Channel Reference",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    children: [
                                      Row(children: <Widget>[
                                        methods.label("Referer: "),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        methods.element(booking.referer),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Booking ID: "),
                                        methods.element(book.bookId.toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text("Booking Details",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    children: [
                                      Row(children: <Widget>[
                                        methods.label("Booked At: "),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        methods.element(DateFormat('dd-MM-yyyy')
                                            .format(
                                                DateTime.parse(book.bookedAt))),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Check-In: "),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        methods.element(DateFormat('dd-MM-yyyy')
                                            .format(DateTime.parse(
                                                book.firstNight))),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Check-Out: "),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        methods.element(DateFormat('dd-MM-yyyy')
                                            .format(
                                                DateTime.parse(book.lastNight)
                                                    .add(Duration(days: 1)))),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Adults: "),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        methods.element(book.adult.toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Children: "),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        methods.element(book.child.toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Arrival Time: "),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        methods.element(book.arriveTime),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text("Guest Details",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    children: [
                                      if (book.title != "")
                                        Row(children: <Widget>[
                                          methods.label("Title: "),
                                          SizedBox(
                                            width: 45,
                                          ),
                                          methods.element(book.title),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ]),
                                      if (book.guestFirstName != "")
                                        Row(children: <Widget>[
                                          methods.label("First Name: "),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          methods.element(book.guestFirstName),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ]),
                                      if (book.guestName != "")
                                        Row(children: <Widget>[
                                          methods.label("Last Name: "),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          methods.element(book.guestName),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.email != "")
                                        Row(children: <Widget>[
                                          methods.label("Email: "),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          methods.element(book.email),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.phone != "")
                                        Row(children: <Widget>[
                                          methods.label("Phone: "),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          methods.element(book.phone),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.mobile != "")
                                        Row(children: <Widget>[
                                          methods.label("Mobile: "),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          methods.element(book.mobile),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.fax != "")
                                        Row(children: <Widget>[
                                          methods.label("Fax: "),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          methods.element(book.fax),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.compagny != "")
                                        Row(children: <Widget>[
                                          methods.label("Compagny: "),
                                          SizedBox(
                                            width: 0,
                                          ),
                                          methods.element(book.compagny),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.address != "")
                                        Row(children: <Widget>[
                                          methods.label("Address: "),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          methods.element(book.address),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.city != "")
                                        Row(children: <Widget>[
                                          methods.label("City: "),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          methods.element(book.city),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.state != "")
                                        Row(children: <Widget>[
                                          methods.label("State: "),
                                          SizedBox(
                                            width: 35,
                                          ),
                                          methods.element(book.state),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.postCode != "")
                                        Row(children: <Widget>[
                                          methods.label("Post Code: "),
                                          SizedBox(
                                            width: 0,
                                          ),
                                          methods.element(book.postCode),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.country != "")
                                        Row(children: <Widget>[
                                          methods.label("Country: "),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          methods.element(book.country),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.comment != Text(" "))
                                        Row(children: <Widget>[
                                          methods.label("Guest Comments: "),
                                          SizedBox(
                                            width: 0,
                                          ),
                                          methods.elementText(book.comment),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ]),
                                      if (book.note != Text(" "))
                                        Row(children: <Widget>[
                                          methods.label("Booking Notes: "),
                                          SizedBox(
                                            width: 0,
                                          ),
                                          methods.elementText(book.note),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text("Invoice Details",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    children: [
                                      Row(children: <Widget>[
                                        methods.label("Original Price: "),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        methods.element(book.price.toString() +
                                            " " +
                                            book.currency),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Price Multiplier: "),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        methods.element(book.multiplier !=
                                                'Not defined'
                                            ? book.multiplier.toString() + " %"
                                            : book.multiplier),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Deposit: "),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        methods.element(
                                            book.deposit.toString() +
                                                " " +
                                                book.currency),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Tax: "),
                                        SizedBox(
                                          width: 60,
                                        ),
                                        methods.element(book.tax.toString() +
                                            " " +
                                            book.currency),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Commission: "),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        methods.element(
                                            book.commission.toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Cleaning Fees: "),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        methods.element(
                                            book.cleaningFees.toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Transaction Fees: "),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        methods.element(
                                            book.transactionFees.toString() +
                                                " " +
                                                book.currency),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Booking Fees: "),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        methods.element(
                                            book.bookingFees.toString() +
                                                " " +
                                                book.currency),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Rate Description: "),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        methods
                                            .elementText(book.rateDescription),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10, top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.green),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        addBooking(
                                            context, book, partner, true);
                                      },
                                      child: Text(
                                        ' Edit ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  )
                                ],
                              );
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
}

postBlockDate(formData, context) async {
  ApiBooking apiBooking = ApiBooking();
  var resp = await apiBooking.postBlockDate(formData);
  if (resp == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Operation successfully completed')),
    );
    Navigator.pushNamed(context, '/booking');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error during this operation')),
    );
  }
}

class Property {
  int id;
  String ref;
  String internalName;
  int propId;
  int roomId;
  Property(this.id, this.internalName, this.ref, this.propId, this.roomId);
}

class Country {
  int id;
  String name;
  Country(this.id, this.name);
}

class Currency {
  int id;
  String code;
  String name;
  Currency(this.id, this.code, this.name);
}
