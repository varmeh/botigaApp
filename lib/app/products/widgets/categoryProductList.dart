import 'package:botiga/models/productModel.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import 'productTile.dart';

class CategoryProductList extends StatelessWidget {
  final List<ProductModel> products;

  CategoryProductList(this.products);

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
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
            style: Theme.of(context).textTheme.bodyText2,
          ),
          // Collapsed Used to display a portion of expanded data
          collapsed: Text(
            products.map((product) => product.name).join(' - '),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          expanded: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: products.map((product) => ProductTile(product)).toList(),
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
}
