import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../models/index.dart' show OrderModel;
import '../../providers/index.dart' show CartProvider, UserProvider;
import '../../theme/index.dart';
import '../../util/index.dart' show Http, Flavor;
import '../../widgets/index.dart' show BotigaAppBar, Toast, LoaderOverlay;

import 'widgets/cartDeliveryInfo.dart';
import '../orders/orderStatusScreen.dart';

class PaymentScreen extends StatefulWidget {
  final String route = 'PaymentScreen';

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

enum PaymentMethod { upi, card, netbanking }

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  PaymentMethod _selectedMethod;
  OrderModel _order;

  final _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    _selectedMethod = PaymentMethod.upi;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _order.paymentSuccess(true);
    _updateOrderStatus();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _order.paymentSuccess(false);
    _updateOrderStatus();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Pay ₹${provider.totalToPay}'),
      bottomNavigationBar: _completePaymentButton(),
      body: SafeArea(
        child: LoaderOverlay(
          isLoading: _isLoading,
          child: Column(
            children: [
              CartDeliveryInfo(provider.cartSeller),
              _paymentOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentOptions() {
    final _pad24 = SizedBox(height: 24);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PAY USING',
            style: AppTheme.textStyle.w600.color50.size(14).lineHeight(1.3),
          ),
          _pad24,
          _paymentTile(
            image: 'payUpi.png',
            title: 'UPI',
            subTitle: 'Gpay, PhonePe etc...',
            method: PaymentMethod.upi,
          ),
          _pad24,
          _paymentTile(
            image: 'payCard.png',
            title: 'Debit Card',
            subTitle: 'Visa, Master, Maestro, Rupay',
            method: PaymentMethod.card,
          ),
          _pad24,
          _paymentTile(
            image: 'payNet.png',
            title: 'Net Banking',
            subTitle: 'All Indian banks',
            method: PaymentMethod.netbanking,
          ),
          _pad24,
        ],
      ),
    );
  }

  Widget _paymentTile({
    String image,
    String title,
    String subTitle,
    PaymentMethod method,
  }) {
    final isSelected = _selectedMethod == method;
    final color = isSelected ? AppTheme.primaryColor : AppTheme.dividerColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        border: Border.all(color: color),
        color: AppTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.dividerColor,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 1.0,
          ),
        ],
      ),
      child: ListTile(
        onTap: () => setState(() => _selectedMethod = method),
        leading: Image.asset('assets/images/$image', width: 40, height: 40),
        title: Text(
          title,
          style: AppTheme.textStyle.w600.color100.size(15).lineHeight(1.3),
        ),
        subtitle: Text(
          subTitle,
          style: AppTheme.textStyle.w600.color50
              .size(12)
              .lineHeight(1.3)
              .letterSpace(0.2),
        ),
        trailing: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: isSelected
                ? Center(
                    child: Icon(
                    Icons.check,
                    size: 12,
                    color: AppTheme.backgroundColor,
                  ))
                : Container()),
      ),
    );
  }

  Widget _completePaymentButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 10.0,
          left: 20.0,
          right: 20.0,
        ),
        child: InkWell(
          onTap: () => _proceedToPayment(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: AppTheme.primaryColor,
            ),
            height: 56,
            child: Center(
              child: Text(
                'Complete Payment',
                style: AppTheme.textStyle.w700
                    .size(15.0)
                    .lineHeight(1.5)
                    .colored(AppTheme.backgroundColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _proceedToPayment() async {
    setState(() => _isLoading = true);

    String method;

    switch (_selectedMethod) {
      case PaymentMethod.upi:
        method = '';
        break;

      case PaymentMethod.card:
        method = 'card';
        break;

      case PaymentMethod.netbanking:
        method = 'netbanking';
        break;
    }

    try {
      final provider = Provider.of<CartProvider>(context, listen: false);
      _order = await provider.checkout();

      final data = await provider.orderPayment(_order.id);

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final options = {
        'key': Flavor.shared.rpayId,
        'amount': provider.totalAmount * 100,
        'name': provider.cartSeller.brandName,
        'order_id': data['id'],
        'timeout': 60 * 5, // In secs,
        'prefill': {
          'contact': '91${userProvider.phone}',
          'email': userProvider.email ?? 'noreply1@botiga.app',
          'method': method
        },
        'notes': {
          'orderId': _order.id,
          'orderNumber': _order.number
        } // used in payment webhook
      };

      _razorpay.open(options);
    } catch (error) {
      if (_order != null) {
        _order.paymentSuccess(false);
        _updateOrderStatus();
      }
      Toast(message: Http.message(error)).show(context);
    }
  }

  void _updateOrderStatus() async {
    // Change order state to failure if cancelled by user
    if (_order.payment.isFailure) {
      final provider = Provider.of<CartProvider>(context, listen: false);
      await provider.paymentCancelled(_order.id);
    }

    setState(() => _isLoading = false);

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => OrderStatusScreen(_order),
        transitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }
}
