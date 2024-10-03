import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:chicaparts_partner/models/user/user.dart';
import 'package:chicaparts_partner/services/api.dart';
import 'package:chicaparts_partner/widgets/menu/bottomMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _passwordVisible;
  var _client;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _client = false;
  }

  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      obscureText: false,
      style: style,
      controller: email,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail, color: Colors.grey),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xFF244B6B),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xFF244B6B),
            width: 2.0,
          ),
        ),
      ),
      validator: (value) => EmailValidator.validate(value.toString())
          ? null
          : "Please enter a valid email",
    );
    final passwordField = TextFormField(
      obscureText: !_passwordVisible,
      style: style,
      controller: pass,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_open, color: Colors.grey),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xFF244B6B),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xFF244B6B),
            width: 2.0,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF244B6B),
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password can\'t be empty';
        }
        return null;
      },
    );
    final loginButon = SizedBox(
      height: 50,
      width: 250,
      // decoration: BoxDecoration(
      //     color: const Color(0xFFFBD107), borderRadius: BorderRadius.circular(20)),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all<Color>(const Color(0xFF244B6B)),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
            _authentification(email.text, pass.text, context);
          }
        },
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );

    return Form(
      key: _formKey,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 155.0,
                    child: Image.asset(
                      "assets/images/new-logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 45.0),
                  emailField,
                  const SizedBox(height: 25.0),
                  passwordField,
                  const SizedBox(
                    height: 35.0,
                  ),
                  loginButon,
                  const SizedBox(
                    height: 35.0,
                  ),
                  InkWell(
                    onTap: () async {
                      var url =
                          "https://booking.chic-aparts.com/auth/register/";

                      await launchUrl(Uri.parse(url));
                    },
                    child: const Text(
                      'Account registration',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF244B6B),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  InkWell(
                    onTap: () async {
                      var url = "https://booking.chic-aparts.com/";

                      // if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                      // } else {
                      //   throw 'error launching $url';
                      // }
                    },
                    child: const Text(
                      'Make reservation',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF244B6B),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    'Chic partner app by Mayem Solutions | v1.0.1',
                    style: TextStyle(
                        color: Color(0xFF244B6B),
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<User> _getUserData(email, pass) async {
    ApiUrl url = ApiUrl();
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    User user = User(0, "", "", []);

    try {
      var data = await client.post(Uri.parse('${apiUrl}auth/login'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'X-Authorization': apiKey,
          },
          body: jsonEncode(<String, String>{'email': email, 'password': pass}));
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        user = User(jsonData["id"], jsonData["name"], jsonData["email"],
            jsonData["third_party"]);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user', data.body);
        prefs.setString('email', jsonData["email"]);
        prefs.remove('token');
        return user;
      } else {
        _client = true;
        var data = await client.post(
            Uri.parse('https://intranet.chic-aparts.com/chicaparts/auth/login'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'X-Authorization': apiKey,
            },
            body:
                jsonEncode(<String, String>{'login': email, 'password': pass}));
        if (data.statusCode == 200) {
          var jsonData = jsonDecode(data.body);
          user = User(0, 'ChicBooking', email, "");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', data.body);
          prefs.setString('email', email);
          prefs.remove('user');
        }
        return user;
      }
    } catch (e) {
      client.close();
      print(e);
      return throw Exception(e);
    }
  }

  _authentification(email, pass, context) async {
    var response = await _getUserData(email, pass);
    launchURLBrowser() async {
      const url = 'https://booking.chic-aparts.com/';
      // if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      // } else {
      //   throw 'Could not launch $url';
      // }
    }

    if (response.email.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error!!"),
              content: const Text("Email or password are incorrect!"),
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.red, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              actions: <Widget>[
                TextButton(
                  child: const Text("Try Again"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => MyHomePage(
      //               index: 0,
      //               //user: user,
      //             )));
      if (!_client) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => const BottomMenu(
                      index: 0,
                    )));
      } else {
        launchURLBrowser();
      }
    }
  }
}
