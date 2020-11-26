import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show UserProvider, CartProvider;
import '../../util/index.dart';
import '../../theme/index.dart';
import '../../widgets/index.dart'
    show LoaderOverlay, PinTextField, ActiveButton, Toast;
import '../shared/background.dart';

import 'signupProfileScreen.dart';
import '../tabbar.dart';

class VerifyOtpScreen extends StatefulWidget {
  static final route = 'verifyOtp';

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  GlobalKey<FormState> _form = GlobalKey();
  String _otp = '';
  String _phoneNumber;

  Timer _timer;
  int _start = 30;
  bool _isloading = false;

  String _sessionId;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _phoneNumber = ModalRoute.of(context).settings.arguments;
      _getOtp();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 32);
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        return LoaderOverlay(
          isLoading: _isloading,
          child: Background(
            title: 'Verify OTP',
            child: SingleChildScrollView(
              child: Column(
                children: [
                  sizedBox,
                  Text(
                    'Please enter OTP sent to your phone number $_phoneNumber',
                    style: AppTheme.textStyle.w500.color100
                        .size(15)
                        .lineHeight(1.3),
                  ),
                  sizedBox,
                  otpForm(),
                  SizedBox(height: 12),
                  resendWidget(),
                  SizedBox(height: 16),
                  ActiveButton(
                    title: 'Verify',
                    onPressed: () {
                      if (_form.currentState.validate()) {
                        _form.currentState.save(); //value saved in _otp
                        _verifyOtp(provider);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Form otpForm() {
    return Form(
      key: _form,
      child: PinTextField(
        pins: 6,
        onSaved: (val) => _otp = val,
      ),
    );
  }

  StatelessWidget resendWidget() {
    return _start > 0
        ? Text(
            'Resend OTP in ${_start}s',
            style: AppTheme.textStyle.w500.color50.size(13).lineHeight(1.5),
          )
        : GestureDetector(
            onTap: () {
              _getOtp();
            },
            child: Text(
              'Resend OTP',
              style: AppTheme.textStyle.w500
                  .colored(AppTheme.primaryColor)
                  .size(13)
                  .lineHeight(1.5),
            ),
          );
  }

  void startTimer() {
    _start = 30;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) =>
          setState(() => _start < 1 ? _timer.cancel() : _start = _start - 1),
    );
  }

  void stopTimer() {
    setState(() => _start = 0);
  }

  Future<void> _getOtp() async {
    try {
      startTimer();
      final json = await Http.get('/api/user/auth/otp/$_phoneNumber');
      _sessionId = json['sessionId'];
    } catch (error) {
      stopTimer();

      Toast(message: Http.message(error)).show(context);
    }
  }

  Future<void> _verifyOtp(UserProvider provider) async {
    setState(() => _isloading = true);
    try {
      await provider.otpAuth(
        phone: _phoneNumber,
        sessionId: _sessionId,
        otp: _otp,
      );

      if (provider.isLoggedIn) {
        // Load user cart
        Provider.of<CartProvider>(context, listen: false).loadCartFromServer();
        Navigator.of(context).pushNamed(Tabbar.route);
      } else {
        Navigator.pushNamed(context, SignupProfileScreen.route,
            arguments: _phoneNumber);
      }
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    } finally {
      setState(() => _isloading = false);
    }
  }
}
