import 'package:flutter/material.dart';
import 'lightTheme.dart';

final _textThemeUpdate = TextTheme(
  headline6: TextStyle(fontWeight: FontWeight.bold),
  subtitle1: TextStyle(fontWeight: FontWeight.w500),
);

final _selectedIconTheme = IconThemeData(size: 28);
final _unselectedIconTheme = IconThemeData(
  size: 24,
  color: Color.fromRGBO(18, 23, 21, 0.25),
);

class AppTheme {
  static final light = lightTheme.copyWith(
    disabledColor: Color.fromRGBO(18, 23, 21, 0.05),
    dividerColor: Color.fromRGBO(18, 23, 21, 0.05),
    textTheme: lightTheme.textTheme.merge(_textThemeUpdate),
    cardTheme: CardTheme(
      margin: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
    ),
    bottomNavigationBarTheme: lightTheme.bottomNavigationBarTheme.copyWith(
      selectedIconTheme: _selectedIconTheme,
      unselectedIconTheme: _unselectedIconTheme,
    ),
  );
}
