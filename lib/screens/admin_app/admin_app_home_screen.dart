import 'package:bottom_navigation/screens/admin_app/models/tabIcon_data.dart';
import 'package:bottom_navigation/screens/admin_app/screens/Home.dart';
import 'package:bottom_navigation/screens/admin_app/screens/Settings.dart';
import 'package:bottom_navigation/screens/admin_app/screens/Statistics.dart';
import 'package:bottom_navigation/widgets/custom_drawer/drawer_user_controller.dart';
import 'package:bottom_navigation/widgets/custom_drawer/home_drawer.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'admin_app_theme.dart';

class AdminAppHomeScreen extends StatefulWidget {
  @override
  _AdminAppHomeScreenState createState() => _AdminAppHomeScreenState();
}

class _AdminAppHomeScreenState extends State<AdminAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

//drawer
  Widget screenView;
  DrawerIndex drawerIndex;

  // @override
  // void initState() {

  //   super.initState();
  // }

  //

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  // Widget tabBody = Container(
  //   color: FitnessAppTheme.background,
  // );

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = Statistics();

    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    // tabBody = Statistics();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  DrawerUserController(
                    screenIndex: drawerIndex,
                    drawerWidth: MediaQuery.of(context).size.width * 0.75,
                    onDrawerCall: (DrawerIndex drawerIndexdata) {
                      changeIndex(drawerIndexdata);
                      //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
                    },
                    screenView: screenView,
                    //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
                  ),
                  // tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            switch (index) {
              case 0:
                animationController.reverse().then<dynamic>((data) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    screenView = Statistics();
                  });
                });
                break;

              case 1:
                animationController.reverse().then<dynamic>((data) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    screenView = Home();
                  });
                });
                break;

              case 2:
                animationController.reverse().then<dynamic>((data) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    screenView = Settings();
                  });
                });
                break;

              case 3:
                animationController.reverse().then<dynamic>((data) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    screenView = Settings();
                  });
                });
                break;
            }

            // if (index == 0) {
            //    animationController.reverse().then<dynamic>((data) {
            //     if (!mounted) {
            //       return;
            //     }
            //     setState(() {
            //       tabBody = Statistics();
            //     });
            //   });
            // } else if (index == 1 || index == 3) {
            //   animationController.reverse().then<dynamic>((data) {
            //     if (!mounted) {
            //       return;
            //     }
            //     setState(() {
            //       tabBody = Home();
            //     });
            //   });
            // }
          },
        ),
      ],
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = Home();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = Statistics();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = Settings();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = Settings();
        });
      } else {
        //do in your way......
      }
    }
  }
}
