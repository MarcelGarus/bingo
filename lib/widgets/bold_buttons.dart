import 'package:flutter/material.dart';

class BoldRaisedButton extends StatelessWidget {
  BoldRaisedButton({
    @required this.label,
    @required this.color,
    @required this.onPressed,
  })  : assert(label != null),
        assert(color != null),
        assert(onPressed != null);

  final String label;
  final Color color;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      onPressed: onPressed,
      elevation: 0,
      highlightElevation: 0,
      shape: StadiumBorder(),
      highlightColor: Colors.white.withOpacity(0.2),
      splashColor: Colors.white.withOpacity(0.4),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}

class BoldFlatButton extends StatelessWidget {
  BoldFlatButton({
    @required this.label,
    @required this.color,
    @required this.onPressed,
  })  : assert(label != null),
        assert(color != null),
        assert(onPressed != null);

  final String label;
  final Color color;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.white,
      onPressed: onPressed,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      highlightColor: color.withOpacity(0.2),
      splashColor: color.withOpacity(0.4),
      padding: const EdgeInsets.all(16),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}
