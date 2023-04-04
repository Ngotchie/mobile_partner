import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:chicaparts/models/user/user.dart';
import 'package:chicaparts/services/api.dart';
import 'package:chicaparts/widgets/menu/bottomMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
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
        prefixIcon: Icon(Icons.mail, color: Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
        prefixIcon: Icon(Icons.lock_open, color: Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFF05A8CF),
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
    final loginButon = Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
          color: Color(0xFFFBD107), borderRadius: BorderRadius.circular(20)),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF05A8CF)),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
            _authentification(email.text, pass.text, context);
          }
        },
        child: Text(
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
            child: Container(
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
                    SizedBox(height: 45.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      height: 130,
                    ),
                    Text(
                      'Chic partner app by Mayem Solutions | v1.0.1',
                      style: TextStyle(
                          color: Color(0xFF05A8CF),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<User> _getUserData(email, pass) async {
    ApiUrl url = new ApiUrl();
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    User user = new User(0, "", "", []);

    try {
      var data = await client.post(Uri.parse(apiUrl + 'auth/login'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'X-Authorization': apiKey,
            'Access-Control-Allow-Origin': '*',
          },
          body: jsonEncode(<String, String>{'email': email, 'password': pass}));
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        user = new User(jsonData["id"], jsonData["name"], jsonData["email"],
            jsonData["third_party"]);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user', data.body);
        prefs.setString('email', jsonData["email"]);
        return user;
      } else {
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
    if (response.email.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error!!"),
              content: new Text("Email or password are incorrect!"),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.red, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              actions: <Widget>[
                new TextButton(
                  child: new Text("Try Again"),
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

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => BottomMenu(
                    index: 0,
                  )));
    }
  }
}
