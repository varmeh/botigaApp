import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../providers/userProvider.dart';
import '../../theme/index.dart';
import '../../util/index.dart' show Http, Validations;
import '../../widgets/index.dart'
    show Toast, BotigaAppBar, LoaderOverlay, BotigaTextFieldForm, ActiveButton;

final Function(String) _nameValidator = (value) {
  if (value.isEmpty) {
    return 'Required';
  } else if (!value.isValidName()) {
    return 'Please use alphabets, space and dot only';
  }
  return null;
};

class ProfileUpdateScreen extends StatefulWidget {
  static final route = 'profileUpdate';

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  UserProvider _provider;
  FocusNode _firstFocusNode;
  FocusNode _lastFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _whatsappFocusNode;

  String _firstName;
  String _lastName;
  String _email;
  String _whatsapp;

  bool _isLoading = false;

  GlobalKey<FormState> _formKey;

  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+91 ##### #####',
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
    _provider = Provider.of<UserProvider>(context);

    return LoaderOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: BotigaAppBar('Update Profile'),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                SizedBox(height: 32.0),
                BotigaTextFieldForm(
                  focusNode: _firstFocusNode,
                  labelText: 'First Name',
                  initialValue: _provider.firstName,
                  onSave: (value) => _firstName = value,
                  nextFocusNode: _lastFocusNode,
                  validator: _nameValidator,
                ),
                sizedBox24,
                BotigaTextFieldForm(
                  focusNode: _lastFocusNode,
                  labelText: 'Last Name',
                  initialValue: _provider.lastName,
                  onSave: (value) => _lastName = value,
                  nextFocusNode: _emailFocusNode,
                  validator: _nameValidator,
                ),
                sizedBox24,
                BotigaTextFieldForm(
                  focusNode: _emailFocusNode,
                  labelText: 'Email',
                  initialValue: _provider.email,
                  onSave: (value) => _email = value,
                  nextFocusNode: _whatsappFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value.isEmpty) {
                      // Email is optional
                      return null;
                    } else if (!value.isValidEmail()) {
                      return 'Please enter a valid email id';
                    }
                    return null;
                  },
                ),
                sizedBox24,
                BotigaTextFieldForm(
                  focusNode: _whatsappFocusNode,
                  labelText: 'Whatsapp Number',
                  initialValue:
                      _phoneMaskFormatter.maskText('91${_provider.whatsapp}'),
                  keyboardType: TextInputType.datetime,
                  onSave: (value) =>
                      _whatsapp = _phoneMaskFormatter.unmaskText(value),
                  maskFormatter: _phoneMaskFormatter,
                  onChange: (_) {
                    if (_phoneMaskFormatter.getUnmaskedText().length == 10) {
                      // hide keyboard as there is no done button on number keyboard
                      FocusScope.of(context).unfocus();
                    }
                  },
                  validator: (value) {
                    if (_phoneMaskFormatter.unmaskText(value).isEmpty) {
                      return 'Required';
                    } else if (_phoneMaskFormatter.unmaskText(value).length !=
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
            child: ActiveButton(
              title: 'Update',
              onPressed: _onPressed,
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() => _isLoading = true);
      try {
        await _provider.updateProfile(
          firstName: _firstName,
          lastName: _lastName,
          whatsapp: _whatsapp,
          email: _email,
        );
        Navigator.of(context).pop();
      } catch (error) {
        Toast(message: Http.message(error)).show(context);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
