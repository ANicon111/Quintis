import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quintis/definitions.dart';
import 'package:quintis/pieces.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int pieceCount = int.parse(GetStorage("quintis/data").read("number"));

  decreasePieceCount() {
    setState(() {
      pieceCount--;
    });
  }

  increasePieceCount() {
    setState(() {
      pieceCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PieceAdder(
          pieceCount: pieceCount,
          increasePieceCount: increasePieceCount,
        ),
        PieceList(
          pieceCount: pieceCount,
          decreasePieceCount: decreasePieceCount,
        ),
      ],
    );
  }
}

class PieceAdder extends StatefulWidget {
  final int pieceCount;
  final Function increasePieceCount;
  const PieceAdder(
      {Key? key, required this.pieceCount, required this.increasePieceCount})
      : super(key: key);

  @override
  State<PieceAdder> createState() => _PieceAdderState();
}

class _PieceAdderState extends State<PieceAdder> {
  int color = 0;
  Piece piece = Piece(List.generate(5, (_) => List.generate(5, (_) => 0)));
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            5,
            (i) => Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                5,
                (j) => Padding(
                  padding: EdgeInsets.all(4 * RelSize(context).pixel()),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: pieceColors[piece.shape[i][j]],
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade800,
                          width: 16 * RelSize(context).pixel(),
                        ),
                        right: BorderSide(
                          color: Colors.grey.shade800,
                          width: 16 * RelSize(context).pixel(),
                        ),
                        top: BorderSide(
                          color: Colors.grey.shade600,
                          width: 16 * RelSize(context).pixel(),
                        ),
                        left: BorderSide(
                          color: Colors.grey.shade600,
                          width: 16 * RelSize(context).pixel(),
                        ),
                      ),
                    ),
                    height: 160 * RelSize(context).pixel(),
                    width: 160 * RelSize(context).pixel(),
                    child: InkWell(
                      onTap: () {
                        setState(
                          () {
                            piece.shape[i][j] = color;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            11,
            (i) => Padding(
              padding: EdgeInsets.all(2 * RelSize(context).pixel()),
              child: Ink(
                decoration: BoxDecoration(
                  color: pieceColors[i],
                  border: Border(
                    bottom: BorderSide(
                      color: color == i
                          ? Colors.green.shade600
                          : Colors.grey.shade800,
                      width: 8 * RelSize(context).pixel(),
                    ),
                    right: BorderSide(
                      color: color == i
                          ? Colors.green.shade600
                          : Colors.grey.shade800,
                      width: 8 * RelSize(context).pixel(),
                    ),
                    top: BorderSide(
                      color: color == i
                          ? Colors.green.shade400
                          : Colors.grey.shade600,
                      width: 8 * RelSize(context).pixel(),
                    ),
                    left: BorderSide(
                      color: color == i
                          ? Colors.green.shade400
                          : Colors.grey.shade600,
                      width: 8 * RelSize(context).pixel(),
                    ),
                  ),
                ),
                height: 72 * RelSize(context).pixel(),
                width: 72 * RelSize(context).pixel(),
                child: InkWell(
                  onTap: () {
                    setState(
                      () {
                        color = i;
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Ink(
          height: 100 * RelSize(context).pixel(),
          width: 400 * RelSize(context).pixel(),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(
              10 * RelSize(context).pixel(),
            ),
          ),
          child: InkWell(
            child: Center(
              child: Text(
                "Add piece",
                style: TextStyle(
                  fontSize: 60 * RelSize(context).pixel(),
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
            onTap: () {
              if (widget.pieceCount < 10) {
                piece.addToStorage();
                widget.increasePieceCount();
              } else {
                const snackBar = SnackBar(
                  content: Text('Max number of pieces reached(20)'),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            hoverColor: Colors.blueAccent.shade400,
            borderRadius: BorderRadius.circular(
              10 * RelSize(context).pixel(),
            ),
          ),
        ),
      ],
    );
  }
}

class PieceList extends StatefulWidget {
  final Function decreasePieceCount;
  final int pieceCount;
  const PieceList(
      {Key? key, required this.pieceCount, required this.decreasePieceCount})
      : super(key: key);

  @override
  State<PieceList> createState() => _PieceListState();
}

class _PieceListState extends State<PieceList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: List.generate(
            10,
            (i) => Padding(
              padding: EdgeInsets.all(
                20 * RelSize(context).pixel(),
              ),
              child: SizedBox(
                width: 800 * RelSize(context).pixel(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
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
                                      color: Pieces.index(i)[0][k][j] == 0
                                          ? null
                                          : pieceColors[Pieces.index(i).shape[k]
                                              [j]],
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
                    Ink(
                      height: 50 * RelSize(context).pixel(),
                      width: 160 * RelSize(context).pixel(),
                      decoration: BoxDecoration(
                        color: Pieces.isEnabled(i)
                            ? Colors.redAccent
                            : Colors.greenAccent,
                        borderRadius: BorderRadius.circular(
                          10 * RelSize(context).pixel(),
                        ),
                      ),
                      child: InkWell(
                        hoverColor: Pieces.isEnabled(i)
                            ? Colors.redAccent.shade400
                            : Colors.greenAccent.shade400,
                        onTap: () {
                          if (Pieces.isEnabled(i)) {
                            Pieces.disable(i);
                          } else {
                            Pieces.enable(i);
                          }
                          setState(() {});
                        },
                        borderRadius: BorderRadius.circular(
                          10 * RelSize(context).pixel(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.not_interested,
                              size: 50 * RelSize(context).pixel(),
                            ),
                            Text(
                              Pieces.isEnabled(i) ? "Disable" : "Enable",
                              style: TextStyle(
                                fontSize: 25 * RelSize(context).pixel(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Column(
          children: List.generate(
            widget.pieceCount,
            (i) => Padding(
              padding: EdgeInsets.all(
                20 * RelSize(context).pixel(),
              ),
              child: SizedBox(
                width: 800 * RelSize(context).pixel(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
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
                                      color: Pieces.index(i + 10)[0][k][j] == 0
                                          ? null
                                          : pieceColors[
                                              Pieces.index(i + 10).shape[k][j]],
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
                    Ink(
                      height: 50 * RelSize(context).pixel(),
                      width: 160 * RelSize(context).pixel(),
                      decoration: BoxDecoration(
                        color: Pieces.isEnabled(i + 10)
                            ? Colors.redAccent
                            : Colors.greenAccent,
                        borderRadius: BorderRadius.circular(
                          10 * RelSize(context).pixel(),
                        ),
                      ),
                      child: InkWell(
                        hoverColor: Pieces.isEnabled(i + 10)
                            ? Colors.redAccent.shade400
                            : Colors.greenAccent.shade400,
                        onTap: () {
                          if (Pieces.isEnabled(i + 10)) {
                            Pieces.disable(i + 10);
                          } else {
                            Pieces.enable(i + 10);
                          }
                          setState(() {});
                        },
                        borderRadius: BorderRadius.circular(
                          10 * RelSize(context).pixel(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.not_interested,
                              size: 50 * RelSize(context).pixel(),
                            ),
                            Text(
                              Pieces.isEnabled(i + 10) ? "Disable" : "Enable",
                              style: TextStyle(
                                fontSize: 25 * RelSize(context).pixel(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                        20 * RelSize(context).pixel(),
                      ),
                      child: Ink(
                        height: 50 * RelSize(context).pixel(),
                        width: 160 * RelSize(context).pixel(),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(
                            10 * RelSize(context).pixel(),
                          ),
                        ),
                        child: InkWell(
                          hoverColor: Colors.redAccent.shade400,
                          onTap: () {
                            Pieces.removeFromStorage(i);
                            widget.decreasePieceCount();
                          },
                          borderRadius: BorderRadius.circular(
                            10 * RelSize(context).pixel(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.close,
                                size: 50 * RelSize(context).pixel(),
                              ),
                              Text(
                                "Remove",
                                style: TextStyle(
                                  fontSize: 25 * RelSize(context).pixel(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
