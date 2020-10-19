import 'package:flutter/material.dart';

import '../../location/searchApartmentScreen.dart';
import '../../shared/setPinScreen.dart';

class SignupApartmentScreen extends StatelessWidget {
  static final route = 'signupApartment';

  @override
  Widget build(BuildContext context) {
    return SearchApartmentScreen(onSelection: () {
      Navigator.pushNamed(context, SetPinScreen.route,
          arguments:
              'Last step! You are almost done. Going forward this 4-digit pin will be used to login.');
    });
  }
}
