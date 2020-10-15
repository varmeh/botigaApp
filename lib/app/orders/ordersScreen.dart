import 'package:botiga/app/profile/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:animations/animations.dart';

import '../../models/orderModel.dart';
import '../../util/index.dart' show HttpServiceExceptionWidget;
import '../../providers/ordersProvider.dart';
import '../../theme/index.dart';
import '../../widgets/loader.dart';

import '../tabbar.dart';
import 'orderDetailScreen.dart';

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  var initialLoad = true;

  final String route = 'ordersScreen';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrdersProvider>(context);
    return SafeArea(
      child: FutureBuilder(
        future: initialLoad ? provider.getOrders() : provider.nextOrders(),
        builder: (context, snapshot) {
          // Show central level loading on empty screen
          if (snapshot.connectionState == ConnectionState.waiting &&
              initialLoad) {
            return Loader();
          } else if (snapshot.hasError) {
            return HttpServiceExceptionWidget(
              exception: snapshot.error,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => Tabbar(index: 1),
                    transitionDuration: Duration.zero,
                  ),
                );
              },
            );
          } else {
            return Stack(
              children: [
                Consumer<OrdersProvider>(
                  builder: (context, provider, child) {
                    return provider.orders.length > 0
                        ? _orderList(provider)
                        : _noOrders();
                  },
                ),
                snapshot.connectionState == ConnectionState.waiting
                    ? Loader()
                    : Container()
              ],
            );
          }
        },
      ),
    );
  }

  Widget _noOrders() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No orders placed yet!',
            style: AppTheme.textStyle.w800.color05.size(72.0),
          ),
          SizedBox(height: 24.0),
          Text(
            'Many amazing products to purchase',
            style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
          ),
        ],
      ),
    );
  }

  Widget _orderList(OrdersProvider provider) {
    final addButtonForMoreOrders =
        provider.currentPage + 1 < provider.pages ? 1 : 0;
    return GestureDetector(
      onTap: () {
        setState(() {
          initialLoad = false;
        });
      },
      child: Container(
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
                  child: Text(
                    'View Past Orders',
                    style: AppTheme.textStyle.w600
                        .size(15)
                        .lineHeight(1.3)
                        .colored(AppTheme.primaryColor),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _orderTile(OrderModel order) {
    final dateFormat = DateFormat('d MMM, y hh:mm a');
    return OpenContainer(
      closedElevation: 0.0,
      transitionDuration: Duration(milliseconds: 500),
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.seller.brandName,
                      style: AppTheme.textStyle.w600.color100
                          .size(15)
                          .lineHeight(1.3),
                    ),
                    Text(
                      '₹${order.totalAmount.toString()}',
                      style: AppTheme.textStyle.w600.color100
                          .size(13)
                          .lineHeight(1.5),
                    )
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormat.format(order.orderDate),
                      style: AppTheme.textStyle.w500.color50
                          .size(12)
                          .lineHeight(1.3),
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
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Divider(
                  thickness: 1.0,
                  color: AppTheme.dividerColor,
                ),
              ],
            ),
          ),
        );
      },
      openBuilder: (_, __) => OrderDetailScreen(order),
    );
  }
}
