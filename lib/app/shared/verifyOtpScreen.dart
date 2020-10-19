import 'dart:async';
import 'package:botiga/widgets/toast.dart';
import 'package:flutter/material.dart';

import '../../util/index.dart';
import '../../theme/index.dart';
import '../../widgets/index.dart';
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
  String _pinValue = '';

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
    return FutureBuilder(
      future: _verify ? getOtp() : null,
      builder: (context, snapshot) {
        return Stack(
          children: [
            Background(
              title: 'Verify OTP',
              backNavigation: true,
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
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: Loader(),
                  )
                : Container()
          ],
        );
      },
    );
  }

  Form otpForm() {
    return Form(
      key: _form,
      child: PinTextField(
        pins: 6,
        onSaved: (val) => _pinValue = val,
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

  Widget verifyButton() {
    return FullWidthButton(
      title: 'Verify',
      onPressed: () {
        if (_form.currentState.validate()) {
          _form.currentState.save(); //value saved in _pinValue

          Http.post('/api/user/auth/otp/verify', body: {
            'phone': widget.phone,
            'sessionId': _sessionId,
            'otpVal': _pinValue,
          }, headers: {
            'x-mock-response-code': '201',
          }).then((value) {
            widget.onVerification(value);
          }).catchError((error) {
            print(error);
            Toast(
              message: 'OTP verification failed. Try again',
              iconData: Icons.error_outline,
            ).show(context);
          });
        }
      },
    );
  }

  Future<void> getOtp() async {
    try {
      startTimer();
      final json = await Http.get('/api/user/auth/otp/9910057231');
      _sessionId = json['sessionId'];
    } catch (error) {
      setState(() {
        _start = 0;
      });

      Toast(
        message: error,
        iconData: Icons.error_outline,
      ).show(context);
    }
  }
}
