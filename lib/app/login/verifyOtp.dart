import 'package:flutter/material.dart';

import '../../theme/index.dart';

import 'widgets/index.dart';

class VerifyOtpScreen extends StatefulWidget {
  static final route = 'otp';

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  GlobalKey<FormState> _form = GlobalKey();
  String pinValue = '';

  @override
  Widget build(BuildContext context) {
    return Background(
      title: 'Verify OTP',
      backNavigation: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              'Please enter OTP sent to your phone number 99999-99999',
              style: AppTheme.textStyle.w500.color100.size(15).lineHeight(1.3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Form(
              key: _form,
              child: PinTextField(
                pins: 6,
                onSaved: (val) => pinValue = val,
              ),
            ),
          ),
          formButton(),
        ],
      ),
    );
  }

  Container formButton() {
    return Container(
      width: double.infinity,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8.0),
        ),
        onPressed: () {
          if (_form.currentState.validate()) {
            _form.currentState.save(); //value saved in pinValue
          }
        },
        color: AppTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            'Verify',
            style: AppTheme.textStyle.w600
                .size(15.0)
                .lineHeight(1.5)
                .colored(AppTheme.backgroundColor),
          ),
        ),
      ),
    );
  }
}
