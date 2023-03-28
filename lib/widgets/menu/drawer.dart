import 'package:flutter/material.dart';
import 'package:chicaparts/widgets/finance/monthlyReport.dart';
import 'package:chicaparts/widgets/finance/paymentOders.dart';
import 'package:chicaparts/widgets/finance/payouts.dart';
import 'package:chicaparts/widgets/finance/yearlyPayouts.dart';
import 'package:chicaparts/widgets/operation/maintenance.dart';
import 'package:chicaparts/widgets/operation/sinister.dart';

Widget drawer(user, context) {
  return Drawer(
      elevation: 10.0,
      child: ListView(
        children: <Widget>[
          Container(
            height: 110,
            child: DrawerHeader(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(color: Color(0xFF05A8CF)),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/images/avatar.png"),
                        radius: 40.0,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          user.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  user.email,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14.0),
                ),
              ]),
            ),
          ),
          Divider(height: 3.0),
          ListTile(
            leading: Icon(Icons.home_sharp),
            title: Text('Accommodations', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushNamed(context, '/accommodation');
            },
          ),
          Divider(height: 3.0),
          ListTile(
            leading: Icon(Icons.ballot_outlined),
            title: Text('Bookings', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushNamed(context, '/booking');
            },
          ),
          Divider(height: 3.0),
          ListTile(
            leading: Icon(Icons.monetization_on_outlined),
            title: Text('Monthly reports', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MonthlyReportWidget(user: user)));
            },
          ),
          Divider(height: 3.0),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Payment orders', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PaymentOrderWidget(user: user)));
            },
          ),
          Divider(height: 3.0),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Payouts', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => PayoutWidget(user: user)));
            },
          ),
          Divider(height: 3.0),
          ListTile(
            leading: Icon(Icons.payments_outlined),
            title:
                Text('Yearly payout reports', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => YearlyPayoutWidget(user: user)));
            },
          ),
          Divider(height: 3.0),
          ListTile(
            leading: Icon(Icons.settings_suggest_sharp),
            title: Text('Maintenance', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MaintenanceWidget(user: user)));
            },
          ),
          Divider(height: 3.0),
          ListTile(
            leading: Icon(Icons.bug_report),
            title: Text('Sinisters', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SinisterWidget(user: user)));
            },
          ),
        ],
      ));
}
