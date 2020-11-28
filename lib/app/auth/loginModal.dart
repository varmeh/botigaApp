import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../theme/index.dart';
import '../../widgets/index.dart'
    show BotigaBottomModal, ActiveButton, BotigaTextFieldForm;
import 'verifyOtpScreen.dart';

class LoginModal {
  BotigaBottomModal _bottomModal;
  GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();

  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+91 ##### #####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  void show(BuildContext context) {
    _bottomModal = _modal(context);
    _bottomModal.show(context);
  }

  BotigaBottomModal _modal(BuildContext context) {
    const sizedBox24 = SizedBox(height: 24);

    return BotigaBottomModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'That\' it...',
            style: AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
          ),
          SizedBox(height: 8.0),
          Text(
            'Login / Signup to place order',
            style: AppTheme.textStyle.w500.color100.size(15.0).lineHeight(1.3),
          ),
          sizedBox24,
          Form(
            key: _phoneFormKey,
            child: BotigaTextFieldForm(
              focusNode: null,
              labelText: 'Phone Number',
              onSave: (_) {},
              keyboardType: TextInputType.datetime,
              onFieldSubmitted: (_) => _onSubmitted(context),
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
          sizedBox24,
          ActiveButton(
            title: 'Continue',
            onPressed: () => _onSubmitted(context),
          ),
        ],
      ),
    );
  }

  void _onSubmitted(BuildContext context) {
    if (_phoneFormKey.currentState.validate()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(
            _phoneMaskFormatter.getUnmaskedText(),
          ),
        ),
      );
    }
  }
}
