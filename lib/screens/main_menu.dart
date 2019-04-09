import 'package:flutter/material.dart';

import 'create_game.dart';

class MainMenuScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
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
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
