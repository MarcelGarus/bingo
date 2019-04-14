import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Colors.deepPurple, Colors.purple],
        ),
      ),
    );
  }
}
