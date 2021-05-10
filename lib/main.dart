import 'package:bottom_navigation/colors.dart';

import 'package:bottom_navigation/screens/auth/login.dart';
import 'package:bottom_navigation/screens/fitness_app/fitness_app_home_screen.dart';
import 'package:bottom_navigation/screens/mainPage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token");
  print(' token ==> $token ');

  if (token == null) {
    runApp(ChangeNotifierProvider(
      create: (context) => ColorProvider(),
      child: MyApp(
        page: Login(),
      ),
    ));
  } else {
    runApp(ChangeNotifierProvider(
      create: (context) => ColorProvider(),
      child: MyApp(
        page: FitnessAppHomeScreen(),
      ),
    ));
  }

  // runApp(ChangeNotifierProvider(
  //   create: (context) => ColorProvider(),
  //   child: MyApp(),
  // ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

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
