import 'package:botiga/app/profile/profileScreen.dart';
import 'package:flutter/material.dart';

import '../../../theme/index.dart';
import '../../../widgets/index.dart'
    show BotigaAppBar, BotigaTextFieldForm, FullWidthButton;

class UserFormScreen extends StatefulWidget {
  static final route = 'userForm';

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  FocusNode _firstNameFocusNode;
  FocusNode _lastNameFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _whatsappFocusNode;

  // GlobalKey<FormState> _firstNameFormKey;

  @override
  void initState() {
    super.initState();

    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _whatsappFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              Text(
                'Create account and access products from Merchants delivering in your community',
                style:
                    AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
              ),
              SizedBox(height: 32.0),
              BotigaTextFieldForm(
                formKey: null,
                focusNode: _firstNameFocusNode,
                labelText: 'First Name',
                onSave: null,
                nextFocusNode: _lastNameFocusNode,
              ),
              sizedBox24,
              BotigaTextFieldForm(
                formKey: null,
                focusNode: _lastNameFocusNode,
                labelText: 'Last Name',
                onSave: null,
                nextFocusNode: _emailFocusNode,
              ),
              sizedBox24,
              BotigaTextFieldForm(
                formKey: null,
                focusNode: _emailFocusNode,
                labelText: 'Email',
                onSave: null,
                nextFocusNode: _whatsappFocusNode,
              ),
              sizedBox24,
              BotigaTextFieldForm(
                formKey: null,
                focusNode: _whatsappFocusNode,
                labelText: 'Whatsapp Number',
                onSave: null,
              ),
              sizedBox24,
            ],
          ),
        ),
      ),
    );
  }
}
