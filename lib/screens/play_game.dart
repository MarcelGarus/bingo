import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../widgets/bingo_field.dart';
import '../widgets/gradient_background.dart';
import '../widgets/share_game_button.dart';
import '../widgets/vote.dart';

class PlayGameScreen extends StatefulWidget {
  @override
  _PlayGameScreenState createState() => _PlayGameScreenState();
}

class _PlayGameScreenState extends State<PlayGameScreen> {
  String _wordToVoteFor;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GradientBackground(),
          SafeArea(
            child: Center(
              child: StreamBuilder<BingoField>(
                stream: Bloc.of(context).fieldStream,
                builder: (context, snapshot) {
                  // If there is no field yet, just display a loading spinner.
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  var wordsToVoteFor = Bloc.of(context).wordsToVoteFor;
                  var wordToVoteForAvailable = wordsToVoteFor.isNotEmpty;
                  if (wordToVoteForAvailable) {
                    _wordToVoteFor = wordsToVoteFor.first;
                  }

                  return Stack(
                    children: <Widget>[
                      Center(
                        child: BingoFieldView(
                          field: snapshot.data,
                          onTilePressed: (tile) async {
                            await Bloc.of(context).proposeMarking(tile.label);
                          },
                        ),
                      ),
                      Positioned(right: 0, bottom: 0, child: ShareGameButton()),
                      VoteWidget(
                        word: _wordToVoteFor ?? '',
                        onAccepted: () =>
                            Bloc.of(context).voteFor(_wordToVoteFor),
                        onRejected: () =>
                            Bloc.of(context).voteAgainst(_wordToVoteFor),
                        isVisible: wordToVoteForAvailable,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
