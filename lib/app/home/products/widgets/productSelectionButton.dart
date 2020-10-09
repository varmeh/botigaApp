import 'package:botiga/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/index.dart' show ProductModel, SellerModel;
import '../../../../widgets/index.dart' show IncrementButton;
import '../../../../providers/index.dart' show CartProvider;

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
              provider.addProduct(widget.seller, widget.product);
              setState(() {
                _value++;
              });
            },
          )
        : IncrementButton(
            value: _value,
            onIncrement: () {
              provider.addProduct(widget.seller, widget.product);
              setState(() {
                _value++;
              });
            },
            onDecrement: () {
              if (_value > 0) {
                provider.removeProduct(widget.product);
                setState(() {
                  _value--;
                });
              }
            },
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
