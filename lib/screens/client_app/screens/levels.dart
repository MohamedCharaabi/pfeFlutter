import 'dart:convert';
import 'dart:developer';

import 'package:bottom_navigation/screens/admin_app/models/Department.dart';
import 'package:bottom_navigation/screens/admin_app/screens/departments.dart';
import 'package:bottom_navigation/screens/admin_app/screens/directions.dart';
import 'package:bottom_navigation/screens/admin_app/screens/divisions.dart';
import 'package:bottom_navigation/screens/admin_app/screens/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../admin_app_theme.dart';
import '../hexColor.dart';

class Levels extends StatefulWidget {
  @override
  _LevelsState createState() => _LevelsState();
}

class _LevelsState extends State<Levels> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  // List<dynamic> Departments = [];
  Future<List<dynamic>> getDepartments() async {
    try {
      var result =
          await http.get(Uri.parse('https://pfe-cims.herokuapp.com/dep'));

      if (result.statusCode == 200)
        return json.decode(result.body);
      else
        log('result  != 200 =>> ${result.statusCode}');
    } catch (e) {
      log('error in theme request ==> ${e.message}');
    }
  }

  @override
  void initState() {
    super.initState();
    getDepartments();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  int selectedLevel = 0;
  List<Widget> tabs = [
    Departments(),
    Directions(),
    Divisions(),
    Services(),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Shimmer.fromColors(
          highlightColor: Colors.black,
          baseColor: Colors.blueAccent,
          period: Duration(seconds: 5),
          child: Text(
            'Niveaux',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Material(
                elevation: 12,
                child: Container(
                  height: height * 0.1,
                  // color: Colors.blueAccent,
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedLevel = 0;
                                });
                              },
                              child: LevelsTabs(
                                height: height,
                                width: width,
                                showLine: selectedLevel == 0 ? true : false,
                                text: 'Deps',
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedLevel = 1;
                                });
                              },
                              child: LevelsTabs(
                                height: height,
                                width: width,
                                showLine: selectedLevel == 1 ? true : false,
                                text: 'Dirs',
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedLevel = 2;
                                });
                              },
                              child: LevelsTabs(
                                height: height,
                                width: width,
                                showLine: selectedLevel == 2 ? true : false,
                                text: 'Divs',
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedLevel = 3;
                                });
                              },
                              child: LevelsTabs(
                                height: height,
                                width: width,
                                showLine: selectedLevel == 3 ? true : false,
                                text: 'Sers',
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: tabs[selectedLevel],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LevelsTabs extends StatelessWidget {
  final String text;
  final bool showLine;

  const LevelsTabs({
    Key key,
    @required this.text,
    @required this.showLine,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: showLine ? Color(0xfff9f9f9) : Colors.white,
      height: height * 0.2,
      // width: width * 0.2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            Container(
              height: showLine ? 3 : 0,
              width: double.maxFinite * 0.5,
              decoration: BoxDecoration(
                color: FitnessAppTheme.nearlyDarkBlue,
                borderRadius: BorderRadius.circular(1),
                shape: BoxShape.rectangle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.4),
                      offset: const Offset(8.0, 16.0),
                      blurRadius: 16.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
