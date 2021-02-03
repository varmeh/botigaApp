import 'package:flutter/material.dart';

import 'appTheme.dart';

// https://blog.gskinner.com/archives/2020/03/flutter-tame-those-textstyles.html
extension TextStyleHelpers on TextStyle {
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);
  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);

  TextStyle get color100 => copyWith(color: AppTheme.color100);
  TextStyle get color50 => copyWith(color: AppTheme.color50);
  TextStyle get color25 => copyWith(color: AppTheme.color25);
  TextStyle get color05 => copyWith(color: AppTheme.color05);

  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);

  TextStyle colored(Color value) => copyWith(color: value);

  TextStyle weight(FontWeight value) => copyWith(fontWeight: value);

  TextStyle size(double value) => copyWith(fontSize: value);

  TextStyle lineHeight(double value) => copyWith(height: value);

  TextStyle letterSpace(double value) => copyWith(letterSpacing: value);
}
