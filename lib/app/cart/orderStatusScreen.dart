import 'package:flutter/material.dart';

import '../../util/index.dart' show DateExtension;
import '../../models/index.dart' show OrderModel;
import '../../theme/index.dart';
import '../../widgets/index.dart' show BotigaAppBar, LoaderOverlay;
import '../orders/orderStatusWidget.dart';
import '../tabbar.dart';

class OrderStatusScreen extends StatefulWidget {
  final OrderModel order;

  OrderStatusScreen(this.order);

  @override
  _OrderStatusScreenState createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Order Details'),
      body: SafeArea(
        child: LoaderOverlay(
          isLoading: _isLoading,
          child: Column(
            children: [
              _sellerInfo(),
              Divider(
                thickness: 8.0,
                color: AppTheme.dividerColor,
              ),
              Container(
                padding: const EdgeInsets.only(top: 12.0),
                child: OrderStatusWidget(
                  order: widget.order,
                  stateLoading: (value) {
                    setState(() => _isLoading = value);
                  },
                ),
              ),
              _home(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sellerInfo() {
    final sizedBox = SizedBox(height: 8.0);
    final order = widget.order;

    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.seller.brandName,
            style: AppTheme.textStyle.w700.color100.size(17.0).lineHeight(1.4),
          ),
          sizedBox,
          Text(
            order.orderDate.toLocal().dateCompleteWithTime,
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
        ],
      ),
    );
  }

  Widget _home() {
    return Container(
      width: 90,
      height: 128,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xff121714).withOpacity(0.12),
            blurRadius: 40.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              0.0, // Move to right 10  horizontally
              0.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Tabbar(index: 0),
              transitionDuration: Duration.zero,
            ),
            (route) => false,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                BotigaIcons.building,
                color: AppTheme.color50,
                size: 34,
              ),
              Text(
                'Home',
                textAlign: TextAlign.center,
                style: AppTheme.textStyle
                    .colored(AppTheme.color100)
                    .w500
                    .size(12)
                    .letterSpace(0.3),
              )
            ],
          ),
        ),
      ),
    );
  }
}
