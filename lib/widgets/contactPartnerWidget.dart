import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'colorIconButton.dart';

class ContactPartnerWidget extends StatelessWidget {
  final String phone;
  final String whatsapp;

  final Color phoneIconColor;
  final Color whatsappIconColor;

  ContactPartnerWidget({
    @required this.phone,
    @required this.whatsapp,
    this.phoneIconColor = Colors.blue,
    this.whatsappIconColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ColorIconButton(
          icon: Icons.phone,
          color: this.phoneIconColor,
          onPressed: () => _phone(context),
        ),
        SizedBox(
          height: 20.0,
        ),
        ColorIconButton(
          icon: Icons.message,
          color: this.whatsappIconColor,
          onPressed: () => _whatsapp(context),
        ),
      ],
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
              title: Text(title),
              content: Text(message),
              actions: [
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
