import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/index.dart' show ProductModel, SellerModel;
import '../../../../providers/index.dart' show CartProvider;
import '../../../../theme/index.dart';
import '../../../../widgets/index.dart' show IncrementButton;

class ProductSelectionButton extends StatefulWidget {
  final ProductModel product;
  final SellerModel seller;

  ProductSelectionButton({@required this.seller, @required this.product});

  @override
  _ProductSelectionButtonState createState() => _ProductSelectionButtonState();
}

class _ProductSelectionButtonState extends State<ProductSelectionButton> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    _value = provider.quantityInCart(widget.product);
    return _value == 0
        ? _AddButton(
            enabled: widget.product.available,
            onPressed: () {
              if (provider.cartSeller != null &&
                  provider.cartSeller != widget.seller) {
                _showCartResetConfirmationDialog(provider);
              } else {
                _addProduct(provider);
              }
            },
          )
        : IncrementButton(
            value: _value,
            onIncrement: () => _addProduct(provider),
            onDecrement: () {
              if (_value > 0) {
                provider.removeProduct(widget.product);
                setState(() => _value--);
              }
            },
          );
  }

  void _addProduct(CartProvider provider) {
    provider.addProduct(widget.seller, widget.product);
    setState(() => _value++);
  }

  void _showCartResetConfirmationDialog(CartProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Replace Cart',
          style: AppTheme.textStyle.w500.color100,
        ),
        content: Text(
          'Your cart contains items from ${provider.cartSeller.brandName}. Do you want to replace them?',
          style: AppTheme.textStyle.w400.color100,
        ),
        actions: [
          TextButton(
            child: Text(
              'No',
              style: AppTheme.textStyle.w600.colored(AppTheme.primaryColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Yes',
              style: AppTheme.textStyle.w600.colored(AppTheme.primaryColor),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              _addProduct(provider);
            },
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final bool enabled;
  final Function onPressed;

  _AddButton({@required this.onPressed, this.enabled});

  @override
  Widget build(BuildContext context) {
    final color = this.enabled ? AppTheme.primaryColor : AppTheme.color50;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: this.enabled ? this.onPressed : () {},
      child: Container(
        width: 80.0,
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          border: Border.all(color: AppTheme.buttonBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            this.enabled ? 'ADD' : 'Not Available',
            style:
                AppTheme.textStyle.w600.size(15).lineHeight(1.2).colored(color),
          ),
        ),
      ),
    );
  }
}
