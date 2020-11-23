import 'package:flutter/material.dart';

import '../../shared/index.dart';
import '../../tabbar.dart';

class LoginOtpScreen extends StatelessWidget {
  static final route = 'loginOtp';

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = ModalRoute.of(context).settings.arguments;

    return VerifyOtpScreen(
      phone: phoneNumber,
      onVerification: (_) {
        Navigator.of(context).pushNamed(Tabbar.route);
      },
    );
  }
}
