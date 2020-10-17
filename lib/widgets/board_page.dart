import 'package:flutter/material.dart';
import 'package:hero_material/hero_material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../codec.dart';
import '../models.dart';
import 'tile.dart';
import '../utils.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({Key key, @required this.board}) : super(key: key);

  final Board board;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HeroMaterial(
            tag: 'current-game-material',
            color: context.theme.primaryColor,
            child: Container(),
          ),
          SafeArea(
            child: MediaQuery.removePadding(
              context: context,
              child: BoardScreenContent(board: board, isFullscreen: true),
            ),
          ),
        ],
      ),
    );
  }
}

class BoardScreenContent extends StatefulWidget {
  const BoardScreenContent({
    Key key,
    @required this.board,
    @required this.isFullscreen,
  })  : assert(board != null),
        super(key: key);

  final Board board;
  final bool isFullscreen;

  @override
  _BoardScreenContentState createState() => _BoardScreenContentState();
}

class _BoardScreenContentState extends State<BoardScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        Hero(
          tag: 'current-game-app-bar',
          child: Material(
            type: MaterialType.transparency,
            child: Row(
              children: [
                SizedBox(width: 16),
                if (!widget.isFullscreen)
                  Text(
                    'Current game'.toUpperCase(),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                Spacer(),
                if (widget.isFullscreen)
                  IconButton(
                    icon: Icon(Icons.edit_outlined),
                    onPressed: () {},
                  ),
                IconButton(
                  icon: Icon(widget.isFullscreen
                      ? Icons.close_fullscreen_outlined
                      : Icons.fullscreen_outlined),
                  onPressed: () {
                    if (widget.isFullscreen) {
                      context.navigator.pop();
                    } else {
                      context.navigator.push(MaterialPageRoute(
                        builder: (_) => BoardScreen(board: widget.board),
                      ));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Hero(
            tag: 'current-game-board',
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
        ),
        Spacer(),
      ],
    );
  }

  Widget _buildTile(TileOnBoard tile) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TileView(
        text: tile.text,
        onTap: () => setState(() => tile.isSelected = !tile.isSelected),
        isSelected: tile.isSelected,
      ),
    );
  }
}
