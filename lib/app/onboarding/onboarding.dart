import 'package:flutter/material.dart';

import '../../widgets/index.dart' show ActiveButton;
import '../../theme/index.dart';

import '../auth/index.dart' show LoginScreen;
import '../location/index.dart' show SelectApartmenWhenNoUserLoggedInScreen;

class OnboardingScreen extends StatelessWidget {
  static const route = 'onboarding';
  final sizedBox24 = SizedBox(height: 24.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              // top: 64.0,
              left: 20.0,
              right: 20.0,
            ),
            child: _carousel(),
          ),
        ),
      ),
      bottomNavigationBar: _callToAction(context),
    );
  }

  Widget _carousel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/communities.png',
        ),
        sizedBox24,
        Text(
          'Buy amazing products sold in your community',
          textAlign: TextAlign.center,
          style: AppTheme.textStyle.w700.size(22.0).color100.lineHeight(1.3),
        ),
        sizedBox24,
        Text(
          'Explore awesome sellers in your community',
          textAlign: TextAlign.center,
          style: AppTheme.textStyle.w500.size(15.0).color50.lineHeight(1.3),
        ),
      ],
    );
  }

  Widget _callToAction(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 44.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ActiveButton(
              title: 'Select Your Community',
              width: 280.0,
              onPressed: () {
                Navigator.pushNamed(
                    context, SelectApartmenWhenNoUserLoggedInScreen.route);
              },
            ),
            sizedBox24,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Have an account?',
                  style: AppTheme.textStyle.w500.size(13.0).color50,
                ),
                SizedBox(width: 4),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.route);
                  },
                  child: Text(
                    'Login',
                    style: AppTheme.textStyle.w500
                        .size(13.0)
                        .colored(AppTheme.primaryColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
