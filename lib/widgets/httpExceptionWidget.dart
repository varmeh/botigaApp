import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/index.dart' show UserProvider;

import 'lottieScreen.dart';

class HttpServiceExceptionWidget extends StatelessWidget {
  final Exception exception;
  final Function onTap;
  final String screenName;

  HttpServiceExceptionWidget({
    @required this.exception,
    @required this.onTap,
    @required this.screenName,
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
      Provider.of<UserProvider>(context, listen: false)
          .appException(exception, screenName);
      return LottieScreen(
        json: 'assets/lotties/fish.json',
        message: 'Something went wrong',
        description:
            'Our team is working hard to fix it.\nPlease try again after sometime',
        buttonTitle: 'Retry',
        onTap: onTap,
      );
    }
  }
}
