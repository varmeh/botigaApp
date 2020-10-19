import 'package:flutter/material.dart';

import '../../shared/phoneScreen.dart';
import 'signupOtpScreen.dart';

class SignupWelcomeScreen extends StatelessWidget {
  static final route = 'welcome';

  @override
  Widget build(BuildContext context) {
    return PhoneScreen(
      title: 'Welcome to Botiga',
      navigate: (String phoneNumber) {
        Navigator.of(context)
            .pushNamed(SignupOtpScreen.route, arguments: phoneNumber);
      },
    );
  }
}
