import 'package:flutter/material.dart';

import '../../shared/index.dart' show ProfileFormScreen, SetPinScreen;

class SignupProfileScreen extends StatelessWidget {
  static final route = 'signupProfileForm';

  @override
  Widget build(BuildContext context) {
    return ProfileFormScreen(
      title: 'Sign Up',
      onPressed: () {
        Navigator.pushNamed(
          context,
          SetPinScreen.route,
          arguments:
              'Last step! You are almost done. Going forward this 4-digit pin will be used to login.',
        );
      },
      description:
          'Create account and access products from Merchants delivering in your community',
    );
  }
}
