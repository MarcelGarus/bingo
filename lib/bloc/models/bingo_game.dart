import 'package:flutter/foundation.dart';

import 'template.dart';
import 'poll.dart';

@immutable
class BingoGame {
  final String id;
  final String title;
  final int size;
  final int numPlayers;
  final Set<String> words;
  final Set<Poll> polls;
  final Set<String> marked;

  /// Rich constructor.
  BingoGame({
    @required this.id,
    @required this.title,
    @required this.size,
    @required this.numPlayers,
    @required this.words,
    @required this.polls,
    @required this.marked,
  });

  factory BingoGame.newGame({
    @required int numPlayers,
    @required GameTemplate template,
  }) {
    return BingoGame(
      id: null,
      title: template.title,
      size: template.size,
      numPlayers: numPlayers,
      words: template.words,
      polls: <Poll>{},
      marked: <String>{},
    );
  }

  BingoGame copyWith({
    String id,
    String title,
    int size,
    int height,
    int numPlayers,
    Set<String> words,
    Set<Poll> polls,
    Set<String> marked,
  }) {
    return BingoGame(
      id: id ?? this.id,
      title: title ?? title,
      size: size ?? this.size,
      numPlayers: numPlayers ?? this.numPlayers,
      words: words ?? this.words,
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
        'words=[${words.join(', ')}], '
        'polls=[${polls.join(', ')}], '
        'marked=[${marked.join(', ')}]}';
  }
}
