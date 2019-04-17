import 'package:flutter/material.dart';

import '../theme.dart';

class GradientBackground extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [kPrimaryColor, kAlmostPrimaryColor],
        ),
      ),
    );
  }
}
