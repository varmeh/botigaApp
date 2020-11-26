import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/index.dart';
import 'passiveButton.dart';
import 'botigaIconButton.dart';
import '../toast.dart';

class WhatsappButton extends StatelessWidget {
  final String number;
  final String title;
  final String message;
  final double width;

  WhatsappButton({
    @required this.number,
    this.title = 'Whatsapp',
    this.message = '',
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return PassiveButton(
      height: 44,
      width: width,
      icon: Image.asset(
        'assets/images/whatsapp.png',
        width: 18,
        height: 18,
      ),
      onPressed: () => whatsapp(context, number, message),
      title: title,
    );
  }
}

class WhatsappIconButton extends StatelessWidget {
  final String number;
  final String message;

  WhatsappIconButton({
    @required this.number,
    this.message = '',
  });

  @override
  Widget build(BuildContext context) {
    return BotigaIconButton(
      child: Image.asset(
        'assets/images/whatsapp.png',
        width: 18,
        height: 18,
      ),
      onPressed: () => whatsapp(context, number, message),
    );
  }
}

void whatsapp(BuildContext context, String number, String message) async {
  final _msg = message ?? '';
  String url =
      'whatsapp://send?phone=91$number&text=${Uri.encodeComponent(_msg)}';
  if (await canLaunch(url)) {
    Future.delayed(Duration(milliseconds: 300), () async {
      await launch(url);
    });
  } else {
    Toast(
      message: 'Please download whatsapp to use this feature',
      icon: Image.asset(
        'assets/images/whatsappOutline.png',
        width: 28.0,
        height: 28.0,
        color: AppTheme.backgroundColor,
      ),
    ).show(context);
  }
}
