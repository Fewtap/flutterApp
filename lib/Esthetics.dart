import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = Color.fromARGB(255, 92, 95, 54);
  static Color accentColor = Color.fromARGB(255, 160, 167, 133);
  static Color shadowColor = darken(accentColor, 10);
  static Color backgroundColor = Color.fromARGB(255, 59, 58, 58);

  /// Darken a color by [percent] amount (100 = black)
// ........................................................
  static Color darken(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
        (c.blue * f).round());
  }

  /// Lighten a color by [percent] amount (100 = white)
// ........................................................
  static Color lighten(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round());
  }
}
