import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../theme/index.dart';
import '../../widgets/index.dart'
    show LoaderOverlay, BotigaAppBar, BotigaBottomModal, PinTextField, Toast;
import '../../util/index.dart' show Http;

import '../tabbar.dart';

class SetPinScreen extends StatefulWidget {
  static final route = 'setPin';

  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen>
    with TickerProviderStateMixin {
  GlobalKey<FormState> _form = GlobalKey();
  String pinValue = '';
  AnimationController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener(loadTabbarAfterAnimationCompletion);
  }

  @override
  void dispose() {
    _controller.removeStatusListener(loadTabbarAfterAnimationCompletion);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String message = ModalRoute.of(context).settings.arguments ?? '';
    const sizedBox = SizedBox(height: 32);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Set PIN'),
      body: LoaderOverlay(
        isLoading: _isLoading,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                sizedBox,
                Text(
                  message,
                  style:
                      AppTheme.textStyle.w500.color50.size(13).lineHeight(1.5),
                ),
                sizedBox,
                pinTextField(),
                sizedBox,
                setPinButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pinTextField() {
    return Form(
      key: _form,
      child: PinTextField(
        pins: 4,
        onSaved: (val) => pinValue = val,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }

  Container setPinButton(BuildContext context) {
    return Container(
      width: 160,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8.0),
        ),
        onPressed: () async {
          if (_form.currentState.validate()) {
            _form.currentState.save(); //value saved in pinValue

            setState(() => _isLoading = true);
            try {
              await Http.patch('/api/user/auth/pin', body: {'pin': pinValue});
              BotigaBottomModal(
                isDismissible: false,
                child: setPinSuccessful(),
              ).show(context);
            } catch (error) {
              Toast(message: Http.message(error)).show(context);
            } finally {
              setState(() => _isLoading = false);
            }
          }
        },
        color: AppTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            'Set Pin',
            style: AppTheme.textStyle.w600
                .size(15.0)
                .lineHeight(1.5)
                .colored(AppTheme.backgroundColor),
          ),
        ),
      ),
    );
  }

  Widget setPinSuccessful() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lotties/checkSuccess.json',
          width: 160.0,
          height: 160.0,
          fit: BoxFit.fill,
          controller: _controller,
          onLoaded: (composition) {
            // Configure the AnimationController with the duration of the
            // Lottie file and start the animation.

            _controller.duration = composition.duration;
            _controller.reset();
            _controller.forward();
          },
        ),
        SizedBox(height: 42.0),
        Text(
          'Pin Set Successfuly',
          style: AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
        ),
        SizedBox(height: 64.0),
      ],
    );
  }

  void loadTabbarAfterAnimationCompletion(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Tabbar.route, (route) => false);
    }
  }
}
