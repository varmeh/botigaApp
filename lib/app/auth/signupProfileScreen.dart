import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/userProvider.dart';
import '../../theme/index.dart';
import '../../util/index.dart' show Http, Validations;
import '../../widgets/index.dart'
    show Toast, BotigaAppBar, LoaderOverlay, BotigaTextFieldForm, ActiveButton;

import '../tabbar.dart';

final Function(String) _nameValidator = (value) {
  if (value.isEmpty) {
    return 'Required';
  } else if (!value.isValidName()) {
    return 'Please use alphabets, space and dot only';
  }
  return null;
};

class SignupProfileScreen extends StatefulWidget {
  static final route = 'signupProfileForm';

  @override
  _SignupProfileScreenState createState() => _SignupProfileScreenState();
}

class _SignupProfileScreenState extends State<SignupProfileScreen> {
  FocusNode _firstFocusNode;
  FocusNode _lastFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _whatsappFocusNode;

  String _firstName;
  String _lastName;
  String _email;
  String _whatsapp;

  String _phoneNumber;

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
    _phoneNumber = ModalRoute.of(context).settings.arguments;

    return LoaderOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: BotigaAppBar('Sign Up'),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 32.0),
                  child: Text(
                    'Create account and access products from merchants delivering in your community',
                    style: AppTheme.textStyle.w500.color50
                        .size(13.0)
                        .lineHeight(1.5),
                  ),
                ),
                BotigaTextFieldForm(
                  focusNode: _firstFocusNode,
                  labelText: 'First Name',
                  onSave: (value) => _firstName = value,
                  nextFocusNode: _lastFocusNode,
                  validator: _nameValidator,
                ),
                sizedBox24,
                BotigaTextFieldForm(
                  focusNode: _lastFocusNode,
                  labelText: 'Last Name',
                  onSave: (value) => _lastName = value,
                  nextFocusNode: _emailFocusNode,
                  validator: _nameValidator,
                ),
                sizedBox24,
                BotigaTextFieldForm(
                  focusNode: _emailFocusNode,
                  labelText: 'Email',
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
                  keyboardType: TextInputType.datetime,
                  onSave: (_) =>
                      _whatsapp = _phoneMaskFormatter.getUnmaskedText(),
                  maskFormatter: _phoneMaskFormatter,
                  onChange: (_) {
                    if (_phoneMaskFormatter.getUnmaskedText().length == 10) {
                      // hide keyboard as there is no done button on number keyboard
                      FocusScope.of(context).unfocus();
                    }
                  },
                  validator: (_) {
                    if (_phoneMaskFormatter.getUnmaskedText().isEmpty) {
                      return null;
                    } else if (_phoneMaskFormatter.getUnmaskedText().length !=
                        10) {
                      return 'Please provide a valid 10 digit Mobile Number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    text: 'By signing up, you agree to all ',
                    style: AppTheme.textStyle
                        .size(13)
                        .lineHeight(1.5)
                        .w500
                        .color50,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: AppTheme.textStyle
                            .size(13)
                            .lineHeight(1.5)
                            .w500
                            .colored(AppTheme.primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            // Note: Don't use canLaunch(url). Fails on iOS devices
                            try {
                              await launch(
                                  'https://s3.ap-south-1.amazonaws.com/products.image.prod/termsAndConditions.pdf');
                            } catch (_) {
                              Toast(
                                message: 'Failed to open agreement in browser',
                              ).show(context);
                            }
                          },
                      ),
                    ],
                  ),
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
              title: 'Create Account',
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
        await Provider.of<UserProvider>(context, listen: false).signup(
          firstName: _firstName,
          lastName: _lastName,
          phone: _phoneNumber,
          whatsapp: _whatsapp,
          email: _email,
        );

        Navigator.pushNamed(
          context,
          Tabbar.route,
        );
      } catch (error) {
        Toast(message: Http.message(error)).show(context);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
