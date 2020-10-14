import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:bingo/app/app.dart';

import '../../widgets/buttons.dart';
import '../../widgets/gradient_background.dart';
import '../../bloc/bloc.dart';
import '../../screens/template_details.dart';
import '../../screens/join_game.dart';
import '../../screens/select_words.dart';

void _joinGame(BuildContext context) {
  /*Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => JoinGameScreen(),
  ));*/
}

void _createNewTemplate(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => TemplateScreen(),
  ));
}

void _startGame(BuildContext context, GameTemplate template) async {
  /*await Bloc.of(context).createGame(template: template);
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (_) => SelectWordsScreen(),
  ));*/
}

class MainMenuScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.white,
        icon: Icon(Icons.add, color: Colors.red),
        label: Text('Create new board'),
      ),
      body: Column(
        children: [
          Spacer(),
          SizedBox(height: 16),
          _LimitedWidthCentered(
            child: Text(
              'textbingo',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          SizedBox(height: 8),
          _LimitedWidthCentered(
            child: Text(
              'Motiviere dich, bei Vorlesungen zumindest etwas aufzupassen...',
              style: TextStyle(fontSize: 16),
            ),
          ),
          TemplatesView(),
          _LimitedWidthCentered(
            child: PrimaryButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.camera_alt),
                  SizedBox(width: 8),
                  Text('Join game'),
                ],
              ),
              onPressed: () => _joinGame(context),
            ),
          ),
          SizedBox(height: 16),
          _LimitedWidthCentered(
            child: MyFlatButton(
              color: Colors.white,
              label: 'Create a new game',
              onPressed: () => _createNewTemplate(context),
            ),
          ),
          Spacer(),
          _LimitedWidthCentered(
            child: Text(
              'By creating or joining a game you agree to our privacy '
              'policy. For more info tap here.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _LimitedWidthCentered extends StatelessWidget {
  _LimitedWidthCentered({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      child: Container(
        width: 300,
        alignment: Alignment.centerLeft,
        child: child,
      ),
    );
  }
}

class TemplatesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Set<GameTemplate>>(
      stream: Stream.empty(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.isEmpty) {
          //return SizedBox(height: 32);
        }

        final templates = [
          GameTemplate(
            title: 'The title',
            size: 3,
            lastUsed: DateTime.now().subtract(Duration(days: 2)),
            words: {'test', 'something else', 'stuff'},
          ),
          GameTemplate(
            title: 'Some other title is this soo do stuff with it',
            size: 30,
            lastUsed: DateTime.now().subtract(Duration(days: 2)),
            words: {
              'test',
              'something else',
              'stuff',
              for (var i = 0; i < 100; i++) '$i',
            },
          ),
          for (var i = 0; i < 10; i++)
            GameTemplate(
              title: 'Yet another game',
              size: 3,
              lastUsed: DateTime.now().subtract(Duration(days: 2)),
              words: {'test', 'something else', 'stuff'},
            ),
        ];

        return SizedBox(
          height: 250,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final spacingUpFront = ((constraints.maxWidth - 300.0) / 2)
                  .clamp(16.0, double.infinity);
              return ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.fromLTRB(spacingUpFront, 32, 0, 32),
                children: templates.map<Widget>((template) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GameTemplateView(template: template),
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }
}

class GameTemplateView extends StatelessWidget {
  GameTemplateView({@required this.template});

  final GameTemplate template;
  int get _numWords => template.words.length;
  int get _size => template.size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () => _startGame(context, template),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: AutoSizeText(
                    template.title,
                    style: TextStyle(fontSize: 24, fontFamily: 'Futura'),
                  ),
                ),
                Text(
                  '\n$_size×$_size\n$_numWords words\nused 2 days ago',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
