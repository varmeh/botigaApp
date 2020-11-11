import 'package:flutter/material.dart';

import '../../../util/index.dart' show KeyStore;
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
          KeyStore.setFirstRun()
              .whenComplete(() => Navigator.pushNamed(context, Tabbar.route));
        }
      },
    );
  }
}
