import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show UserProvider, CartProvider;
import '../../theme/index.dart';
import '../../util/index.dart' show KeyStore;
import '../tabbar.dart';

import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  static final route = 'splashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  bool _animationCompleted = false;
  bool _loadingComplete = false;
  bool _hasProfile = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener(loadNextScreen);

    Future.delayed(Duration(milliseconds: 100), () => _getProfile());
  }

  @override
  void dispose() {
    _controller.removeStatusListener(loadNextScreen);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingComplete && _animationCompleted) {
      String next;
      if (KeyStore.shared.firstRun) {
        next = OnboardingScreen.route;
      } else {
        next = Tabbar.route;
        if (_hasProfile) {
          // Get User Cart
          Provider.of<CartProvider>(context, listen: false)
              .loadCartFromServer();
        }
      }
      Future.delayed(Duration.zero,
          () => Navigator.of(context).pushReplacementNamed(next));
    }

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Lottie.asset(
          'assets/lotties/splashScreen.json',
          repeat: false,
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
      ),
    );
  }

  Future<void> _getProfile() async {
    try {
      await Provider.of<UserProvider>(context, listen: false).getProfile();
      _hasProfile = true;
    } catch (_) {} finally {
      setState(() => _loadingComplete = true);
    }
  }

  void loadNextScreen(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() => _animationCompleted = true);
    }
  }
}
