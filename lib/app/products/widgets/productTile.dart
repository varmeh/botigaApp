import 'package:flutter/material.dart';

import '../../../models/index.dart' show ProductModel;
import '../../../util/index.dart' show Constants;
import 'productSelectionButton.dart';

class ProductTile extends StatelessWidget {
  final ProductModel product;

  ProductTile(this.product);

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.name,
              style:
                  _textTheme.subtitle1.merge(Constants.kTextStyleFontWeight700),
            ),
            ProductSelectionButton(product),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              '₹${product.price.toString()}',
              style:
                  _textTheme.subtitle2.merge(Constants.kTextStyleFontWeight600),
            ),
            SizedBox(
              width: 40,
            ),
            Text(
              product.quantity,
              style:
                  _textTheme.subtitle2.merge(Constants.kTextStyleFontWeight600),
            ),
          ],
        ),
        _productInfo(context, product.description),
      ],
    );
  }

  Widget _productInfo(BuildContext context, String title) {
    return title != null && title.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .merge(Constants.kTextStyleFontWeight300),
            ),
          )
        : Container();
  }
}
