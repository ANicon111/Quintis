import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quintis/board.dart';
import 'package:quintis/settings.dart';

void main() async {
  await GetStorage.init("quintis/data");
  GetStorage("quintis/data").writeIfNull("number", "0");
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
          ? const Settings()
          : const Board(
              height: 25,
              width: 25,
              maxSize: 950,
            ),
    );
  }
}
