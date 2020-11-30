import 'package:botiga/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/index.dart' show LoginModal;
import '../tabbar.dart';
import '../../models/index.dart' show ProductModel;
import '../../providers/index.dart' show CartProvider, UserProvider;
import '../../util/index.dart' show Http;
import '../../widgets/index.dart'
    show IncrementButton, LottieScreen, BotigaAppBar, Toast, LoaderOverlay;
import '../location/index.dart' show AddHouseDetailModal;

import 'widgets/cartDeliveryInfo.dart';
import 'paymentScreen.dart';

class CartScreen extends StatefulWidget {
  final String route = 'cartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;
  bool _showSellerNotLiveDialog = true;

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
    return LottieScreen(
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
              itemCount: 3,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return CartDeliveryInfo(provider.cartSeller);

                  case 1:
                    return _itemList(provider);

                  case 2:
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
            final data = await provider.checkout();

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
            setState(() => _isLoading = false);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 8),
        ...productList,
      ],
    );
  }

  Widget _itemTile(CartProvider provider, ProductModel product, int quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
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
      padding: const EdgeInsets.all(20.0),
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
