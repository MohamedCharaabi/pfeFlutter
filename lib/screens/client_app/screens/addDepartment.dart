import 'dart:convert';

import 'package:bottom_navigation/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AddDepartment extends StatefulWidget {
  @override
  _AddDepartmentState createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddDepartment> {
  TextEditingController _depController = new TextEditingController();
  _submit(department) async {
    var url = "https://pfe-cims.herokuapp.com/dep"; // iOS

    await http
        .post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'name': department}),
        )
        .then((res) => {
              print(res.body),
              if (res.statusCode == 200)
                {
                  Fluttertoast.showToast(
                      msg: "Department Submitted Succesfully!!",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text(
          'Add Department',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
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
                    child: TextField(
                      controller: _depController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Department name ",
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
                    Fluttertoast.showToast(
                        msg: "          Sending data..          ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey.shade400,
                        textColor: Colors.black,
                        fontSize: 16.0);

                    await _submit(_depController.text);
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
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
