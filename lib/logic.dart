import 'dart:async';
import 'dart:math';

import 'package:quintis/pieces.dart';

class Board {
  final int width;
  final int height;
  List<List<int>> board = [];

  Piece nextPiece = Pieces.random();
  int nextPieceRotation = Random().nextInt(4);

  Piece currentPiece = Pieces.random();
  int currentPieceRotation = Random().nextInt(4);
  int pieceX = 0;
  int pieceY = 0;

  Duration frequency = const Duration(milliseconds: 500);
  Timer? gameTimer;
  bool gameOver = false;
  int points = 0;
  final Function updateGui;

  static void _() {}

  //init functions
  Board([this.width = 0, this.height = 0, this.updateGui = _]) {
    start();
    gameTimer = Timer.periodic(frequency, (_) {
      if (board.isNotEmpty) runGameTick();
    });
  }

  void delete() {
    gameTimer?.cancel();
  }

  //piece-related functions
  void setCurrentPiece() {
    setPiece(board, currentPiece, currentPieceRotation, pieceY, pieceX);
  }

  void deleteCurrentPiece() {
    deletePiece(board, currentPiece, currentPieceRotation, pieceY, pieceX);
  }

  void moveCurrentPiece(int relX) {
    deleteCurrentPiece();
    if (isPosValid(
        board, currentPiece, currentPieceRotation, pieceY, pieceX + relX)) {
      pieceX += relX;
    }
    setCurrentPiece();
    updateGui();
  }

  void rotateCurrentPiece() {
    deleteCurrentPiece();
    if (isPosValid(
        board, currentPiece, (currentPieceRotation + 1) % 4, pieceY, pieceX)) {
      currentPieceRotation = (currentPieceRotation + 1) % 4;
    }
    setCurrentPiece();
    updateGui();
  }

  //game-related functions
  void fastForward() {
    while (pieceY != 0) {
      runGameTick();
    }
  }

  void linesToPoints() {
    List<int> completeLines = [];
    if (pieceY + 5 >= height) pieceY = height - 5;
    for (int i = pieceY; i < pieceY + 5; i++) {
      bool isCompleteLine = true;
      for (int j = 0; j < width && isCompleteLine; j++) {
        if (board[i][j] == 0) isCompleteLine = false;
      }
      if (isCompleteLine) completeLines.add(i);
    }
    int lines = completeLines.length;
    points += (100 + width) * ((1 << lines) - 1);
    for (int line in completeLines) {
      board.removeAt(line);
      board = board.reversed.toList();
      board.add(List.generate(width, (_) => 0));
      board = board.reversed.toList();
    }
  }

  void runGameTick() {
    deleteCurrentPiece();
    if (isPosValid(
        board, currentPiece, currentPieceRotation, pieceY + 1, pieceX)) {
      pieceY++;
    } else {
      setCurrentPiece();
      linesToPoints();
      currentPiece = nextPiece;
      currentPieceRotation = nextPieceRotation;
      nextPiece = Pieces.random();
      nextPieceRotation = Random().nextInt(4);
      pieceX = width ~/ 2 - 2;
      pieceY = 0;
    }
    if (isPosValid(board, currentPiece, currentPieceRotation, pieceY, pieceX)) {
      setCurrentPiece();
    } else {
      gameOver = true;
    }
    updateGui();
  }

  void start() {
    board = List.generate(
      height,
      (_) => List.generate(
        width,
        (_) => 0,
      ),
    );
    pieceX = width ~/ 2 - 2;
    points = 0;
    gameOver = false;
    updateGui();
  }
}

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
      if (!(i >= 0 &&
              i < board.length &&
              j >= 0 &&
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
      if (piece[rotation][i][j] != 0) {
        board[i + height][j + width] = piece[rotation][i][j];
      }
    }
  }
}

void deletePiece(
  List<List<int>> board,
  Piece piece,
  int rotation,
  int height,
  int width,
) {
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      if (piece[rotation][i][j] != 0) {
        board[i + height][j + width] = 0;
      }
    }
  }
}
