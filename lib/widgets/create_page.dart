import 'package:flutter/material.dart';

import '../models.dart';
import '../utils.dart';
import 'share_page.dart';
import 'tile.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({Key key, @required this.game}) : super(key: key);

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
        actions: [
          IconButton(icon: Icon(Icons.copy_outlined)),
          IconButton(icon: Icon(Icons.delete_outlined)),
          IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: () {
              context.navigator.push(MaterialPageRoute(
                builder: (_) => SharePage(game: game),
              ));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.play_arrow_outlined),
        label: Text('Play'),
      ),
      body: SafeArea(
        child: GridView.extent(
          maxCrossAxisExtent: 150,
          padding: EdgeInsets.all(16),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            for (final tile in game.tiles..sort())
              TileView(text: tile, elevation: 2),
            TileView(text: '+'),
          ],
        ),
      ),
    );
  }
}
