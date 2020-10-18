import 'package:flutter/material.dart';

import '../../shared/verifyOtpScreen.dart';
import '../../location/locationPermissionModal.dart';

class SignupOtpScreen extends StatelessWidget {
  static final route = 'signupOtp';

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = ModalRoute.of(context).settings.arguments;

    return VerifyOtpScreen(
      phone: phoneNumber,
      onVerification: () {
        LocationPermissionModal().show(context);
      },
    );
  }
}
