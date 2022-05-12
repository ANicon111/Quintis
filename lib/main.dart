import 'package:flutter/material.dart';
import 'package:quintis/board.dart';

void main() {
  runApp(const Quintis());
}

class Quintis extends StatelessWidget {
  const Quintis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Board(
        height: 50,
        width: 50,
        maxSize: 950,
      ),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
    );
  }
}
