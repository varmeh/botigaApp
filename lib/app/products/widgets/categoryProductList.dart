import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import 'productTile.dart';

class CategoryProductList extends StatelessWidget {
  const CategoryProductList({
    Key key,
  }) : super(key: key);

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
            'Moong Dal * Whole Moong Dal * Moong Dal * Whole Moong Dal',
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          expanded: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductTile(),
              ProductTile(),
              ProductTile(),
            ],
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
