import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

const loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit";

class OrderItemizedDetailsWidget extends StatelessWidget {
  const OrderItemizedDetailsWidget({
    Key key,
    @required ThemeData themeData,
  })  : _themeData = themeData,
        super(key: key);

  final ThemeData _themeData;

  @override
  Widget build(BuildContext context) {
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
          // collapsed: Text(
          //   loremIpsum,
          //   softWrap: true,
          //   maxLines: 2,
          //   overflow: TextOverflow.ellipsis,
          // ),
          expanded: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var _ in Iterable.generate(5))
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    loremIpsum,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ),
            ],
          ),
          builder: (_, collapsed, expanded) {
            return Container(
              // padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
