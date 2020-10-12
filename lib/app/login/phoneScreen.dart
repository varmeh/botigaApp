import 'package:flutter/material.dart';

import '../../theme/index.dart';
import '../../widgets/botigaTextFieldForm.dart';

import 'widgets/background.dart';

class PhoneScreen extends StatelessWidget {
  final String title;

  PhoneScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Background(
      title: title,
      child: Form(
        child: Column(
          children: [
            textField(),
            formButton(),
          ],
        ),
      ),
    );
  }

  Padding textField() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      child: BotigaTextFieldForm(
        labelText: 'Phone Number',
        validator: (value) {
          if (value.isEmpty) {
            return 'Required';
          }
          return null;
        },
        keyboardType: TextInputType.number,
      ),
    );
  }

  Container formButton() {
    return Container(
      width: double.infinity,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8.0),
        ),
        onPressed: () {
          // Navigator.of(context)
          //     .pushNamed(SignUpOtp.routeName);
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
}
