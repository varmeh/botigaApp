import 'package:flutter/material.dart';

import '../../location/searchApartmentScreen.dart';
// import '../../shared/setPinScreen.dart';
import '../../tabbar.dart';

class SignupApartmentScreen extends StatelessWidget {
  static final route = 'signupApartment';

  @override
  Widget build(BuildContext context) {
    return SearchApartmentScreen(onSelection: () {
      Navigator.pushNamed(context, Tabbar.route);
    });
  }
}
