import 'dart:math';

import 'package:flutter/material.dart';

import '../models.dart';
import '../utils.dart';
import 'tile.dart';

class GamePreviewBoard extends StatefulWidget {
  const GamePreviewBoard({Key key, @required this.game}) : super(key: key);

  final Game game;

  @override
  _GamePreviewBoardState createState() => _GamePreviewBoardState();
}

class _GamePreviewBoardState extends State<GamePreviewBoard> {
  final shownTiles = <String>[];
  final hiddenTiles = <String>[];

  @override
  void initState() {
    super.initState();
    shownTiles.addAll(widget.game.tiles);
    while (shownTiles.length > widget.game.numTilesOnBoard) {
      hiddenTiles.add(shownTiles.removeAt(0));
    }
    if (hiddenTiles.isNotEmpty) _replaceTiles();
  }

  Future<void> _replaceTiles() async {
    while (mounted) {
      setState(_replaceTile);
      await Future.delayed((Random().nextDouble() * 2 + 1).seconds);
    }
  }

  void _replaceTile() {
    final shownIndex = Random().nextInt(shownTiles.length);
    final hiddenIndex = Random().nextInt(hiddenTiles.length);
    final shown = shownTiles[shownIndex];
    shownTiles[shownIndex] = hiddenTiles[hiddenIndex];
    hiddenTiles[hiddenIndex] = shown;
  }

  @override
  Widget build(BuildContext context) {
    return TileGridView(
      size: widget.game.size,
      tiles: [
        for (var i = 0; i < pow(widget.game.size, 2); i++)
          if (i < shownTiles.length)
            GamePreviewTile(text: shownTiles[i])
          else
            Container(),
      ],
    );
  }
}

class GamePreviewTile extends StatefulWidget {
  const GamePreviewTile({Key key, @required this.text}) : super(key: key);

  final String text;

  @override
  _GamePreviewTileState createState() => _GamePreviewTileState();
}

class _GamePreviewTileState extends State<GamePreviewTile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  String _text;

  @override
  void initState() {
    super.initState();
    _text = widget.text;
    _controller = AnimationController(vsync: this, duration: 200.milliseconds)
      ..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(GamePreviewTile previous) {
    super.didUpdateWidget(previous);
    if (previous.text != widget.text) _animate();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _animate() async {
    _controller.reset();
    _controller.animateTo(1, curve: Curves.easeInCubic);
    await Future.delayed(200.milliseconds);
    _text = widget.text;
    _controller.animateTo(0, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 - _controller.value,
      child: TileView(text: _text, elevation: 2),
    );
  }
}
