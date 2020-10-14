import 'package:botiga/app/auth/login/loginOtpScreen.dart';
import 'package:flutter/material.dart';

import '../../../widgets/index.dart';
import '../../../theme/index.dart';
import '../../tabbar.dart';

import '../widgets/index.dart';
import '../model/otpSessionModel.dart';
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

  Container continueButton() {
    return Container(
      width: double.infinity,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8.0),
        ),
        onPressed: () {
          if (_form.currentState.validate()) {
            _form.currentState.save(); //value saved in pinValue
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Tabbar.route, (route) => false);
          }
        },
        color: AppTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            'Continue',
            style: AppTheme.textStyle.w600
                .size(15.0)
                .lineHeight(1.5)
                .colored(AppTheme.backgroundColor),
          ),
        ),
      ),
    );
  }

  GestureDetector forgotButton(BuildContext context, String phoneNumber) {
    return GestureDetector(
      onTap: () {
        // TODO: api call for otp required
        Navigator.of(context).pushNamed(
          LoginOtpScreen.route,
          arguments: OtpSessionModel(
            phone: phoneNumber,
            sessionId: '0f91ca0f-9eac-4ce2-8bba-bb943e78d421',
          ),
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
