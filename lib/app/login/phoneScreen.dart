import 'package:flutter/material.dart';

import '../../theme/index.dart';
import '../../widgets/botigaTextFieldForm.dart';

import 'widgets/background.dart';

class PhoneScreen extends StatefulWidget {
  final String title;

  PhoneScreen(this.title);

  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  GlobalKey<FormState> _phoneFormKey;
  FocusNode _phoneFocusNode;

  void _phoneListener() {
    if (!_phoneFocusNode.hasFocus) {
      _phoneFormKey.currentState.validate();
    }
  }

  @override
  void initState() {
    super.initState();
    _phoneFormKey = GlobalKey<FormState>();
    _phoneFocusNode = FocusNode();

    _phoneFocusNode.addListener(_phoneListener);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _phoneFocusNode.removeListener(_phoneListener);
    _phoneFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      title: widget.title,
      child: Column(
        children: [
          textField(),
          formButton(),
        ],
      ),
    );
  }

  Padding textField() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      child: BotigaTextFieldForm(
        formKey: _phoneFormKey,
        focusNode: _phoneFocusNode,
        labelText: 'Phone Number',
        validator: (value) {
          if (value.isEmpty) {
            return 'Required';
          } else if (value.length != 10) {
            return 'Phone number should have 10 digits';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        onChange: (val) {
          if (val.length == 10) {
            // hide keyboard as there is no done button on number keyboard
            FocusScope.of(context).unfocus();
          }
        },
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
          if (_phoneFormKey.currentState.validate()) {}
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
