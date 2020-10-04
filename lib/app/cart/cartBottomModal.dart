import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:animations/animations.dart';

import '../../providers/index.dart' show CartProvider;
import '../home/products/productListScreen.dart';
import '../../util/index.dart' show Constants;
import 'cartConfirmationScreen.dart';

class CartBottomModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        return provider.numberOfItemsInCart > 0
            ? _cart(context, provider)
            : Container();
      },
    );
  }

  Widget _cart(BuildContext context, CartProvider provider) {
    return Material(
      elevation: 3.0,
      child: Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _sellerButton(context, provider),
            ),
            Expanded(
              child: _cartButton(context, provider),
            )
          ],
        ),
      ),
    );
  }

  Widget _cartButton(BuildContext context, CartProvider provider) {
    final _themeData = Theme.of(context);
    return OpenContainer(
      closedColor: _themeData.primaryColor,
      transitionDuration: Constants.kContainerAnimationDuration,
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: Container(
            color: _themeData.primaryColor,
            child: Center(
              child: Badge(
                animationDuration: Duration(milliseconds: 100),
                badgeColor: _themeData.primaryColorLight,
                badgeContent: Text('${provider.numberOfItemsInCart}'),
                animationType: BadgeAnimationType.scale,
                child: Icon(
                  Icons.shopping_cart,
                  color: _themeData.cardColor,
                  size: 35,
                ),
              ),
            ),
          ),
        );
      },
      openBuilder: (_, __) => CartConfirmationScreen(),
    );
  }

  Widget _sellerButton(BuildContext context, CartProvider provider) {
    final _themeData = Theme.of(context);
    return OpenContainer(
      closedColor: _themeData.cardColor,
      transitionDuration: Constants.kContainerAnimationDuration,
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: Center(
            child: Text(
              provider.cartSeller.brandName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
      openBuilder: (_, __) => ProductListScreen(provider.cartSeller),
    );
  }
}
