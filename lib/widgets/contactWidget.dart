import 'package:flutter/material.dart';

import 'buttons/index.dart' show WhatsappButton, CallButton;

class ContactWidget extends StatelessWidget {
  final String phone;
  final String whatsapp;
  final String whatsappMessage;

  ContactWidget({
    @required this.phone,
    @required this.whatsapp,
    this.whatsappMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: CallButton(number: phone)),
        SizedBox(width: 20),
        Expanded(
          child: WhatsappButton(
            number: whatsapp,
            message: whatsappMessage,
          ),
        )
      ],
    );
  }
}
