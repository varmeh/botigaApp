import 'package:flutter/material.dart';

import '../../theme/index.dart';

class BotigaIconButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;

  BotigaIconButton({
    @required this.child,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 42,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: AppTheme.dividerColor,
        ),
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
