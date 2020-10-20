import 'package:botiga/app/auth/login/loginOtpScreen.dart';
import 'package:flutter/material.dart';

import '../../../util/index.dart' show Http;
import '../../../widgets/index.dart'
    show LoaderOverlay, PinTextField, FullWidthButton, Toast;
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
  String _pinValue = '';
  String _phoneNumber = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 32);
    _phoneNumber = ModalRoute.of(context).settings.arguments;

    return Background(
      title: 'Enter PIN',
      backNavigation: true,
      child: LoaderOverlay(
        isLoading: _isLoading,
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
            forgotButton(context, _phoneNumber),
          ],
        ),
      ),
    );
  }

  Widget pinTextField() {
    return Form(
      key: _form,
      child: PinTextField(
        pins: 4,
        onSaved: (val) => _pinValue = val,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }

  Widget continueButton() {
    return FullWidthButton(
      title: 'Continue',
      onPressed: () async {
        if (_form.currentState.validate()) {
          _form.currentState.save(); //value saved in _pinValue
          setState(() => _isLoading = true);
          try {
            await Http.post('/api/user/auth/sigin/pin', body: {
              'phone': _phoneNumber,
              'pin': _pinValue,
            }, headers: {
              'x-mock-response-code': '200',
            });

            Navigator.of(context)
                .pushNamedAndRemoveUntil(Tabbar.route, (route) => false);
          } catch (error) {
            Toast(message: Http.message(error)).show(context);
          } finally {
            setState(() => _isLoading = false);
          }
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
