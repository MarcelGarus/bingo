import 'package:flutter/material.dart';

import 'widgets/bingo_field.dart';
import 'screens/create_game.dart';
import 'bloc/models.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bingo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Signature',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: BingoFieldView(
            field: BingoField([
              [BingoTile('hey'), BingoTile('this'), BingoTile('is')],
              [BingoTile('some'), BingoTile('really'), BingoTile('cool')],
              [BingoTile('stuff'), BingoTile('here'), BingoTile('nich')],
            ]),
            onTilePressed: print,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => CreateGameScreen(),
          ));
        },
      ),
    );
  }
}
