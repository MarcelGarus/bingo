import 'package:flutter/foundation.dart';

import 'poll.dart';

enum BingoTileState { unmarked, polled, marked }

/// One bingo tile on the field.
@immutable
class BingoTile {
  final String word;
  final BingoTileState state;
  final Poll poll;

  BingoTile._(
    this.word, {
    @required this.state,
    this.poll,
  })  : assert(word != null),
        assert(state != null);

  factory BingoTile.unmarked(String label) {
    return BingoTile._(label, state: BingoTileState.unmarked);
  }

  factory BingoTile.polled(String label, Poll poll) {
    return BingoTile._(label, state: BingoTileState.polled, poll: poll);
  }

  factory BingoTile.marked(String label) {
    return BingoTile._(label, state: BingoTileState.marked);
  }

  bool get isUnmarked => state == BingoTileState.unmarked;
  bool get isPolled => state == BingoTileState.polled;
  bool get isMarked => state == BingoTileState.marked;

  @override
  String toString() {
    return '{$word: $state}';
  }
}
