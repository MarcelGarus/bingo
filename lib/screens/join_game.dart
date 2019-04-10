import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../screens/select_words.dart';
import '../widgets/hovered_input.dart';

class JoinGameScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        padding: MediaQuery.of(context).padding +
            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        children: <Widget>[
          Center(
            child: Text('Join a game', style: TextStyle(fontSize: 32)),
          ),
          SizedBox(height: 16),
          HoveredInput(
            hint: 'Enter the code',
            onDone: (code) async {
              await Bloc.of(context).joinGame(code);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => SelectWordsScreen(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
