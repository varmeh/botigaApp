import 'package:botiga/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/botigaIcons.dart';
import 'passiveButton.dart';

class ContactWidget extends StatelessWidget {
  final String phone;
  final String whatsapp;

  ContactWidget({@required this.phone, @required this.whatsapp});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: PassiveButton(
            height: 44,
            icon: Icon(
              BotigaIcons.call,
              color: AppTheme.color100,
              size: 16,
            ),
            onPressed: () => _phone(context),
            title: 'Call',
          ),
        ),
        SizedBox(
          width: 13,
        ),
        Expanded(
          child: PassiveButton(
            height: 44,
            icon: Image.asset(
              'assets/images/whatsapp.png',
              width: 18,
              height: 18,
            ),
            onPressed: () => _whatsapp(context),
            title: 'Whatsapp',
          ),
        )
      ],
    );
  }

  void _phone(BuildContext context) async {
    final url = 'tel://$phone';
    if (await canLaunch(url)) {
      Future.delayed(Duration(milliseconds: 300), () async {
        await launch(url);
      });
    } else {
      _showDialogUrlNotSupported(
        context,
        'Phone Call Unsupported',
        'Phone call is not supported on this device',
      );
    }
  }

  void _whatsapp(BuildContext context) async {
    String url = 'whatsapp://send?phone=91$phone';
    if (await canLaunch(url)) {
      Future.delayed(Duration(milliseconds: 300), () async {
        await launch(url);
      });
    } else {
      _showDialogUrlNotSupported(
        context,
        'Whatsapp Missing',
        'Please download whatsapp to use this feature',
      );
    }
  }

  void _showDialogUrlNotSupported(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: AppTheme.textStyle.w500.color100,
        ),
        content: Text(
          message,
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
