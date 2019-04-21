import 'package:flutter/material.dart';

import 'input.dart';

class WordsInput extends StatefulWidget {
  WordsInput({
    @required this.words,
    @required this.onWordsChanged,
  })  : assert(words != null),
        assert(onWordsChanged != null);

  final List<String> words;
  final void Function(List<String> words) onWordsChanged;

  @override
  _WordsInputState createState() => _WordsInputState();
}

class _WordsInputState extends State<WordsInput> {
  String error;

  bool _isWordValid(String word) {
    word = word.trim();

    if (word.isEmpty) {
      setState(() => error = null);
      return false;
    }

    if (widget.words.map((s) => s.toLowerCase()).contains(word.toLowerCase())) {
      setState(() => error = 'You already entered a similar word.');
      return false;
    }

    setState(() => error = null);
    return true;
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 8,
          children: widget.words.map((word) {
            return Chip(
              label: Text(word),
              backgroundColor: Colors.white,
              onDeleted: () {
                widget.onWordsChanged(
                    widget.words.where((w) => w != word).toList());
              },
            );
          }).toList(),
        ),
        SizedBox(height: widget.words.isEmpty ? 0 : 16),
        SizedBox(
          width: 300,
          child: MyInput(
            hint: 'Add a word',
            onChanged: (word) => _isWordValid(word),
            onDone: (word) {
              if (_isWordValid(word)) {
                widget.onWordsChanged(widget.words.followedBy([word]).toList());
                return true;
              }
              return false;
            },
          ),
        ),
        Container(child: error == null ? null : Text(error)),
      ],
    );
  }
}
