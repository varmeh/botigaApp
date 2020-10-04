import 'package:botiga/models/index.dart';
import 'package:flutter/material.dart';

import '../../../../theme/index.dart';
import 'productSelectionButton.dart';

class CategoryList extends StatelessWidget {
  final CategoryModel category;
  final SellerModel seller;

  CategoryList(this.category, this.seller);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      accentColor: AppTheme.textColor100,
      dividerColor: Colors.transparent,
      unselectedWidgetColor: AppTheme.textColor100,
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
                  children: [
                    Divider(
                      color: AppTheme.textColor100,
                      thickness: 1,
                      indent: 0,
                      endIndent: 300,
                    ),
                    // List all the products
                    ...category.products.map((product) => _productTile(product))
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
        Divider(thickness: 1.0)
      ],
    );
  }

  Widget _productTile(ProductModel product) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTheme.textStyle.w500.color100
                      .lineHeight(1.35)
                      .size(15)
                      .letterSpace(1),
                ),
                Text(
                  product.size,
                  style:
                      AppTheme.textStyle.w500.color50.lineHeight(1.6).size(13),
                ),
                SizedBox(height: 3),
                Text(
                  '₹${product.price}',
                  style:
                      AppTheme.textStyle.w500.color100.lineHeight(1.6).size(13),
                ),
                SizedBox(height: 5),
                product.description != null
                    ? Text(
                        product.description,
                        style: AppTheme.textStyle.w500.color100
                            .lineHeight(1.3)
                            .letterSpace(0.2)
                            .size(12),
                      )
                    : Container()
              ],
            ),
          ),
          SizedBox(
            width: 100,
            height: 120,
            child: Stack(
              children: [
                product.imageUrl != null
                    ? Container(
                        width: 104.0,
                        height: 104.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(product.imageUrl),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      )
                    : Container(),
                Positioned(
                  bottom: product.imageUrl != null ? 0 : 40,
                  left: 10,
                  child: ProductSelectionButton(
                    seller: seller,
                    product: product,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
