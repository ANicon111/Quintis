import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quintis/cell.dart';
import 'package:quintis/definitions.dart';
import 'package:quintis/logic.dart';

class BoardGui extends StatefulWidget {
  final int height;
  final int width;
  final double maxSize;
  const BoardGui({
    Key? key,
    required this.height,
    required this.width,
    required this.maxSize,
  }) : super(key: key);

  @override
  State<BoardGui> createState() => _BoardGuiState();
}

class _BoardGuiState extends State<BoardGui> {
  Board board = Board();
  FocusNode node = FocusNode();
  int movement = 0;
  Timer? horizontalTimer;

  @override
  void initState() {
    super.initState();
    board = Board(widget.width, widget.height, () {
      setState(() {});
    });
    horizontalTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (movement != 0) board.moveCurrentPiece(movement);
    });
  }

  @override
  void dispose() {
    node.dispose();
    board.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    node.requestFocus();
    return Stack(
      children: [
        Center(
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.distance > 2 * RelSize(context).pixel()) {
                movement = details.delta.direction > 0 ? -1 : 1;
              } else {
                movement = 0;
              }
            },
            onHorizontalDragEnd: (_) {
              movement = 0;
            },
            onVerticalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.distance >
                  4 * RelSize(context).pixel()) {
                board.fastForward();
              }
            },
            onTap: () {
              board.rotateCurrentPiece();
            },
            child: RawKeyboardListener(
              focusNode: node,
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.space)) {
                  board.fastForward();
                }
                if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                  movement = -1;
                } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                  movement = 1;
                } else {
                  movement = 0;
                }
                if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                  board.rotateCurrentPiece();
                }
                if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                  board.runGameTick();
                  board.runTimer();
                }
              },
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      widget.height,
                      (i) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          widget.width,
                          (j) => Cell(
                            color: pieceColors[board.board[i][j]],
                            size: widget.maxSize /
                                (widget.height > widget.width
                                    ? widget.height
                                    : widget.width),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: board.gameOver
                        ? null
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Next piece:",
                                style: TextStyle(
                                    fontSize: 64 * RelSize(context).pixel()),
                              ),
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    5,
                                    (j) => Column(
                                      children: List.generate(
                                          5,
                                          (k) => Cell(
                                              color: pieceColors[board
                                                          .nextPiece[
                                                      board.nextPieceRotation]
                                                  [k][j]],
                                              size: 25 *
                                                  RelSize(context).pixel())),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 100 * RelSize(context).pixel(),
                              ),
                              Text(
                                "Score: " + board.points.toString(),
                                style: TextStyle(
                                    fontSize: 64 * RelSize(context).pixel()),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        board.gameOver
            ? Center(
                child: Ink(
                  width: 1000 * RelSize(context).pixel(),
                  height: 1000 * RelSize(context).pixel(),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(200),
                    borderRadius:
                        BorderRadius.circular(10 * RelSize(context).pixel()),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Game over",
                        style:
                            TextStyle(fontSize: 160 * RelSize(context).pixel()),
                      ),
                      Text(
                        "Score: " + board.points.toString(),
                        style:
                            TextStyle(fontSize: 64 * RelSize(context).pixel()),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.all(
                          100 * RelSize(context).pixel(),
                        ),
                        child: Ink(
                          height: 100 * RelSize(context).pixel(),
                          width: 400 * RelSize(context).pixel(),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.shade400,
                            borderRadius: BorderRadius.circular(
                              10 * RelSize(context).pixel(),
                            ),
                          ),
                          child: InkWell(
                            child: Center(
                              child: Text(
                                "Restart",
                                style: TextStyle(
                                  fontSize: 60 * RelSize(context).pixel(),
                                ),
                              ),
                            ),
                            onTap: () {
                              board.start();
                            },
                            hoverColor: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(
                              10 * RelSize(context).pixel(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
