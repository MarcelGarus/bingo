import 'package:flutter/material.dart';

class MyFlatButton extends StatelessWidget {
  MyFlatButton({
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
      color: color.withOpacity(0.12),
      onPressed: onPressed,
      elevation: 0,
      highlightElevation: 0,
      shape: StadiumBorder(),
      highlightColor: color.withOpacity(0.2),
      splashColor: color.withOpacity(0.4),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}

class MyRaisedButton extends StatelessWidget {
  MyRaisedButton({
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
    return Material(
      shape: StadiumBorder(),
      elevation: 12,
      color: Colors.white,
      shadowColor: Colors.white,
      child: InkWell(
        customBorder: StadiumBorder(),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.4),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
