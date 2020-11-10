import 'package:flutter/material.dart';

import './buttons/index.dart' show WhatsappButton, CallButton;

class ContactWidget extends StatelessWidget {
  final String phone;
  final String whatsapp;

  ContactWidget({
    @required this.phone,
    @required this.whatsapp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: CallButton(phone: phone)),
        SizedBox(
          width: 13,
        ),
        Expanded(
          child: WhatsappButton(phone: phone),
        )
      ],
    );
  }
}
