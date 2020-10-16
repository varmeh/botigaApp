import 'package:flutter/material.dart';

import '../shared/index.dart' show ProfileFormScreen;

class ProfileUpdateScreen extends StatelessWidget {
  static final route = 'profileUpdate';

  @override
  Widget build(BuildContext context) {
    return ProfileFormScreen(
      title: 'Update Profile',
      onPressed: () {
        Navigator.pop(context);
      },
      description:
          'Create account and access products from Merchants delivering in your community',
    );
  }
}
