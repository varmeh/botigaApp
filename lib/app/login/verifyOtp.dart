import 'dart:async';
import 'package:flutter/material.dart';

import '../../theme/index.dart';

import 'widgets/index.dart';
import 'model/otpSessionModel.dart';

class VerifyOtpScreen extends StatefulWidget {
  static final route = 'otp';

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  GlobalKey<FormState> _form = GlobalKey();
  String pinValue = '';

  Timer _timer;
  int _start;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 32);
    final OtpSessionModel otpSessionModel =
        ModalRoute.of(context).settings.arguments;

    return Background(
      title: 'Verify OTP',
      backNavigation: true,
      child: Column(
        children: [
          sizedBox,
          Text(
            'Please enter OTP sent to your phone number ${otpSessionModel.phone}',
            style: AppTheme.textStyle.w500.color100.size(15).lineHeight(1.3),
          ),
          sizedBox,
          Form(
            key: _form,
            child: PinTextField(
              pins: 6,
              onSaved: (val) => pinValue = val,
            ),
          ),
          SizedBox(height: 12),
          _start > 0
              ? Text(
                  'Resend OTP in ${_start}s',
                  style:
                      AppTheme.textStyle.w500.color50.size(13).lineHeight(1.5),
                )
              : GestureDetector(
                  onTap: () {
                    startTimer();
                  },
                  child: Text(
                    'Resend OTP',
                    style: AppTheme.textStyle.w500
                        .colored(AppTheme.primaryColor)
                        .size(13)
                        .lineHeight(1.5),
                  ),
                ),
          SizedBox(height: 16),
          formButton(),
        ],
      ),
    );
  }

  void startTimer() {
    _start = 30;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) =>
          setState(() => _start < 1 ? _timer.cancel() : _start = _start - 1),
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
