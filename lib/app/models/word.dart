import 'package:flutter/foundation.dart';

import 'poll.dart';

enum WordState { unmarked, polled, marked }

/// A word that might be displayed in a bingo tile on a field.
@immutable
class Word {
  final String word;
  final WordState state;
  final Poll poll;

  Word._(
    this.word, {
    @required this.state,
    this.poll,
  })  : assert(word != null),
        assert(state != null);

  factory Word.unmarked(String label) {
    return Word._(label, state: WordState.unmarked);
  }

  factory Word.polled(String label, Poll poll) {
    return Word._(label, state: WordState.polled, poll: poll);
  }

  factory Word.marked(String label) {
    return Word._(label, state: WordState.marked);
  }

  bool get isUnmarked => state == WordState.unmarked;
  bool get isPolled => state == WordState.polled;
  bool get isMarked => state == WordState.marked;

  bool matches(String word) => this.word == word;

  @override
  String toString() {
    return '[${word.padRight(15)} ${isMarked ? '✔️' : isUnmarked ? '❌' : '🗳️'}]';
  }
}
