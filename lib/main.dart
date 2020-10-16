import 'package:flutter/material.dart' hide Router, Route;
import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'board_screen.dart';
import 'choose_tiles_screen.dart';
import 'codec.dart';
import 'main_screen.dart';
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
        if (game.requiresChoosingTiles) {
          return ChooseTilesScreen(game: game);
        } else {
          return BoardScreen(board: Board(game: game, tiles: game.tiles));
        }
      },
    ),
    // Route(
    //   matcher: Matcher.path('settings'),
    //   materialBuilder: (_, __) => SettingsPage(),
    // ),
    Route(
      materialBuilder: (_, settings) {
        if (settings.remainingUri.pathSegments.isEmpty) {
          return MainScreen();
        } else {
          // TODO: 404
          throw 'Bääääh';
        }
      },
    ),
  ],
);
