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

  Piece operator [](int i) {
    switch (i) {
      case 0:
        return line;
      case 1:
        return corner;
      default:
        return line;
    }
  }
}
