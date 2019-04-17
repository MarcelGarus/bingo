import 'package:flutter/foundation.dart';

import 'poll.dart';

@immutable
class BingoGame {
  final String id;
  final int size;
  final int numPlayers;
  final Set<String> labels;
  final Set<Poll> polls;
  final Set<String> marked;

  /// Rich constructor.
  BingoGame({
    @required this.id,
    @required this.size,
    @required this.numPlayers,
    @required this.labels,
    @required this.polls,
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
      polls: <Poll>{},
      marked: <String>{},
    );
  }

  BingoGame copyWith({
    String id,
    int size,
    int height,
    int numPlayers,
    Set<String> labels,
    Set<Poll> polls,
    Set<String> marked,
  }) {
    return BingoGame(
      id: id ?? this.id,
      size: size ?? this.size,
      numPlayers: numPlayers ?? this.numPlayers,
      labels: labels ?? this.labels,
      polls: polls ?? this.polls,
      marked: marked ?? this.marked,
    );
  }

  Poll getPoll(String label) {
    return polls.firstWhere((vote) => vote.word == label);
  }

  BingoGame copyWithUpdatedPoll({
    @required Poll original,
    @required Poll updated,
  }) {
    return copyWith(
      polls: polls.map((poll) => poll == original ? updated : poll).toSet()
        ..removeWhere((poll) => poll == null),
    );
  }

  @override
  String toString() {
    return '{id=$id, size=$size, numPlayers=$numPlayers, '
        'labels=[${labels.join(', ')}], '
        'polls=[${polls.join(', ')}], '
        'marked=[${marked.join(', ')}]}';
  }
}
