import 'package:flutter/material.dart';

class ColorIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final onPressed;

  ColorIconButton(
      {@required this.icon, @required this.color, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(
        this.icon,
        color: this.color,
        size: 20,
      ),
    );
  }
}
