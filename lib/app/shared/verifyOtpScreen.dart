import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/userProvider.dart';
import '../../util/index.dart';
import '../../theme/index.dart';
import '../../widgets/index.dart'
    show LoaderOverlay, PinTextField, FullWidthButton, Toast;
import 'background.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phone;
  final Function onVerification;

  VerifyOtpScreen({
    @required this.phone,
    @required this.onVerification,
  });

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  GlobalKey<FormState> _form = GlobalKey();
  String _otp = '';

  Timer _timer;
  int _start;
  bool _verify = false;

  String _sessionId;

  @override
  void initState() {
    super.initState();
    getOtp();
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
        return FutureBuilder(
          future: _verify ? verifyOtp(provider) : null,
          builder: (context, snapshot) {
            return LoaderOverlay(
              isLoading: snapshot.connectionState == ConnectionState.waiting,
              child: Background(
                title: 'Verify OTP',
                backNavigation: true,
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
                      verifyButton(),
                    ],
                  ),
                ),
              ),
            );
          },
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
              getOtp();
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

  Widget verifyButton() {
    return FullWidthButton(
      title: 'Verify',
      onPressed: () {
        if (_form.currentState.validate()) {
          _form.currentState.save(); //value saved in _otp
          setState(() => _verify = true);
        }
      },
    );
  }

  Future<void> getOtp() async {
    try {
      startTimer();
      final json = await Http.get('/api/user/auth/otp/${widget.phone}');
      _sessionId = json['sessionId'];
    } catch (error) {
      stopTimer();

      Toast(message: Http.message(error)).show(context);
    }
  }

  Future<void> verifyOtp(UserProvider provider) async {
    try {
      await provider.otpAuth(
        phone: widget.phone,
        sessionId: _sessionId,
        otp: _otp,
      );
      widget
          .onVerification(provider.firstName == null); // null only for new user
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    } finally {
      setState(() => _verify = false);
    }
  }
}
