import 'package:flutter/material.dart';

import '../widgets/bold_buttons.dart';
import '../widgets/gradient_background.dart';
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
      body: Stack(
        children: <Widget>[
          GradientBackground(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(),
              MyFlatButton(
                color: Colors.white,
                label: 'Create new game',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CreateGameScreen(),
                  ));
                },
              ),
              SizedBox(height: 16),
              MyFlatButton(
                color: Colors.white,
                label: 'Join game',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => JoinGameScreen(),
                  ));
                },
              ),
              SizedBox(height: 16),
              MyRaisedButton(
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
