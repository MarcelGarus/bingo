import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../screens/share_game.dart';

class ShareGameButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () {
        var game = Bloc.of(context).game;
        if (game == null) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('No game found.'),
          ));
        }

        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => ShareGameScreen(code: game.id),
        ));
      },
    );
  }
}
