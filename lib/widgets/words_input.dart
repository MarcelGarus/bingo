import 'package:flutter/material.dart';

import 'hovered_input.dart';

class WordsInput extends StatelessWidget {
  WordsInput({
    @required this.words,
    @required this.onWordsChanged,
  })  : assert(words != null),
        assert(onWordsChanged != null);

  final List<String> words;
  final void Function(List<String> words) onWordsChanged;

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Wrap(
          children: words
              .map((word) {
                return Chip(
                  label: Text(word),
                  backgroundColor: Colors.white,
                  elevation: 2,
                  onDeleted: () {
                    onWordsChanged(words.where((w) => w != word).toList());
                  },
                );
              })
              .expand((c) => [c, SizedBox(width: 8)])
              .toList(),
        ),
        SizedBox(height: words.isEmpty ? 0 : 16),
        HoveredInput(
          hint: 'Add a word',
          onDone: (word) {
            if (word.trim().isEmpty) return;
            onWordsChanged(words.followedBy([word]).toList());
          },
        ),
      ],
    );
  }
}
