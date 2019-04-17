import 'package:flutter/material.dart';

import 'bold_input.dart';

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
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 8,
          children: words.map((word) {
            return Chip(
              label: Text(word),
              backgroundColor: Colors.white,
              onDeleted: () {
                onWordsChanged(words.where((w) => w != word).toList());
              },
            );
          }).toList(),
        ),
        SizedBox(height: words.isEmpty ? 0 : 16),
        SizedBox(
          width: 300,
          child: MyInput(
            hint: 'Add a word',
            onDone: (word) {
              if (word.trim().isEmpty) return;
              onWordsChanged(words.followedBy([word]).toList());
            },
          ),
        ),
      ],
    );
  }
}
