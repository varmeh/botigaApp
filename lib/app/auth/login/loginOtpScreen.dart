import 'package:flutter/material.dart';

import '../widgets/index.dart';
import '../setPinScreen.dart';
import '../model/otpSessionModel.dart';

class LoginOtpScreen extends StatelessWidget {
  static final route = 'loginOtp';

  @override
  Widget build(BuildContext context) {
    final OtpSessionModel otpSessionModel =
        ModalRoute.of(context).settings.arguments;
    return VerifyOtpScreen(
      phone: otpSessionModel.phone,
      sessionId: otpSessionModel.sessionId,
      onVerification: () {
        Navigator.of(context).pushNamed(
          SetPinScreen.route,
          arguments: 'Set PIN for faster login next time',
        );
      },
    );
  }
}
