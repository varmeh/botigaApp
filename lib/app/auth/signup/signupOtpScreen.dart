import 'package:flutter/material.dart';

import '../../shared/verifyOtpScreen.dart';
import '../model/otpSessionModel.dart';
import '../../location/locationPermissionModal.dart';

class SignupOtpScreen extends StatelessWidget {
  static final route = 'signupOtp';

  @override
  Widget build(BuildContext context) {
    final OtpSessionModel otpSessionModel =
        ModalRoute.of(context).settings.arguments;

    return VerifyOtpScreen(
      phone: otpSessionModel.phone,
      sessionId: otpSessionModel.sessionId,
      onVerification: () {
        LocationPermissionModal().show(context);
      },
    );
  }
}
