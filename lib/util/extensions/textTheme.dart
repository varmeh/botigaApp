import 'package:flutter/material.dart';

// https://blog.gskinner.com/archives/2020/03/flutter-tame-those-textstyles.html

extension TextStyleHelpers on TextStyle {
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);

  TextStyle colored(Color value) => copyWith(color: value);

  TextStyle letterSpace(double value) => copyWith(letterSpacing: value);
}
