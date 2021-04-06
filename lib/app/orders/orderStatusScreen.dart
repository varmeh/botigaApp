import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../../providers/index.dart' show OrdersProvider, CartProvider;
import '../../models/index.dart' show OrderModel;
import '../../theme/index.dart';
import '../../util/index.dart' show DateExtension;
import '../../widgets/index.dart' show BotigaAppBar, ShimmerWidget;
import 'orderStatusWidget.dart';
import '../tabbar.dart';

class OrderStatusScreen extends StatefulWidget {
  final OrderModel order;

  OrderStatusScreen(this.order);

  @override
  _OrderStatusScreenState createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  bool _isLoading;
  OrderModel _order;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _order = widget.order;

    Future.delayed(Duration(milliseconds: 25), () => _getOrderStatus());
  }

  Future<void> _getOrderStatus() async {
    try {
      setState(() => _isLoading = true);

      final provider = Provider.of<OrdersProvider>(context, listen: false);
      provider.resetOrders();

      // Get Order status from backend
      _order = await provider.fetchOrderWithId(widget.order.id);
    } catch (_) {} finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _shimmerEffect();
    } else if (_order.payment.isSuccess) {
      final provider = Provider.of<CartProvider>(context, listen: false);
      provider.clearCart();
      provider.saveCartToServer();

      return _orderDetails();
    } else {
      return _paymentFailureScreen();
    }
  }

  Widget _orderDetails() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar(
        'Order Details',
        canPop: false,
      ),
      floatingActionButton: _homeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          children: [
            _sellerInfo(),
            Divider(
              thickness: 4.0,
              color: AppTheme.dividerColor,
            ),
            Container(
              padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
              child: OrderStatusWidget(
                order: _order,
                stateLoading: (value) {
                  setState(() => _isLoading = value);
                },
              ),
            ),
            _refundMessage(),
          ],
        ),
      ),
    );
  }

  Widget _sellerInfo() {
    final sizedBox = SizedBox(height: 8.0);
    final order = widget.order;

    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 24.0,
        top: 12.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.seller.brandName,
            style: AppTheme.textStyle.w600.color100.size(17.0).lineHeight(1.4),
          ),
          sizedBox,
          Text(
            order.orderDate.dateCompleteWithTime,
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

  Widget _homeButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      width: 90,
      height: 120,
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
              SizedBox(height: 4.0),
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

  Widget _refundMessage() {
    return widget.order.payment.isFailure
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Color(0xfffdf0d5),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Text(
              'Incase any amount is deducted from your bank account, it will credited back to the same account in 2 to 3 business days.',
              style: AppTheme.textStyle.color100.w500
                  .size(12.0)
                  .lineHeight(1.5)
                  .letterSpace(0.2),
            ),
          )
        : Container();
  }

  Widget _paymentFailureScreen() {
    const sizedBox = SizedBox(height: 24);
    final width = MediaQuery.of(context).size.width - 40;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lotties/paymentFailure.json',
                width: width,
                height: width,
                fit: BoxFit.cover,
              ),
              sizedBox,
              Text(
                'Payment Failed!',
                style: AppTheme.textStyle.w700
                    .size(22)
                    .lineHeight(1.3)
                    .colored(AppTheme.errorColor),
              ),
              sizedBox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44.0),
                child: Text(
                  'Incase money is deducted, It will be refunded in 2 days.',
                  textAlign: TextAlign.center,
                  style:
                      AppTheme.textStyle.w500.color50.size(15).lineHeight(1.5),
                ),
              ),
              sizedBox,
              InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => Tabbar(index: 2),
                      transitionDuration: Duration.zero,
                    ),
                    (route) => false,
                  );
                },
                child: Container(
                  width: 160,
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: AppTheme.backgroundColor,
                  ),
                  child: Center(
                    child: Text(
                      'Go to Cart',
                      style: AppTheme.textStyle.w500
                          .size(15)
                          // .lineHeight(1.5)
                          .colored(AppTheme.primaryColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerEffect() {
    final sizedBox = SizedBox(height: 8.0);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      floatingActionButton: ShimmerWidget(
        child: Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          width: 90,
          height: 120,
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
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: ShimmerWidget(
            child: Container(
              width: 200,
              height: 28,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        brightness: Brightness.light,
        elevation: 0.0,
        centerTitle: false,
        titleSpacing: 0.0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            ShimmerWidget(
              child: Container(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 24.0,
                  top: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      height: 22,
                      color: Colors.white,
                    ),
                    sizedBox,
                    Container(
                      width: 160,
                      height: 16,
                      color: Colors.white,
                    ),
                    sizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            height: 15,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 48.0),
                        Expanded(
                          child: Container(
                            height: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 4.0,
              color: AppTheme.dividerColor,
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: Column(
                children: [
                  _shimmerTile(true),
                  _shimmerTile(false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerTile(bool hasDivider) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: ShimmerWidget(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            SizedBox(width: 24),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 18,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 15,
                  color: Colors.white,
                ),
                SizedBox(height: 24),
                hasDivider
                    ? Divider(
                        thickness: 1,
                        color: Colors.white,
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}
