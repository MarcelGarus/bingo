import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../widgets/bingo_field.dart';

class PlayGameScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: StreamBuilder<BingoField>(
            stream: Bloc.of(context).fieldStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

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
