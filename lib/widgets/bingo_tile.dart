import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../bloc/models.dart';
import 'bold_material.dart';

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
      child: BoldMaterial(
        onTap: onPressed,
        splashColor: Colors.amber,
        child: Container(
          width: 128,
          height: 128,
          color: tile.state == BingoTileState.marked
              ? Colors.amber
              : Colors.transparent,
          alignment: Alignment.center,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (tile.state == BingoTileState.voting) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.red),
        strokeWidth: 8,
      );
    } else {
      return AutoSizeText(
        tile.label,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 36),
      );
    }
  }
}
