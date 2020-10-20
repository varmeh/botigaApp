import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

import '../theme/index.dart';

class Toast {
  final String message;
  final IconData iconData;

  Toast({@required this.message, this.iconData = Icons.error_outline});

  void show(BuildContext context) {
    Flushbar(
      maxWidth: 335,
      backgroundColor: Color(0xff2591B2),
      messageText: Text(
        message,
        style:
            AppTheme.textStyle.colored(AppTheme.backgroundColor).w500.size(15),
      ),
      icon: Icon(iconData, size: 30, color: AppTheme.backgroundColor),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      borderRadius: 8,
    ).show(context);
  }
}
