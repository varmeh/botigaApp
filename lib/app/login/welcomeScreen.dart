import 'package:flutter/material.dart';

import 'widgets/phoneScreen.dart';
import 'model/index.dart';
import 'verifyOtp.dart';

class WelcomeScreen extends StatelessWidget {
  static final route = 'welcome';

  @override
  Widget build(BuildContext context) {
    return PhoneScreen(
      title: 'Welcome to Botiga',
      navigate: () {
        Navigator.of(context).pushNamed(
          VerifyOtpScreen.route,
          arguments: OtpSessionModel(
            phone: '9910057232',
            sessionId: '0f91ca0f-9eac-4ce2-8bba-bb943e78d421',
          ),
        );
      },
    );
  }
}
