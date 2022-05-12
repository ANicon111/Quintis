import 'package:flutter/material.dart';

class RelSize {
  final BuildContext context;
  RelSize(this.context);
  double vmin() {
    return MediaQuery.of(context).size.shortestSide / 100;
  }

  double vmax() {
    return MediaQuery.of(context).size.longestSide / 100;
  }

  double pixel() {
    return MediaQuery.of(context).size.shortestSide / 1080;
  }
}
