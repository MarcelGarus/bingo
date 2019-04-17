import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../screens/select_words.dart';
import '../widgets/buttons.dart';
import '../widgets/gradient_background.dart';
import '../widgets/size_selector.dart';
import '../widgets/words_input.dart';

class CreateGameScreen extends StatefulWidget {
  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  int size = 2;
  List<String> words = [];

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GradientBackground(),
          ListView(
            padding: MediaQuery.of(context).padding +
                EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            children: <Widget>[
              Center(
                child: Text(
                  'Create a new game',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              SizedBox(height: 32),
              SizeSelector(
                sizes: [2, 3, 4, 5],
                selectedSize: size,
                onSizeSelected: (s) => setState(() => size = s),
              ),
              SizedBox(height: 32),
              WordsInput(
                words: words,
                onWordsChanged: (w) => setState(() => words = w),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildFab() {
    if (words.length <= size * size) {
      return Text(
        'Enter at least ${size * size + 1} words.',
        style: TextStyle(color: Colors.white),
      );
    } else {
      return MyRaisedButton(
        label: 'Start the game',
        color: Colors.white,
        onPressed: () async {
          await Bloc.of(context)
              .createGame(size: size, labels: Set.from(words));
          setState(() {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => SelectWordsScreen(),
            ));
          });
        },
      );
    }
  }
}
