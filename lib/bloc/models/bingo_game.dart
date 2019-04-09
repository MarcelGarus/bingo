import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'votes.dart';

@immutable
class BingoGame {
  final String id;
  final int width, height;
  final int numPlayers;
  final Set<String> labels;
  final Queue<Vote> voteQueue;
  final Set<String> marked;

  /// Rich constructor.
  BingoGame({
    @required this.id,
    @required this.width,
    @required this.height,
    @required this.numPlayers,
    @required this.labels,
    @required this.voteQueue,
    @required this.marked,
  });

  factory BingoGame.newGame({
    @required String id,
    @required int width,
    @required int height,
    @required int numPlayers,
    @required Set<String> labels,
  }) {
    return BingoGame(
      id: id,
      width: width,
      height: height,
      numPlayers: numPlayers,
      labels: labels,
      voteQueue: Queue<Vote>(),
      marked: <String>{},
    );
  }

  BingoGame copyWith({
    String id,
    int width,
    int height,
    int numPlayers,
    Set<String> labels,
    Queue<Vote> voteQueue,
    Set<String> marked,
  }) {
    return BingoGame(
      id: id ?? this.id,
      width: width ?? this.width,
      height: height ?? this.height,
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
