import 'package:flutter/material.dart';

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
        _IconButton(
          iconData: Icons.remove,
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
        _IconButton(
          iconData: Icons.add,
          onPressed: this.onIncrement,
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData iconData;
  final Function onPressed;

  _IconButton({@required this.iconData, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPressed,
      child: Icon(
        this.iconData,
        color: Theme.of(context).primaryColor,
        size: 20,
      ),
    );
  }
}
