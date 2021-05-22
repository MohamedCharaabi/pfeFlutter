import 'package:bottom_navigation/screens/admin_app/models/responsive.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/StatisticsWidgets/constants.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/StatisticsWidgets/header.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/StatisticsWidgets/my_fiels.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/StatisticsWidgets/recent_files.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/StatisticsWidgets/storage_details.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            // Header(),
            SizedBox(height: defaultPadding),
            MyFiels(),
            SizedBox(height: defaultPadding),
            RecentFiles(),
            SizedBox(height: defaultPadding),
            StarageDetails(),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
