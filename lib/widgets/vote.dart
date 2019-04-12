import 'package:flutter/material.dart';

class VoteWidget extends StatelessWidget {
  VoteWidget({
    @required this.word,
    @required this.onAccepted,
    @required this.onRejected,
  })  : assert(word != null),
        assert(onAccepted != null),
        assert(onRejected != null);

  final String word;
  final VoidCallback onAccepted;
  final VoidCallback onRejected;

  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 2,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Did this just occur?'),
            Text(word, style: TextStyle(fontSize: 24)),
            Row(
              children: <Widget>[
                RaisedButton(child: Text('No'), onPressed: onRejected),
                RaisedButton(child: Text('Yes'), onPressed: onAccepted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
