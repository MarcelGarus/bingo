import 'package:flutter/material.dart';

import 'tile.dart';

class CreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create')),
      body: SafeArea(
        child: GridView.extent(
          maxCrossAxisExtent: 150,
          padding: EdgeInsets.all(16),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            TileView(text: 'blub'),
            TileView(text: 'blib'),
            TileView(text: 'blob'),
            TileView(text: 'blab'),
            TileView(text: 'blub'),
            TileView(text: 'blib'),
            TileView(text: 'blob'),
            TileView(text: '+', onTap: () {}),
          ],
        ),
      ),
    );
  }
}
