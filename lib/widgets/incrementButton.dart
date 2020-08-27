import 'package:flutter/material.dart';

import 'colorIconButton.dart';

class IncrementButton extends StatelessWidget {
  final int value;
  final Function onIncrement;
  final Function onDecrement;

  IncrementButton(
      {@required this.value,
      @required this.onIncrement,
      @required this.onDecrement});

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ColorIconButton(
          icon: Icons.remove,
          color: Theme.of(context).primaryColor,
          onPressed: this.onDecrement,
        ),
        Text(
          value.toString(),
          style: _themeData.textTheme.subtitle1.merge(
            TextStyle(
              color: _themeData.primaryColor,
            ),
          ),
        ),
        ColorIconButton(
          icon: Icons.add,
          color: Theme.of(context).primaryColor,
          onPressed: this.onIncrement,
        ),
      ],
    );
  }
}
