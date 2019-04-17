import 'package:flutter/material.dart';

import '../bloc/models.dart';
import '../widgets/bingo_tile.dart';
import '../widgets/buttons.dart';
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
                onPressed: _increaseCounter,
              ),
              BingoTileView(
                tile: _count % 3 == 0
                    ? BingoTile.unmarked('sample tile')
                    : _count % 3 == 1
                        ? BingoTile.polled(
                            'sample tile',
                            Poll(
                              word: 'sample tile',
                              votesApprove: 2,
                              votesReject: 1,
                              numPlayers: 4,
                              deadline:
                                  DateTime.now().add(Duration(minutes: 1)),
                            ))
                        : BingoTile.marked('sample tile'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
