import 'package:flutter/foundation.dart';

import 'bingo_tile.dart';

/// A bingo field. Can be created by providing a bunch of phrases, like:
/// ```dart
/// var field = BingoField.fromShuffled(
///   size: 4,
///   labels: { 'Something', 'Something else', ... },
/// );
/// ```
/// Then, tiles can be marked using the `withMarked` method:
/// ```dart
/// field = field.withMarked('Something');
/// ```
/// Tiles can always be accessed using the [] operator:
/// var tile = field[3][2] // The tile at position (3, 2).
@immutable
class BingoField {
  final int size;
  final List<BingoTile> tiles;

  /// Creates a bingo field.
  BingoField({
    @required this.size,
    @required this.tiles,
  })  : assert(size != null),
        assert(size > 0),
        assert(tiles != null),
        assert(tiles.length == size * size);

  /// Creates a new bingo field that contains the given labels.
  factory BingoField.fromLabels({
    @required int size,
    @required Set<String> labels,
  }) {
    return BingoField(
      size: size,
      tiles: List<BingoTile>.from(labels.map((label) => BingoTile(label)))
        ..shuffle(),
    );
  }

  /// Returns a copy of this bingo field, but the tile with the given label is
  /// marked.
  BingoField withTileStates(BingoTileState Function(String label) getState) {
    return BingoField(
      size: size,
      tiles: tiles
          .map((tile) => BingoTile(tile.label, state: getState(tile.label)))
          .toList(growable: false),
    );
  }

  /// Returns a BingoColumn (a helper class) that also overloads the []
  /// operator, allowing for referencing fields at (x,y) using BingoField[x][y].
  operator [](int x) => BingoColumn((y) => tiles[size * y + x]);

  @override
  String toString() {
    return tiles.toString();
  }
}

class BingoColumn {
  BingoTile Function(int index) _callback;
  BingoColumn(this._callback);
  operator [](index) => _callback(index);
}
