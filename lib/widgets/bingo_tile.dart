import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../bloc/models.dart';
import '../theme.dart';

class BingoTileView extends ImplicitlyAnimatedWidget {
  BingoTileView({
    @required this.tile,
    @required this.onPressed,
  })  : assert(tile != null),
        assert(onPressed != null),
        super(duration: Duration(milliseconds: 300));

  final BingoTile tile;
  final VoidCallback onPressed;

  _BingoTileViewState createState() => _BingoTileViewState();
}

class _BingoTileViewState extends AnimatedWidgetBaseState<BingoTileView> {
  BingoTile get tile => widget.tile;

  ColorTween _backgroundTween;
  ColorTween _foregroundTween;
  Tween<double> _approveTween;
  Tween<double> _rejectTween;
  Tween<double> _borderOpacityTween;

  @override
  void forEachTween(TweenVisitor visitor) {
    _backgroundTween = visitor(
      _backgroundTween,
      tile.isUnmarked ? Colors.white : Colors.black12,
      (dynamic val) => ColorTween(begin: val),
    );
    _foregroundTween = visitor(
      _foregroundTween,
      tile.isUnmarked ? Color(0xFF43a047) : Colors.white,
      (dynamic val) => ColorTween(begin: val),
    );
    _approveTween = visitor(
      _approveTween,
      tile.isPolled ? (tile.poll.votesApprove / tile.poll.numPlayers) : 0.0,
      (dynamic val) => Tween<double>(begin: val),
    );
    _rejectTween = visitor(
      _rejectTween,
      tile.isPolled ? (tile.poll.votesReject / tile.poll.numPlayers) : 0.0,
      (dynamic val) => Tween<double>(begin: val),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      margin: const EdgeInsets.all(8),
      child: Transform.scale(
        scale: !tile.isMarked
            ? 1.0
            : 2.0 -
                max(
                  Curves.bounceOut.transform(animation.value),
                  1.0 - Curves.fastOutSlowIn.transform(animation.value),
                ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Material(
                color: _backgroundTween.evaluate(animation),
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: AutoSizeText(
                    tile.word,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 36,
                      color: _foregroundTween.evaluate(animation),
                    ),
                  ),
                ),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: tile.isUnmarked ? widget.onPressed : null,
                splashColor: kPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                child:
                    SizedBox(width: 128, height: 128, child: _buildContent()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Opacity(
      opacity: _borderOpacityTween.evaluate(animation),
      child: PollBorder(
        approveRatio: _approveTween.evaluate(animation),
        rejectRatio: _rejectTween.evaluate(animation),
      ),
    );
  }
}

class PollBorder extends StatefulWidget {
  final double approveRatio;
  final double rejectRatio;

  PollBorder({@required this.approveRatio, @required this.rejectRatio});

  _PollBorderState createState() => _PollBorderState();
}

class _PollBorderState extends State<PollBorder> {
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
        _offset += 0.001;
      });
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: PartialRRectBorder(
        begin: _offset,
        end: _offset + widget.approveRatio,
        color: Colors.white,
      ),
      child: CustomPaint(
        foregroundPainter: PartialRRectBorder(
          begin: _offset - widget.rejectRatio,
          end: _offset,
          color: Colors.black,
        ),
        child: Container(width: double.infinity, height: double.infinity),
      ),
    );
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
