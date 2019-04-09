import 'dart:collection';

import 'package:flutter/foundation.dart';

/// One bingo tile on the field.
@immutable
class BingoTile {
  final String label;
  final bool isMarked;

  BingoTile(
    this.label, {
    this.isMarked = false,
  })  : assert(label != null),
        assert(isMarked != null);
}

/// A bingo field. Can be created by providing a bunch of phrases, like:
/// ```dart
/// var field = BingoField.fromShuffled(
///   width: 4,
///   height: 4,
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
  final List<List<BingoTile>> _field;

  int get width => _field.length;
  int get height => _field[0].length;

  /// Creates a bingo field.
  BingoField(List<List<BingoTile>> field)
      : _field = field,
        assert(field != null),
        assert(Set.from(field.map((column) => column.length)).length == 1,
            'The different columns have different heights. This is not allowed.'),
        assert(field.length > 0),
        assert(field[0].length > 0);

  /// Creates a new bingo field that contains the given labels.
  BingoField fromShuffled({
    @required int width,
    @required int height,
    @required Set<String> labels,
  }) {
    assert(labels.length == width * height);

    var shuffledLabels = Queue.of(List.from(labels)..shuffle());
    var field = List.generate(width, (x) {
      return List.generate(
        height,
        (y) => shuffledLabels.removeFirst(),
        growable: false,
      );
    }, growable: false);

    return BingoField(field);
  }

  /// Returns a copy of this bingo field, but the tile with the given label
  /// marked.
  BingoField withMarked(String label) {
    var width = this.width;
    var height = this.height;

    return BingoField(
      List.generate(width, (x) {
        return List.generate(height, (y) {
          var tile = _field[x][y];
          return BingoTile(
            tile.label,
            isMarked: tile.label == label ? true : tile.isMarked,
          );
        }, growable: false);
      }, growable: false),
    );
  }

  /// Returns a BingoColumn (a helper class) that also overloads the []
  /// operator, allowing for referencing fields at (x,y) using BingoField[x][y].
  operator [](int x) => BingoColumn((y) => _field[x][y]);
}

class BingoColumn {
  BingoTile Function(int index) _callback;

  BingoColumn(this._callback);

  operator [](index) => _callback(index);
}
