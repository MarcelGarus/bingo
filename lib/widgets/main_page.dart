import 'dart:math';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hero_material/hero_material.dart';

import 'board_page.dart';
import 'choose_tiles_page.dart';
import '../codec.dart';
import '../models.dart';
import 'tile.dart';
import '../utils.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.navigator.pushNamed('create'),
        icon: Icon(Icons.add),
        label: Text('Create'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final cardHeight = constraints.maxWidth + 21;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text('TextBingo', style: TextStyle(fontSize: 32)),
            SizedBox(height: 16),
            MediaQuery.removePadding(
              context: context,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: false,
                  height: cardHeight,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.8,
                  initialPage: 0,
                ),
                items: [
                  // Container(
                  //   padding: EdgeInsets.only(bottom: 16),
                  //   child: BoardPreview(
                  //     board: Board(
                  //       game: Game(
                  //         tiles: [
                  //           'Banana', 'Kiwi', 'Orange', 'Cherry', 'Papaya',
                  //           'Pomegranade', //
                  //           'Apple', 'Passion Fruit', 'Mango', 'Avocado',
                  //           'Grapefruit', 'Smoothie',
                  //         ],
                  //         size: 3,
                  //       ),
                  //       tiles: [
                  //         'Banana', 'Kiwi', 'Orange', 'Cherry', 'Papaya',
                  //         'Pomegranade', //
                  //         'Apple', 'Passion Fruit', 'Mango'
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  for (var i = 0; i < 5; i++)
                    FittedBox(
                      child: SizedBox(
                        width: 300,
                        child: GamePreview(
                          game: Game(
                            tiles: [
                              'Banana', 'Kiwi', 'Orange', 'Cherry', 'Papaya',
                              'Pomegranade', //
                              'Apple', 'Passion Fruit', 'Mango', 'Avocado',
                              'Grapefruit', 'Smoothie',
                            ],
                            size: 3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 90),
          ],
        );
      }),
    );
  }
}

class BoardPreview extends StatelessWidget {
  const BoardPreview({Key key, @required this.board}) : super(key: key);

  final Board board;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HeroMaterial(
          tag: 'current-game-material',
          color: context.theme.primaryColor,
          elevation: 4,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(),
        ),
        BoardScreenContent(board: board, isFullscreen: false),
      ],
    );
  }
}

class GamePreview extends StatefulWidget {
  const GamePreview({Key key, @required this.game}) : super(key: key);

  final Game game;

  @override
  _GamePreviewState createState() => _GamePreviewState();
}

class _GamePreviewState extends State<GamePreview> {
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
      await Future.delayed(3.seconds);
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
    return Material(
      color: context.theme.primaryColor,
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                FittedBox(
                  child: BoardView(
                    size: widget.game.size,
                    tiles: [
                      for (var i = 0;
                          i < widget.game.size * widget.game.size;
                          i++)
                        if (i < shownTiles.length)
                          GamePreviewTile(text: shownTiles[i])
                        else
                          Container(),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text('Tap for details'),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.navigator
                    .pushNamed('play/${gameCodec.encode(widget.game)}'),
              ),
            ),
          )
        ],
      ),
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
