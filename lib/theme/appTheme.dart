import 'package:flutter/material.dart';
import 'lightTheme.dart';

final _textThemeUpdate = TextTheme(
  headline6: TextStyle(fontWeight: FontWeight.bold),
  subtitle1: TextStyle(fontWeight: FontWeight.w500),
);

final _selectedIconTheme = IconThemeData(size: 28);
final _unselectedIconTheme = IconThemeData(
  size: 24,
  color: Color.fromARGB(63, 18, 23, 21),
);

class AppTheme {
  static final light = lightTheme.copyWith(
    disabledColor: Colors.grey[300],
    textTheme: lightTheme.textTheme.merge(_textThemeUpdate),
    cardTheme: CardTheme(
      margin: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
    ),
    bottomNavigationBarTheme: lightTheme.bottomNavigationBarTheme.copyWith(
      backgroundColor: Colors.white,
      selectedIconTheme: _selectedIconTheme,
      unselectedIconTheme: _unselectedIconTheme,
    ),
  );
}
