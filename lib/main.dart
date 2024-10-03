import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chicaparts_partner/widgets/login/login.dart';
import 'package:chicaparts_partner/widgets/menu/bottomMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarColor: Color(0xFF122636) //Colors.orange[900] // status bar color
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chic Partner',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF244B6B), //Color(0xFFF37540),
            secondary: const Color(0xffffbd107),
          ),
          fontFamily: 'Montserrat'),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/booking': (context) => const BottomMenu(index: 1),
        '/accommodation': (context) => const BottomMenu(index: 0),
        '/finance': (context) => const BottomMenu(index: 2),
        '/operation': (context) => const BottomMenu(index: 3),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String currentEmail = "";
  String currentUser = "";
  String currentToken = "";
  startTime() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, navigationPage);
  }

  getData() async {}
  _launchURLBrowser(token) async {
    var url = 'https://booking.chic-aparts.com';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUser = prefs.getString('user') ?? "";
      currentEmail = prefs.getString('email') ?? "";
      currentToken = prefs.getString('token') ?? "";
    });
    if (currentEmail != "") {
      if (currentUser != "") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => const BottomMenu(
                      index: 0,
                    )));
      } else {
        _launchURLBrowser(currentToken);
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/new-logo.png",
          width: 200,
        ),
      ),
    );
  }
}
