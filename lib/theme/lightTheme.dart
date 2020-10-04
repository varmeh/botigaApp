import 'package:flutter/material.dart';

// Material Color Theme Creation
// https://material.io/design/color/the-color-system.html#color-theme-creation

final lightTheme = ThemeData.from(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff179f57),
    primaryVariant: Color(0xff0d8144),
    secondary: Color(0xff03dac6),
    secondaryVariant: Color(0xff018786),
    background: Color(0xffffffff),
    surface: Color.fromRGBO(18, 23, 21, 0.05),
    error: Color(0xffda3030),
    onPrimary: Color(0xff121715),
    onSecondary: Color(0xffffffff),
    onBackground: Colors.black,
    onSurface: Color(0x80121715),
    onError: Color(0xffffffff),
  ),
);
