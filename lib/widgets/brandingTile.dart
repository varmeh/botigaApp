import 'package:flutter/material.dart';

import '../theme/textTheme.dart'; // required to access extensions

class BrandingTile extends StatelessWidget {
  final String quote;
  final String message;

  BrandingTile(this.quote, this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            this.quote,
            style: TextStyles.montserrat.w800.color05.size(36),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            this.message,
            style: TextStyles.montserrat.w500.color25.size(13),
          )
        ],
      ),
    );
  }
}
