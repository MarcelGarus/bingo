import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../widgets/bingo_field.dart';
import '../widgets/share_game_button.dart';
import '../widgets/vote.dart';

class PlayGameScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(elevation: 0, actions: <Widget>[ShareGameButton()]),
      body: SafeArea(
        child: Center(
          child: StreamBuilder<BingoField>(
            stream: Bloc.of(context).fieldStream,
            builder: (context, snapshot) {
              // If there is no field yet, just display a loading spinner.
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              // If there are words to vote for, let the user vote.
              var wordsToVoteFor = Bloc.of(context).wordsToVoteFor;
              if (wordsToVoteFor.isNotEmpty) {
                var word = wordsToVoteFor.first;
                return VoteWidget(
                  word: word,
                  onAccepted: () => Bloc.of(context).voteFor(word),
                  onRejected: () => Bloc.of(context).voteAgainst(word),
                );
              }

              // Otherwise, just display the field.
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BingoFieldView(
                    field: snapshot.data,
                    onTilePressed: (tile) async {
                      await Bloc.of(context).proposeMarking(tile.label);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
