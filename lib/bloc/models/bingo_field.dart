import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'bingo_tile.dart';

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
  final String id;
  final int width, height;
  final List<BingoTile> field;

  /// Creates a bingo field.
  BingoField({
    @required this.id,
    @required this.width,
    @required this.height,
    @required this.field,
  })  : assert(id != null),
        assert(width != null),
        assert(width > 0),
        assert(height != null),
        assert(height > 0),
        assert(field != null),
        assert(field.length == width * height);

  /// Creates a new bingo field that contains the given labels.
  factory BingoField.fromShuffled({
    @required String id,
    @required int width,
    @required int height,
    @required Set<String> labels,
  }) {
    return BingoField(
      id: id,
      width: width,
      height: height,
      field: List.from(labels)..shuffle(),
    );
  }

  /// Returns a copy of this bingo field, but the tile with the given label is
  /// marked.
  BingoField withMarked(String label) {
    return BingoField(
      id: id,
      width: width,
      height: height,
      field: field
          .map((tile) =>
              tile.label == label ? BingoTile(label, isMarked: true) : tile)
          .toList(growable: false),
    );
  }

  /// Returns a BingoColumn (a helper class) that also overloads the []
  /// operator, allowing for referencing fields at (x,y) using BingoField[x][y].
  operator [](int x) => BingoColumn((y) => field[width * y + x]);
}

class BingoColumn {
  BingoTile Function(int index) _callback;
  BingoColumn(this._callback);
  operator [](index) => _callback(index);
}
