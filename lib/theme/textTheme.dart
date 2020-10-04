import 'package:flutter/material.dart';

// https://blog.gskinner.com/archives/2020/03/flutter-tame-those-textstyles.html

class TextStyles {
  static TextStyle get montserrat => TextStyle(fontFamily: 'Montserrat');
}

extension TextStyleHelpers on TextStyle {
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);
  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);

  TextStyle get color100 => copyWith(color: Color.fromRGBO(18, 23, 21, 1));
  TextStyle get color50 => copyWith(color: Color.fromRGBO(18, 23, 21, 0.5));
  TextStyle get color25 => copyWith(color: Color.fromRGBO(18, 23, 21, 0.25));
  TextStyle get color05 => copyWith(color: Color.fromRGBO(18, 23, 21, 0.05));

  TextStyle size(double value) => copyWith(fontSize: value);

  TextStyle letterSpace(double value) => copyWith(letterSpacing: value);
}
