import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/index.dart';

/*
 *	Params Explained
 *	- focusNode - Used to create a focus reference for a node
 *	- nextFocusNode - Pass the focus node value of the next text field
 */

class BotigaTextFieldForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String labelText;
  final Function(String) validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final int maxLines;
  final int maxLength;
  final FocusNode nextFocusNode;
  final Function(String) onFieldSubmitted;
  final TextEditingController textEditingController;
  final Function(String) onChange;
  final TextInputFormatter maskFormatter;

  BotigaTextFieldForm({
    @required this.formKey,
    @required this.focusNode,
    @required this.labelText,
    this.validator,
    this.maskFormatter,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.maxLines = 1,
    this.maxLength,
    this.nextFocusNode,
    this.onFieldSubmitted,
    this.textEditingController,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        // showCursor: false,
        inputFormatters: [maskFormatter],
        validator: validator,
        keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
        textInputAction: textInputAction,
        maxLines: maxLines,
        onSaved: (val) => '',
        cursorColor: AppTheme.primaryColor,
        focusNode: focusNode,
        maxLength: maxLength,
        controller: textEditingController,
        onFieldSubmitted: (value) {
          if (onFieldSubmitted != null) {
            onFieldSubmitted(value);
          }
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
        onChanged: onChange,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone, color: AppTheme.color50),
          fillColor: AppTheme.backgroundColor,
          filled: true,
          labelText: labelText,
          labelStyle:
              AppTheme.textStyle.w500.color50.size(15.0).lineHeight(1.3),
          errorStyle: AppTheme.textStyle.w400.colored(AppTheme.errorColor),
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
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.0,
              color: AppTheme.errorColor,
            ),
          ),
        ),
      ),
    );
  }
}
