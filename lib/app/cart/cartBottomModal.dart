import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show CartProvider;
import '../../theme/index.dart';
import '../../widgets/openContainerBottomModal.dart';
import 'cartScreen.dart';

class CartBottomModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = AppTheme.textStyle.w600
        .size(15)
        .lineHeight(1.3)
        .colored(AppTheme.backgroundColor);
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        if (provider.numberOfItemsInCart <= 0) {
          return Container();
        } else {
          return OpenContainerBottomModal(
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
                        size: 20,
                      ),
                      SizedBox(width: 16.0),
                      Text(
                        '${provider.numberOfItemsInCart} Item${provider.numberOfItemsInCart > 1 ? 's' : ''} • ₹${provider.totalAmount}',
                        style: textStyle,
                      ),
                    ],
                  ),
                  Text(
                    'GO TO CART',
                    style: textStyle,
                  ),
                ],
              ),
            ),
            openOnTap: () => CartScreen(),
          );
        }
      },
    );
  }
}
