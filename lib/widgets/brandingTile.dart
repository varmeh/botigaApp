import 'package:flutter/material.dart';

import '../util/index.dart'; // required to access extensions

class BrandingTile extends StatelessWidget {
  final String quote;
  final String message;

  BrandingTile(this.quote, this.message);

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            this.quote,
            style: _themeData.textTheme.headline1
                .colored(_themeData.disabledColor),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            this.message,
            style: _themeData.textTheme.caption
                .colored(_themeData.disabledColor.withOpacity(0.25)),
          )
        ],
      ),
    );
  }
}
