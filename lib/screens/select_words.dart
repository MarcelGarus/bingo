import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../widgets/bingo_tile.dart';
import '../widgets/gradient_background.dart';
import '../widgets/share_game_button.dart';
import 'play_game.dart';

class SelectWordsScreen extends StatefulWidget {
  @override
  _SelectWordsScreenState createState() => _SelectWordsScreenState();
}

class _SelectWordsScreenState extends State<SelectWordsScreen> {
  final acceptedWords = <String>{};
  final rejectedWords = <String>{};
  final otherWords = <String>{};

  String word1, word2;
  StreamSubscription<BingoGame> streamSubscription;

  int get numRequiredWords => pow(Bloc.of(context).game.size, 2);

  void initState() {
    super.initState();
    streamSubscription =
        Bloc.of(context).gameStream.listen((game) => _update());
  }

  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  void _update() async {
    var allWords = Bloc.of(context).game.labels;
    acceptedWords.removeWhere((word) => !allWords.contains(word));
    otherWords
      ..clear()
      ..addAll(allWords.difference(acceptedWords).difference(rejectedWords));

    // If we reduced the number of words to a satisfyingly small amount, start
    // the game.
    var availableWords = acceptedWords.union(otherWords);
    var numAvailableWords = availableWords.length;

    assert(numAvailableWords >= numRequiredWords);
    if (numAvailableWords == numRequiredWords) {
      await Bloc.of(context).selectLabels(availableWords);
      await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => PlayGameScreen(),
      ));
    } else {
      // Otherwise, we need to reduce the number of words. Do that by letting
      // the player choose between [word1] and [word2]. If there are so many
      // words that the user voted on all of them but still got too many words,
      // let him re-vote on some of them.
      setState(() {
        while (otherWords.length < 2) {
          var wordToRevote = _chooseRandomWord(acceptedWords);
          acceptedWords.remove(wordToRevote);
          otherWords.add(wordToRevote);
        }

        word1 = _chooseRandomWord(otherWords);
        word2 = _chooseRandomWord(otherWords.where((w) => w != word1));
      });
    }
  }

  void _selectWord(String word) {
    acceptedWords.add(word);

    var otherWord = (word == word1) ? word2 : word1;
    rejectedWords.add(otherWord);

    print('Accepted: $acceptedWords, Rejected: $rejectedWords');

    _update();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GradientBackground(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(),
              Align(
                alignment: Alignment.centerRight,
                child: ShareGameButton(),
              ),
              BingoTileView(
                tile: BingoTile.unmarked(word1 ?? ''),
                onPressed: () => _selectWord(word1),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text('vs', style: TextStyle(fontSize: 16)),
              ),
              BingoTileView(
                tile: BingoTile.unmarked(word2 ?? ''),
                onPressed: () => _selectWord(word2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _chooseRandomWord(Iterable<String> words) {
  return List.from(words)[Random().nextInt(words.length)];
}
