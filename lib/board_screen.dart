import 'package:flutter/material.dart';

import 'models.dart';
import 'tile.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({Key key, this.board}) : super(key: key);

  final Board board;

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              for (var i = 0; i < widget.board.size; i++)
                Row(
                  children: [
                    for (var j = 0; j < widget.board.size; j++)
                      _buildTile(widget.board.tiles[i * 3 + j]),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(TileOnBoard tile) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TileView(
        text: tile.text,
        state: tile.isSelected ? Selection.selected : Selection.notSelected,
        onTap: () => setState(() => tile.isSelected = !tile.isSelected),
      ),
    );
  }
}
