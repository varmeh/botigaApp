import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/ordersProvider.dart';
import '../../theme/index.dart';
import '../../models/orderModel.dart';
import '../../widgets/index.dart'
    show ContactPartnerWidget, Loader, BotigaAppBar, HttpServiceExceptionWidget;

class OrderDetailScreen extends StatefulWidget {
  static const route = 'orderDetails';

  final OrderModel order;

  OrderDetailScreen(this.order);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool initiateCancellation = false;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      thickness: 8.0,
      color: AppTheme.dividerColor,
    );

    return Container(
      color: AppTheme.backgroundColor, // setting status bar color to white
      child: Scaffold(
        appBar: BotigaAppBar('', actions: [_cancelButton(context)]),
        body: SafeArea(
          child: Container(
            color: AppTheme.backgroundColor,
            child: FutureBuilder(
              future: initiateCancellation
                  ? Provider.of<OrdersProvider>(context)
                      .cancelOrder(widget.order.id)
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
                              OrderDetailScreen(widget.order),
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
      ),
    );
  }

  Widget _cancelButton(BuildContext context) {
    // TODO: order cancellation api pending
    return widget.order.status == 'open' || widget.order.status == 'delay'
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
                        'Confirm',
                        style: AppTheme.textStyle.w600
                            .colored(AppTheme.errorColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          initiateCancellation = true;
                        });
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
            widget.order.seller.brandName,
            style: AppTheme.textStyle.w600.color100.size(15.0).lineHeight(1.4),
          ),
          sizedBox,
          Text(
            dateFormat.format(widget.order.orderDate.toLocal()),
            style: AppTheme.textStyle.w500.color50.size(12.0).lineHeight(1.3),
          ),
          sizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: '#${widget.order.number}',
                  style: AppTheme.textStyle.w500.color100
                      .size(13.0)
                      .lineHeight(1.5),
                  children: [
                    TextSpan(text: '・'),
                    TextSpan(
                      text:
                          '${widget.order.products.length} ITEM${widget.order.products.length > 1 ? 'S' : ''}',
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
                      text: widget.order.totalAmount.toString(),
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
          ContactPartnerWidget(
            phone: widget.order.seller.phone,
            whatsapp: widget.order.seller.whatsapp,
          )
        ],
      ),
    );
  }

  Widget _deliveryStatus() {
    final dateFormat = DateFormat('d MMMM hh:mm a');

    String message;

    if (widget.order.status == 'cancelled') {
      message =
          'Order Cancelled on ${dateFormat.format(widget.order.completionDate.toLocal())}';
    } else if (widget.order.status == 'delivered') {
      message =
          'Order delivered on ${dateFormat.format(widget.order.completionDate.toLocal())}';
    } else if (widget.order.status == 'out') {
      message = 'Order is out for delivery';
    } else {
      message =
          'Delivery expected on ${DateFormat('d MMMM').format(widget.order.expectedDeliveryDate.toLocal())}';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 20.0,
      ),
      child: Row(
        children: [
          Container(
            width: 12.0,
            height: 12.0,
            decoration: BoxDecoration(
              color: widget.order.statusColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.0),
          Text(
            message,
            style: AppTheme.textStyle.w500.color100.size(13.0).lineHeight(1.5),
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
          ...widget.order.products.map((product) => _productDetails(product)),
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
                text: widget.order.totalAmount.toString(),
                style: style,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
