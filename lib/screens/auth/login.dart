import 'dart:convert';

import 'package:bottom_navigation/constants/formValidation.dart';
import 'package:bottom_navigation/screens/admin_app/admin_app_home_screen.dart';
import 'package:bottom_navigation/screens/admin_app/admin_app_theme.dart';
import 'package:bottom_navigation/screens/client_app/client_app_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colored_progress_indicators/flutter_colored_progress_indicators.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bottom_navigation/screens/admin_app/hexColor.dart';

class Login extends StatefulWidget {
  // static final String path = "lib/src/pages/login/login12.dart";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  bool isLoading = false;
  ButtonState buttonState = ButtonState.idle;
  login(email, password) async {
    var url = "https://pfe-cims.herokuapp.com/new/login"; // iOS

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      print(' res ==> ${response.body}');
      if (response.statusCode == 200) {
        String role = jsonDecode(response.body)['userData']['role'];
        if (role != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var userData = jsonDecode(response.body)["userData"];
          await prefs.setString('userData', jsonEncode(userData));
          setState(() {
            buttonState = ButtonState.success;
          });
        } else {
          Fluttertoast.showToast(
              msg: "This is not an Admin account",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            buttonState = ButtonState.fail;
          });
        }
      } else {
        setState(() {
          buttonState = ButtonState.fail;
        });
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      setState(() {
        buttonState = ButtonState.fail;
      });
      Fluttertoast.showToast(
          msg: "Error ==> $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey.shade400,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              FitnessAppTheme.nearlyDarkBlue,
              HexColor('#6A88E5'),
            ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      4,
                      Text(
                        "Connexion",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                      1.3,
                      Text(
                        "Bienvenue",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 60,
                          ),
                          FadeAnimation(
                              1.4,
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(225, 95, 27, .3),
                                          blurRadius: 20,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        controller: _emailController,
                                        validator: (val) {
                                          return emailValidation(val);
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        // initialValue: "medch@yahoo.fr",
                                        decoration: InputDecoration(
                                            hintText: "Email ",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        controller: _passController,
                                        // initialValue: "12345",
                                        validator: (val) {
                                          return passwordlValidation(val);
                                        },
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText: _obscureText,
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: Icon(_obscureText
                                                  ? Icons
                                                      .visibility_off_outlined
                                                  : Icons.visibility),
                                              onPressed: _toggle,
                                            ),
                                            hintText: "Mot de passe",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 40,
                          ),
                          FadeAnimation(
                              1.5,
                              Text(
                                "",
                                style: TextStyle(color: Colors.grey),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            1.6,
                            ProgressButton.icon(
                              iconedButtons: {
                                ButtonState.idle: IconedButton(
                                    text: "Conexion",
                                    icon:
                                        Icon(Icons.login, color: Colors.white),
                                    color: Colors.deepPurple.shade500),
                                ButtonState.loading: IconedButton(
                                    text: "Chargement",
                                    color: Colors.deepPurple.shade700),
                                ButtonState.fail: IconedButton(
                                    text: "Echec",
                                    icon:
                                        Icon(Icons.cancel, color: Colors.white),
                                    color: Colors.red.shade300),
                                ButtonState.success: IconedButton(
                                    text: "Succ??s",
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    color: Colors.green.shade400)
                              },
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    buttonState = ButtonState.loading;
                                  });
                                  await login(_emailController.text,
                                      _passController.text);
                                  // setState(() {
                                  //   isLoading = false;
                                  // });
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String userData = prefs.getString("userData");
                                  // print('userData ==> $userData');
                                  if (userData != null) {
                                    Map<String, dynamic> data =
                                        jsonDecode(userData);
                                    if (data['role'] == 'admin') {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminAppHomeScreen()));
                                    } else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClientAppHomeScreen()));
                                    }
                                  }
                                }
                              },
                              state: buttonState,
                            ),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            // isLoading
                            //     ? ColoredLinearProgressIndicator()
                            //     : SizedBox(
                            //         height: 0,
                            //       ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
          Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
          curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(0, animation["translateY"]), child: child),
      ),
    );
  }
}
