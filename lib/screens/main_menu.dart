import 'package:flutter/material.dart';

import '../widgets/bold_buttons.dart';
import '../widgets/vote.dart';
import 'create_game.dart';
import 'join_game.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  bool _isVisible = false;

  void _toggle() {
    setState(() => _isVisible = !_isVisible);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(),
              BoldRaisedButton(
                color: Colors.purple,
                label: 'Create new game',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CreateGameScreen(),
                  ));
                },
              ),
              SizedBox(height: 16),
              BoldRaisedButton(
                color: Colors.deepOrange,
                label: 'Join game',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => JoinGameScreen(),
                  ));
                },
              ),
              SizedBox(height: 16),
              BoldFlatButton(
                label: 'Vote',
                color: Colors.green,
                onPressed: _toggle,
              ),
            ],
          ),
          VoteWidget(
            word: 'This is a sample sentence.',
            onAccepted: _toggle,
            onRejected: _toggle,
            isVisible: _isVisible,
          ),
        ],
      ),
    );
  }
}
