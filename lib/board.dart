import 'package:flutter/material.dart';
import 'package:quintis/definitions.dart';
import 'package:quintis/logic.dart';
import 'package:quintis/pieces.dart';

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
            )),
      ),
    );
  }
}

class Board extends StatefulWidget {
  final int height;
  final int width;
  final double maxSize;
  const Board({
    Key? key,
    required this.height,
    required this.width,
    required this.maxSize,
  }) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final List<Color> pieceColors = [
    Colors.grey,
    Colors.red,
    Colors.green.shade700,
    Colors.blue,
    Colors.yellow,
    Colors.white,
  ];

  List<List<int>>? pieces;

  @override
  void initState() {
    pieces = List.generate(
      widget.height,
      (_) => List.generate(
        widget.width,
        (_) => 0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setPiece(pieces!, Pieces.line, 0, 0, -2);
    setPiece(pieces!, Pieces.corner, 0, 5, 5);
    setPiece(pieces!, Pieces.corner, 1, 5, 10);
    setPiece(pieces!, Pieces.corner, 2, 5, 15);
    setPiece(pieces!, Pieces.corner, 3, 5, 20);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: widget.maxSize * RelSize(context).pixel(),
              width: widget.maxSize * RelSize(context).pixel(),
              child: Column(
                children: List.generate(
                  widget.height,
                  (i) => Row(
                    children: List.generate(
                      widget.width,
                      (j) => Cell(
                        color: pieceColors[pieces![i][j]],
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
            ),
          ],
        ),
      ),
    );
  }
}
