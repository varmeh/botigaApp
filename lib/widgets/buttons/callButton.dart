import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'passiveButton.dart';
import '../toast.dart';

import '../../theme/index.dart';

class CallButton extends StatelessWidget {
  final String number;
  final String title;

  CallButton({
    @required this.number,
    this.title = 'Call',
  });

  @override
  Widget build(BuildContext context) {
    return PassiveButton(
      height: 44,
      icon: Icon(
        BotigaIcons.call,
        color: AppTheme.color100,
        size: 16,
      ),
      onPressed: () => _phone(context),
      title: title,
    );
  }

  void _phone(BuildContext context) async {
    final url = 'tel://$number';
    if (await canLaunch(url)) {
      Future.delayed(Duration(milliseconds: 300), () async {
        await launch(url);
      });
    } else {
      Toast(
          message: 'Phone call is not supported on this device',
          icon: Icon(
            BotigaIcons.call,
            size: 24,
            color: AppTheme.backgroundColor,
          )).show(context);
    }
  }
}
