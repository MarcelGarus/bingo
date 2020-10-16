import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

enum Selection { notSelected, confirming, selected }

class TileView extends ImplicitlyAnimatedWidget {
  const TileView({
    Key key,
    @required this.text,
    this.state = Selection.notSelected,
    @required this.onTap,
  }) : super(
          key: key,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );

  final String text;
  final Selection state;
  final VoidCallback onTap;

  @override
  _TileViewState createState() => _TileViewState();
}

class _TileViewState extends AnimatedWidgetBaseState<TileView> {
  ColorTween _foregroundTween;

  @override
  void forEachTween(TweenVisitor visitor) {
    _foregroundTween = visitor(
      _foregroundTween,
      widget.state == Selection.selected ? Colors.white : Colors.black,
      (dynamic val) => ColorTween(begin: val),
    );
    // _borderOpacityTween = visitor(
    //   _borderOpacityTween,
    //   widget.state == Selection.confirming ? 1.0 : 0.0,
    //   (dynamic val) => Tween<double>(begin: val),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      child: Stack(
        children: [
          Material(
            animationDuration: Duration(milliseconds: 200),
            color: widget.state == Selection.selected
                ? Theme.of(context).accentColor
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: widget.state == Selection.selected ? 0 : 5,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(8),
                child: AutoSizeText(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 36,
                    color: _foregroundTween.evaluate(animation),
                    fontFamily: 'Signature',
                  ),
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: widget.state == Selection.confirming ? 1.0 : 0.0,
            child: ConfirmationBorder(),
          ),
        ],
      ),
    );
  }
}

class ConfirmationBorder extends StatefulWidget {
  _ConfirmationBorderState createState() => _ConfirmationBorderState();
}

class _ConfirmationBorderState extends State<ConfirmationBorder> {
  bool _isRunning = true;
  double _offset = 0.0;

  void initState() {
    super.initState();
    _runAnimation();
  }

  void dispose() {
    super.dispose();
    _isRunning = false;
  }

  void _runAnimation() async {
    while (_isRunning) {
      setState(() {
        _offset += 0.002;
      });
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  Widget build(BuildContext context) {
    Widget child = Container(width: double.infinity, height: double.infinity);
    for (var i = 0.0; i < 1.0; i += 1 / 9) {
      child = CustomPaint(
        foregroundPainter: PartialRRectBorder(
          begin: _offset + i,
          end: _offset + i + 0.06,
          color: Theme.of(context).accentColor,
        ),
        child: child,
      );
    }
    return child;
  }
}

class PartialRRectBorder extends CustomPainter {
  static const double total = (128 - 2 * 16) * 4 + 2 * pi * 16;
  double begin;
  double end;
  Color color;

  PartialRRectBorder({double begin, double end, this.color}) {
    begin = begin % 1;
    if (end > 1) end = end % 1;
    this.begin = total * begin;
    this.end = total * end;
  }

  /// How much of the total length we already walked / will walk with the next
  /// shape.
  double walked = 0.0, nextWalked = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (begin > end) {
      PartialRRectBorder(begin: 0, end: end / total, color: this.color)
          .paint(canvas, size);
      PartialRRectBorder(begin: begin / total, end: 1, color: this.color)
          .paint(canvas, size);
      return;
    }

    walked = 0.0;
    nextWalked = 0.0;

    var paint = Paint()
      ..color = this.color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    // Draw the upper border.
    nextWalked = walked + 128 - 2 * 16;
    _drawPartialLine(
      canvas,
      paint,
      beginOffset: Offset(16, 0),
      endOffset: Offset(128 - 16.0, 0),
    );
    walked = nextWalked;

    // Draw the upper right corner.
    nextWalked = walked + 16 * pi / 2;
    _drawPartialCorner(
      canvas,
      paint,
      rect: Rect.fromLTWH(128 - 32.0, 0, 32, 32),
      beginAngle: -pi / 2,
      endAngle: 0,
    );
    walked = nextWalked;

    // Draw the right border.
    nextWalked = walked + 128 - 2 * 16;
    _drawPartialLine(
      canvas,
      paint,
      beginOffset: Offset(128, 16),
      endOffset: Offset(128, 128 - 16.0),
    );
    walked = nextWalked;

    // Draw the lower right corner.
    nextWalked = walked + 16 * pi / 2;
    _drawPartialCorner(
      canvas,
      paint,
      rect: Rect.fromLTWH(128 - 32.0, 128 - 32.0, 32, 32),
      beginAngle: 0,
      endAngle: pi / 2,
    );
    walked = nextWalked;

    // Draw the bottom border.
    nextWalked = walked + 128 - 2 * 16;
    _drawPartialLine(
      canvas,
      paint,
      beginOffset: Offset(128 - 16.0, 128),
      endOffset: Offset(16, 128),
    );
    walked = nextWalked;

    // Draw the bottom left corner.
    nextWalked = walked + 16 * pi / 2;
    _drawPartialCorner(
      canvas,
      paint,
      rect: Rect.fromLTWH(0, 128 - 32.0, 32, 32),
      beginAngle: pi / 2,
      endAngle: pi,
    );
    walked = nextWalked;

    // Draw the left border.
    nextWalked = walked + 128 - 2 * 16;
    _drawPartialLine(
      canvas,
      paint,
      beginOffset: Offset(0, 128 - 16.0),
      endOffset: Offset(0, 16),
    );
    walked = nextWalked;

    // Draw the top left corner.
    nextWalked = walked + 16 * pi / 2;
    _drawPartialCorner(
      canvas,
      paint,
      rect: Rect.fromLTWH(0, 0, 32, 32),
      beginAngle: pi,
      endAngle: 3 * pi / 2,
    );
    walked = nextWalked;
  }

  double _unlerpDouble(double a, double b, double t) {
    return ((t - a) / (b - a)).clamp(0.0, 1.0);
  }

  void _drawPartialLine(
    Canvas canvas,
    Paint paint, {
    Offset beginOffset,
    Offset endOffset,
  }) {
    var begin = _unlerpDouble(walked, nextWalked, this.begin);
    var end = _unlerpDouble(walked, nextWalked, this.end);
    if (begin >= end) return;
    var translatedBeginOffset = Offset.lerp(beginOffset, endOffset, begin);
    var translatedEndOffset = Offset.lerp(beginOffset, endOffset, end);
    canvas.drawLine(translatedBeginOffset, translatedEndOffset, paint);
  }

  void _drawPartialCorner(
    Canvas canvas,
    Paint paint, {
    Rect rect,
    double beginAngle,
    double endAngle,
  }) {
    var begin = _unlerpDouble(walked, nextWalked, this.begin);
    var end = _unlerpDouble(walked, nextWalked, this.end);
    if (begin >= end) return;
    var translatedBeginAngle = lerpDouble(beginAngle, endAngle, begin);
    var translatedEndAngle = lerpDouble(beginAngle, endAngle, end);
    canvas.drawArc(
      rect,
      translatedBeginAngle,
      translatedEndAngle - translatedBeginAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
