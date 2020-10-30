import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/index.dart';

/*
 *	This custom implementation has focus listener on each of the text field
 * 	to activate the autoValidation once user moves to another field
 *
 *	Params Explained
 *	- focusNode - Used to create a focus reference for a node
 *	- nextFocusNode - Pass the focus node value of the next text field
 *	- onSave - Returns the value in text field on submit
 *
 */

class BotigaTextFieldForm extends StatefulWidget {
  final FocusNode focusNode;
  final String labelText;
  final Function(String) onSave;
  final Function(String) validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final int maxLength;
  final FocusNode nextFocusNode;
  final Function(String) onFieldSubmitted;
  final TextEditingController textEditingController;
  final Function(String) onChange;
  final TextInputFormatter maskFormatter;
  final TextCapitalization textCapitalization;
  final IconData icon;
  final String initialValue;
  final double iconSize;
  final bool readOnly;

  BotigaTextFieldForm({
    @required this.focusNode,
    @required this.labelText,
    @required this.onSave,
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
    this.textCapitalization = TextCapitalization.words,
    this.icon,
    this.initialValue,
    this.iconSize = 25,
    this.readOnly = false,
  });

  @override
  _BotigaTextFieldFormState createState() => _BotigaTextFieldFormState();
}

class _BotigaTextFieldFormState extends State<BotigaTextFieldForm> {
  var _autoValidate = false;

  void _focusListener() {
    // Enable autovalidation once the user moves to the next field
    if (!widget.focusNode.hasFocus && !_autoValidate) {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusListener);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    widget.focusNode.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> inputFormatters = [];
    if (widget.maskFormatter != null) {
      inputFormatters.add(widget.maskFormatter);
    }

    return TextFormField(
      readOnly: widget.readOnly,
      autovalidateMode:
          _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
      inputFormatters: inputFormatters,
      textCapitalization: widget.textCapitalization,
      initialValue: widget.initialValue,
      validator: widget.validator,
      keyboardType:
          widget.maxLines > 1 ? TextInputType.multiline : widget.keyboardType,
      keyboardAppearance: MediaQuery.of(context).platformBrightness,
      style: AppTheme.textStyle.w500.color100.size(15.0).lineHeight(1.3),
      textInputAction: widget.nextFocusNode != null
          ? TextInputAction.next
          : widget.textInputAction,
      maxLines: widget.maxLines,
      onSaved: widget.onSave,
      cursorColor: AppTheme.primaryColor,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      controller: widget.textEditingController,
      onFieldSubmitted: (value) {
        if (widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted(value);
        }
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
      },
      onChanged: widget.onChange,
      decoration: InputDecoration(
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: AppTheme.color50, size: widget.iconSize)
            : null,
        fillColor:
            widget.readOnly ? AppTheme.dividerColor : AppTheme.backgroundColor,
        filled: true,
        labelText: widget.labelText,
        labelStyle: AppTheme.textStyle.w500.color50.size(15.0).lineHeight(1.3),
        errorStyle: AppTheme.textStyle.w400.colored(AppTheme.errorColor),
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
    );
  }
}
