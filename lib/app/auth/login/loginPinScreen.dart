import 'package:botiga/app/auth/login/loginOtpScreen.dart';
import 'package:flutter/material.dart';

import '../../../widgets/index.dart';
import '../../../theme/index.dart';
import '../../tabbar.dart';

import '../../shared/background.dart';
import 'loginOtpScreen.dart';

class LoginPinScreen extends StatefulWidget {
  static final route = 'verifyPin';

  @override
  _LoginPinScreenState createState() => _LoginPinScreenState();
}

class _LoginPinScreenState extends State<LoginPinScreen> {
  GlobalKey<FormState> _form = GlobalKey();
  String pinValue = '';

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 32);
    final String phoneNumber = ModalRoute.of(context).settings.arguments;

    return Background(
      title: 'Enter PIN',
      backNavigation: true,
      child: Column(
        children: [
          sizedBox,
          Text(
            'Please enter your PIN to login',
            style: AppTheme.textStyle.w500.color100.size(15).lineHeight(1.3),
          ),
          sizedBox,
          pinTextField(),
          sizedBox,
          continueButton(),
          sizedBox,
          forgotButton(context, phoneNumber),
        ],
      ),
    );
  }

  Widget pinTextField() {
    return Form(
      key: _form,
      child: PinTextField(
        pins: 4,
        onSaved: (val) => pinValue = val,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }

  Widget continueButton() {
    return FullWidthButton(
      title: 'Continue',
      onPressed: () {
        if (_form.currentState.validate()) {
          _form.currentState.save(); //value saved in pinValue
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Tabbar.route, (route) => false);
        }
      },
    );
  }

  GestureDetector forgotButton(BuildContext context, String phoneNumber) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          LoginOtpScreen.route,
          arguments: phoneNumber,
        );
      },
      child: Text(
        'Forgot PIN?',
        style: AppTheme.textStyle.w600
            .colored(AppTheme.primaryColor)
            .size(15)
            .lineHeight(1.5),
      ),
    );
  }
}
