import 'dart:convert';
import 'dart:developer';

import 'package:bottom_navigation/constants/formValidation.dart';
import 'package:bottom_navigation/screens/auth/login.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../admin_app_theme.dart';
import '../hexColor.dart';
import 'levels.dart';

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

  int selectedLevel = 0;
  List<Widget> tabs = [
    MyReclamation(),
    AddReclamation(),
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
                                text: 'Mon reclamtions',
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
                                text: 'Reclamer',
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

class MyReclamation extends StatefulWidget {
  // const MyReclamation({ Key? key }) : super(key: key);

  @override
  _MyReclamationState createState() => _MyReclamationState();
}

class _MyReclamationState extends State<MyReclamation> {
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
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: SingleChildScrollView(
        child: FutureBuilder(
            future: getReclamations(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(bottom: 50),
                  height: height,
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
                          leading:
                              CircleAvatar(child: Icon(Icons.info_outline)),
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
                ),
              );
            }),
      ),
    );
  }
}

class AddReclamation extends StatefulWidget {
  // const AddReclamation({ Key? key }) : super(key: key);

  @override
  _AddReclamationState createState() => _AddReclamationState();
}

class _AddReclamationState extends State<AddReclamation> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _contentController = new TextEditingController();
  Map<String, dynamic> userData = {};
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = jsonDecode(prefs.getString("userData"));
    setState(() {
      userData = data;
      // _formData = {
      //   'fullName': data['fullName'],
      //   'password': data['password'],
      //   'avatar': data['avatar'],
      //   'email': data['email']
      // };
    });
  }

  Future submitAlert() async {
    var body = jsonEncode(<String, dynamic>{
      'by': userData['fullName'],
      'content': _contentController.text,
      'title': _titleController.text,
      'avatar': userData['avatar']
    });
    log(body);

    try {
      var result =
          await http.post(Uri.parse('https://pfe-cims.herokuapp.com/alert'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: body);
      log(result.body);

      if (result.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Votre reclamation envoyer!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.shade400,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    log('Errorrr while parsing requests <<check getRequets methode in home >>');
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FadeAnimation(
                    1.2,
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10))
                          ]),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[200]))),
                        child: TextFormField(
                          controller: _titleController,
                          validator: (val) {
                            return standarTextValidation(val, 'titre');
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Titre ",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                FadeAnimation(
                    1.4,
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10))
                          ]),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[200]))),
                        child: TextFormField(
                          controller: _contentController,
                          validator: (val) {
                            return standarTextValidation(val, 'Message');
                          },
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: 6,
                          decoration: InputDecoration(
                              hintMaxLines: 5,
                              hintText: "Message",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                FadeAnimation(
                    1.6,
                    InkWell(
                      onTap: () async {
                        await submitAlert();
                      },
                      child: Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.nearlyDarkBlue,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Center(
                          child: Text('Submit',
                              style: TextStyle(
                                color: Colors.white,
                                backgroundColor: FitnessAppTheme.nearlyDarkBlue,
                              )
                              // Container(
                              //   // padding: EdgeInsets.all(10),
                              //   width: 250,
                              //   height: 70,
                              //   decoration: BoxDecoration(
                              //       color: FitnessAppTheme.nearlyDarkBlue,
                              //       borderRadius: BorderRadius.circular(22),
                              //       // gradient: LinearGradient(
                              //       //     colors: [
                              //       //       FitnessAppTheme.nearlyDarkBlue,
                              //       //       HexColor('#6A88E5'),
                              //       //     ],
                              //       //     begin: Alignment.topLeft,
                              //       //     end: Alignment.bottomRight),

                              //       border: Border(
                              //           bottom: BorderSide(color: Colors.grey[200]))),
                              //   child: ),
                              ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
