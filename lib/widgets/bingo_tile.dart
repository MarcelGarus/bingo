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
            ? Theme.of(context).primaryColor
            : Colors.white,
        elevation: tile.state == BingoTileState.unmarked ? 2 : 0,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 128,
            height: 128,
            alignment: Alignment.center,
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
      );
    } else {
      return AutoSizeText(
        tile.label,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
      );
    }
  }
}
