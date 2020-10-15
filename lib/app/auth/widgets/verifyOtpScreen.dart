import 'dart:async';
import 'package:flutter/material.dart';

import '../../../theme/index.dart';
import '../../../widgets/index.dart';

import '../widgets/index.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phone;
  final String sessionId;
  final Function onVerification;

  VerifyOtpScreen({
    @required this.phone,
    @required this.sessionId,
    @required this.onVerification,
  });

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

    return Background(
      title: 'Verify OTP',
      backNavigation: true,
      child: Column(
        children: [
          sizedBox,
          Text(
            'Please enter OTP sent to your phone number ${widget.phone}',
            style: AppTheme.textStyle.w500.color100.size(15).lineHeight(1.3),
          ),
          sizedBox,
          otpForm(),
          SizedBox(height: 12),
          resendWidget(),
          SizedBox(height: 16),
          verifyButton(),
        ],
      ),
    );
  }

  Form otpForm() {
    return Form(
      key: _form,
      child: PinTextField(
        pins: 6,
        onSaved: (val) => pinValue = val,
      ),
    );
  }

  StatelessWidget resendWidget() {
    return _start > 0
        ? Text(
            'Resend OTP in ${_start}s',
            style: AppTheme.textStyle.w500.color50.size(13).lineHeight(1.5),
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

  Widget verifyButton() {
    return FullWidthButton(
      title: 'Verify',
      onPressed: () {
        if (_form.currentState.validate()) {
          _form.currentState.save(); //value saved in pinValue
          // TODO: verify pin

          widget.onVerification();
        }
      },
    );
  }
}
