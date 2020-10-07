import 'package:botiga/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart' show SellerModel, ProductModel;
import '../../providers/index.dart' show CartProvider;
import '../../widgets/index.dart' show IncrementButton;

const _itemPadding = EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0);

class CartScreen extends StatelessWidget {
  final String route = 'cartScreen';

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CartProvider>(context);

    return Container(
      color: AppTheme.backgroundColor,
      child: Scaffold(
        body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return _sellerInformation(_provider.cartSeller);

                        case 1:
                          return _itemList(_provider);

                        case 2:
                          return _grandBill(_provider);

                        default:
                          return Container();
                      }
                    },
                  ),
                  // PaymentBottomModal()
                ],
              )),
        ),
      ),
    );
  }

  Widget _sellerInformation(SellerModel seller) {
    final _sizedBox = SizedBox(height: 15.0);

    return Container(
      padding: _itemPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  seller.brandName,
                  style: AppTheme.textStyle.w500,
                ),
                _sizedBox,
                Text(
                  seller.businessCategory,
                ),
              ],
            ),
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

    return Container(
      padding: _itemPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: productList,
      ),
    );
  }

  Widget _itemTile(CartProvider provider, ProductModel product, int quantity) {
    return Column(
      children: [
        SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '${product.name} [${product.size}]',
                style: AppTheme.textStyle.w500,
              ),
            ),
            Expanded(
              child: Center(
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
            ),
            Expanded(
              child: Text(
                '₹${(product.price * quantity).toInt()}',
                style: AppTheme.textStyle,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _grandBill(CartProvider provider) {
    return Container(
      padding: _itemPadding,
      child: Column(
        children: [
          Divider(
            color: AppTheme.dividerColor,
            thickness: 1.0,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Total to pay',
                  style: AppTheme.textStyle.w600.color100.size(13),
                ),
              ),
              Expanded(
                child: Text(
                  '₹${provider.totalPrice.toInt()}',
                  style: AppTheme.textStyle.w600.color100.size(13),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
