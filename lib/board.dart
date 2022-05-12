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
          ),
        ),
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
    return Center(
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
          Ink(
            width: 50 * RelSize(context).pixel(),
            height: 50 * RelSize(context).pixel(),
            color: Colors.red,
            child: InkWell(
              onTap: () {
                pieces = List.generate(
                  widget.height,
                  (_) => List.generate(
                    widget.width,
                    (_) => 0,
                  ),
                );
                for (int i = 0; i < 5; i++) {
                  for (int j = 0; j < 5; j++) {
                    setPiece(
                        pieces!, Pieces.random(), (i + j) % 4, 5 * i, 5 * j);
                  }
                }
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
