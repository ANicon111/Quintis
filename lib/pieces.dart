import 'dart:math';

import 'package:get_storage/get_storage.dart';

class Piece {
  bool initd = false;
  List<List<int>> _deg90 = [];
  List<List<int>> _deg180 = [];
  List<List<int>> _deg270 = [];
  final List<List<int>> shape;
  Piece(this.shape);

  List<List<int>> operator [](int rotation) {
    if (!initd) {
      _deg90 =
          List.generate(5, ((i) => List.generate(5, ((j) => shape[4 - j][i]))));
      _deg180 = List.generate(
          5, ((i) => List.generate(5, ((j) => shape[4 - i][4 - j]))));
      _deg270 =
          List.generate(5, ((i) => List.generate(5, ((j) => shape[j][4 - i]))));
    }
    switch (rotation) {
      case 0:
        return shape;
      case 1:
        return _deg90;
      case 2:
        return _deg180;
      case 3:
        return _deg270;

      default:
        return shape;
    }
  }

  void addToStorage() {
    String value = "";
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        value += shape[i][j].toString();
      }
    }
    GetStorage("quintis/data")
        .write((GetStorage("quintis/data").read("number")), value);
    GetStorage("quintis/data").write("number",
        (int.parse(GetStorage("quintis/data").read("number")) + 1).toString());
  }

  static Piece getFromStorage(int i) {
    String value = GetStorage("quintis/data").read(i.toString());
    Piece piece =
        Piece(List.generate(5, ((_) => List.generate(5, ((_) => 0)))));
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        piece.shape[i][j] = int.parse(value[i * 5 + j]);
      }
    }
    return piece;
  }
}

class Pieces {
  static Piece line = Piece(
    [
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
    ],
  );
  static Piece corner = Piece(
    [
      [0, 0, 0, 0, 0],
      [0, 2, 2, 2, 0],
      [0, 2, 0, 0, 0],
      [0, 2, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
  );
  static Piece u = Piece(
    [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 3, 0, 3, 0],
      [0, 3, 3, 3, 0],
      [0, 0, 0, 0, 0],
    ],
  );

  static Piece t = Piece(
    [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 4, 4, 4, 0],
      [0, 0, 4, 0, 0],
      [0, 0, 4, 0, 0],
    ],
  );

  static Piece b = Piece(
    [
      [0, 0, 0, 0, 0],
      [0, 0, 5, 0, 0],
      [0, 0, 5, 5, 0],
      [0, 0, 5, 5, 0],
      [0, 0, 0, 0, 0],
    ],
  );

  static Piece reverseb = Piece(
    [
      [0, 0, 0, 0, 0],
      [0, 0, 6, 0, 0],
      [0, 6, 6, 0, 0],
      [0, 6, 6, 0, 0],
      [0, 0, 0, 0, 0],
    ],
  );

  static Piece l = Piece(
    [
      [0, 0, 7, 0, 0],
      [0, 0, 7, 0, 0],
      [0, 0, 7, 0, 0],
      [0, 0, 7, 7, 0],
      [0, 0, 0, 0, 0],
    ],
  );

  static Piece reversel = Piece(
    [
      [0, 0, 8, 0, 0],
      [0, 0, 8, 0, 0],
      [0, 0, 8, 0, 0],
      [0, 8, 8, 0, 0],
      [0, 0, 0, 0, 0],
    ],
  );

  static Piece key = Piece(
    [
      [0, 0, 9, 0, 0],
      [0, 0, 9, 0, 0],
      [0, 0, 9, 9, 0],
      [0, 0, 9, 0, 0],
      [0, 0, 0, 0, 0],
    ],
  );

  static Piece reversekey = Piece(
    [
      [0, 0, 10, 0, 0],
      [0, 0, 10, 0, 0],
      [0, 0, 10, 10, 0],
      [0, 0, 10, 0, 0],
      [0, 0, 0, 0, 0],
    ],
  );

  static Piece index(int i) {
    switch (i) {
      case 0:
        return line;
      case 1:
        return corner;
      case 2:
        return u;
      case 3:
        return t;
      case 4:
        return b;
      case 5:
        return reverseb;
      case 6:
        return l;
      case 7:
        return reversel;
      case 8:
        return key;
      case 9:
        return reversekey;
      default:
        return Piece.getFromStorage(i - 10);
    }
  }

  static void removeFromStorage(int i) {
    int n = int.parse(GetStorage("quintis/data").read("number"));
    n--;
    GetStorage("quintis/data").write("number", n.toString());
    while (i < n) {
      String next = (GetStorage("quintis/data").read((i + 1).toString()));
      GetStorage("quintis/data").write(i.toString(), next);
      i++;
    }
    GetStorage("quintis/data").remove(i.toString());
  }

  static void disable(int i) {
    String oldList = GetStorage("quintis/data").read("enabled");
    String list = oldList.substring(0, i) + "0" + oldList.substring(i + 1, 20);
    GetStorage("quintis/data").write("enabled", list);
  }

  static void enable(int i) {
    String oldList = GetStorage("quintis/data").read("enabled");
    String list = oldList.substring(0, i) + "1" + oldList.substring(i + 1, 20);
    GetStorage("quintis/data").write("enabled", list);
  }

  static bool isEnabled(int i) {
    String list = GetStorage("quintis/data").read("enabled");
    return list[i] == "1";
  }

  static List<int> getEnabledList() {
    List<int> enabled = [];
    String list = GetStorage("quintis/data").read("enabled");
    int number = int.parse(GetStorage("quintis/data").read("number")) + 10;
    for (int i = 0; i < number; i++) {
      if (list[i] == "1") {
        enabled.add(i);
      }
    }
    return enabled;
  }

  static Piece random() {
    List<int> enabled = getEnabledList();
    return index(enabled[Random().nextInt(enabled.length)]);
  }

  //de implementat dezactivare pieselor
}
