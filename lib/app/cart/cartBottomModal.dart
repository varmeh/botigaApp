import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import '../../providers/index.dart' show CartProvider;

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
    final _themeData = Theme.of(context);
    return Material(
      elevation: 3.0,
      child: Container(
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: _storeButton(_themeData, provider),
            ),
            Expanded(
              child: _cartButton(_themeData, provider),
            )
          ],
        ),
      ),
    );
  }

  Widget _cartButton(ThemeData _themeData, CartProvider provider) {
    return GestureDetector(
      onTap: () {},
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
  }

  Widget _storeButton(ThemeData _themeData, CartProvider provider) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: _themeData.cardColor,
        padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                provider.cartStore.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text('Add More'),
            )
          ],
        ),
      ),
    );
  }
}
