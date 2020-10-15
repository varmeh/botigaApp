import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/index.dart';

/*
 *	This custom implementation has focus listener on each of the text field
 *
 *	Params Explained
 *	- formKey - Used to call validate & save methods of form
 *	- focusNode - Used to create a focus reference for a node
 *	- onSave - Returns the value in text field on submit
 *	- nextFocusNode - Pass the focus node value of the next text field
 */

class BotigaTextFieldForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
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

  BotigaTextFieldForm({
    @required this.formKey,
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
  });

  @override
  _BotigaTextFieldFormState createState() => _BotigaTextFieldFormState();
}

class _BotigaTextFieldFormState extends State<BotigaTextFieldForm> {
  void _focusListener() {
    if (!widget.focusNode.hasFocus) {
      if (widget.formKey.currentState.validate()) {
        widget.formKey.currentState.save();
      }
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

    return Form(
      key: widget.formKey,
      child: TextFormField(
        // showCursor: false,
        inputFormatters: inputFormatters,
        validator: widget.validator,
        keyboardType:
            widget.maxLines > 1 ? TextInputType.multiline : widget.keyboardType,
        style: AppTheme.textStyle.w500.color100.size(15.0).lineHeight(1.3),
        textInputAction: widget.textInputAction,
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
          prefixIcon: Icon(Icons.phone, color: AppTheme.color50),
          fillColor: AppTheme.backgroundColor,
          filled: true,
          labelText: widget.labelText,
          labelStyle:
              AppTheme.textStyle.w500.color50.size(15.0).lineHeight(1.3),
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
      ),
    );
  }
}
