import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../admin_app_theme.dart';
import '../hexColor.dart';

class Divisions extends StatefulWidget {
  @override
  _DivisionsState createState() => _DivisionsState();
}

class _DivisionsState extends State<Divisions> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  List<dynamic> Divisions = [];
  Future<List<dynamic>> getDivisions() async {
    try {
      var result =
          await http.get(Uri.parse('https://pfe-cims.herokuapp.com/div'));

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
    getDivisions();
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

    return Container(
      height: height * 0.8,
      child: FutureBuilder(
          future: getDivisions(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return Container(
              margin: EdgeInsets.only(bottom: 50),
              child: ListView.builder(
                shrinkWrap: true,
                // controller: controller,
                itemCount: snapshot.data.length,
                // physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var department = snapshot.data[index];

                  return Slidable(
                    actionPane: SlidableBehindActionPane(),
                    secondaryActions: [
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          log('deleteClicked');
                        },
                      ),
                      IconSlideAction(
                        caption: 'Edit',
                        color: Colors.green,
                        icon: Icons.edit,
                        onTap: () {
                          log('Edit Clicked');
                        },
                      )
                    ],
                    actionExtentRatio: 1 / 2,
                    child: Container(
                      height: height * 0.1,
                      width: width * 0.8,
                      // margin: EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                        color: FitnessAppTheme.nearlyDarkBlue,
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                          colors: [
                            FitnessAppTheme.nearlyDarkBlue,
                            HexColor('#6A88E5'),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff6A88E5),
                            blurRadius: 4,
                            // offset: Offset.infinite,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          CircleAvatar(),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                department["name"],
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                department["dir_name"],
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                department["dep_name"],
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}
