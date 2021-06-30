import 'dart:convert';
import 'dart:developer';
import 'dart:io' as Io;

import 'package:bottom_navigation/screens/admin_app/admin_app_theme.dart';
import 'package:bottom_navigation/screens/admin_app/hexColor.dart';
import 'package:bottom_navigation/screens/auth/login.dart';
import 'package:bottom_navigation/widgets/custom_drawer/drawer_theme.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _dark;
  TextEditingController _fullNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  Map<String, dynamic> _formData = {};
  Map<String, dynamic> userData = {};
  // File _avatar;
  final picker = ImagePicker();
  final cloudinary = CloudinaryPublic('isetz', 'default', cache: false);

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = jsonDecode(prefs.getString("userData"));
    setState(() {
      userData = data;
      _formData = {
        'fullName': data['fullName'],
        'password': data['password'],
        'avatar': data['avatar'],
        'email': data['email']
      };
    });
  }

  submitForm(id) async {
    var url = "https://pfe-cims.herokuapp.com/new/$id"; // iOS

    await http
        .patch(
          Uri.parse(url),
          body: _formData,
        )
        .then((res) => {
              print(res.body),
              if (res.statusCode == 200)
                {
                  Fluttertoast.showToast(
                      msg: "Your Profile Submitted Succesfully!!",
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

  Future<String> submitAvatar(id, avatar) async {
    var url = "https://pfe-cims.herokuapp.com/new/editavatar/$id"; // iOS
    try {
      await http.patch(
        Uri.parse(url),
        body: {'avatar': avatar},
      ).then((res) => {
            log('avatr submit resp ===> ${res.body}'),
            if (res.statusCode == 200)
              {
                Fluttertoast.showToast(
                    msg: "Your Profile Picture Submitted Succesfully!!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey.shade400,
                    textColor: Colors.white,
                    fontSize: 16.0)
              }
          });
      return 'Success';
    } catch (err) {
      Fluttertoast.showToast(
          msg: "Error $err",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return 'fail';
    }
  }

  Future changeImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedFile.path,
              resourceType: CloudinaryResourceType.Image),
        );

        String result = await submitAvatar(userData['_id'], response.secureUrl);

        log('response ==> $response');
        if (result == 'Success') {
          setState(() {
            userData['_avatar'] = response.secureUrl;
          });
        }
      } on CloudinaryException catch (e) {
        log('error ==> ${e.message}');
        log('${e.request}');
      }
    } else {
      log('No image selected.');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    _dark = false;
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Theme(
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: _dark ? null : Colors.grey.shade200,
        appBar: AppBar(
          elevation: 1,
          brightness: _getBrightness(),
          iconTheme: IconThemeData(color: _dark ? Colors.white : Colors.black),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            'Profile',
            style: TextStyle(color: _dark ? Colors.white : Colors.black),
          ),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(FontAwesomeIcons.moon),
            //   onPressed: () {
            //     setState(() {
            //       _dark = !_dark;
            //     });
            //   },
            // )
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.purple,
                    child: ListTile(
                        title: Text(
                          userData['fullName'] ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        leading: InkWell(
                          onTap: () async {
                            await changeImage();
                          },
                          child: CircleAvatar(
                            backgroundImage: userData['avatar'] != null
                                ? NetworkImage(userData['avatar'])
                                : AssetImage(
                                    'assets/images/userImage.png',
                                  ),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    editUserDialog(height, width));
                          },
                        )),
                  ),
                  const SizedBox(height: 10.0),
                  // Card(
                  //   elevation: 4.0,
                  //   margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10.0)),
                  //   child: Column(
                  //     children: <Widget>[
                  //       ListTile(
                  //         leading: Icon(
                  //           Icons.lock_outline,
                  //           color: Colors.purple,
                  //         ),
                  //         title: Text("Changer mot de passe"),
                  //         trailing: Icon(Icons.keyboard_arrow_right),
                  //         onTap: () {
                  //           //open change password
                  //           showDialog(
                  //               context: context,
                  //               builder: (context) => AlertDialog(
                  //                     title: new Text("My Super title"),
                  //                     content: new Text("Hello World"),
                  //                   ));
                  //         },
                  //       ),
                  //       _buildDivider(),
                  //       ListTile(
                  //         leading: Icon(
                  //           FontAwesomeIcons.mailBulk,
                  //           color: Colors.purple,
                  //         ),
                  //         title: Text("Changer Email"),
                  //         trailing: Icon(Icons.keyboard_arrow_right),
                  //         onTap: () {
                  //           //open change language
                  //           showDialog(
                  //               context: context,
                  //               builder: (context) => AlertDialog(
                  //                     title: new Text("My Super title"),
                  //                     content: new Text("Hello World"),
                  //                   ));
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 20.0),
                  // Text(
                  //   "Notification Settings",
                  //   style: TextStyle(
                  //     fontSize: 20.0,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.indigo,
                  //   ),
                  // ),
                  // SwitchListTile(
                  //   activeColor: Colors.purple,
                  //   contentPadding: const EdgeInsets.all(0),
                  //   value: true,
                  //   title: Text("Received notification"),
                  //   onChanged: (val) {},
                  // ),
                  // const SizedBox(height: 60.0),
                ],
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 00,
              left: 00,
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.powerOff,
                  color: Colors.white,
                ),
                onPressed: () {
                  //log out
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }

  editUserDialog(double height, double width) {
    _fullNameController.text = '';
    _emailController.text = '';
    _passwordController.text = '';
    return Dialog(
      // backgroundColor: Colors.transparent,
      elevation: 1.5,
      insetPadding:
          EdgeInsets.symmetric(vertical: height * 0.15, horizontal: 5),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Container(
              height: 350,
              width: width,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    fadeInput(
                        'fullName', _fullNameController, TextInputType.text),
                    SizedBox(height: 10.0),
                    fadeInput(
                        'email', _emailController, TextInputType.emailAddress),
                    SizedBox(height: 10.0),
                    fadeInput('password', _passwordController,
                        TextInputType.visiblePassword),
                    SizedBox(height: 20.0),
                    FadeAnimation(
                      2,
                      InkWell(
                          onTap: () {
                            log('formData == > $_formData');
                            submitForm(userData['_id']);
                          },
                          child: Container(
                            width: width * 0.8,
                            decoration: BoxDecoration(
                                color: FitnessAppTheme.nearlyDarkBlue,
                                gradient: LinearGradient(
                                    colors: [
                                      FitnessAppTheme.nearlyDarkBlue,
                                      HexColor('#6A88E5'),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Container(
                              height: 55,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: Center(
                                child: Text('Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  FadeAnimation fadeInput(String data, TextEditingController editController,
      TextInputType keyboardType) {
    return FadeAnimation(
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
                border: Border(bottom: BorderSide(color: Colors.grey[200]))),
            child: TextField(
              controller: editController,
              keyboardType: keyboardType,
              onChanged: (val) => _formData = {..._formData, data: val},
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                  hintText: "${userData[data]}",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
            ),
          ),
        ));
  }
}
