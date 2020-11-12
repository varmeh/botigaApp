import 'package:flutter/material.dart';

import '../../models/index.dart' show OrderModel;
import '../../theme/index.dart';
import '../tabbar.dart';

class OrderStatusScreen extends StatefulWidget {
  final OrderModel order;

  OrderStatusScreen(this.order);

  @override
  _OrderStatusScreenState createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(
    //   Duration(seconds: 2),
    //   () => Navigator.of(context).pushAndRemoveUntil(
    //     PageRouteBuilder(
    //       pageBuilder: (_, __, ___) => Tabbar(index: 0),
    //       transitionDuration: Duration.zero,
    //     ),
    //     (route) => false,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.order.number,
                    textAlign: TextAlign.center,
                    style: AppTheme.textStyle.w700.color100.size(25.0),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.order.totalAmount.toString(),
                  style: AppTheme.textStyle.w500.color50.size(20.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
