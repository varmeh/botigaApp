import 'package:flutter/material.dart';

import '../theme/index.dart';

class IncrementButton extends StatelessWidget {
  final int value;
  final Function onIncrement;
  final Function onDecrement;

  IncrementButton({
    @required this.value,
    @required this.onIncrement,
    @required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border.all(color: AppTheme.buttonBorderColor),
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconButton(Icons.remove, AppTheme.primaryColor, this.onDecrement),
          Container(
            width: 20.0,
            alignment: Alignment.center,
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: AppTheme.textStyle.w600
                  .size(15)
                  .colored(AppTheme.primaryColor),
            ),
          ),
          _iconButton(Icons.add, AppTheme.primaryColor, this.onIncrement),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, Color color, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.0,
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }
}
