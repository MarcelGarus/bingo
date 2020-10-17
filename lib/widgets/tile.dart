import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class TileView extends ImplicitlyAnimatedWidget {
  TileView({
    Key key,
    @required this.text,
    this.onTap,
    this.isSelected = false,
    this.elevation = 5,
  }) : super(
          key: key,
          duration: 200.milliseconds,
          curve: Curves.easeInOut,
        );

  final String text;
  final VoidCallback onTap;
  final bool isSelected;
  final double elevation;

  @override
  _TileViewState createState() => _TileViewState();
}

class _TileViewState extends AnimatedWidgetBaseState<TileView> {
  ColorTween _foregroundTween;

  @override
  void forEachTween(TweenVisitor visitor) {
    _foregroundTween = visitor(
      _foregroundTween,
      widget.isSelected ? Colors.white : Colors.black,
      (dynamic val) => ColorTween(begin: val),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 128,
      child: Material(
        animationDuration: 200.milliseconds,
        color: widget.isSelected ? context.theme.accentColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: widget.elevation ?? (widget.isSelected ? 0 : 5),
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
    );
  }
}

class TileGridView extends StatelessWidget {
  const TileGridView({
    Key key,
    @required this.size,
    @required this.tiles,
    this.spacing = 16,
  }) : super(key: key);

  final int size;
  final List<Widget> tiles;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var i = 0; i < size; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var j = 0; j < size; j++) ...[
                if (j > 0) SizedBox(width: spacing),
                tiles[i * 3 + j],
              ]
            ],
          ),
        ],
      ],
    );
  }
}
