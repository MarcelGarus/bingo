import 'package:flutter/material.dart';

import '../bloc/models.dart';
import '../widgets/bingo_field.dart';

class PlayGameScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: BingoFieldView(
            field: BingoField([
              [BingoTile('hey'), BingoTile('this'), BingoTile('is')],
              [BingoTile('some'), BingoTile('really'), BingoTile('cool')],
              [BingoTile('stuff'), BingoTile('here'), BingoTile('nich')],
            ]),
            onTilePressed: print,
          ),
        ),
      ),
    );
  }
}
