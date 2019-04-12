import 'dart:math';

import 'package:flutter/material.dart';

class HoveredInput extends StatelessWidget {
  HoveredInput({
    @required this.hint,
    @required this.onDone,
  });

  final String hint;
  final void Function(String text) onDone;
  final _controller = TextEditingController();

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                ),
                onSubmitted: onDone,
              ),
            ),
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () => onDone(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}
