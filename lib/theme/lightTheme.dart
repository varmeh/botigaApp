import 'package:flutter/material.dart';

final _textTheme = TextTheme(
  headline6: TextStyle(
    color: Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  ),
  subtitle1: TextStyle(
    color: Colors.grey,
    fontSize: 18.0,
  ),
  subtitle2: TextStyle(
    color: Colors.grey,
    fontSize: 14.0,
  ),
  bodyText2: TextStyle(
    color: Colors.black,
    fontSize: 14.0,
  ),
  button: TextStyle(
    color: Colors.white,
    fontSize: 18.0,
  ),
);

final lightTheme = ThemeData.light().copyWith(
  primaryColor: Color(0xff00bcd4),
  primaryColorBrightness: Brightness.light,
  primaryColorLight: Color(0xffb2ebf2),
  primaryColorDark: Color(0xff0097a7),
  accentColor: Color(0xff00bcd4),
  scaffoldBackgroundColor: Color(0xfffafafa),
  bottomAppBarColor: Color(0xffffffff),
  cardColor: Color(0xffffffff),
  dividerColor: Color(0x1f000000),
  highlightColor: Color(0x66bcbcbc),
  indicatorColor: Color(0xff00bcd4),
  hintColor: Color(0x8a000000),
  errorColor: Color(0xffd32f2f),
  textTheme: _textTheme,
);
