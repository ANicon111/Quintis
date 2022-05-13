import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quintis/definitions.dart';
import 'package:quintis/logic.dart';

class Cell extends StatefulWidget {
  final Color color;
  final double size;
  const Cell({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.size * 0.02),
      child: Container(
        width: widget.size * 0.8,
        height: widget.size * 0.8,
        decoration: BoxDecoration(
          color: widget.color,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade800,
              width: widget.size * 0.08,
            ),
            right: BorderSide(
              color: Colors.grey.shade800,
              width: widget.size * 0.08,
            ),
            top: BorderSide(
              color: Colors.grey.shade600,
              width: widget.size * 0.08,
            ),
            left: BorderSide(
              color: Colors.grey.shade600,
              width: widget.size * 0.08,
            ),
          ),
        ),
      ),
    );
  }
}

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

  @override
  void initState() {
    board = Board(widget.width, widget.height, () {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    node.dispose();
    board.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (board.gameOver) board.start();
    node.requestFocus();
    return Center(
      child: RawKeyboardListener(
        focusNode: node,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.space)) {
            board.fastForward();
          }
          if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            board.moveCurrentPiece(-1);
          }
          if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            board.moveCurrentPiece(1);
          }
          if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
            board.rotateCurrentPiece();
          }
          if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
            board.runGameTick();
          }
        },
        child: ListView(
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
                      size: 1 *
                          widget.maxSize *
                          RelSize(context).pixel() /
                          (widget.height > widget.width
                              ? widget.height
                              : widget.width),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Next piece:",
                    style: TextStyle(fontSize: 64 * RelSize(context).pixel()),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    width: 135 * RelSize(context).pixel(),
                    height: 135 * RelSize(context).pixel(),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (j) => Column(
                            children: List.generate(
                              5,
                              (k) => Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                        2 * RelSize(context).pixel()),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: board.nextPiece[board
                                                    .nextPieceRotation][k][j] ==
                                                0
                                            ? null
                                            : pieceColors[board.nextPiece[
                                                board.nextPieceRotation][k][j]],
                                      ),
                                      height: 20 * RelSize(context).pixel(),
                                      width: 20 * RelSize(context).pixel(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100 * RelSize(context).pixel(),
                  ),
                  Text(
                    "Score: " + board.points.toString(),
                    style: TextStyle(fontSize: 64 * RelSize(context).pixel()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
