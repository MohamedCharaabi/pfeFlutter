import 'dart:developer';

import 'package:bottom_navigation/screens/admin_app/admin_app_theme.dart';
import 'package:flutter/material.dart';

class LevelsCount extends StatefulWidget {
  final Map<String, dynamic> levelsCount;
  LevelsCount({this.levelsCount});
  @override
  _LevelsCountState createState() => _LevelsCountState();
}

class _LevelsCountState extends State<LevelsCount> {
  Map<String, dynamic> data;
  var data5 = 1;
  // List<Map<String, dynamic>> levelsData = [];
  List<Map<String, dynamic>> levelsData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    levelsData = [
      {
        'title': 'Deps',
        'icon': Icons.domain,
        'value': widget.levelsCount['depCount'],
        'gradiant': [
          Color(0xffb1217b),
          Color(0xffe7b7cd),
        ]
      },
      {
        'title': 'Dirs',
        'icon': Icons.near_me,
        'value': widget.levelsCount['dirCount'],
        'gradiant': [
          Color(0xff0967fd),
          Color(0xff38b2f7),
        ]
      },
      {
        'title': 'Divs',
        'icon': Icons.alt_route,
        'value': widget.levelsCount['divCount'],
        'gradiant': [
          Color(0xffff002e),
          Color(0xfffa4d00),
        ]
      },
      {
        'title': 'Sers',
        'icon': Icons.volunteer_activism,
        'value': widget.levelsCount['serCount'],
        'gradiant': [
          Color(0xff2e3ec9),
          Color(0xff5f9bfa),
        ]
      }
    ];
    log('levels ==>${levelsData}');
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.3,
      width: width,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: height * 0.13,
                  width: height * 0.13,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          levelsData[index]['gradiant'][0],
                          levelsData[index]['gradiant'][1]
                        ]),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          offset: const Offset(8.0, 16.0),
                          blurRadius: 16.0),
                    ],
                  ),
                  child: Icon(
                    levelsData[index]['icon'],
                    color: Colors.white,
                  ),
                ),
                Text('${levelsData[index]['value']}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff080911),
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 5,
                ),
                Text('${levelsData[index]['title']}',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xffaab0c4),
                    )),
              ],
            );

            // return Container(
            //   height: height * 0.15,
            //   width: width * 0.3,
            //   margin: EdgeInsets.only(right: 10),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(15),
            //     color: Colors.blue,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: <Widget>[
            //       Icon(levelsData[index]['icon']),
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: <Widget>[
            //           Text('${levelsData[index]['title']}',
            //               style: TextStyle(fontSize: 18)),
            //           Text('${levelsData[index]['value']}',
            //               style: TextStyle(fontSize: 18))
            //         ],
            //       ),
            //     ],
            //   ),
            // );
          }),
    );
  }
}
