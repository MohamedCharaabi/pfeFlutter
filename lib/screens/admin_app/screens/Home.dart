import 'dart:convert';
import 'dart:developer';

import 'package:bottom_navigation/colors.dart';
import 'package:bottom_navigation/constants/Theme.dart';
import 'package:bottom_navigation/screens/admin_app/admin_app_theme.dart';
import 'package:bottom_navigation/screens/admin_app/models/Request.dart';
// import 'package:bottom_navigation/screens/admin_app/screens/flipTest.dart';
import 'package:bottom_navigation/screens/admin_app/widgets/flipItem.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../hexColor.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> selectedThemeList = [
    "Symfony",
    "Angular",
    "React",
    "Excel",
    "Java",
    "Vue",
    "facebook2",
    "facebook",
    "javascript",
  ];
  Future<List<PersonalRequest>> getRequests() async {
    var result =
        await http.get(Uri.parse('https://pfe-cims.herokuapp.com/request'));

    // print(result.body);
    if (result.statusCode == 200) {
      var response = json.decode(result.body);
      List<PersonalRequest> requests = [];
      // List<String> themes = [];
      for (var item in response) {
        requests.add(PersonalRequest.fromJson(item));
      }
      return requests;
    }
    log('Errorrr while parsing requests <<check getRequets methode in home >>');
  }

  List<String> countList = [
    "Symfony",
    "Angular",
    "React",
    "Excel",
  ];

  List<Widget> shimm = [];

  @override
  void initState() {
    super.initState();
  }

  void _openFilterDialog() async {
    await FilterListDialog.display<String>(context,
        listData: countList,
        selectedListData: selectedThemeList,
        height: 480,
        headlineText: "Select Theme",
        searchFieldHintText: "Search Here", choiceChipLabel: (item) {
      return item;
    }, validateSelectedItem: (list, val) {
      return list.contains(val);
    }, onItemSearch: (list, text) {
      if (list.any(
          (element) => element.toLowerCase().contains(text.toLowerCase()))) {
        return list
            .where(
                (element) => element.toLowerCase().contains(text.toLowerCase()))
            .toList();
      } else {
        return [];
      }
    }, onApplyButtonClick: (list) {
      if (list != null) {
        setState(() {
          selectedThemeList = List.from(list);
        });
      }
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    int offset = 0;
    int time = 800;

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
            'Demmandes',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_outlined),
            color: FitnessAppTheme.nearlyDarkBlue,
            onPressed: _openFilterDialog,
          )
        ],
      ),
      body: Center(
        child: Container(
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(height: 15,),

                FutureBuilder<List<PersonalRequest>>(
                  future: getRequests(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // WidgetsBinding.instance
                      //     .addPostFrameCallback((_) => setState(() {
                      //           isLoading = false;
                      //         }));

                      // print("snapshot data ==> " + snapshot.data);
                      return Container(
                        height: height,
                        width: width,
                        child: ListView.builder(
                            padding: EdgeInsets.all(8),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              PersonalRequest snap =
                                  snapshot.data.reversed.toList()[index];
                              String date = DateFormat('yMd')
                                  .format(DateTime.parse(snap.date));
                              String theme = snap.theme;
                              if (selectedThemeList.contains(theme)) {
                                return Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: FlipItem(
                                    request: snap,
                                  ),
                                );
                                // return Container(
                                //   height: height * 0.12,
                                //   width: width,
                                //   margin: EdgeInsets.only(top: 15),
                                //   padding: EdgeInsets.symmetric(
                                //       horizontal: 10, vertical: 10),
                                //   decoration: BoxDecoration(
                                //       color: FitnessAppTheme.nearlyDarkBlue,
                                //       gradient: LinearGradient(
                                //           colors: [
                                //             FitnessAppTheme.nearlyDarkBlue,
                                //             HexColor('#6A88E5'),
                                //           ],
                                //           begin: Alignment.topLeft,
                                //           end: Alignment.bottomRight),
                                //       borderRadius: BorderRadius.circular(22)),
                                //   child: Row(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.spaceBetween,
                                //     children: <Widget>[
                                //       Row(
                                //         children: <Widget>[
                                //           Container(
                                //             width: width * 0.2,
                                //             child: Text(
                                //               '${r['themeDem']}',
                                //               style: TextStyle(
                                //                   color: ArgonColors.white),
                                //             ),
                                //           ),
                                //           Column(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: <Widget>[
                                //               Text(
                                //                 '${r['nomDem']} ${r['prenomDem']}',
                                //                 style: TextStyle(
                                //                     color: ArgonColors.white),
                                //               ),
                                //               SizedBox(
                                //                 height: 5,
                                //               ),
                                //               Text(
                                //                 '${r['emailDem']}',
                                //                 style: TextStyle(
                                //                     color: ArgonColors.white),
                                //               ),
                                //             ],
                                //           ),
                                //         ],
                                //       ),
                                //       PopupMenuButton(
                                //         icon: Icon(
                                //           Icons.more_vert,
                                //           color: Colors.white,
                                //         ),
                                //         itemBuilder: (BuildContext context) =>
                                //             <PopupMenuEntry>[
                                //           const PopupMenuItem(
                                //             child: ListTile(
                                //               leading: Icon(Icons.details),
                                //               title: Text('Voir Details'),
                                //               // onTap: () {
                                //               //  return log('${r['themeDem']}');
                                //               // }
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // );

                              }
                              return SizedBox(
                                height: 0,
                              );
                            }),
                      );
                    } else {
                      // return Center(child: CircularProgressIndicator());
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: 6,
                        itemBuilder: (BuildContext context, int index) {
                          offset += 5;
                          time = 800 + offset;

                          print(time);

                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Shimmer.fromColors(
                                highlightColor: Colors.white,
                                baseColor: Colors.grey[300],
                                child: ShimmerLayout(),
                                period: Duration(milliseconds: time),
                              ));
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 200;
    double containerHeight = 15;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            children: [
              Container(
                height: 15,
                width: 30,
                color: Colors.grey,
                margin: EdgeInsets.only(bottom: 5),
              ),
              Container(
                height: 15,
                width: 30,
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: containerHeight,
                width: containerWidth * 0.26,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth * 0.5,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth * 0.75,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}
