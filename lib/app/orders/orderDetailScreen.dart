import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/orderModel.dart';
import '../../providers/ordersProvider.dart';
import '../../theme/index.dart';
import '../../util/index.dart' show Http, DateExtension;
import '../../widgets/index.dart'
    show
        MerchantContactWidget,
        LoaderOverlay,
        BotigaAppBar,
        Toast,
        WhatsappButton,
        BotigaBottomModal;
import 'orderStatusWidget.dart';

class OrderDetailScreen extends StatefulWidget {
  static const route = 'orderDetails';

  final String orderId;

  OrderDetailScreen(this.orderId);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool _isLoading = false;
  OrdersProvider provider;
  OrderModel order;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      thickness: 4.0,
      color: AppTheme.dividerColor,
    );

    provider = Provider.of<OrdersProvider>(context);
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                  child: MerchantContactWidget(
                    phone: order.seller.phone,
                    whatsapp: order.seller.whatsapp,
                  ),
                ),
                divider,
                _deliveryAddress(),
                divider,
                OrderStatusWidget(
                  order: order,
                  stateLoading: (value) {
                    setState(() => _isLoading = value);
                  },
                ),
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
    return order.isOpen || order.isDelayed
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
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

      if (order.payment.isSuccess) {
        Future.delayed(
          Duration(milliseconds: 200),
          () => _whatsappModal(
              imageUrl: 'assets/images/orderCancel.png',
              imageSize: 68.0,
              title: 'Order Cancelled',
              whatsappNumber: order.seller.whatsapp,
              whatsappMessage:
                  'Botiga Reminder:\nHello ${order.seller.brandName},\nI have cancelled order number ${order.number} placed on ${order.orderDate.dateFormatDayMonthComplete}.\nPlease refund the amount\n'),
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

    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.seller.brandName,
            style: AppTheme.textStyle.w600.color100.size(15.0).lineHeight(1.4),
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

  Widget _deliveryAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/homeOutline.png',
            width: 24.0,
            height: 24.0,
          ),
          SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deliver To',
                  style: AppTheme.textStyle.w600.color100
                      .size(15.0)
                      .lineHeight(1.3),
                ),
                SizedBox(height: 4),
                Text(
                  '${order.house}, ${order.apartment}',
                  style: AppTheme.textStyle.w500.color50
                      .size(13.0)
                      .lineHeight(1.5),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _itemizedBill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        children: [
          ...order.products.map((product) => _productDetails(product)),
          SizedBox(height: 24.0),
          _discountData(),
          _total(),
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
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: product.quantity.toString(),
                    style: AppTheme.textStyle.w500.color100
                        .size(13)
                        .lineHeight(1.5),
                    children: [
                      TextSpan(text: ' X '),
                      TextSpan(text: product.name),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              RichText(
                text: TextSpan(
                  text: '₹',
                  style: AppTheme.textStyle.w400.color100
                      .size(13.0)
                      .lineHeight(1.6)
                      .letterSpace(0.5),
                  children: [
                    TextSpan(
                      text: (product.price * product.quantity).toString(),
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
          Text(
            product.unitInfo,
            style: AppTheme.textStyle.w500.color50.size(12.0).lineHeight(1.35),
          ),
        ],
      ),
    );
  }

  Widget _discountData() {
    final _sizedBox20 = SizedBox(height: 20);
    final _style =
        AppTheme.textStyle.w500.size(13).lineHeight(1.2).letterSpace(0.2);

    return order.hasCoupon
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Items total',
                      style: _style.color100,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '₹${order.totalAmount + order.discountAmount}',
                      style: _style.color100,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              _sizedBox20,
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Saved with Coupon',
                      style: _style.color100,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '-₹${order.discountAmount}',
                      style: _style.colored(AppTheme.primaryColor),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              _sizedBox20,
            ],
          )
        : Container();
  }

  Widget _total() {
    final style = AppTheme.textStyle.w600.color100.size(13).lineHeight(1.6);

    return Padding(
        padding: const EdgeInsets.only(bottom: 52.0),
        child: Column(
          children: [
            Divider(
              thickness: 1,
              color: AppTheme.dividerColor,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: style,
                ),
                RichText(
                  text: TextSpan(
                    text: '₹',
                    style: AppTheme.textStyle.w400.color100
                        .size(13.0)
                        .lineHeight(1.6),
                    children: [
                      TextSpan(
                        text: order.totalAmount.toString(),
                        style: style,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void _whatsappModal({
    String imageUrl,
    double imageSize,
    String title,
    String whatsappNumber,
    String whatsappMessage,
  }) {
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
              title,
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
          WhatsappButton(
            title: 'Whatsapp Seller',
            number: whatsappNumber,
            width: 220.0,
            message: whatsappMessage,
          ),
          _sizedBox,
        ],
      ),
    ).show(context);
  }
}
