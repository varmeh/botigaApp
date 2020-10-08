import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/orderModel.dart';
import '../../util/index.dart' show HttpServiceExceptionWidget;
import '../../providers/ordersProvider.dart';
import '../../theme/index.dart';

class OrderListScreen extends StatelessWidget {
  final String route = 'ordersScreen';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<OrdersProvider>(context, listen: false).getOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          );
        } else if (snapshot.hasError) {
          return HttpServiceExceptionWidget(snapshot.error);
        } else {
          return Consumer<OrdersProvider>(
            builder: (context, provider, child) {
              return provider.orders.length > 0
                  ? _orderList(provider)
                  : _noOrders();
            },
          );
        }
      },
    );
  }

  Widget _noOrders() {
    return Center(
      child: Text('No Orders'),
    );
  }

  Widget _orderList(OrdersProvider provider) {
    final addButtonForMoreOrders =
        provider.currentPage < provider.pages - 1 ? 1 : 0;
    return Container(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: provider.orders.length + 1 + addButtonForMoreOrders,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Text(
              'Orders',
              style: AppTheme.textStyle.w700.size(22).lineHeight(1.4),
            );
          } else if (index <= provider.orders.length) {
            return _orderTile(provider.orders[index - 1]);
          } else {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.dividerColor,
                  ),
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: provider to load next
                  },
                  child: Text(
                    'View Past Orders',
                    style: AppTheme.textStyle.w600
                        .size(15)
                        .lineHeight(1.3)
                        .colored(AppTheme.primaryColor),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _orderTile(OrderModel order) {
    final dateFormat = DateFormat('d MMM, y hh:mm a');
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.seller.brandName,
                style:
                    AppTheme.textStyle.w600.color100.size(15).lineHeight(1.3),
              ),
              Text(
                '₹${order.totalAmount.toString()}',
                style:
                    AppTheme.textStyle.w600.color100.size(13).lineHeight(1.5),
              )
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(order.orderDate),
                style: AppTheme.textStyle.w500.color50.size(12).lineHeight(1.3),
              ),
              Row(
                children: [
                  Text(
                    order.statusMessage,
                    style: AppTheme.textStyle.w500.color50
                        .size(12)
                        .lineHeight(1.3),
                  ),
                  SizedBox(width: 4.0),
                  Container(
                    width: 12.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                      color: order.statusColor,
                      shape: BoxShape.circle,
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 20.0),
          Divider(
            thickness: 1.0,
            color: AppTheme.dividerColor,
          )
        ],
      ),
    );
  }
}
