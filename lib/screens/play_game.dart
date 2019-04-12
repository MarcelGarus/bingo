import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../widgets/bingo_field.dart';
import '../widgets/share_game_button.dart';
import '../widgets/vote.dart';

class PlayGameScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[ShareGameButton()],
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder<BingoField>(
            stream: Bloc.of(context).fieldStream,
            builder: (context, snapshot) {
              // If there is no field yet, just display a loading spinner.
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
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
                  VoteWidget(
                    word: 'Wolle sagt "nich"',
                    onAccepted: () {},
                    onRejected: () {},
                    isVisible: true,
                  ),
                ],
              );

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
            },
          ),
        ),
      ),
    );
  }
}
