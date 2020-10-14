import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key key, this.onPressed, this.child}) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: StadiumBorder(),
      elevation: 2,
      color: Colors.white,
      child: InkWell(
        customBorder: StadiumBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.button,
            child: child,
          ),
        ),
      ),
    );
  }
}
