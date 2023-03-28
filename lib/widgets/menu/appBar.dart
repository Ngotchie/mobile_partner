import 'package:flutter/material.dart';
import 'package:chicaparts/widgets/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

PreferredSizeWidget? appBar(title, context, position) {
  return AppBar(
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
    title: Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    // titleSpacing: 0,
    actions: <Widget>[
      PopupMenuButton(
        itemBuilder: (BuildContext bc) => [
          PopupMenuItem(child: Text("Logout"), value: "/logout"),
        ],
        onSelected: (route) async {
          // Note You must create respective pages for navigation
          if (route == "/logout") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('user');
            prefs.remove('email');
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginPage()));
          }
        },
      ),
    ],
  );
}
