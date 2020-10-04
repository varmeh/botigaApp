import 'dart:io';
import 'package:botiga/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/botigaIcons.dart';

class ContactPartnerWidget extends StatelessWidget {
  final String phone;
  final String whatsapp;

  ContactPartnerWidget({@required this.phone, @required this.whatsapp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 44,
              child: FlatButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                icon: Icon(
                  BotigaIcons.call,
                  color: AppTheme.textColor100,
                  size: 18,
                ),
                onPressed: () => _phone(context),
                color: AppTheme.dividerColor,
                label: Text(
                  'Call',
                  style: AppTheme.textStyle.w500.color100.size(15),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 13,
          ),
          Expanded(
            child: Container(
              height: 44,
              child: FlatButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                icon: Image.asset('assets/images/whatsapp.png'),
                onPressed: () => _whatsapp(context),
                color: AppTheme.dividerColor,
                label: Text(
                  'Whatsapp',
                  style: AppTheme.textStyle.w500.color100.size(15),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _phone(BuildContext context) async {
    final url = 'tel://$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showDialogUrlNotSupported(
        context,
        'Phone Call Unsupported',
        'Phone call is not supported on this device',
      );
    }
  }

  void _whatsapp(BuildContext context) async {
    String url = 'whatsapp://send?phone=$phone';
    if (await canLaunch(url)) {
      if (Platform.isIOS) {
        url = 'whatsapp://wa.me/$phone';
      }
      await launch(url);
    } else {
      _showDialogUrlNotSupported(
        context,
        'Whatsapp Missing',
        'Please download whatsapp to use this feature',
      );
    }
  }

  void _showDialogUrlNotSupported(
      BuildContext context, String title, String message) {
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
