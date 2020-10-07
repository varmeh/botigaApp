import 'package:botiga/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart' show ProductModel;
import '../../providers/index.dart' show CartProvider;
import '../../widgets/index.dart' show IncrementButton;

import 'widgets/cartDeliveryInfo.dart';

class CartScreen extends StatelessWidget {
  final String route = 'cartScreen';

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CartProvider>(context);

    return Container(
      color: AppTheme.backgroundColor,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: AppTheme.textColor100,
            ),
          ),
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Container(
            color: AppTheme.backgroundColor,
            child: _provider.numberOfItemsInCart > 0
                ? _cartDetails(_provider)
                : _cartEmpty(),
          ),
        ),
      ),
    );
  }

  Widget _cartEmpty() {
    return Center(
      child: Text('Empty'),
    );
  }

  Widget _cartDetails(CartProvider provider) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ListView.builder(
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
        // PaymentBottomModal()
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

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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

  Widget _totalPrice(double totalPrice) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                  '₹${totalPrice.toString()}',
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
