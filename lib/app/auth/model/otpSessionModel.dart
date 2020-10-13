import 'package:flutter/material.dart';

class OtpSessionModel {
  final String phone;
  final String sessionId;
  final Function onVerification;

  OtpSessionModel({
    @required this.phone,
    @required this.sessionId,
    @required this.onVerification,
  });
}
