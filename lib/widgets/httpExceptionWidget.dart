import 'dart:io';

import 'package:flutter/material.dart';

import 'lottieScreen.dart';

class HttpServiceExceptionWidget extends StatelessWidget {
  final Exception exception;
  final Function onTap;

  HttpServiceExceptionWidget({
    @required this.exception,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (exception is SocketException) {
      return LottieScreen(
        json: 'assets/lotties/tower.json',
        message: 'Internet Unavailable',
        description:
            'We are unable to connect to network.\nPlease check your internet connection',
        buttonTitle: 'Retry',
        onTap: onTap,
      );
    } else {
      return LottieScreen(
        json: 'assets/lotties/fish.json',
        message: 'Something went wrong',
        description:
            'Our teams are working hard to fix it.\nPlease try again after sometime',
        buttonTitle: 'Retry',
        onTap: onTap,
      );
    }
  }
}
