import 'package:flutter/material.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';

import 'board_screen.dart';
import 'choose_tiles_screen.dart';
import 'codec.dart';
import 'models.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> _playGame() async {
    final game = Game(
      tiles: [
        'Banana', 'Kiwi', 'Orange', 'Cherry', 'Papaya', 'Pomegranade', //
        'Apple', 'Passion Fruit', 'Mango', 'Avocado', 'Grapefruit', 'Smoothie',
      ],
      size: 3,
    );
    context.navigator.pushNamed('play/${gameCodec.encode(game)}');
    // final chosenTexts = await context.navigator.push(MaterialPageRoute(
    //   builder: (_) => ChooseTilesScreen(
    //     texts: game.texts,
    //     targetLength: game.numTilesOnBoard,
    //   ),
    // ));
    // final board = Board(
    //   game: game,
    //   tiles: [
    //     for (final text in chosenTexts) Tile(text),
    //   ]..shuffle(),
    // );
    // context.navigator.push(MaterialPageRoute(
    //   builder: (_) => BoardScreen(board: board),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          RaisedButton(onPressed: _playGame, child: Text('Play game')),
          RaisedButton(onPressed: () {}, child: Text('Add game')),
        ],
      ),
    );
  }
}
