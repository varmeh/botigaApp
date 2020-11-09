import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/ordersProvider.dart';
import '../../theme/index.dart';
import '../../models/orderModel.dart';
import '../../widgets/index.dart'
    show ContactWidget, Loader, BotigaAppBar, HttpServiceExceptionWidget;

class OrderDetailScreen extends StatefulWidget {
  static const route = 'orderDetails';

  final String orderId;

  OrderDetailScreen(this.orderId);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool initiateCancellation = false;
  final _memoizer = AsyncMemoizer();
  var order;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      thickness: 8.0,
      color: AppTheme.dividerColor,
    );

    final provider = Provider.of<OrdersProvider>(context);
    order = provider.getOrderWithId(widget.orderId);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('', actions: [_cancelButton(context)]),
      body: SafeArea(
        child: Container(
          color: AppTheme.backgroundColor,
          child: FutureBuilder(
            future: initiateCancellation
                ? _memoizer.runOnce(() => Future.delayed(
                    Duration(
                      milliseconds: 100,
                    ), // Delayed to ensure screen display first
                    () => provider.cancelOrder(widget.orderId)))
                : null,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return HttpServiceExceptionWidget(
                  exception: snapshot.error,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            OrderDetailScreen(widget.orderId),
                        transitionDuration: Duration.zero,
                      ),
                    );
                  },
                );
              } else {
                return Stack(
                  children: [
                    ListView(
                      children: [
                        _sellerInfo(),
                        divider,
                        _deliveryStatus(),
                        divider,
                        _itemizedBill()
                      ],
                    ),
                    snapshot.connectionState == ConnectionState.waiting
                        ? Center(
                            child: Loader(),
                          )
                        : Container(),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _cancelButton(BuildContext context) {
    return order.status == 'open' || order.status == 'delay'
        ? GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Cancel Order',
                    style: AppTheme.textStyle.w500.color100,
                  ),
                  content: Text(
                    'Are you sure you want to cancel this order?',
                    style: AppTheme.textStyle.w400.color100,
                  ),
                  actions: [
                    FlatButton(
                      child: Text(
                        'Don\'t Cancel',
                        style: AppTheme.textStyle.w600.color50,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Confirm',
                        style: AppTheme.textStyle.w600
                            .colored(AppTheme.errorColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() => initiateCancellation = true);
                      },
                    ),
                  ],
                ),
              );
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  'Cancel order',
                  style: AppTheme.textStyle.w500
                      .size(15)
                      .lineHeight(1.3)
                      .colored(AppTheme.errorColor),
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _sellerInfo() {
    final sizedBox = SizedBox(height: 6.0);
    final dateFormat = DateFormat('d MMM, y h:mm a');

    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.seller.brandName,
            style: AppTheme.textStyle.w600.color100.size(15.0).lineHeight(1.4),
          ),
          sizedBox,
          Text(
            dateFormat.format(order.orderDate.toLocal()),
            style: AppTheme.textStyle.w500.color50.size(12.0).lineHeight(1.3),
          ),
          sizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: '#${order.number}',
                  style: AppTheme.textStyle.w500.color100
                      .size(13.0)
                      .lineHeight(1.5),
                  children: [
                    TextSpan(text: '・'),
                    TextSpan(
                      text:
                          '${order.products.length} ITEM${order.products.length > 1 ? 'S' : ''}',
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '₹',
                  style: AppTheme.textStyle.w400.color100
                      .size(13.0)
                      .lineHeight(1.5),
                  children: [
                    TextSpan(
                      text: order.totalAmount.toString(),
                      style: AppTheme.textStyle.w600.color100
                          .size(13.0)
                          .lineHeight(1.5),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.0),
          ContactWidget(
            phone: order.seller.phone,
            whatsapp: order.seller.whatsapp,
          )
        ],
      ),
    );
  }

  Widget _deliveryStatus() {
    final dateFormat = DateFormat('d MMMM hh:mm a');

    String message;

    if (order.status == 'cancelled') {
      message =
          'Order Cancelled on ${dateFormat.format(order.completionDate.toLocal())}';
    } else if (order.status == 'delivered') {
      message =
          'Order delivered on ${dateFormat.format(order.completionDate.toLocal())}';
    } else if (order.status == 'out') {
      message = 'Order is out for delivery';
    } else {
      message =
          'Delivery expected on ${DateFormat('d MMMM').format(order.expectedDeliveryDate.toLocal())}';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 20.0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 6.0),
              Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  color: order.statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 24.0),
              Text(
                message,
                style:
                    AppTheme.textStyle.w500.color100.size(13.0).lineHeight(1.5),
              ),
            ],
          ),
          SizedBox(height: 18),
          Row(
            children: [
              Image.asset(
                'assets/images/card.png',
                width: 24.0,
                height: 24.0,
              ),
              SizedBox(width: 18.0),
              Text(
                'Paid via UPI',
                style:
                    AppTheme.textStyle.w500.color100.size(13.0).lineHeight(1.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemizedBill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        children: [
          ...order.products.map((product) => _productDetails(product)),
          SizedBox(height: 16.0),
          Divider(
            thickness: 1,
            color: AppTheme.dividerColor,
          ),
          SizedBox(height: 24.0),
          _total()
        ],
      ),
    );
  }

  Widget _productDetails(OrderProductModel product) {
    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: product.quantity.toString(),
                  style:
                      AppTheme.textStyle.w500.color100.size(13).lineHeight(1.5),
                  children: [
                    TextSpan(text: ' X '),
                    TextSpan(text: product.name),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '₹',
                  style: AppTheme.textStyle.w400.color100
                      .size(13.0)
                      .lineHeight(1.6)
                      .letterSpace(0.5),
                  children: [
                    TextSpan(
                      text: product.price.toString(),
                      style: AppTheme.textStyle.w500.color100
                          .size(13.0)
                          .lineHeight(1.6)
                          .letterSpace(0.5),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Text(product.unitInfo),
        ],
      ),
    );
  }

  Widget _total() {
    final style = AppTheme.textStyle.w600.color100.size(13).lineHeight(1.6);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total',
          style: style,
        ),
        RichText(
          text: TextSpan(
            text: '₹',
            style: AppTheme.textStyle.w400.color100.size(13.0).lineHeight(1.6),
            children: [
              TextSpan(
                text: order.totalAmount.toString(),
                style: style,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
