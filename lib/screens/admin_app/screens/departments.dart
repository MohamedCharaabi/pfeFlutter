import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../admin_app_theme.dart';
import '../hexColor.dart';

class Departments extends StatefulWidget {
  @override
  _DepartmentsState createState() => _DepartmentsState();
}

class _DepartmentsState extends State<Departments> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  List<dynamic> Departments = [];
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
            'Departments',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: <Widget>[
            Container(
              height: height * 0.1,
              color: Colors.blueAccent,
              width: width,
            ),
            Expanded(
              child: Container(
                child: Text('Hi'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
