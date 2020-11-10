import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/ordersProvider.dart';
import '../../util/index.dart' show Http;
import '../../theme/index.dart';
import '../../models/orderModel.dart';
import '../../widgets/index.dart'
    show
        ContactWidget,
        LoaderOverlay,
        BotigaAppBar,
        Toast,
        PassiveButton,
        BotigaBottomModal;

class OrderDetailScreen extends StatefulWidget {
  static const route = 'orderDetails';

  final String orderId;

  OrderDetailScreen(this.orderId);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool _isLoading = false;
  // final _memoizer = AsyncMemoizer();
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
          child: LoaderOverlay(
            isLoading: _isLoading,
            child: ListView(
              children: [
                _sellerInfo(),
                divider,
                _deliveryStatus(),
                divider,
                _itemizedBill()
              ],
            ),
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
                        _cancelOrder();
                        Navigator.of(context).pop();
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

  Future<void> _cancelOrder() async {
    setState(() => _isLoading = true);
    try {
      final provider = Provider.of<OrdersProvider>(context, listen: false);
      await provider.cancelOrder(widget.orderId);
      final order = provider.getOrderWithId(widget.orderId);

      if (order.payment.status == 'success') {
        Future.delayed(
          Duration(milliseconds: 200),
          () => _whatsappModal(
            imageUrl: 'assets/images/orderCancel.png',
            imageSize: 68.0,
            message: 'Order Cancelled',
          ),
        );
      }
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
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

    String orderMessage;
    String paymentMessage;
    Widget button = Container();

    // Order Status Message
    if (order.status == 'cancelled') {
      orderMessage =
          'Order Cancelled on ${dateFormat.format(order.completionDate.toLocal())}';
    } else if (order.status == 'delivered') {
      orderMessage =
          'Order delivered on ${dateFormat.format(order.completionDate.toLocal())}';
    } else if (order.status == 'out') {
      orderMessage = 'Order is out for delivery';
    } else {
      orderMessage =
          'Delivery expected on ${DateFormat('d MMMM').format(order.expectedDeliveryDate.toLocal())}';
    }

    // Order Payment Message
    if (order.payment.status == 'success') {
      paymentMessage = 'Paid via ${order.payment.paymentMode}';
    } else if (order.payment.status == 'pending') {
      paymentMessage = 'Payment confirmation pending from the bank.';
    } else {
      // for payment status - failure
      paymentMessage =
          order.status == 'cancelled' ? 'No dues pending' : 'Payment Failed';
      if (order.status != 'delieverd' && order.status != 'cancelled') {
        // Retry Button
        button = Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: PassiveButton(
            width: double.infinity,
            title: 'Retry Payment',
            onPressed: () {},
          ),
        );
      }
    }

    // Show Refund Information Only
    if (order.refund.status != null) {
      // Refund Initiated
      if (order.refund.status == 'success') {
        paymentMessage = 'Refund completed';
      } else {
        paymentMessage = 'Refund pending';
        // Show Reminder button
        button = Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: PassiveButton(
            width: double.infinity,
            icon: Icon(Icons.update, size: 18.0),
            title: 'Remind Seller to Refund',
            onPressed: () => _whatsappModal(
              imageUrl: 'assets/images/sadSmilie.png',
              imageSize: 48.0,
              message: 'We are Sorry, you have to do it again',
            ),
          ),
        );
      }
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
                orderMessage,
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
              Expanded(
                child: Text(
                  paymentMessage,
                  style: AppTheme.textStyle.w500.color100
                      .size(13.0)
                      .lineHeight(1.5),
                ),
              ),
            ],
          ),
          button,
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

  void _whatsappModal({String imageUrl, double imageSize, String message}) {
    final _sizedBox = SizedBox(height: 16.0);
    final _padding = const EdgeInsets.symmetric(horizontal: 28.0);

    BotigaBottomModal(
      child: Column(
        children: [
          Image.asset(
            imageUrl,
            width: imageSize,
            height: imageSize,
          ),
          _sizedBox,
          Padding(
            padding: _padding,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style:
                  AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
            ),
          ),
          _sizedBox,
          Padding(
            padding: _padding,
            child: Text(
              'Please contact seller for refund.',
              textAlign: TextAlign.center,
              style: AppTheme.textStyle.w500.color50.size(15.0).lineHeight(1.3),
            ),
          ),
          _sizedBox,
          Padding(
            padding: _padding,
            child: Text(
              'We understand the hassle, so please bear with us while we make it seamless',
              textAlign: TextAlign.center,
              style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
            ),
          ),
          SizedBox(height: 32.0),
          PassiveButton(
            width: 220,
            title: 'Whatsapp Seller',
            icon: Image.asset(
              'assets/images/whatsapp.png',
              width: 18.0,
              height: 18.0,
            ),
            onPressed: () {},
          ),
        ],
      ),
    ).show(context);
  }
}
