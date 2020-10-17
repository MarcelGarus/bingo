import 'dart:math';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hero_material/hero_material.dart';

import 'board_page.dart';
import 'choose_tiles_page.dart';
import '../codec.dart';
import '../models.dart';
import 'game_preview_board.dart';
import 'preview_card.dart';
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
                  FittedBox(
                    child: SizedBox(
                      width: 300,
                      child: BoardPreview(
                        board: Board(
                          game: Game(
                            tiles: [
                              'Banana', 'Kiwi', 'Orange', 'Cherry', 'Papaya',
                              'Pomegranade', //
                              'Apple', 'Passion Fruit', 'Mango', 'Avocado',
                              'Grapefruit', 'Smoothie',
                            ],
                            size: 3,
                          ),
                          tiles: [
                            'Banana', 'Kiwi', 'Orange', 'Cherry', 'Papaya',
                            'Pomegranade', //
                            'Apple', 'Passion Fruit', 'Mango'
                          ],
                        ),
                      ),
                    ),
                  ),
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
    return PreviewCard(
      title: 'Fruits',
      board: TileGridView(
        size: board.game.size,
        tiles: [
          for (var i = 0; i < pow(board.game.size, 2); i++)
            TileView(
              text: board.tiles[i].text,
              isSelected: board.tiles[i].isSelected,
            ),
        ],
      ),
      footer: Center(
        child: Text('This is the current game.\nTap to continue playing'),
      ),
    );
  }
}

class GamePreview extends StatelessWidget {
  const GamePreview({Key key, @required this.game}) : super(key: key);

  final Game game;

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      title: 'Fruit bingo',
      board: GamePreviewBoard(game: game),
      footer: Center(child: Text('Tap for details')),
    );
  }
}
