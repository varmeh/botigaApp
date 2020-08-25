import 'package:flutter/material.dart';

// Material Color Theme Creation
// https://material.io/design/color/the-color-system.html#color-theme-creation

final lightTheme = ThemeData.from(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff6200ee),
    primaryVariant: Color(0xff3700b3),
    secondary: Color(0xff03dac6),
    secondaryVariant: Color(0xff018786),
    background: Colors.grey[200],
    surface: Colors.white,
    error: Color(0xffb00020),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: Colors.black,
    onSurface: Colors.black,
    onError: Colors.white,
  ),
);
