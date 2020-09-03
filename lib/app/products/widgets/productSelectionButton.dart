import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/index.dart' show ProductModel, StoreModel;
import '../../../widgets/index.dart' show IncrementButton;
import '../../../providers/index.dart' show CartProvider;

class ProductSelectionButton extends StatefulWidget {
  final ProductModel product;
  final StoreModel store;
  final bool enabled;

  ProductSelectionButton(
      {@required this.store, @required this.product, this.enabled = true});

  @override
  _ProductSelectionButtonState createState() => _ProductSelectionButtonState();
}

class _ProductSelectionButtonState extends State<ProductSelectionButton> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    _value = provider.quantityInCart(widget.product);
    return Container(
      child: _value == 0
          ? _AddButton(
              enabled: widget.enabled,
              onPressed: () {
                provider.addProduct(widget.store, widget.product);
                setState(() {
                  _value++;
                });
              },
            )
          : IncrementButton(
              value: _value,
              onIncrement: () {
                provider.addProduct(widget.store, widget.product);
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
            ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final Function onPressed;
  final bool enabled;

  _AddButton({@required this.onPressed, this.enabled});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final _color = this.enabled ? themeData.primaryColor : themeData.hintColor;
    final _borderColor =
        this.enabled ? themeData.primaryColor : themeData.disabledColor;

    return GestureDetector(
      onTap: this.enabled ? this.onPressed : () {},
      child: Container(
        width: 80.0,
        height: 30.0,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(color: _borderColor)),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            this.enabled ? 'ADD' : 'Not Available',
            style: themeData.textTheme.subtitle2.merge(
              TextStyle(color: _color),
            ),
          ),
        ),
      ),
    );
  }
}
