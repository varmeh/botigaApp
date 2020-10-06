import 'package:botiga/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../../providers/index.dart' show CartProvider;
import '../../util/index.dart' show Constants;
import '../../theme/appTheme.dart';
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
    final textStyle =
        AppTheme.textStyle.w600.size(15).colored(AppTheme.backgroundColor);
    return Material(
      elevation: 3.0,
      // color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width - 40,
        child: OpenContainer(
          closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0),
            ),
          ),
          closedColor: AppTheme.primaryColor,
          transitionDuration: Constants.kContainerAnimationDuration,
          closedBuilder: (context, openContainer) {
            return GestureDetector(
              onTap: openContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          BotigaIcons.basket,
                          color: AppTheme.backgroundColor,
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          '${provider.numberOfItemsInCart} Item${provider.numberOfItemsInCart > 1 ? 's' : ''}',
                          style: textStyle,
                        ),
                      ],
                    ),
                    Text(
                      'Rs. ${provider.totalPrice}',
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            );
          },
          openBuilder: (_, __) => CartConfirmationScreen(),
        ),
      ),
    );
  }
}
