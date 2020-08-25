import 'package:botiga/theme/lightTheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final light = lightTheme.copyWith(
    cardTheme: CardTheme(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    ),
  );
}
