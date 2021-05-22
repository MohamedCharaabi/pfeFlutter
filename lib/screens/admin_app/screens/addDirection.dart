import 'dart:convert';
import 'dart:developer';

import 'package:bottom_navigation/screens/admin_app/models/Department.dart';
import 'package:bottom_navigation/screens/auth/login.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AddDirection extends StatefulWidget {
  @override
  _AddDirectionState createState() => _AddDirectionState();
}

class _AddDirectionState extends State<AddDirection> {
  TextEditingController _dirController = new TextEditingController();
  Map<String, String> _formData = {'name': '', 'dep_name': ''};
  bool isLoading = true;
  String _selectDep = '';
  List<String> departments = [];

  _submit(name, selectedDep) async {
    var url = "https://pfe-cims.herokuapp.com/dir"; // iOS

    await http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(
                <String, String>{'name': name, 'dep_name': selectedDep}))
        .then((res) => {
              print(' res ><<<>>>>>>> ${res.body}'),
              if (res.statusCode == 200)
                {
                  Fluttertoast.showToast(
                      msg: "Direction Submitted Succesfully!!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey.shade400,
                      textColor: Colors.white,
                      fontSize: 16.0)
                }
            })
        .catchError((err) => {
              Fluttertoast.showToast(
                  msg: "Error $err",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0)
            });
  }

  Future<String> getDeps() async {
    final response =
        await http.get(Uri.parse('https://pfe-cims.herokuapp.com/dep'));

    if (response.statusCode == 200) {
      List<String> deps = [];

      var result = json.decode(response.body);

      for (var dep in result) {
        // deps.add(Department.fromJson(dep));
        deps.add(dep['name']);
      }
      log(' deps ===> $deps');
      setState(() {
        departments = deps;
        isLoading = false;
      });

      return 'success';
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.

      throw Exception('Failed to load departments');
    }
  }

  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(value);
        });
  }

  _getDslDecoration() {
    return BoxDecoration(
      border: BorderDirectional(
        bottom: BorderSide(width: 1, color: Colors.black12),
        top: BorderSide(width: 1, color: Colors.black12),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getDeps();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text(
          'Add Direction',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : DirectSelectContainer(
              child: Container(
                height: height,
                width: width,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
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
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextField(
                                  controller: _dirController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "Direction name ",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Card(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                        child: DirectSelectList<String>(
                                            values: departments,
                                            defaultItemIndex: 3,
                                            itemBuilder: (String value) =>
                                                getDropDownMenuItem(value),
                                            focusedItemDecoration:
                                                _getDslDecoration(),
                                            onItemSelectedListener:
                                                (item, index, context) {
                                              _selectDep = item;
                                            }),
                                        padding: EdgeInsets.only(left: 12))),
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.unfold_more,
                                    color: Colors.black38,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                            1.6,
                            InkWell(
                              onTap: () async {
                                Fluttertoast.showToast(
                                    msg: "          Sending data..          ",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey.shade400,
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                                // log('formData ===> $_formData');
                                await _submit(_dirController.text, _selectDep);
                              },
                              child: Container(
                                height: 50,
                                // margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orange[900]),
                                child: Center(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
