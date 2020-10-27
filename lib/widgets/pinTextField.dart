import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../theme/index.dart';

class PinTextField extends StatelessWidget {
  final int pins;
  final Function(String) onSaved;
  final MainAxisAlignment mainAxisAlignment;

  PinTextField({
    @required this.pins,
    @required this.onSaved,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: pins,
      obscureText: false,
      animationType: AnimationType.fade,
      mainAxisAlignment: mainAxisAlignment,
      keyboardType: TextInputType.number,
      keyboardAppearance: MediaQuery.of(context).platformBrightness,
      textStyle: AppTheme.textStyle.w500.color50.size(20.0).lineHeight(1.25),
      pastedTextStyle:
          AppTheme.textStyle.w500.color50.size(20.0).lineHeight(1.25),
      cursorColor: AppTheme.color50,
      cursorHeight: 20.0,
      autoFocus: true,
      validator: (value) {
        if (value.isEmpty) {
          return 'Required';
        } else if (value.length != pins) {
          return 'Please enter values in all pins';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.disabled,
      enableActiveFill: true, // required to set pin colors
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: 50,
        fieldWidth: 40,
        borderWidth: 0.0,
        activeFillColor: AppTheme.color05,
        inactiveFillColor: AppTheme.color05,
        selectedFillColor: AppTheme.color05,
        activeColor: AppTheme.color05,
        inactiveColor: AppTheme.color05,
        selectedColor: AppTheme.color05,
      ),
      animationDuration: Duration(milliseconds: 200),
      // errorAnimationController: _errorController,
      // controller: textEditingController,
      onChanged: (_) {},
      onCompleted: (_) {},
      onSaved: onSaved,
      beforeTextPaste: (text) {
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
    );
  }
}
