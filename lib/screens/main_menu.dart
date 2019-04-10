import 'package:flutter/material.dart';

import 'create_game.dart';
import 'join_game.dart';

class MainMenuScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(),
          RaisedButton(
            color: Colors.white,
            child: Text('Create new game'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => CreateGameScreen(),
              ));
            },
          ),
          RaisedButton(
            color: Colors.white,
            child: Text('Join game'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => JoinGameScreen(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
