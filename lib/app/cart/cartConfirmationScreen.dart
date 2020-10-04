import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart' show SellerModel, ProductModel;
import '../../providers/index.dart' show CartProvider;
import '../../widgets/index.dart' show ContactPartnerWidget, IncrementButton;
import 'paymentBottomModal.dart';

const _itemPadding = EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0);

class CartConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    final _provider = Provider.of<CartProvider>(context);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return _sellerInformation(
                              _themeData, _provider.cartSeller);

                        case 1:
                          return _itemList(_themeData, _provider);

                        case 2:
                          return _grandBill(_themeData, _provider);

                        default:
                          return Container(
                            height: 50,
                            color: _themeData.cardColor,
                          );
                      }
                    },
                  ),
                  PaymentBottomModal()
                ],
              )),
        ),
      ),
    );
  }

  Widget _sellerInformation(ThemeData themeData, SellerModel seller) {
    final _sizedBox = SizedBox(height: 15.0);

    return Container(
      color: themeData.cardColor,
      padding: _itemPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  seller.brandName,
                  style: themeData.textTheme.headline6,
                ),
                _sizedBox,
                Text(
                  seller.businessCategory,
                ),
              ],
            ),
          ),
          Expanded(
            child: ContactPartnerWidget(
              phone: seller.phone,
              whatsapp: seller.whatsapp,
            ),
          )
        ],
      ),
    );
  }

  Widget _itemList(ThemeData themeData, CartProvider provider) {
    final List<Widget> productList = [];
    provider.products.forEach(
      (product, quantity) {
        productList.add(_itemTile(themeData, provider, product, quantity));
      },
    );

    return Container(
      color: themeData.cardColor,
      padding: _itemPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: productList,
      ),
    );
  }

  Widget _itemTile(ThemeData themeData, CartProvider provider,
      ProductModel product, int quantity) {
    return Column(
      children: [
        SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '${product.name} [${product.size}]',
                style: themeData.textTheme.subtitle1,
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
                style: themeData.textTheme.subtitle1,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _grandBill(ThemeData themeData, CartProvider provider) {
    return Container(
      color: themeData.cardColor,
      padding: _itemPadding,
      child: Column(
        children: [
          Divider(
            color: themeData.dividerColor,
            thickness: 1.0,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Total Amount to be Paid',
                  style: themeData.textTheme.subtitle1,
                ),
              ),
              Expanded(
                child: Text(
                  '₹${provider.totalPrice.toInt()}',
                  style: themeData.textTheme.subtitle1,
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
