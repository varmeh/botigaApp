import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../theme/index.dart';

class OrderItemizedDetailsWidget extends StatelessWidget {
  const OrderItemizedDetailsWidget({
    Key key,
  }) : super(key: key);

  Widget _itemizedInfo(ThemeData themeData) {
    final _textStyle = themeData.textTheme.subtitle2.w400;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Basmati Atta',
              style: _textStyle,
            ),
          ),
          Expanded(
            child: Text(
              '2kg x 1',
              textAlign: TextAlign.end,
              style: _textStyle,
            ),
          ),
          Expanded(
            child: Text(
              '₹150',
              textAlign: TextAlign.end,
              style: _textStyle,
            ),
          ),
        ],
      ),
    );
  }

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
            tapBodyToCollapse: true,
          ),
          header: Text(
            "Details",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          // Collapsed Used to display a portion of expanded data
          // collapsed: Text(
          //   loremIpsum,
          //   softWrap: true,
          //   maxLines: 2,
          //   overflow: TextOverflow.ellipsis,
          // ),
          expanded: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _itemizedInfo(_themeData),
              _itemizedInfo(_themeData),
              _itemizedInfo(_themeData),
              _itemizedInfo(_themeData),
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
