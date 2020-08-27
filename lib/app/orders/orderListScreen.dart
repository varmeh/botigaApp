import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import 'widgets/orderCard.dart';

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
        useInkWell: true,
      ),
      child: ListView.builder(
        itemCount: 5,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return OrderCard();
        },
      ),
    );
  }
}
