import 'package:flutter/material.dart';

import '../../shared/verifyOtpScreen.dart';
import '../../location/searchApartmentScreen.dart';
import '../../tabbar.dart';

class SignupOtpScreen extends StatelessWidget {
  static final route = 'signupOtp';

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = ModalRoute.of(context).settings.arguments;

    return VerifyOtpScreen(
      phone: phoneNumber,
      onVerification: (final json) {
        if (json['message'] == 'createUser') {
          Navigator.pushNamed(context, SearchApartmentScreen.route);
        } else {
          // TODO: save user information
          Navigator.pushNamed(context, Tabbar.route);
        }
      },
    );
  }
}
