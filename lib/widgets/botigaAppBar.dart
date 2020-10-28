import 'package:flutter/material.dart';

import '../theme/index.dart';

class BotigaAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final List<Widget> actions;

  BotigaAppBar(
    this.title, {
    Key key,
    this.actions,
  })  : preferredSize = Size.fromHeight(56.0), //setting to default height
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0.0,
      leading: Navigator.canPop(context)
          ? GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: AppTheme.color100,
              ),
            )
          : Container(),
      title: Text(
        title,
        style: AppTheme.textStyle.w600.color100.size(20).lineHeight(1.25),
      ),
      backgroundColor: AppTheme.backgroundColor,
      brightness: Brightness.light,
      elevation: 0.0,
      actions: actions,
    );
  }
}
