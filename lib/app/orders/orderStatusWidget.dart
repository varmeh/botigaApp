import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../providers/index.dart' show UserProvider, CartProvider;
import '../../models/index.dart' show OrderModel;
import '../../theme/index.dart';
import '../../util/index.dart' show DateExtension, Http, Flavor;
import '../../widgets/index.dart'
    show
        StatusImageWidget,
        ImageStatus,
        PassiveButton,
        BotigaBottomModal,
        WhatsappButton,
        Toast;
import 'orderStatusScreen.dart';

class OrderStatusWidget extends StatefulWidget {
  final OrderModel order;
  final Function(bool) stateLoading;

  OrderStatusWidget({
    @required this.order,
    @required this.stateLoading,
  });

  @override
  _OrderStatusWidgetState createState() => _OrderStatusWidgetState();
}

class _OrderStatusWidgetState extends State<OrderStatusWidget> {
  final _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    widget.order.paymentSuccess(true);
    _updateOrderStatus();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    widget.order.paymentSuccess(false);
    _updateOrderStatus();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String orderTitle = 'Order Placed';
    ImageStatus orderStatus = ImageStatus.success;
    String orderSubtitle;

    // Order Status Message
    if (widget.order.isCancelled) {
      orderTitle = 'Order Cancelled';
      orderSubtitle =
          'Cancelled on ${widget.order.completionDate.dateFormatDayMonthTime}';
      orderStatus = ImageStatus.failure;
    } else if (widget.order.isDelivered) {
      orderSubtitle =
          'Delivered on ${widget.order.completionDate.dateFormatDayMonthTime}';
    } else if (widget.order.isOutForDelivery) {
      orderSubtitle = 'Out for delivery';
    } else {
      orderSubtitle =
          'Delivery expected on ${widget.order.expectedDeliveryDate.dateFormatDayMonthComplete}';
    }

    Widget button = Container();
    String paymentTitle;
    ImageStatus paymentStatus;
    String paymentSubtitle;

    // Order Payment Message
    if (widget.order.payment.isSuccess) {
      paymentStatus = ImageStatus.success;
      paymentTitle =
          'Paid via ${widget.order.payment.paymentMode.toUpperCase()}';
    } else {
      // for payment status - failure
      paymentStatus = ImageStatus.failure;
      paymentTitle = 'Payment Failed';

      if (!widget.order.isCancelled) {
        // Retry Button
        button = PassiveButton(
          width: 200,
          title: 'Retry Payment',
          onPressed: () async {
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            widget.stateLoading(true);
            try {
              // Ensure a valid razor pay orderId before initiating payment
              String orderId = widget.order.payment.orderId;
              if (orderId == null) {
                // orderId is null if initial payment try failed due to any reason
                final data =
                    await Provider.of<CartProvider>(context, listen: false)
                        .orderPayment(widget.order.id);
                orderId = data['id'];
              }

              final options = {
                'key': Flavor.shared.rpayId,
                'amount': widget.order.totalAmount * 100,
                'name': widget.order.seller.brandName,
                'order_id': orderId,
                'timeout': 60, // In secs,
                'prefill': {
                  'contact': '91${userProvider.phone}',
                  'email': userProvider.email ?? 'noreply1@botiga.app'
                },
                'notes': {'orderId': widget.order.id} // used in payment webhook
              };

              _razorpay.open(options);
            } catch (error) {
              widget.stateLoading(false);
              Toast(message: Http.message(error)).show(context);
            }
          },
        );
      }
    }

    // Show Refund Information Only
    if (widget.order.refund.status != null) {
      // Refund Initiated
      if (widget.order.refund.isSuccess) {
        paymentSubtitle = 'Refund completed';
      } else {
        paymentSubtitle = 'Refund pending';
        // Show Reminder button
        button = PassiveButton(
          width: double.infinity,
          icon: Icon(Icons.update, size: 18.0),
          title: 'Remind Seller to Refund',
          onPressed: () => _whatsappModal(context, widget.order),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          _tile(
            baseImage: 'assets/images/order.png',
            status: orderStatus,
            title: orderTitle,
            subTitle: orderSubtitle,
          ),
          _tile(
            baseImage: 'assets/images/card.png',
            status: paymentStatus,
            title: paymentTitle,
            subTitle: paymentSubtitle,
            divider: false,
            button: button,
          ),
        ],
      ),
    );
  }

  Widget _tile({
    String baseImage,
    ImageStatus status,
    String title,
    String subTitle,
    Widget button,
    bool divider = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
        // bottom: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusImageWidget(
            baseImage: baseImage,
            status: status,
          ),
          SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: Container(
              decoration: divider
                  ? BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppTheme.dividerColor),
                      ),
                    )
                  : BoxDecoration(),
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.textStyle.color100.w600
                        .size(15)
                        .lineHeight(1.3),
                  ),
                  subTitle != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            subTitle,
                            style: AppTheme.textStyle.color50.w500
                                .size(13)
                                .lineHeight(1.5),
                          ),
                        )
                      : Container(),
                  button != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: button,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateOrderStatus() {
    widget.stateLoading(false);
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => OrderStatusScreen(widget.order),
        transitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }

  void _whatsappModal(BuildContext context, OrderModel order) {
    final _sizedBox = SizedBox(height: 16.0);
    final _padding = const EdgeInsets.symmetric(horizontal: 28.0);

    BotigaBottomModal(
      child: Column(
        children: [
          Image.asset(
            'assets/images/sadSmilie.png',
            width: 48.0,
            height: 48.0,
          ),
          _sizedBox,
          Padding(
            padding: _padding,
            child: Text(
              'We are Sorry, you have to do it again',
              textAlign: TextAlign.center,
              style:
                  AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
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
          WhatsappButton(
            title: 'Whatsapp Seller',
            number: order.seller.whatsapp,
            width: 220.0,
            message:
                'Botiga Reminder:\nHello ${order.seller.brandName},\nThis is a reminder for refund of amount ${order.refund.amount} for order number ${order.number} cancelled on ${order.completionDate.dateFormatDayMonthComplete}',
          ),
          _sizedBox,
        ],
      ),
    ).show(context);
  }
}
