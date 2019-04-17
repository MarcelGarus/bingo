import 'package:flutter/material.dart';

class MyInput extends StatelessWidget {
  MyInput({
    @required this.hint,
    @required this.onDone,
  });

  final String hint;
  final void Function(String text) onDone;
  final _controller = TextEditingController();

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white, width: 3)),
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
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
                onSubmitted: onDone,
              ),
            ),
            IconButton(
              icon: Icon(Icons.done, color: Colors.white),
              onPressed: () => onDone(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}
