import 'package:flutter/material.dart';

import '../widgets/phoneScreen.dart';
import '../model/otpSessionModel.dart';
import 'signupOtpScreen.dart';

class WelcomeScreen extends StatelessWidget {
  static final route = 'welcome';

  @override
  Widget build(BuildContext context) {
    return PhoneScreen(
      title: 'Welcome to Botiga',
      navigate: (String phoneNumber) {
        Navigator.of(context).pushNamed(
          SignupOtpScreen.route,
          arguments: OtpSessionModel(
            phone: phoneNumber,
            sessionId: '0f91ca0f-9eac-4ce2-8bba-bb943e78d421',
          ),
        );
      },
    );
  }
}
