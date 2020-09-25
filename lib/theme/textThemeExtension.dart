import 'package:flutter/material.dart';

// https://blog.gskinner.com/archives/2020/03/flutter-tame-those-textstyles.html

extension TextStyleHelpers on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle letterSpace(double value) => copyWith(letterSpacing: value);
}
