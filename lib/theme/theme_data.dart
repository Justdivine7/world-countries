import 'package:flutter/material.dart';

// LIGHT AND DARK MODE THEMES
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Nunito',
  scaffoldBackgroundColor: Colors.white,
  cardColor: Color.fromRGBO(
    242,
    244,
    247,
    1,
  ),
  hintColor: Color.fromRGBO(255, 108, 0, 1),
  focusColor: Colors.black,
  primaryColor: Colors.white,
  canvasColor: Colors.grey[400]!,
  highlightColor: Colors.grey[100]!,
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Nunito',
  scaffoldBackgroundColor: Color.fromRGBO(0, 15, 36, 1),
  cardColor: Color.fromRGBO(
    152,
    162,
    179,
    0.2,
  ),
  canvasColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  focusColor: Colors.white,
  hintColor: Color.fromRGBO(255, 108, 0, 1),
  primaryColor: Colors.white,
  textTheme: TextTheme(
    bodySmall: TextStyle(color: Colors.white),
  ),
);
