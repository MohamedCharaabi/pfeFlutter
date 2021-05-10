import 'dart:convert';

import 'package:bottom_navigation/colors.dart';
import 'package:bottom_navigation/constants/Theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getRequests();
  }

  Future<List<dynamic>> getRequests() async {
    var result =
        await http.get(Uri.parse('https://pfe-cims.herokuapp.com/request'));

    print(result.body);
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
          height: height,
          width: width,
          child: FutureBuilder<List<dynamic>>(
            future: getRequests(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // print("snapshot data ==> " + snapshot.data);
                return Container(
                  height: height,
                  width: width,
                  child: ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final r = snapshot.data[index];
                        String date = DateFormat('yMd')
                            .format(DateTime.parse(r['dateDem']));

                        return Container(
                          height: height * 0.12,
                          width: width,
                          margin: EdgeInsets.only(top: 15),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(color: Colors.purple),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${r['nomDem']} ${r['prenomDem']}',
                                style: TextStyle(color: ArgonColors.white),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '${r['themeDem']}',
                                    style: TextStyle(color: ArgonColors.white),
                                  ),
                                  Text(
                                    date,
                                    style: TextStyle(color: ArgonColors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
