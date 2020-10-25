import 'package:flutter/material.dart';

import '../../shared/verifyOtpScreen.dart';
import '../../tabbar.dart';
import './signupProfileScreen.dart';

class SignupOtpScreen extends StatelessWidget {
  static final route = 'signupOtp';

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = ModalRoute.of(context).settings.arguments;

    return VerifyOtpScreen(
      phone: phoneNumber,
      onVerification: (bool newUser) {
        if (newUser) {
          Navigator.pushNamed(context, SignupProfileScreen.route,
              arguments: phoneNumber);
        } else {
          Navigator.pushNamed(context, Tabbar.route);
        }
      },
    );
  }
}
