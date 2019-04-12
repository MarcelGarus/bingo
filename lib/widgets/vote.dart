import 'package:flutter/material.dart';

import 'bold_buttons.dart';
import 'bold_material.dart';

class VoteWidget extends ImplicitlyAnimatedWidget {
  VoteWidget({
    @required this.word,
    @required this.onAccepted,
    @required this.onRejected,
    @required this.isVisible,
  })  : assert(word != null),
        assert(onAccepted != null),
        assert(onRejected != null),
        assert(isVisible != null),
        super(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);

  final String word;
  final VoidCallback onAccepted;
  final VoidCallback onRejected;
  final bool isVisible;

  _VoteWidgetState createState() => _VoteWidgetState();
}

class _VoteWidgetState extends AnimatedWidgetBaseState<VoteWidget> {
  Tween<double> _transformTween;

  void forEachTween(TweenVisitor visitor) {
    _transformTween = visitor(
      _transformTween,
      widget.isVisible ? 16.0 : -160.0,
      (dynamic val) => Tween<double>(begin: val),
    );
  }

  Widget build(BuildContext context) {
    return Positioned(
      bottom: _transformTween.evaluate(animation),
      left: 16,
      right: 16,
      child: RepaintBoundary(
        key: ValueKey('Voting dialog'),
        child: BoldMaterial(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Did this just happen?', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text(widget.word, style: TextStyle(fontSize: 24)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    BoldFlatButton(
                      label: 'No',
                      color: Colors.red,
                      onPressed: widget.onRejected,
                    ),
                    SizedBox(width: 8),
                    BoldFlatButton(
                      label: 'Yes',
                      color: Colors.green,
                      onPressed: widget.onAccepted,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
