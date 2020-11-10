import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'passiveButton.dart';
import '../../theme/index.dart';

class WhatsappButton extends StatelessWidget {
  final String phone;
  final String title;

  WhatsappButton({
    @required this.phone,
    this.title = 'Whatsapp',
  });

  @override
  Widget build(BuildContext context) {
    return PassiveButton(
      height: 44,
      icon: Image.asset(
        'assets/images/whatsapp.png',
        width: 18,
        height: 18,
      ),
      onPressed: () => _whatsapp(context),
      title: title,
    );
  }

  void _whatsapp(BuildContext context) async {
    String url = 'whatsapp://send?phone=91$phone';
    if (await canLaunch(url)) {
      Future.delayed(Duration(milliseconds: 300), () async {
        await launch(url);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Whatsapp Missing',
            style: AppTheme.textStyle.w500.color100,
          ),
          content: Text(
            'Please download whatsapp to use this feature',
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
