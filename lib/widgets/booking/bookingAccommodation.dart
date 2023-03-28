import 'package:flutter/material.dart';
import 'package:chicaparts/api/api_accommodation.dart';
import 'package:chicaparts/models/user/user.dart';
import 'package:chicaparts/widgets/booking/calender.dart';

class BookingAccommodationWidget extends StatefulWidget {
  const BookingAccommodationWidget({Key? key, required this.user})
      : super(key: key);
  final User user;
  @override
  State<BookingAccommodationWidget> createState() =>
      _BookingAccommodationWidgetState();
}

class _BookingAccommodationWidgetState
    extends State<BookingAccommodationWidget> {
  final apiAcc = ApiAccommodation();

  Future<dynamic> callApiListAcc(partner) {
    return apiAcc.getAccommodations(partner);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: callApiListAcc(widget.user.thirdParty["id"]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            } else {
              return Container(
                margin: EdgeInsets.only(top: 5),
                child: Center(
                  child: Wrap(
                    children: [
                      for (var i = 0;
                          i < snapshot.data["accommodations"].length;
                          i++)
                        card(snapshot.data["accommodations"][i], widget.user),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget card(accommodation, user) {
    return Card(
      shadowColor: Colors.black,
      color: Colors.grey[350],
      child: SizedBox(
        width: 155,
        height: 170,
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.home) //CircleAvatar
                  ), //CircleAvatar
              SizedBox(
                height: 1,
              ), //SizedBox
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: accommodation['internal_name'],
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat')), //Textstyle
              ), //Text
              SizedBox(
                height: 5,
              ),
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: accommodation['external_name'],
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat')), //Textstyle
              ), ////SizedBox//Text
              SizedBox(
                height: 5,
              ), //SizedBox
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CalendarWidget(
                                  user: user,
                                  accommodation: accommodation['internal_name'],
                                )));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: Colors.white,
                          size: 14,
                        ),
                        Text(
                          'View bookings',
                          style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ],
                    ), //Row
                  ), //Padding
                ), //RaisedButton
              ) //SizedBox
            ],
          ), //Column
        ), //Padding
      ), //SizedBox
    );
  }
}
