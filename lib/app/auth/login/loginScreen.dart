import 'package:flutter/material.dart';

import '../../shared/phoneScreen.dart';
import 'loginOtpScreen.dart';

class LoginScreen extends StatelessWidget {
  static final route = 'login';

  @override
  Widget build(BuildContext context) {
    return PhoneScreen(
      title: 'Login',
      navigate: (String phoneNumber) {
        Navigator.of(context).pushNamed(
          LoginOtpScreen.route,
          arguments: phoneNumber,
        );
      },
    );
  }
}
