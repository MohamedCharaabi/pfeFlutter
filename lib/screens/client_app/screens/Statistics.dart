import 'dart:convert';
import 'dart:developer';

import 'package:bottom_navigation/screens/admin_app/models/responsive.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/StatisticsWidgets/constants.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/StatisticsWidgets/header.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/StatisticsWidgets/my_fiels.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/StatisticsWidgets/recent_files.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/StatisticsWidgets/storage_details.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/levelsCount.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/lineChart.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/lineChartExample.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/pieChartExample2.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<dynamic> topThemes = [];
  Map<String, dynamic> levelsCount = {};
  List<dynamic> monthRequest = [];
  bool isLoading = true;
  Future<Map<String, dynamic>> getStats() async {
    try {
      var result =
          await http.get(Uri.parse('https://pfe-cims.herokuapp.com/stat'));

      if (result.statusCode == 200) {
        log('top theme ==> ${json.decode(result.body)['topTheme']}');
        setState(() {
          topThemes = json.decode(result.body)['topTheme'];
          levelsCount = json.decode(result.body)['levelsCount'];
          monthRequest = json.decode(result.body)['monthRequest'];

          isLoading = false;
        });
        return json.decode(result.body);
      } else
        log('result  != 200 =>> ${result.statusCode}');
    } catch (e) {
      log('error in TopTheme request ==> $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        // brightness: _getBrightness(),
        // iconTheme: IconThemeData(color: _dark ? Colors.white : Colors.black),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Shimmer.fromColors(
          baseColor: Colors.black,
          highlightColor: Colors.blueAccent,
          period: Duration(seconds: 5),
          child: Text(
            'Dashboad',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nombre de stages',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: defaultPadding),
                  LevelsCount(
                    levelsCount: levelsCount,
                  ),
                  SizedBox(height: defaultPadding),
                  Text(
                    'Demmandes Mois',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: defaultPadding),
                  // LineChartSample2(monthRequest: monthRequest),
                  CustomLineChart(monthRequest: monthRequest),
                  SizedBox(height: defaultPadding),
                  Text(
                    'Top Themes',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: defaultPadding),
                  PieChartSample2(topThemes: topThemes),
                  // SizedBox(height: defaultPadding),
                  // RecentFiles(),
                  // SizedBox(height: defaultPadding),
                  // StarageDetails(),
                  SizedBox(
                    height: 60,
                  )
                ],
              ),
            ),
    );
  }
}
