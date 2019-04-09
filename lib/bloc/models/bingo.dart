import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'bingo_field.dart';

@immutable
class BingoGame {
  final int width, height;
  final int numPlayers;
  final Set<String> labels;
  final Queue<String> voteQueue;
  final Set<String> marked;
  final BingoField field;

  /// Rich constructor.
  BingoGame({
    @required this.width,
    @required this.height,
    @required this.numPlayers,
    @required this.labels,
    @required this.voteQueue,
    @required this.marked,
    @required this.field,
  });

  factory BingoGame.newGame({
    @required width,
    @required height,
    @required numPlayers,
    @required labels,
  }) {
    return BingoGame(
      width: width,
      height: height,
      numPlayers: numPlayers,
      labels: labels,
      voteQueue: Queue(),
      marked: {},
      field: null,
    );
  }

  factory BingoGame.createField({
    
  })
}
