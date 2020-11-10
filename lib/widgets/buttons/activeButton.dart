import 'package:flutter/material.dart';

import '../../theme/index.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Widget icon;
  final double width;
  final double height;
  final bool bold;

  PrimaryButton({
    @required this.title,
    @required this.onPressed,
    this.icon,
    this.width,
    this.bold = true,
    this.height = 52.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8.0),
        ),
        onPressed: onPressed,
        color: AppTheme.primaryColor,
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
              style: AppTheme.textStyle
                  .size(15.0)
                  .weight(bold ? FontWeight.w600 : FontWeight.w500)
                  .lineHeight(1.5)
                  .colored(AppTheme.backgroundColor),
            ),
          ],
        ),
      ),
    );
  }
}
