import 'package:flutter/material.dart';

import '../widgets/index.dart';
import '../model/otpSessionModel.dart';

class SignupOtpScreen extends StatelessWidget {
  static final route = 'signupOtp';

  @override
  Widget build(BuildContext context) {
    final OtpSessionModel otpSessionModel =
        ModalRoute.of(context).settings.arguments;

    return VerifyOtpScreen(
      phone: otpSessionModel.phone,
      sessionId: otpSessionModel.sessionId,
      onVerification: () {},
    );
  }
}
