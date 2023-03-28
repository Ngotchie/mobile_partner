import 'package:flutter/material.dart';
import 'package:chicaparts/models/user/user.dart';
import 'package:chicaparts/widgets/booking/bookingAccommodation.dart';
import 'package:chicaparts/widgets/booking/myBookings.dart';
import 'package:chicaparts/widgets/login/login.dart';
import 'package:chicaparts/widgets/menu/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingIndexWidget extends StatefulWidget {
  const BookingIndexWidget({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  _BookingIndexWidgetState createState() => _BookingIndexWidgetState();
}

class _BookingIndexWidgetState extends State<BookingIndexWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: drawer(widget.user, context),
        appBar: AppBar(
          backgroundColor: Color(0xFF05A8CF),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          // GestureDetector(
          //   onTap: () {},
          //   child: Icon(Icons.menu_rounded),
          // ),
          title: Row(
            children: [
              Text(
                "BOOKINGS",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext bc) => [
                PopupMenuItem(child: Text("Logout"), value: "/logout"),
              ],
              onSelected: (route) async {
                if (route == "/logout") {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('user');
                  prefs.remove('email');
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => LoginPage()));
                }
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                child: Container(
                  child: Text(
                    'All Bookings',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'My Bookings',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // AllBookingWidget(user: widget.user),
            BookingAccommodationWidget(user: widget.user),
            // CalendarWidget(user: widget.user),
            MyBookingWidget(user: widget.user)
          ],
        ),
      ),
    );
  }
}
