import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show UserProvider, CartProvider, AuthUtil;
import '../../theme/index.dart';
import '../../util/index.dart';
import '../../widgets/index.dart'
    show LoaderOverlay, PinTextField, ActiveButton, Toast;
import '../shared/background.dart';
import '../tabbar.dart';
import 'signupProfileScreen.dart';

class VerifyOtpScreen extends StatefulWidget {
  static final route = 'verifyOtp';

  final String phone;

  VerifyOtpScreen(this.phone);

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  GlobalKey<FormState> _form = GlobalKey();
  String _otp = '';

  Timer _timer;
  int _start = 30;
  bool _isloading = false;

  String _sessionId;

  @override
  void initState() {
    super.initState();
    _getOtp();
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
                    'Please enter OTP sent to your phone number ${widget.phone}',
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
            behavior: HitTestBehavior.opaque,
            onTap: () => _getOtp(),
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
      final json = await Http.get('/api/user/auth/otp/${widget.phone}');
      _sessionId = json['sessionId'];
    } catch (error) {
      stopTimer();

      Toast(message: Http.message(error)).show(context);
    }
  }

  Future<void> _verifyOtp(UserProvider provider) async {
    setState(() => _isloading = true);
    try {
      await AuthUtil.verifyOtp(
        context: context,
        phone: widget.phone,
        sessionId: _sessionId,
        otp: _otp,
      );

      if (provider.isLoggedIn) {
        if (Provider.of<CartProvider>(context, listen: false).isEmpty) {
          // Cart is empty
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Tabbar(index: 0),
              transitionDuration: Duration.zero,
            ),
            (route) => false,
          );
        } else {
          // User has browsed in non-login state & selected a few items for checkout
          // Direct him to cart screen
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Tabbar(index: 2),
              transitionDuration: Duration.zero,
            ),
            (route) => false,
          );
        }
      } else {
        Navigator.pushNamed(context, SignupProfileScreen.route,
            arguments: widget.phone);
      }
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    } finally {
      setState(() => _isloading = false);
    }
  }
}
