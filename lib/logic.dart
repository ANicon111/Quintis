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

  bool newPiece = true;

  int pieceX = 0;
  int pieceY = 0;

  Duration frequency = const Duration(milliseconds: 1000);
  Timer? gameTimer;
  Stopwatch elapsedTime = Stopwatch();
  bool gameOver = false;
  double points = 0;
  int difficulty = 5;
  final Function updateGui;

  static void _() {}

  //init functions
  Board([this.width = 0, this.height = 0, this.updateGui = _]) {
    start();
  }

  void delete() {
    gameTimer?.cancel();
    elapsedTime.stop();
  }

  //piece-related functions
  bool isNewPiece() {
    if (newPiece) {
      newPiece = false;
      return true;
    }
    return false;
  }

  void setCurrentPiece() {
    setPiece(board, currentPiece, currentPieceRotation, pieceY, pieceX);
  }

  void deleteCurrentPiece() {
    deletePiece(board, currentPiece, currentPieceRotation, pieceY, pieceX);
  }

  void moveCurrentPiece(int relX) {
    if (!gameOver) {
      deleteCurrentPiece();
      while (isPosValid(board, currentPiece, currentPieceRotation, pieceY,
              pieceX + relX.sign) &&
          relX != 0) {
        pieceX += relX.sign;
        relX -= relX.sign;
      }
      playerInteraction();
    }
  }

  void rotateCurrentPiece() {
    if (!gameOver) {
      deleteCurrentPiece();
      if (isPosValid(board, currentPiece, (currentPieceRotation + 1) % 4,
          pieceY, pieceX)) {
        currentPieceRotation = (currentPieceRotation + 1) % 4;
      }
      playerInteraction();
    }
  }

  //game-related functions

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
    difficulty = 5;
    runTimer();
    updateGui();
  }

  void runTimer() {
    elapsedTime.reset();
    elapsedTime.start();
    gameTimer?.cancel();
    gameTimer = Timer(frequency, () {
      if (board.isNotEmpty) runGameTick();
      runTimer();
    });
  }

  void pauseTimer() {
    gameTimer?.cancel();
    if (elapsedTime.elapsed < frequency * 2) {
      gameTimer = Timer(frequency, () {
        if (board.isNotEmpty) runGameTick();
        runTimer();
      });
    } else {
      if (board.isNotEmpty) runGameTick();
      runTimer();
    }
  }

  void playerInteraction() {
    pauseTimer();
    setCurrentPiece();
    updateGui();
  }

  void fastForward() {
    if (!gameOver) {
      while (!isNewPiece()) {
        runGameTick();
      }
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
    points += (100 + width) * ((1 << lines) - 1) * difficulty;
    if (lines > 0 && difficulty < height * 10) {
      difficulty++;
      frequency = Duration(milliseconds: 5000 ~/ difficulty);
    }
    for (int line in completeLines) {
      board.removeAt(line);
      board = board.reversed.toList();
      board.add(List.generate(width, (_) => 0));
      board = board.reversed.toList();
    }
  }

  void runGameTick() {
    if (!gameOver) {
      deleteCurrentPiece();
      if (isPosValid(
          board, currentPiece, currentPieceRotation, pieceY + 1, pieceX)) {
        pieceY++;
        newPiece = false;
      } else {
        setCurrentPiece();
        linesToPoints();
        currentPiece = nextPiece;
        currentPieceRotation = nextPieceRotation;
        nextPiece = Pieces.random();
        nextPieceRotation = Random().nextInt(4);
        pieceX = width ~/ 2 - 2;
        pieceY = 0;
        newPiece = true;
      }
      if (isPosValid(
          board, currentPiece, currentPieceRotation, pieceY, pieceX)) {
        setCurrentPiece();
      } else {
        gameTimer?.cancel();
        gameOver = true;
      }
      updateGui();
    }
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
