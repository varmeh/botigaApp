import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import 'orderStandardInfoWidget.dart';
import 'orderItemizedDetailWidget.dart';

class OrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);

    return ExpandableNotifier(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          child: Column(
            children: [
              OrderStandardInfoWidget(),
              OrderItemizedDetailsWidget(themeData: _themeData),
            ],
          ),
        ),
      ),
    );
  }
}
