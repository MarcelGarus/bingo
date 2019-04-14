import 'package:auto_size_text/auto_size_text.dart';
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
        color: tile.state == BingoTileState.marked
            ? Colors.black12
            : Colors.white12,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: tile.state == BingoTileState.unmarked ? onPressed : null,
          splashColor: Colors.white54,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 128,
            height: 128,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(4),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (tile.state == BingoTileState.voting) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
        strokeWidth: 8,
      );
    } else {
      return AutoSizeText(
        tile.label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 36,
          color: Colors.white,
        ),
      );
    }
  }
}
