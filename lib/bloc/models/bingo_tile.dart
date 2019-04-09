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
