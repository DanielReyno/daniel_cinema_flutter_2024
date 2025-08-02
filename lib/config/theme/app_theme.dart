import 'package:flutter/material.dart';

const List<Color> colorsSeeds = [
  Colors.teal,
  Colors.green,
  Colors.blueAccent,
  Colors.deepPurple,
  Colors.redAccent,
  Colors.amber,
  Colors.brown,
  Colors.indigo
];


class AppTheme {

  final bool isDarkMode;
  final Color colorSeed;

  AppTheme({this.isDarkMode = false, this.colorSeed = Colors.redAccent});

  ThemeData get getAppTheme => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: colorSeed,
    brightness: !isDarkMode
    ? Brightness.light
    : Brightness.dark
  );
}