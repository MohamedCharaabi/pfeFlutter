import 'dart:convert';
import 'dart:developer';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../admin_app_theme.dart';
import '../hexColor.dart';

class Reclamations extends StatefulWidget {
  @override
  _ReclamationsState createState() => _ReclamationsState();
}

class _ReclamationsState extends State<Reclamations> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  List<dynamic> reclamations = [];
  Future<List<dynamic>> getReclamations() async {
    try {
      var result =
          await http.get(Uri.parse('https://pfe-cims.herokuapp.com/alert'));

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
    getReclamations();
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
        title: Shimmer.fromColors(
          highlightColor: Colors.black,
          baseColor: Colors.blueAccent,
          period: Duration(seconds: 5),
          child: Text(
            'Reclamations',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Container(
        height: height * 0.8,
        child: FutureBuilder(
            future: getReclamations(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              return Container(
                margin: EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                  shrinkWrap: true,
                  // scrollDirection: Axis.vertical,
                  // controller: controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  // physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var alert = snapshot.data.reversed.toList()[index];

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: ExpansionTileCard(
                        // key: cardB,
                        expandedTextColor: Colors.red,
                        leading: CircleAvatar(child: Icon(Icons.info_outline)),
                        title: Text(alert['title']),
                        subtitle: Text(alert['by']),
                        children: <Widget>[
                          Divider(
                            thickness: 1.0,
                            height: 1.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Text(alert['content']),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}
