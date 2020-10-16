import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../util/validationExtension.dart';
import '../../../theme/index.dart';
import '../../../widgets/index.dart'
    show BotigaAppBar, BotigaTextFieldForm, FullWidthButton;

final Function(String) _nameValidator = (value) {
  if (value.isEmpty) {
    return 'Required';
  } else if (!value.isValidName()) {
    return 'Please use alphabets, space and dot characters only';
  }
  return null;
};

class UserFormScreen extends StatefulWidget {
  static final route = 'userForm';

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  FocusNode _firstFocusNode;
  FocusNode _lastFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _whatsappFocusNode;

  GlobalKey<FormState> _formKey;

  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+91 #####-#####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();

    _firstFocusNode = FocusNode();
    _lastFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _whatsappFocusNode = FocusNode();

    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _firstFocusNode.dispose();
    _lastFocusNode.dispose();
    _emailFocusNode.dispose();
    _whatsappFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox24 = SizedBox(height: 24.0);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Sign Up'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              Text(
                'Create account and access products from Merchants delivering in your community',
                style:
                    AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
              ),
              SizedBox(height: 32.0),
              BotigaTextFieldForm(
                focusNode: _firstFocusNode,
                labelText: 'First Name',
                onSave: null,
                nextFocusNode: _lastFocusNode,
                validator: _nameValidator,
              ),
              sizedBox24,
              BotigaTextFieldForm(
                focusNode: _lastFocusNode,
                labelText: 'Last Name',
                onSave: null,
                nextFocusNode: _emailFocusNode,
                validator: _nameValidator,
              ),
              sizedBox24,
              BotigaTextFieldForm(
                focusNode: _emailFocusNode,
                labelText: 'Email',
                onSave: null,
                nextFocusNode: _whatsappFocusNode,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (!value.isValidEmail()) {
                    return 'Please enter a valid email id';
                  }
                  return null;
                },
              ),
              sizedBox24,
              BotigaTextFieldForm(
                focusNode: _whatsappFocusNode,
                labelText: 'Whatsapp Number',
                keyboardType: TextInputType.number,
                onSave: null,
                maskFormatter: _phoneMaskFormatter,
                onChange: (_) {
                  if (_phoneMaskFormatter.getUnmaskedText().length == 10) {
                    // hide keyboard as there is no done button on number keyboard
                    FocusScope.of(context).unfocus();
                  }
                },
                validator: (_) {
                  if (_phoneMaskFormatter.getUnmaskedText().isEmpty) {
                    return 'Required';
                  } else if (_phoneMaskFormatter.getUnmaskedText().length !=
                      10) {
                    return 'Please provide a valid 10 digit Mobile Number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 16.0,
        child: Container(
          color: AppTheme.backgroundColor,
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            bottom: 32.0,
          ),
          child: FullWidthButton(
            title: 'Create Account',
            onPressed: _onPressed,
          ),
        ),
      ),
    );
  }

  void _onPressed() {
    if (_formKey.currentState.validate()) {
      print('validated');
    }
  }
}
