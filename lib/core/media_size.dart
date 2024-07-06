import 'package:flutter/material.dart';

class ScreenSize {
  double screenWidth;
  double screenHeight;

  ScreenSize(BuildContext context)
      : screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
}
