import 'package:flutter/material.dart';

import '../../theme/index.dart';
import '../../models/orderModel.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  OrderDetailScreen(this.order);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor, // setting status bar color to white
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: AppTheme.color100,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            color: AppTheme.backgroundColor,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Center(child: Text(order.number));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
