import 'package:flutter/foundation.dart';

import 'word.dart';

/// A bingo field. Can be created by providing a bunch of words, like:
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
/// ```
/// var tile = field[3][2] // The tile at position (3, 2).
/// ```
@immutable
class BingoField {
  final int size;
  final List<Word> tiles;

  /// Creates a bingo field.
  BingoField({
    @required this.size,
    @required this.tiles,
  })  : assert(size != null),
        assert(size > 0),
        assert(tiles != null),
        assert(tiles.length == size * size);

  /// Creates a new bingo field that contains the given words.
  factory BingoField.fromWords({
    @required int size,
    @required Set<String> words,
  }) {
    return BingoField(
      size: size,
      tiles: List<Word>.from(words.map((word) => Word.unmarked(word)))
        ..shuffle(),
    );
  }

  /// Returns a copy of this bingo field, but all the tiles are mapped using
  /// the given function.
  BingoField mapTiles(Word Function(Word word) updateWord) {
    return BingoField(
      size: size,
      tiles: tiles.map((word) => updateWord(word)).toList(growable: false),
    );
  }

  /// Returns a [_BingoColumn] (a helper class) that also overloads the []
  /// operator, allowing for referencing fields at (x,y) using the syntax
  /// `BingoField[x][y]`.
  operator [](int x) => _BingoColumn((y) => tiles[size * y + x]);

  @override
  String toString() {
    final buffer = StringBuffer()
      ..writeAll([
        for (var y = 0; y < size; y++)
          [
            for (var x = 0; x < size; x++) this[x][y].toString(),
          ].join(' '),
      ]);
    return buffer.toString();
  }
}

class _BingoColumn {
  Word Function(int index) _callback;
  _BingoColumn(this._callback);
  operator [](index) => _callback(index);
}
