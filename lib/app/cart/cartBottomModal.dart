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
    return Material(
      elevation: 3.0,
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
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
                    style: AppTheme.textStyle.w600
                        .size(15)
                        .colored(AppTheme.backgroundColor),
                  ),
                ],
              ),
              Text(
                'Rs. ${provider.totalPrice}',
                style: AppTheme.textStyle.w600
                    .size(15)
                    .colored(AppTheme.backgroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// OpenContainer(
//   closedColor: AppTheme.primaryColor,
//   transitionDuration: Constants.kContainerAnimationDuration,
//   closedBuilder: (context, openContainer) {
//     return GestureDetector(
//       onTap: openContainer,
//       child: Container(
//         child: Center(
//           child: Badge(
//             animationDuration: Duration(milliseconds: 100),
//             badgeColor: AppTheme.backgroundColor,
//             badgeContent: Text('${provider.numberOfItemsInCart}'),
//             animationType: BadgeAnimationType.scale,
//             child: Icon(
//               Icons.shopping_cart,
//               color: AppTheme.backgroundColor,
//               size: 35,
//             ),
//           ),
//         ),
//       ),
//     );
//   },
//   openBuilder: (_, __) => CartConfirmationScreen(),
// ),
