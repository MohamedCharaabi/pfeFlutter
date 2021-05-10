import 'package:flutter/material.dart';

class ColorProvider with ChangeNotifier {
  int colorCount = 0;

  void colorHandleClick(int index) {
    colorCount = index;
    notifyListeners();
  }
}
