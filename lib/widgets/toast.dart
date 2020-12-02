import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../theme/index.dart';

class Toast {
  final String message;
  final Widget icon;
  final Color color;

  Toast({@required this.message, this.icon, this.color});

  void show(BuildContext context) {
    Flushbar(
      backgroundColor: color != null ? color : Color(0xff2591B2),
      messageText: Text(
        message,
        style:
            AppTheme.textStyle.colored(AppTheme.backgroundColor).w500.size(15),
      ),
      icon: icon != null
          ? icon
          : Icon(
              Icons.error_outline,
              size: 24,
              color: AppTheme.backgroundColor,
            ),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      borderRadius: 8,
    ).show(context);
  }
}
