import 'package:bottom_navigation/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:bottom_navigation/constants/Theme.dart';

import 'package:bottom_navigation/widgets/drawer-tile.dart';

class ArgonDrawer extends StatelessWidget {
  final String currentPage;

  ArgonDrawer({this.currentPage});

  _launchURL() async {
    const url = 'https://creative-tim.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: ArgonColors.white,
      child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Image.asset("assets/img/argon-logo.png"),
                ),
              ),
            )),
        Expanded(
          flex: 2,
          child: ListView(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16),
            children: [
              DrawerTile(
                  icon: Icons.home,
                  onTap: () {
                    // if (currentPage != "Home")
                    //   Navigator.pushReplacementNamed(context, '/home');
                  },
                  iconColor: ArgonColors.primary,
                  title: "Home",
                  isSelected: currentPage == "Home" ? true : false),
              DrawerTile(
                  icon: Icons.pie_chart,
                  onTap: () {
                    // if (currentPage != "Profile")
                    //   Navigator.pushReplacementNamed(context, '/profile');
                  },
                  iconColor: ArgonColors.warning,
                  title: "Profile",
                  isSelected: currentPage == "Profile" ? true : false),
              DrawerTile(
                  icon: Icons.account_circle,
                  onTap: () {
                    // if (currentPage != "Account")
                    //   Navigator.pushReplacementNamed(context, '/account');
                  },
                  iconColor: ArgonColors.info,
                  title: "Account",
                  isSelected: currentPage == "Account" ? true : false),
              DrawerTile(
                  icon: Icons.settings_input_component,
                  onTap: () {
                    // if (currentPage != "Elements")
                    //   Navigator.pushReplacementNamed(context, '/elements');
                  },
                  iconColor: ArgonColors.error,
                  title: "Elements",
                  isSelected: currentPage == "Elements" ? true : false),
              DrawerTile(
                  icon: Icons.apps,
                  onTap: () {
                    // if (currentPage != "Articles")
                    //   Navigator.pushReplacementNamed(context, '/articles');
                  },
                  iconColor: ArgonColors.primary,
                  title: "Articles",
                  isSelected: currentPage == "Articles" ? true : false),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.only(left: 8, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 4, thickness: 0, color: ArgonColors.muted),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 16, bottom: 8),
                    child: Text("More",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          fontSize: 15,
                        )),
                  ),
                  DrawerTile(
                      icon: Icons.logout,
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove('token');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                      iconColor: ArgonColors.muted,
                      title: "Log Out",
                      isSelected: currentPage == "Log Out" ? true : false),
                  DrawerTile(
                      icon: Icons.settings,
                      onTap: () {},
                      iconColor: ArgonColors.muted,
                      title: "Settings",
                      isSelected: currentPage == "Settings" ? true : false),
                ],
              )),
        ),
      ]),
    ));
  }
}
