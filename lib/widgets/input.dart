import 'package:flutter/material.dart';

class MyInput extends StatefulWidget {
  MyInput({
    @required this.hint,
    @required this.onDone,
    this.onChanged,
  });

  final String hint;
  final bool Function(String text) onDone;
  final void Function(String text) onChanged;

  @override
  _MyInputState createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  final _controller = TextEditingController();

  void _onDone() {
    if (widget.onDone(_controller.text)) {
      _controller.clear();
    }
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  border: InputBorder.none,
                ),
                onChanged: widget.onChanged,
                onSubmitted: (_) => _onDone(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.done),
              onPressed: _onDone,
            ),
          ],
        ),
      ),
    );
  }
}
