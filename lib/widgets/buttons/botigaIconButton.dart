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
    return FlatButton(
      height: 42.0,
      minWidth: 42.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: child,
      color: AppTheme.dividerColor,
      onPressed: onPressed,
    );
  }
}
