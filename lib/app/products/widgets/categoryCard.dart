import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../util/index.dart' show Constants;
import '../../../models/index.dart'
    show SellerModel, CategoryModel, ProductModel;
import 'productSelectionButton.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final SellerModel store;

  CategoryCard({@required this.category, @required this.store});

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    return ExpandableNotifier(
      child: Card(
        child: Container(
          padding: Constants.kEdgeInsetsCard,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.category,
                    style: _textTheme.headline6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      category.products.length.toString(),
                      style: _textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              _productList(context),
            ],
          ),
        ),
      ),
    );
  }

  // List of all products in a category
  Widget _productList(BuildContext context) {
    final _themeData = Theme.of(context);
    final _products = category.products;
    return ScrollOnExpand(
      scrollOnExpand: true,
      scrollOnCollapse: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: _themeData.dividerColor),
          ),
        ),
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            tapBodyToCollapse: false,
          ),
          header: Text(
            'Click to select products',
            style: _themeData.textTheme.bodyText2,
          ),
          // Collapsed Used to display a portion of expanded data
          collapsed: Text(
            _products.map((product) => product.name).join(' - '),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          expanded: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _products
                .map((product) => _productTile(context, product))
                .toList(),
          ),
          builder: (_, collapsed, expanded) {
            return Container(
              child: Expandable(
                collapsed: collapsed,
                expanded: expanded,
                theme: const ExpandableThemeData(crossFadePoint: 0),
              ),
            );
          },
        ),
      ),
    );
  }

  // UI for each product in a category
  Widget _productTile(BuildContext context, ProductModel product) {
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
            ProductSelectionButton(
              store: store,
              product: product,
            ),
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
