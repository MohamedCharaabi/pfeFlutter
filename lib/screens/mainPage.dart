import 'package:bottom_navigation/colors.dart';
import 'package:bottom_navigation/screens/Statistics.dart';
import 'package:bottom_navigation/screens/Home.dart';
import 'package:bottom_navigation/screens/Settings.dart';
import 'package:bottom_navigation/screens/Themes.dart';
import 'package:bottom_navigation/widgets/drawer.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  List<Widget> screens = [Home(), Themes(), Statistics(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ArgonDrawer(),
      body: screens[currentIndex],
      bottomNavigationBar:
          Consumer<ColorProvider>(builder: (context, provider, child) {
        return ConvexAppBar.badge(
          {3: provider.colorCount == 0 ? null : provider.colorCount.toString()},
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.map, title: 'Theme'),
            TabItem(icon: Icons.format_list_numbered, title: 'Statistics'),
            TabItem(icon: Icons.settings_applications, title: 'Settings'),
          ],
          initialActiveIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        );
      }),
    );
  }
}
