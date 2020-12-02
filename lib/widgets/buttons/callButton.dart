import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/index.dart';
import '../toast.dart';
import 'botigaIconButton.dart';
import 'passiveButton.dart';

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
        onPressed: () => callToNumber(context, number),
        title: title);
  }
}

class CallIconButton extends StatelessWidget {
  final String number;

  CallIconButton({@required this.number});

  @override
  Widget build(BuildContext context) {
    return BotigaIconButton(
      child: Icon(
        BotigaIcons.call,
        color: AppTheme.color100,
        size: 16,
      ),
      onPressed: () => callToNumber(context, number),
    );
  }
}

void callToNumber(BuildContext context, String number) async {
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
        size: 18,
        color: AppTheme.backgroundColor,
      ),
    ).show(context);
  }
}
