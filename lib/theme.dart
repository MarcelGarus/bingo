import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF00897b);
const kAlmostPrimaryColor = Color(0xFF43a047);

final kTheme = ThemeData(
  primaryColor: kPrimaryColor,
  textTheme: const TextTheme(
    title: TextStyle(fontFamily: 'Futura', fontSize: 32),
    button: TextStyle(
      fontFamily: 'Futura',
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
);
