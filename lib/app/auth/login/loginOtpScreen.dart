import 'package:flutter/material.dart';

import '../../shared/index.dart';

class LoginOtpScreen extends StatelessWidget {
  static final route = 'loginOtp';

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = ModalRoute.of(context).settings.arguments;

    return VerifyOtpScreen(
      phone: phoneNumber,
      onVerification: (_) {
        Navigator.of(context).pushNamed(
          SetPinScreen.route,
          arguments: 'Set PIN for faster login next time',
        );
      },
    );
  }
}
