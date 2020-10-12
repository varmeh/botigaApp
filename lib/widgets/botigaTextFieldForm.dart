import 'package:flutter/material.dart';

import '../theme/index.dart';

class BotigaTextFieldForm extends StatelessWidget {
  final String labelText;
  final Function(String) validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final int maxLines;
  final FocusNode nextFocusNode;

  BotigaTextFieldForm({
    @required this.labelText,
    @required this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.maxLines = 1,
    this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // showCursor: false,
      validator: validator,
      keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      onSaved: (val) => '',
      cursorColor: AppTheme.primaryColor,
      focusNode: focusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(nextFocusNode);
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone, color: AppTheme.color50),
        fillColor: AppTheme.backgroundColor,
        filled: true,
        labelText: labelText,
        labelStyle: AppTheme.textStyle.w500.color50.size(15.0).lineHeight(1.3),
        hintStyle: AppTheme.textStyle.w500
            // .size(15.0)
            // .lineHeight(1.3)
            .colored(Colors.orange),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: AppTheme.color25,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: AppTheme.color25,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: AppTheme.errorColor,
          ),
        ),
      ),
    );
  }
}
