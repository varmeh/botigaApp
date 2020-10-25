import 'package:botiga/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tabbar.dart';
import '../../models/index.dart' show ProductModel;
import '../../providers/index.dart' show CartProvider;
import '../../widgets/index.dart'
    show IncrementButton, OpenContainerBottomModal, LottieScreen, BotigaAppBar;

import 'widgets/cartDeliveryInfo.dart';

class CartScreen extends StatelessWidget {
  final String route = 'cartScreen';

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
    return Stack(
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
          child: OpenContainerBottomModal(
            child: Center(
              child: Text(
                'Proceed to pay',
                style: AppTheme.textStyle.w700
                    .colored(AppTheme.backgroundColor)
                    .size(13)
                    .lineHeight(1.6),
              ),
            ),
            openOnTap: () => Center(
              child: Text('Payment Screen'),
            ),
          ),
        )
      ],
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
                  '${product.name}',
                  style:
                      AppTheme.textStyle.w500.color100.size(15).lineHeight(1.4),
                ),
                Text(
                  '${product.size}',
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
