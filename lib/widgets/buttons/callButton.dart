import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'passiveButton.dart';
import '../../theme/index.dart';

class CallButton extends StatelessWidget {
  final String phone;
  final String title;

  CallButton({
    @required this.phone,
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
    final url = 'tel://$phone';
    if (await canLaunch(url)) {
      Future.delayed(Duration(milliseconds: 300), () async {
        await launch(url);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Phone Call Unsupported',
            style: AppTheme.textStyle.w500.color100,
          ),
          content: Text(
            'Phone call is not supported on this device',
            style: AppTheme.textStyle.w400.color100,
          ),
          actions: [
            FlatButton(
              child: Text(
                'Close',
                style: AppTheme.textStyle.w600.colored(AppTheme.primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
  }
}
