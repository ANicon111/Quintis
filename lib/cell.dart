import 'package:flutter/material.dart';

class Cell extends StatefulWidget {
  final MaterialColor? color;
  final double size;
  final void Function()? onTap;
  const Cell({
    Key? key,
    required this.color,
    required this.size,
    this.onTap,
  }) : super(key: key);

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.size * 0.02),
      child: Ink(
        width: widget.size * 0.8,
        height: widget.size * 0.8,
        decoration: BoxDecoration(
          color: widget.color,
          border: Border(
            bottom: BorderSide(
              color: widget.color?.shade800 ?? Colors.transparent,
              width: widget.size * 0.08,
            ),
            right: BorderSide(
              color: widget.color?.shade800 ?? Colors.transparent,
              width: widget.size * 0.08,
            ),
            top: BorderSide(
              color: widget.color?.shade700 ?? Colors.transparent,
              width: widget.size * 0.08,
            ),
            left: BorderSide(
              color: widget.color?.shade700 ?? Colors.transparent,
              width: widget.size * 0.08,
            ),
          ),
        ),
        child: InkWell(
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
