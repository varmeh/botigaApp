import 'package:flutter/material.dart';

import 'widgets/phoneScreen.dart';
import 'verifyOtp.dart';

class WelcomeScreen extends StatelessWidget {
  static final route = 'welcome';

  @override
  Widget build(BuildContext context) {
    return PhoneScreen(
      title: 'Welcome to Botiga',
      navigate: () {
        Navigator.of(context).pushNamed(VerifyOtpScreen.route);
      },
    );
  }
}
