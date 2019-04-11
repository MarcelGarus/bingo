import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'votes.dart';

@immutable
class BingoGame {
  final String id;
  final int size;
  final int numPlayers;
  final Set<String> labels;
  final Set<Vote> votes;
  final Set<String> marked;

  /// Rich constructor.
  BingoGame({
    @required this.id,
    @required this.size,
    @required this.numPlayers,
    @required this.labels,
    @required this.votes,
    @required this.marked,
  });

  factory BingoGame.newGame({
    @required int size,
    @required int numPlayers,
    @required Set<String> labels,
  }) {
    return BingoGame(
      id: null,
      size: size,
      numPlayers: numPlayers,
      labels: labels,
      votes: <Vote>{},
      marked: <String>{},
    );
  }

  BingoGame copyWith({
    String id,
    int size,
    int height,
    int numPlayers,
    Set<String> labels,
    Set<Vote> votes,
    Set<String> marked,
  }) {
    return BingoGame(
      id: id ?? this.id,
      size: size ?? this.size,
      numPlayers: numPlayers ?? this.numPlayers,
      labels: labels ?? this.labels,
      votes: votes ?? this.votes,
      marked: marked ?? this.marked,
    );
  }

  Vote getVote(String label) {
    return votes.firstWhere((vote) => vote.label == label);
  }

  BingoGame copyWithUpdatedVote({
    @required Vote original,
    @required Vote updated,
  }) {
    return copyWith(
      votes: votes.map((vote) => vote == original ? updated : vote).toSet()
        ..removeWhere((v) => v == null),
    );
  }

  @override
  String toString() {
    return '{id=$id, size=$size, numPlayers=$numPlayers, '
        'labels=[${labels.join(', ')}], '
        'voteQueue=[${votes.join(', ')}], '
        'marked=[${marked.join(', ')}]}';
  }
}
