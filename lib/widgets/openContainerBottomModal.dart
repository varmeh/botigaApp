import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../theme/index.dart';

class OpenContainerBottomModal extends StatelessWidget {
  final Widget child;
  final Function openOnTap;

  OpenContainerBottomModal({
    @required this.child,
    @required this.openOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3.0,
      shadowColor: Colors.transparent,
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width - 40,
        child: OpenContainer(
          closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0),
            ),
          ),
          closedColor: AppTheme.primaryColor,
          transitionDuration: Duration(milliseconds: 500),
          closedBuilder: (context, openContainer) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: openContainer,
              child: this.child,
            );
          },
          openBuilder: (_, __) => this.openOnTap(),
        ),
      ),
    );
  }
}
