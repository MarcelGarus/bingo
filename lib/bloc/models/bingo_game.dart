import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'votes.dart';

@immutable
class BingoGame {
  final String id;
  final int size;
  final int numPlayers;
  final Set<String> labels;
  final Queue<Vote> voteQueue;
  final Set<String> marked;

  /// Rich constructor.
  BingoGame({
    @required this.id,
    @required this.size,
    @required this.numPlayers,
    @required this.labels,
    @required this.voteQueue,
    @required this.marked,
  });

  factory BingoGame.newGame({
    @required String id,
    @required int size,
    @required int numPlayers,
    @required Set<String> labels,
  }) {
    return BingoGame(
      id: id,
      size: size,
      numPlayers: numPlayers,
      labels: labels,
      voteQueue: Queue<Vote>(),
      marked: <String>{},
    );
  }

  BingoGame copyWith({
    String id,
    int size,
    int height,
    int numPlayers,
    Set<String> labels,
    Queue<Vote> voteQueue,
    Set<String> marked,
  }) {
    return BingoGame(
      id: id ?? this.id,
      size: size ?? this.size,
      numPlayers: numPlayers ?? this.numPlayers,
      labels: labels ?? this.labels,
      voteQueue: voteQueue ?? this.voteQueue,
      marked: marked ?? this.marked,
    );
  }

  Vote getVote(String label) {
    return voteQueue.firstWhere((vote) => vote.label == label);
  }

  BingoGame copyWithUpdatedVote({
    @required Vote original,
    @required Vote updated,
  }) {
    return copyWith(
      voteQueue: Queue.from(
        voteQueue.map((vote) => vote == original ? updated : vote),
      ),
    );
  }
}
