import 'package:flutter/material.dart';
import 'lightTheme.dart';

final textThemeUpdate = TextTheme(
  headline6: TextStyle(fontWeight: FontWeight.bold),
  subtitle1: TextStyle(fontWeight: FontWeight.w500),
);

class AppTheme {
  static final light = lightTheme.copyWith(
    textTheme: lightTheme.textTheme.merge(textThemeUpdate),
    cardTheme: CardTheme(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    ),
  );
}
