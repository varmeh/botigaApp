import 'package:flutter/material.dart';

import '../../../util/index.dart' show Constants;
import 'productSelectionButton.dart';

class ProductTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Moong Dal',
              style:
                  _textTheme.subtitle1.merge(Constants.kTextStyleFontWeight700),
            ),
            ProductSelectionButton(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              '₹100',
              style:
                  _textTheme.subtitle2.merge(Constants.kTextStyleFontWeight600),
            ),
            SizedBox(
              width: 40,
            ),
            Text(
              '100gm',
              style:
                  _textTheme.subtitle2.merge(Constants.kTextStyleFontWeight600),
            ),
          ],
        ),
        ProductInfo(
            'Description - All you have got here is organic dal from farmer to fork'),
        ProductInfo('Ingredients'),
      ],
    );
  }
}

class ProductInfo extends StatelessWidget {
  final String title;

  ProductInfo(this.title);

  @override
  Widget build(BuildContext context) {
    return title.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              this.title,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .merge(Constants.kTextStyleFontWeight300),
            ),
          )
        : Container();
  }
}
