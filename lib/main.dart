import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quintis/board.dart';
import 'package:quintis/settings.dart';

import 'definitions.dart';

void main() async {
  await GetStorage.init("quintis/data");
  GetStorage("quintis/data").writeIfNull("number", "0");
  GetStorage("quintis/data").writeIfNull("enabled", "1" * 20);
  runApp(const Quintis());
}

class Quintis extends StatelessWidget {
  const Quintis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Pages(),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
    );
  }
}

class Pages extends StatefulWidget {
  const Pages({Key? key}) : super(key: key);

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  bool settingsOpen = false;
  int width = 25;

  int height = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quintis"),
        actions: [
          IconButton(
            icon: Icon(settingsOpen ? Icons.close : Icons.settings_rounded),
            onPressed: () {
              setState(() {
                settingsOpen = !settingsOpen;
              });
            },
          ),
        ],
      ),
      body: settingsOpen
          ? Settings(
              setWidth: (int width) => this.width = width,
              setHeight: (int height) => this.height = height,
              getWidth: () => width,
              getHeight: () => height,
            )
          : BoardGui(
              height: height,
              width: width,
              maxSize: 1000 * RelSize(context).pixel() -
                  AppBar().preferredSize.height,
            ),
    );
  }
}
