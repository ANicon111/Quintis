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

List<Color> pieceColors = [
  Colors.grey.shade700,
  Colors.white,
  Colors.yellow.shade700,
  Colors.teal.shade600,
  Colors.purple,
  Colors.red.shade300,
  Colors.red.shade800,
  Colors.green.shade300,
  Colors.green.shade800,
  Colors.blue.shade300,
  Colors.blue.shade800,
];
