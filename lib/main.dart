import 'dart:convert';
import 'dart:developer';

import 'package:bottom_navigation/colors.dart';

import 'package:bottom_navigation/screens/auth/login.dart';
import 'package:bottom_navigation/screens/admin_app/admin_app_home_screen.dart';
import 'package:bottom_navigation/screens/client_app/client_app_home_screen.dart';
// import 'package:bottom_navigation/screens/mainPage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget page;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userData = prefs.getString("userData");
  print(' userData ==> $userData ');
  Map<String, dynamic> data = userData != null ? jsonDecode(userData) : null;
  // log(data);
  if (data == null) {
    page = Login();
  } else if (data['role'] == 'admin') {
    page = AdminAppHomeScreen();
  } else {
    page = ClientAppHomeScreen();
  }

  runApp(MyApp(page: page));
}

class MyApp extends StatelessWidget {
  final Widget page;

  MyApp({this.page});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cims-PFE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: page,
    );
  }
}
