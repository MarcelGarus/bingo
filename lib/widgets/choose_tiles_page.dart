import 'dart:math';

import 'package:flutter/material.dart';

import 'board_page.dart';
import '../models.dart';
import 'tile.dart';
import '../utils.dart';

class ChooseTilesPage extends StatefulWidget {
  final Game game;

  const ChooseTilesPage({Key key, @required this.game}) : super(key: key);

  @override
  _ChooseTilesPageState createState() => _ChooseTilesPageState();
}

enum ChooseOption { left, right }

extension on ChooseOption {
  ChooseOption get other =>
      this == ChooseOption.left ? ChooseOption.right : ChooseOption.left;
}

class _ChooseTilesPageState extends State<ChooseTilesPage> {
  /// Tiles that can possibly appear in the game. Initially, this includes all
  /// tiles from the game. It's then reduced over time.
  List<String> _tiles;
  Map<ChooseOption, String> _shownTiles;

  bool get hasTooManyTiles => _tiles.length > widget.game.numTilesOnBoard;

  @override
  void initState() {
    super.initState();
    _tiles = List.of(widget.game.tiles);
    assert(hasTooManyTiles,
        'SelectTilesScreen shown although no tiles need to be selected.');
    _refreshShownTiles();
  }

  /// Randomly chooses two tiles to be shown.
  void _refreshShownTiles() {
    setState(() {
      assert(hasTooManyTiles);
      final i = Random().nextInt(_tiles.length);
      var j = Random().nextInt(_tiles.length - 1);
      if (j >= i) j++;
      _shownTiles = {
        ChooseOption.left: _tiles[i],
        ChooseOption.right: _tiles[j],
      };
    });
  }

  void _selectTile(ChooseOption option) {
    _tiles.remove(_shownTiles[option.other]);
    print('Tiles are now $_tiles.');
    if (hasTooManyTiles) {
      _refreshShownTiles();
    } else {
      context.navigator.pushReplacement(MaterialPageRoute(
        builder: (_) => BoardScreen(
          board: Board(game: widget.game, tiles: _tiles),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TileView(
                text: _shownTiles[ChooseOption.left],
                onTap: () => _selectTile(ChooseOption.left),
              ),
              SizedBox(width: 8),
              Text('or'),
              SizedBox(width: 8),
              TileView(
                text: _shownTiles[ChooseOption.right],
                onTap: () => _selectTile(ChooseOption.right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
