import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../admin_app_theme.dart';
import '../hexColor.dart';

class Themes extends StatefulWidget {
  @override
  _ThemesState createState() => _ThemesState();
}

class _ThemesState extends State<Themes> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  List<dynamic> themes = [];
  Future<List<dynamic>> getThemes() async {
    try {
      var result =
          await http.get(Uri.parse('https://pfe-cims.herokuapp.com/theme'));

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
    getThemes();
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
            'Themes',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          child: FutureBuilder(
              future: getThemes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  shrinkWrap: true,
                  // controller: controller,
                  itemCount: snapshot.data.length,
                  // physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var theme = snapshot.data[index];

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
                        height: height * 0.15,
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
                                  theme["theme"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  theme["creator"],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}
