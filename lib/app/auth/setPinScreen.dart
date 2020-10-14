import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../theme/index.dart';
import '../../widgets/index.dart';

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
    final String message = ModalRoute.of(context).settings.arguments;
    const sizedBox = SizedBox(height: 32);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppTheme.color100,
          ),
        ),
        title: Text(
          'Set PIN',
          style: AppTheme.textStyle.w600.color100.size(20).lineHeight(1.25),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          color: AppTheme.backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              sizedBox,
              Text(
                message,
                style: AppTheme.textStyle.w500.color50.size(13).lineHeight(1.5),
              ),
              sizedBox,
              pinTextField(),
              sizedBox,
              setPinButton(context),
            ],
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
        onPressed: () {
          if (_form.currentState.validate()) {
            _form.currentState.save(); //value saved in pinValue
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              builder: (context) {
                return setPinSuccessful(context);
              },
            );
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

  Widget setPinSuccessful(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16.0),
      topRight: const Radius.circular(16.0),
    );

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(left: 22, right: 22, top: 42),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Column(
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

              _controller.duration = composition.duration * 2;
              _controller.reset();
              _controller.forward();
            },
          ),
          SizedBox(height: 24.0),
          Text(
            'Pin Set Successfuly',
            style: AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
          ),
        ],
      ),
    );
  }

  void loadTabbarAfterAnimationCompletion(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Tabbar.route, (route) => false);
    }
  }
}
