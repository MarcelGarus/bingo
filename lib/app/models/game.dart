import 'package:flutter/foundation.dart';

import 'template.dart';
import 'poll.dart';
import 'word.dart';

@immutable
class Game {
  final String id;
  final String title;
  final int size;
  final int numPlayers;
  final Set<Word> words;

  Game({
    @required this.id,
    @required this.title,
    @required this.size,
    @required this.numPlayers,
    @required this.words,
  });

  factory Game.newGame({
    @required int numPlayers,
    @required GameTemplate template,
  }) {
    return Game(
      id: null,
      title: template.title,
      size: template.size,
      numPlayers: numPlayers,
      words: template.words.map((word) => Word.unmarked(word)),
    );
  }

  Game copyWith({
    String id,
    String title,
    int size,
    int height,
    int numPlayers,
    Set<Word> words,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? title,
      size: size ?? this.size,
      numPlayers: numPlayers ?? this.numPlayers,
      words: words ?? this.words,
    );
  }

  Game copyWithWord({@required Word updatedWord}) {
    return copyWith(
      words: {
        for (final word in words)
          if (word.word == updatedWord.word) updatedWord else word,
      },
    );
  }

  @override
  String toString() {
    return 'BingoGame #$id, $size×$size, $numPlayers players.\n'
        'Words: ${words.join(', ')}';
  }
}
