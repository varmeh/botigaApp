import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../widgets/index.dart';

import 'background.dart';

class PhoneScreen extends StatefulWidget {
  final String title;
  final Function navigate;

  PhoneScreen({@required this.title, @required this.navigate});

  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  GlobalKey<FormState> _phoneFormKey;
  FocusNode _phoneFocusNode;
  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+91 #####-#####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _phoneFormKey = GlobalKey<FormState>();
    _phoneFocusNode = FocusNode();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
    );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
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
      child: Form(
        key: _phoneFormKey,
        child: BotigaTextFieldForm(
          focusNode: _phoneFocusNode,
          labelText: 'Phone Number',
          onSave: (_) {},
          keyboardType: TextInputType.number,
          onChange: (val) {
            if (_phoneMaskFormatter.getUnmaskedText().length == 10) {
              // hide keyboard as there is no done button on number keyboard
              FocusScope.of(context).unfocus();
            }
          },
          validator: (val) {
            if (_phoneMaskFormatter.getUnmaskedText().isEmpty) {
              return 'Required';
            } else if (_phoneMaskFormatter.getUnmaskedText().length != 10) {
              return 'Please provide a valid 10 digit Mobile Number';
            }
            return null;
          },
          maskFormatter: _phoneMaskFormatter,
        ),
      ),
    );
  }

  Widget formButton() {
    return FullWidthButton(
      title: 'Continue',
      onPressed: () {
        if (_phoneFormKey.currentState.validate()) {
          // Navigator.of(context)
          //     .pushNamed(SignUpOtp.routeName);
          widget.navigate(_phoneMaskFormatter.getUnmaskedText());
        }
      },
    );
  }
}
