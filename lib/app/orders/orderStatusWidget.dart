import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cart/paymentScreen.dart';
import '../../providers/index.dart' show OrdersProvider;
import '../../theme/index.dart';
import '../../util/index.dart' show DateExtension, Http;
import '../../models/index.dart' show OrderModel;
import '../../widgets/index.dart'
    show
        StatusImageWidget,
        ImageStatus,
        PassiveButton,
        BotigaBottomModal,
        WhatsappButton,
        Toast;

class OrderStatusWidget extends StatelessWidget {
  final OrderModel order;
  final Function(bool) stateLoading;

  OrderStatusWidget({
    @required this.order,
    @required this.stateLoading,
  });

  @override
  Widget build(BuildContext context) {
    String orderTitle = 'Order Placed';
    ImageStatus orderStatus = ImageStatus.success;
    String orderSubtitle;

    // Order Status Message
    if (order.isCancelled) {
      orderTitle = 'Order Cancelled';
      orderSubtitle =
          'Cancelled on ${order.completionDate.toLocal().dateFormatDayMonthTime}';
      orderStatus = ImageStatus.failure;
    } else if (order.isDelivered) {
      orderSubtitle =
          'Delivered on ${order.completionDate.toLocal().dateFormatDayMonthTime}';
    } else if (order.isOutForDelivery) {
      orderSubtitle = 'Out for delivery';
    } else {
      orderSubtitle =
          'Delivery expected on ${order.expectedDeliveryDate.toLocal().dateFormatDayMonthComplete}';
    }

    Widget button = Container();
    String paymentTitle;
    ImageStatus paymentStatus;
    String paymentSubtitle;

    // Order Payment Message
    if (order.payment.isSuccess) {
      paymentStatus = ImageStatus.success;
      paymentTitle = 'Paid via ${order.payment.paymentMode}';
    } else if (order.payment.isPending) {
      paymentStatus = ImageStatus.pending;
      paymentTitle = 'Payment confirmation pending from the bank.';
    } else {
      // for payment status - failure
      paymentStatus = ImageStatus.failure;
      paymentTitle = 'Payment Failed';
      if (!order.isCancelled) {
        // Retry Button
        button = PassiveButton(
          width: 200,
          title: 'Retry Payment',
          onPressed: () => _retryPayment(context),
        );
      }
    }

    // Show Refund Information Only
    if (order.refund.status != null) {
      // Refund Initiated
      if (order.refund.isSuccess) {
        paymentSubtitle = 'Refund completed';
      } else {
        paymentSubtitle = 'Refund pending';
        // Show Reminder button
        button = PassiveButton(
          width: double.infinity,
          icon: Icon(Icons.update, size: 18.0),
          title: 'Remind Seller to Refund',
          onPressed: () => _whatsappModal(context, order),
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

  void _retryPayment(BuildContext context) async {
    stateLoading(true);
    try {
      final data = await Provider.of<OrdersProvider>(context, listen: false)
          .retryPayment(order.id);

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => PaymentScreen(
            paymentId: data['paymentId'],
            paymentToken: data['paymentToken'],
          ),
          transitionDuration: Duration.zero,
        ),
      );
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    } finally {
      stateLoading(false);
    }
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
            phone: order.seller.whatsapp,
            width: 220.0,
            message:
                'Botiga Reminder:\nHello ${order.seller.brandName},\nThis is a reminder for refund of amount ${order.refund.amount} for order number ${order.number} cancelled on ${order.completionDate.toLocal().dateFormatDayMonthComplete}',
          ),
          _sizedBox,
        ],
      ),
    ).show(context);
  }
}
