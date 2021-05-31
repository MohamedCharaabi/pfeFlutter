import 'dart:convert';
import 'dart:developer';
import 'package:bottom_navigation/constants/formValidation.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:bottom_navigation/screens/admin_app/models/Department.dart';
import 'package:bottom_navigation/screens/auth/login.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class AddDivision extends StatefulWidget {
  @override
  _AddDivisionState createState() => _AddDivisionState();
}

class _AddDivisionState extends State<AddDivision> {
  TextEditingController _divController = new TextEditingController();
  Map<String, String> _formData = {'name': '', 'dep_name': ''};
  bool isLoading = true;
  String _selectDep = '';
  List<String> fetchDepartments = [];
  List<String> fetchDirections = [];
  ButtonState buttonState = ButtonState.idle;
  final _formKey = GlobalKey<FormState>();
  _submit(name, selectedDep) async {
    var url = "https://pfe-cims.herokuapp.com/dir"; // iOS

    try {
      var result = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{'name': name, 'dep_name': selectedDep}));
      log(result.body);
      if (result.statusCode == 200) {
        setState(() {
          buttonState = ButtonState.success;
        });
      } else {
        log('result code ==>  ${result.statusCode}');
        setState(() {
          buttonState = ButtonState.fail;
        });
        Fluttertoast.showToast(
            msg: "Error ===> ${json.decode(result.body)['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.shade400,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      setState(() {
        buttonState = ButtonState.fail;
      });
      Fluttertoast.showToast(
          msg: "Error ==> $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey.shade400,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<String> getDeps() async {
    final response =
        await http.get(Uri.parse('https://pfe-cims.herokuapp.com/all'));

    if (response.statusCode == 200) {
      List<String> deps = [];
      List<String> dirs = [];

      var departments = json.decode(response.body)['departments'];
      var directions = json.decode(response.body)['directions'];

      for (var dep in departments) {
        // deps.add(Department.fromJson(dep));
        deps.add(dep['name']);
      }
      for (var dir in directions) {
        // deps.add(Department.fromJson(dir));
        dirs.add(dir['name']);
      }
      log(' deps ===> $deps');
      setState(() {
        fetchDepartments = deps;
        fetchDirections = dirs;
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
      resizeToAvoidBottomInset: false,
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
            'Ajout Division',
            style: TextStyle(color: Colors.black),
          ),
        ),
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
                                          color:
                                              Color.fromRGBO(225, 95, 27, .3),
                                          blurRadius: 20,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]))),
                                  child: TextFormField(
                                    controller: _divController,
                                    validator: (val) {
                                      return standarTextValidation(
                                          val, 'Division name');
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: "Division name ",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            1.4,
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(225, 95, 27, .3),
                                          blurRadius: 20,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      height: 60,
                                      width: width * 0.75,
                                      child: Padding(
                                        child: DirectSelectList<String>(
                                            values: fetchDepartments,
                                            defaultItemIndex: 0,
                                            itemBuilder: (String value) =>
                                                getDropDownMenuItem(value),
                                            focusedItemDecoration:
                                                _getDslDecoration(),
                                            onItemSelectedListener:
                                                (item, index, context) {
                                              _selectDep = item;
                                            }),
                                        padding: EdgeInsets.only(left: 12),
                                      ),
                                    ),
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
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            1.6,
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(225, 95, 27, .3),
                                          blurRadius: 20,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        child: DirectSelectList<String>(
                                            values: fetchDirections,
                                            defaultItemIndex: 0,
                                            itemBuilder: (String value) =>
                                                getDropDownMenuItem(value),
                                            focusedItemDecoration:
                                                _getDslDecoration(),
                                            onItemSelectedListener:
                                                (item, index, context) {
                                              _selectDep = item;
                                            }),
                                        padding: EdgeInsets.only(left: 12),
                                      ),
                                    ),
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
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            1.8,
                            ProgressButton.icon(
                              iconedButtons: {
                                ButtonState.idle: IconedButton(
                                    text: "Send",
                                    icon: Icon(Icons.send, color: Colors.white),
                                    color: Colors.deepPurple.shade500),
                                ButtonState.loading: IconedButton(
                                    text: "Loading",
                                    color: Colors.deepPurple.shade700),
                                ButtonState.fail: IconedButton(
                                    text: "Failed",
                                    icon:
                                        Icon(Icons.cancel, color: Colors.white),
                                    color: Colors.red.shade300),
                                ButtonState.success: IconedButton(
                                    text: "Success",
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    color: Colors.green.shade400)
                              },
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    buttonState = ButtonState.loading;
                                  });
                                  await _submit(
                                      _divController.text, _selectDep);
                                }
                              },
                              state: buttonState,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
