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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: hint),
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
