import 'package:flutter/material.dart';

class BoldMaterial extends StatelessWidget {
  BoldMaterial({
    @required this.child,
    this.onTap,
    this.splashColor,
  });

  final Widget child;
  final VoidCallback onTap;
  final Color splashColor;

  Widget build(BuildContext context) {
    var content;
    if (onTap == null) {
      content = child;
    } else {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: splashColor,
        highlightColor: Colors.transparent,
        child: child,
      );
    }

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.black, width: 4),
      ),
      child: content,
    );
  }
}
