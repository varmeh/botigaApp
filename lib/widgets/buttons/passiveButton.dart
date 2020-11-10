import 'package:flutter/material.dart';

import '../../theme/index.dart';

class PassiveButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Widget icon;
  final double width;
  final double height;

  PassiveButton({
    @required this.title,
    @required this.onPressed,
    this.icon,
    this.width,
    this.height = 44.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        onPressed: onPressed,
        color: AppTheme.dividerColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: icon,
                  )
                : Container(),
            Text(
              title,
              style: AppTheme.textStyle.w500.color100.size(15),
            ),
          ],
        ),
      ),
    );
  }
}
