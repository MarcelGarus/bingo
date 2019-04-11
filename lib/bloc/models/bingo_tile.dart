import 'package:flutter/foundation.dart';

enum BingoTileState { unmarked, voting, marked }

/// One bingo tile on the field.
@immutable
class BingoTile {
  final String label;
  final BingoTileState state;

  BingoTile(
    this.label, {
    this.state = BingoTileState.unmarked,
  })  : assert(label != null),
        assert(state != null);

  String toString() {
    return '{$label: $state}';
  }
}
