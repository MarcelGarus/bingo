import 'package:flutter/material.dart' hide Router, Route;
import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'widgets/board_page.dart';
import 'widgets/choose_tiles_page.dart';
import 'codec.dart';
import 'widgets/create_page.dart';
import 'widgets/main_page.dart';
import 'models.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TextBingo',
      theme: ThemeData(
        primaryColor: Color(0xfffff9c4),
        accentColor: Color(0xff00796b),
        scaffoldBackgroundColor: Color(0xfffff9c4),
        textTheme: const TextTheme(
          headline6: TextStyle(fontFamily: 'Signature', fontSize: 32),
          button: TextStyle(
            fontFamily: 'Signature',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: router.onGenerateRoute,
      navigatorObservers: [
        // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
      ],
    );
  }
}

final router = Router(
  routes: [
    Route(
      matcher: Matcher.path('play/{gameId}'),
      materialBuilder: (_, result) {
        // TODO: Handle no id or no valid game.
        final game = gameCodec.decode(result['gameId']);
        // TODO: Show game preview card.

        if (game.requiresChoosingTiles) {
          return ChooseTilesPage(game: game);
        } else {
          return BoardScreen(board: Board(game: game, tiles: game.tiles));
        }
      },
    ),
    Route(
      matcher: Matcher.path('play'),
      materialBuilder: (_, result) {
        // TODO: Handle no playable game.
        final game = result.settings.arguments as Game;
        if (game.requiresChoosingTiles) {
          return ChooseTilesPage(game: game);
        } else {
          return BoardScreen(board: Board(game: game, tiles: game.tiles));
        }
      },
    ),
    Route(
      matcher: Matcher.path('create'),
      materialBuilder: (_, result) {
        return CreatePage(
          game: result.settings.arguments as Game ??
              Game(name: 'New', tiles: [], size: 3),
        );
      },
    ),
    // Route(
    //   matcher: Matcher.path('settings'),
    //   materialBuilder: (_, __) => SettingsPage(),
    // ),
    Route(
      materialBuilder: (_, settings) {
        if (settings.remainingUri.pathSegments.isEmpty) {
          return MainPage();
        } else {
          // TODO: 404
          throw 'Bääääh';
        }
      },
    ),
  ],
);
