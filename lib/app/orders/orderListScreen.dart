import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../util/index.dart' show Constants;

class OrderListScreen extends StatefulWidget {
  OrderListScreen({Key key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  Widget build(BuildContext context) {
    return ExpandableTheme(
      data: ExpandableThemeData(
        // iconColor: Theme.of(context).primaryColor,
        useInkWell: true,
      ),
      child: ListView.builder(
        itemCount: 5,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Card1();
        },
      ),
    );
  }
}

enum _DeliveryStatus { pending, outfordelivery, delivered, cancelled }

class _DeliveryData {
  final String message;
  final IconData iconData;
  final Color iconColor;

  _DeliveryData(this.message, this.iconData, this.iconColor);
}

class OrderDetailsWidget extends StatelessWidget {
  static Map<_DeliveryStatus, _DeliveryData> _deliveryInfo = {
    _DeliveryStatus.pending:
        _DeliveryData('Pending', Icons.hourglass_empty, Colors.orange),
    _DeliveryStatus.outfordelivery:
        _DeliveryData('Out For Delivery', Icons.directions_bike, Colors.green),
    _DeliveryStatus.cancelled:
        _DeliveryData('Cancelled', Icons.highlight_off, Colors.red),
    _DeliveryStatus.delivered:
        _DeliveryData('Delivered', Icons.check_circle, Colors.green),
  };

  Widget _deliveryStatus(TextTheme textTheme, _DeliveryStatus status) {
    return Row(
      children: [
        Text(
          _deliveryInfo[status].message,
          style: textTheme.bodyText2,
        ),
        SizedBox(
          width: 3,
        ),
        Icon(
          _deliveryInfo[status].iconData,
          size: 16,
          color: _deliveryInfo[status].iconColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    final _sizedBox = SizedBox(
      height: 15,
    );

    return Padding(
      padding: const EdgeInsets.only(
          top: 25.0, left: 15.0, right: 15.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '24 Mantra',
                style: _textTheme.subtitle1
                    .merge(Constants.kTextStyleFontWeight700),
              ),
              _deliveryStatus(_textTheme, _DeliveryStatus.outfordelivery),
            ],
          ),
          _sizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Aug 26, 2020', style: _textTheme.bodyText2),
              // Text('Order Id #123456', style: _textTheme.bodyText2),
              Text('₹300', style: _textTheme.bodyText2),
            ],
          ),
        ],
      ),
    );
  }
}

const loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit";

class Card1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);

    return ExpandableNotifier(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          child: Column(
            children: [
              OrderDetailsWidget(),
              ScrollOnExpand(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
