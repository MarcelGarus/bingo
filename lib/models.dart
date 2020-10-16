import 'package:meta/meta.dart';

/// A game that can be played. It is a template for a board.
class Game {
  Game({@required this.tiles, @required this.size})
      : assert(tiles != null),
        assert(size != null);

  final List<String> tiles;
  final int size;

  int get numTilesOnBoard => size * size;
  bool get requiresChoosingTiles => tiles.length > numTilesOnBoard;
}

/// An active game that's currently played.
class Board {
  Board({@required this.game, @required List<String> tiles})
      : assert(game != null),
        assert(tiles != null),
        assert(game.numTilesOnBoard == tiles.length),
        tiles = tiles.map((text) => TileOnBoard(text)).toList()..shuffle();

  final Game game;
  final List<TileOnBoard> tiles;
  int get size => game.size;
}

class TileOnBoard {
  TileOnBoard(this.text, [this.isSelected = false]);

  final String text;
  bool isSelected;
}
