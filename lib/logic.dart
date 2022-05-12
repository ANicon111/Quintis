import 'package:quintis/pieces.dart';

bool isPosValid(
  List<List<int>> board,
  Piece piece,
  int rotation,
  int height,
  int width,
) {
  //verifica daca piesa intra pe tabla si daca nu se suprapune cu o piesa existenta
  for (int i = height; i < height + 5; i++) {
    for (int j = width; j < width + 5; j++) {
      if (!(i > 0 &&
              i < board.length &&
              j > 0 &&
              j < board[0].length &&
              board[i][j] == 0 ||
          piece[rotation][i - height][j - width] == 0)) return false;
    }
  }
  return true;
}

void setPiece(
  List<List<int>> board,
  Piece piece,
  int rotation,
  int height,
  int width,
) {
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      if (i + height >= 0 && j + width >= 0 && piece[rotation][i][j] != 0) {
        board[i + height][j + width] = piece[rotation][i][j];
      }
    }
  }
}
