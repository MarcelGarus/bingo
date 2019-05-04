import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../widgets/buttons.dart';
import '../widgets/gradient_background.dart';
import '../bloc/bloc.dart';
import 'template_details.dart';
import 'join_game.dart';
import 'select_words.dart';

void _joinGame(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => JoinGameScreen(),
  ));
}

void _createNewTemplate(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => TemplateScreen(),
  ));
}

void _startGame(BuildContext context, GameTemplate template) async {
  await Bloc.of(context).createGame(template: template);
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (_) => SelectWordsScreen(),
  ));
}

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GradientBackground(),
          Positioned.fill(child: Column(children: _buildContentItems())),
        ],
      ),
    );
  }

  List<Widget> _buildContentItems() {
    return [
      Spacer(),
      SizedBox(height: 16),
      _LimitedWidthCentered(
        child: Text(
          'Hörsaalbingo',
          style: TextStyle(color: Colors.white, fontSize: 32),
        ),
      ),
      SizedBox(height: 8),
      _LimitedWidthCentered(
        child: Text(
          'Motiviere dich, bei Vorlesungen zumindest etwas aufzupassen...',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      DictionariesView(),
      _LimitedWidthCentered(
        child: MyRaisedButton(
          color: Colors.white,
          label: 'Join game',
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
    ];
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

class DictionariesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Set<GameTemplate>>(
      stream: Bloc.of(context).templatesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.isEmpty) {
          return SizedBox(height: 32);
        }

        return Container(
          height: 148,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final spacingUpFront = ((constraints.maxWidth - 300.0) / 2)
                  .clamp(16.0, double.infinity);
              return ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.fromLTRB(spacingUpFront, 32, 0, 16),
                children: snapshot.data.map<Widget>((template) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: TemplateShortcut(template: template),
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

class TemplateShortcut extends StatelessWidget {
  TemplateShortcut({@required this.template});

  final GameTemplate template;
  int get _numWords => template.words.length;
  int get _size => template.size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 150,
      child: Material(
        color: Colors.white,
        elevation: 6,
        shadowColor: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _startGame(context, template),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: AutoSizeText(
                    template.title,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              Text('$_numWords words, ${_size}x$_size'),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
