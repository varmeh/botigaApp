import 'package:flutter/material.dart';

import '../../../widgets/index.dart' show IncrementButton;

class ProductSelectionButton extends StatefulWidget {
  final bool enabled;

  ProductSelectionButton({this.enabled = true});

  @override
  _ProductSelectionButtonState createState() => _ProductSelectionButtonState();
}

class _ProductSelectionButtonState extends State<ProductSelectionButton> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final _borderColor =
        widget.enabled ? themeData.primaryColor : themeData.disabledColor;
    return Container(
      width: 80.0,
      height: 30.0,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(color: _borderColor)),
      child: _value == 0
          ? _AddButton(
              enabled: widget.enabled,
              onPressed: () {
                setState(() {
                  _value++;
                });
              },
            )
          : IncrementButton(
              value: _value,
              onIncrement: () {
                setState(() {
                  _value++;
                });
              },
              onDecrement: () {
                setState(() {
                  if (_value > 0) {
                    _value--;
                  }
                });
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
    return GestureDetector(
      onTap: this.enabled ? this.onPressed : () {},
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          this.enabled ? 'ADD' : 'Not Available',
          style: themeData.textTheme.subtitle2.merge(
            TextStyle(color: _color),
          ),
        ),
      ),
    );
  }
}
