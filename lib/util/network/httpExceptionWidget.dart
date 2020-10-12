import 'dart:io';
import 'package:flutter/material.dart';

import '../../widgets/lottieScreen.dart';

class HttpServiceExceptionWidget extends StatelessWidget {
  final exception;

  HttpServiceExceptionWidget(this.exception);

  @override
  Widget build(BuildContext context) {
    if (exception is SocketException) {
      return LottieScreen(
        json: 'assets/lotties/tower.json',
        message: 'Internet Unavailable',
        description:
            'We are unable to connect to network.\nPlease check your internet connection',
        buttonTitle: 'Retry',
        onTap: () {},
      );
    } else {
      return LottieScreen(
        json: 'assets/lotties/fish.json',
        message: 'Something went wrong',
        description:
            'Our teams are working hard to fix it.\nPlease try again after sometime',
        buttonTitle: 'Retry',
        onTap: () {},
      );
    }
  }
}
