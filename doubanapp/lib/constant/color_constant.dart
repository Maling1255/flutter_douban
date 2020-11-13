
import 'package:flutter/material.dart';
import 'dart:math' as math;
class ColorConstant {

  static const Color colorRed277 = Colors.redAccent;
  static const Color colorDefaultTitle = Color.fromARGB(255, 45, 45, 45);
  static const Color colorOrigin = Color.fromARGB(255, 232, 145, 60);
  static const Color colorDetail = Color.fromARGB(196, 197, 145, 197);
  static const Color ThemeGreen = Color.fromARGB(255, 0, 189, 95);


  static Color randomColor() {
    return Color.fromARGB(
        random(150, 255), random(0, 255), random(0, 255), random(0, 255));
  }

  static int random(int min, int max) {
    final _random = math.Random();
    return min + _random.nextInt(max - min + 1);
  }
}