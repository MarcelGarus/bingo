import 'package:flutter/material.dart';

import 'hovered_input.dart';

class WordSelectionController extends ValueNotifier<List<String>> {
  WordSelectionController() : super([]);

  List<String> get words => value;
  set size(List<String> w) => value = w;
}

class WordSelector extends StatefulWidget {
  WordSelector({
    @required this.controller,
  }) : assert(controller != null);

  final WordSelectionController controller;

  @override
  _WordSelectorState createState() => _WordSelectorState();
}

class _WordSelectorState extends State<WordSelector> {
  @override
  void didUpdateWidget(WordSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller.addListener(() => setState(() {}));
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Wrap(
          children: widget.controller.words
              .map((word) {
                return Chip(
                  label: Text(word),
                  backgroundColor: Colors.white,
                  elevation: 2,
                  onDeleted: () {
                    setState(() => widget.controller.words.remove(word));
                  },
                );
              })
              .expand((c) => [c, SizedBox(width: 8)])
              .toList(),
        ),
        SizedBox(height: 16),
        HoveredInput(
          hint: 'Add a word',
          onDone: (word) {
            setState(() {
              widget.controller.value = widget.controller.value..add(word);
            });
          },
        ),
      ],
    );
  }
}
