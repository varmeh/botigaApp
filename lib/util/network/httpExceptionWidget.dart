import 'dart:io';
import 'package:flutter/material.dart';

import 'httpExceptions.dart';

class HttpServiceExceptionWidget extends StatelessWidget {
  final exception;

  HttpServiceExceptionWidget(this.exception);

  Widget _exceptionMessage(String message) {
    return Center(
      child: Text(message),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (exception is SocketException) {
      return _exceptionMessage('No Internet connection 😑');
    } else if (exception is FormatException) {
      return _exceptionMessage('Bad response format 👎');
    } else if (exception is UanuthorizedException) {
      return _exceptionMessage(exception.toString());
    } else {
      return _exceptionMessage(exception.toString());
    }
  }
}
