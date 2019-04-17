import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xFF00897b), Color(0xFF43a047)],
        ),
      ),
    );
  }
}
