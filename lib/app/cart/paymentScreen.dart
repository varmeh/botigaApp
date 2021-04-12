import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../models/index.dart' show OrderModel;
import '../../providers/index.dart' show CartProvider, UserProvider;
import '../../theme/index.dart';
import '../../util/index.dart' show Http, Flavor;
import '../../widgets/index.dart'
    show BotigaAppBar, Toast, PassiveButton, LoaderOverlay;

import 'widgets/cartDeliveryInfo.dart';
import '../orders/orderStatusScreen.dart';

class PaymentScreen extends StatefulWidget {
  final String route = 'PaymentScreen';

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  OrderModel _order;

  final _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
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
    final _pad16 = SizedBox(height: 16);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select an option',
            style: AppTheme.textStyle.w700.color100.size(17).lineHeight(1.3),
          ),
          SizedBox(height: 24),
          PassiveButton(
            title: 'Debit Card',
            onPressed: () => _proceedToPayment('card'),
          ),
          _pad16,
          PassiveButton(
            title: 'Netbanking',
            onPressed: () => _proceedToPayment('netbanking'),
          ),
          _pad16,
          PassiveButton(
            title: 'UPI',
            onPressed: () => _proceedToPayment(''),
          ),
          _pad16,
        ],
      ),
    );
  }

  void _proceedToPayment(String method) async {
    setState(() => _isLoading = true);
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
