import 'package:flutter/material.dart';

import '../../../../models/index.dart' show CategoryModel, SellerModel;
import '../../../../theme/index.dart';
import 'productTile.dart';

class CategoryList extends StatelessWidget {
  final CategoryModel category;
  final SellerModel seller;
  final bool isLast;

  CategoryList({this.category, this.seller, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      accentColor: AppTheme.color100,
      dividerColor: Colors.transparent,
      unselectedWidgetColor: AppTheme.color100,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );

    final numberOfProducts = category.products.length;

    return Column(
      children: [
        Theme(
          data: theme,
          child: ListTileTheme(
            contentPadding: EdgeInsets.all(0),
            child: ExpansionTile(
              title: RichText(
                text: TextSpan(
                  text: numberOfProducts > 9
                      ? numberOfProducts.toString()
                      : '0${numberOfProducts.toString()}',
                  style: AppTheme.textStyle.w600.color50.size(12),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' ',
                      style: AppTheme.textStyle.letterSpace(20.0),
                    ),
                    TextSpan(
                      text: category.name.toUpperCase(),
                      style: AppTheme.textStyle.w600.color100
                          .size(14)
                          .letterSpace(1.0),
                    ),
                  ],
                ),
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(0.0),
                      width: 40.0,
                      child: Divider(
                        color: AppTheme.color100,
                        thickness: 1,
                      ),
                    ),
                    // List all the products
                    ...category.products.asMap().entries.map(
                          (entry) => ProductTile(
                            seller: seller,
                            product: entry.value,
                            lastTile: entry.key == numberOfProducts - 1,
                          ),
                        ),
                  ],
                )
              ],
            ),
          ),
        ),
        !this.isLast
            ? Divider(thickness: 1.0, color: AppTheme.dividerColor)
            : SizedBox.shrink()
      ],
    );
  }
}
