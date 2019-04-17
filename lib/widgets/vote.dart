import 'package:flutter/material.dart';

import 'bold_buttons.dart';

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
      widget.isVisible ? 0.0 : 1.0,
      (dynamic val) => Tween<double>(begin: val),
    );
  }

  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: RepaintBoundary(
        key: ValueKey('Voting dialog'),
        child: FractionalTranslation(
          translation: Offset(0, _transformTween.evaluate(animation)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              borderRadius: BorderRadius.circular(16),
              elevation: 12,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Did this just happen?',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text(widget.word, style: TextStyle(fontSize: 24)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MyFlatButton(
                          label: 'No',
                          color: Colors.red,
                          onPressed: widget.onRejected,
                        ),
                        SizedBox(width: 8),
                        MyFlatButton(
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
        ),
      ),
    );
  }
}
