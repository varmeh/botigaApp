import 'package:flutter/material.dart';

import '../../../util/index.dart' show Http;
import '../../../widgets/index.dart' show Toast;
import '../../shared/index.dart' show ProfileFormScreen;
import '../../location/searchApartmentScreen.dart';

class SignupProfileScreen extends StatelessWidget {
  static final route = 'signupProfileForm';

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = ModalRoute.of(context).settings.arguments;

    return ProfileFormScreen(
      title: 'Sign Up',
      onPressed:
          (String firstName, String lastName, String whatsapp, String email) {
        print(phoneNumber);
        Http.post('/api/user/auth/signup', body: {
          'firstName': firstName,
          'lastName': lastName,
          'phone': phoneNumber,
          'whatsapp': whatsapp,
          'email': email,
        }, headers: {
          'x-mock-response-code': '201',
        }).then((_) {
          Navigator.pushNamed(
            context,
            SearchApartmentScreen.route,
          );
        }).catchError((error) {
          Toast(
            message: error,
            iconData: Icons.error_outline,
          ).show(context);
        });
      },
      buttonText: 'Create Account',
      description:
          'Create account and access products from merchants delivering in your community',
    );
  }
}
