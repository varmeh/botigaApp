import 'package:flutter/material.dart';

import 'widgets/phoneScreen.dart';

class LoginScreen extends StatelessWidget {
  static final route = 'login';

  @override
  Widget build(BuildContext context) {
    return PhoneScreen(
      title: 'Login',
      navigate: () {},
    );
  }
}
