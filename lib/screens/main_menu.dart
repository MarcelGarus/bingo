import 'package:flutter/material.dart';

import '../bloc/models.dart';
import '../widgets/bingo_tile.dart';
import '../widgets/bold_buttons.dart';
import '../widgets/gradient_background.dart';
import 'create_game.dart';
import 'join_game.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _count = 0;

  void _increaseCounter() => setState(() => _count++);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GradientBackground(),
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              alignment: Alignment.center,
              child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    FlutterLogo(colors: Colors.amber, size: 200),
                    SizedBox(height: 16),
                    Text(
                      'Hörsaalbingo',
                      style: TextStyle(color: Colors.white, fontSize: 32),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Motiviere dich, bei Vorlesungen zumindest etwas '
                      'aufzupassen...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 32),
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
                    Spacer(),
                    Text(
                      'By creating or joining a game you agree to our privacy '
                      'policy. For more info tap here.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
