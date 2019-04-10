import 'package:flutter/material.dart';

import '../bloc/models.dart';

class BingoTileView extends StatelessWidget {
  BingoTileView({
    @required this.tile,
    @required this.onPressed,
  })  : assert(tile != null),
        assert(onPressed != null);

  final BingoTile tile;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: tile.isMarked ? Colors.orangeAccent : Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 128,
            height: 128,
            alignment: Alignment.center,
            child: Text(
              tile.label,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
