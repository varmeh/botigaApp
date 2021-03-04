import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../models/index.dart' show ProductModel, OrderModel;
import '../../providers/index.dart'
    show CartProvider, UserProvider, SellerProvider;
import '../../theme/index.dart';
import '../../util/index.dart' show Http, Flavor;
import '../../widgets/index.dart'
    show IncrementButton, LottieScreen, BotigaAppBar, Toast, LoaderOverlay;
import '../auth/index.dart' show LoginModal;
import '../location/index.dart' show AddHouseDetailModal;
import '../tabbar.dart';
import 'widgets/cartDeliveryInfo.dart';
import '../orders/orderStatusScreen.dart';
import 'couponScreen.dart';

class CartScreen extends StatefulWidget {
  final String route = 'cartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;
  bool _showSellerNotLiveDialog = true;

  final _razorpay = Razorpay();
  OrderModel _order;

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
    final _provider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar(''),
      body: SafeArea(
        child: _provider.numberOfItemsInCart > 0
            ? _cartDetails(_provider)
            : _cartEmpty(context),
      ),
    );
  }

  Widget _cartEmpty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: LottieScreen(
        json: 'assets/lotties/windmill.json',
        message: 'Nothing here',
        description: 'Look around, you will find something you love',
        buttonTitle: 'Browse Merchants',
        onTap: () {
          // Remove all the screens on stack when in product detail screen cart
          if (Navigator.canPop(context)) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Tabbar(index: 0),
              transitionDuration: Duration.zero,
            ),
          );
        },
      ),
    );
  }

  Widget _cartDetails(CartProvider provider) {
    if (provider.cartSeller.live == false && _showSellerNotLiveDialog) {
      _showSellerNotLiveDialog = false;
      Future.delayed(Duration(milliseconds: 500), () => _sellerNotLiveDialog());
    }

    return LoaderOverlay(
      isLoading: _isLoading,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return CartDeliveryInfo(provider.cartSeller);

                  case 1:
                    return _sellerCoupons(provider);

                  case 2:
                    return _itemList(provider);

                  case 3:
                    return _totalPrice(provider.totalPrice);

                  default:
                    return Container();
                }
              },
            ),
          ),
          Positioned(
            bottom: 0,
            child: _modal(provider),
          ),
        ],
      ),
    );
  }

  Widget _sellerCoupons(CartProvider cartProvider) {
    final _sellerProvider = Provider.of<SellerProvider>(context, listen: false);
    final _divider = Divider(
      thickness: 4,
      color: AppTheme.dividerColor,
    );

    String couponText = 'Apply Coupon';
    Widget trailingWidget = Icon(
      Icons.arrow_forward_ios_rounded,
      color: AppTheme.color50,
      size: 18,
    );
    Function onTap = () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CouponScreen(
                _sellerProvider.coupons(cartProvider.cartSeller.id)),
          ),
        );

    if (cartProvider.isCouponApplied) {
      couponText = '${cartProvider.couponApplied.couponCode} Applied';
      trailingWidget = Image.asset(
        'assets/images/cancelRounded.png',
        width: 20,
        height: 20,
      );
      onTap = () => cartProvider.removeCoupon();
    }

    return _sellerProvider.hasCoupons(cartProvider.cartSeller.id)
        ? Column(
            children: [
              _divider,
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/coupon.png',
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            couponText,
                            style: AppTheme.textStyle.w600.color100
                                .size(15)
                                .lineHeight(1.3),
                          ),
                        ],
                      ),
                      trailingWidget
                    ],
                  ),
                ),
              ),
              _divider
            ],
          )
        : Container();
  }

  Widget _modal(CartProvider provider) {
    if (provider.userLoggedIn) {
      return provider.hasAddress
          ? _proceedToPaymentModal(provider)
          : _addNewAddressModal();
    }
    return _openLoginModal();
  }

  Widget _openLoginModal() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => LoginModal().show(context),
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
          color: AppTheme.primaryColor,
        ),
        child: Center(
          child: Text(
            'Proceed with Phone number',
            style: AppTheme.textStyle.w700
                .colored(AppTheme.backgroundColor)
                .size(13)
                .lineHeight(1.6),
          ),
        ),
      ),
    );
  }

  Widget _addNewAddressModal() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        setState(() => _isLoading = true);
        try {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          final apartment =
              await userProvider.getApartmentById(userProvider.apartmentId);
          AddHouseDetailModal().show(
            context: context,
            apartment: apartment,
            clearCart: false,
          );
        } catch (_) {
          Toast(message: Http.message('Something went wrong. Try again'))
              .show(context);
        } finally {
          setState(() => _isLoading = false);
        }
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
          color: AppTheme.primaryColor,
        ),
        child: Center(
          child: Text(
            'Add new address',
            style: AppTheme.textStyle.w700
                .colored(AppTheme.backgroundColor)
                .size(13)
                .lineHeight(1.6),
          ),
        ),
      ),
    );
  }

  Widget _proceedToPaymentModal(CartProvider provider) {
    return Material(
      elevation: 3.0,
      shadowColor: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          setState(() => _isLoading = true);
          try {
            _order = await provider.checkout();

            final data = await provider.orderPayment(_order.id);

            final userProvider =
                Provider.of<UserProvider>(context, listen: false);

            final options = {
              'key': Flavor.shared.rpayId,
              'amount': provider.totalPrice * 100,
              'name': provider.cartSeller.brandName,
              'order_id': data['id'],
              'timeout': 60 * 5, // In secs,
              'prefill': {
                'contact': '91${userProvider.phone}',
                'email': userProvider.email ?? 'noreply1@botiga.app',
                'method': 'upi',
              },
              'notes': {'orderId': _order.id} // used in payment webhook
            };

            _razorpay.open(options);
          } catch (error) {
            if (_order != null) {
              _order.paymentSuccess(false);
              _updateOrderStatus();
            }
            Toast(message: Http.message(error)).show(context);
          }
        },
        child: provider.cartSeller.live
            ? Container(
                height: 56,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16.0),
                    topRight: const Radius.circular(16.0),
                  ),
                  color: AppTheme.primaryColor,
                ),
                child: Center(
                  child: Text(
                    'Proceed to pay',
                    style: AppTheme.textStyle.w700
                        .colored(AppTheme.backgroundColor)
                        .size(13)
                        .lineHeight(1.6),
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  void _updateOrderStatus() {
    setState(() => _isLoading = false);

    final provider = Provider.of<CartProvider>(context, listen: false);
    provider.clearCart();
    provider.saveCartToServer();

    if (_order.payment.isFailure) {
      provider.paymentCancelled(_order.id);
    }

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => OrderStatusScreen(_order),
        transitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }

  void _sellerNotLiveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Merchant Unavailable',
          style: AppTheme.textStyle.w500.color100,
        ),
        content: Text(
          'Merchant in your cart is not taking orders now. Try sometime later',
          style: AppTheme.textStyle.w400.color100,
        ),
        actions: [
          FlatButton(
            child: Text(
              'Close',
              style: AppTheme.textStyle.w600.colored(AppTheme.primaryColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget _itemList(CartProvider provider) {
    final List<Widget> productList = [];
    provider.products.forEach(
      (product, quantity) {
        productList.add(_itemTile(provider, product, quantity));
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 8),
          ...productList,
        ],
      ),
    );
  }

  Widget _itemTile(CartProvider provider, ProductModel product, int quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style:
                      AppTheme.textStyle.w500.color100.size(15).lineHeight(1.4),
                ),
                Text(
                  product.size,
                  style:
                      AppTheme.textStyle.w500.color50.size(13).lineHeight(1.6),
                )
              ],
            ),
          ),
          Center(
            child: IncrementButton(
              value: quantity,
              onIncrement: () {
                provider.addProduct(provider.cartSeller, product);
              },
              onDecrement: () {
                if (quantity > 0) {
                  provider.removeProduct(product);
                }
              },
            ),
          ),
          Expanded(
            child: Text(
              '₹${(product.price * quantity).toInt()}',
              style: AppTheme.textStyle.w500.color100.size(13).lineHeight(1.6),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalPrice(double totalPrice) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      child: Column(
        children: [
          Divider(
            color: AppTheme.dividerColor,
            thickness: 1.0,
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total to pay',
                    style: AppTheme.textStyle.w600.color100
                        .size(13)
                        .lineHeight(1.6),
                  ),
                ),
                Expanded(
                  child: Text(
                    '₹${totalPrice.toString()}',
                    style: AppTheme.textStyle.w600.color100
                        .size(13)
                        .lineHeight(1.6),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
