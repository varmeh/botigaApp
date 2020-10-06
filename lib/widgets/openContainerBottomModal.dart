import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import '../theme/index.dart';

class OpenContainerBottomModal extends StatelessWidget {
  final Widget child;
  final Function onTap;

  OpenContainerBottomModal({@required this.child, @required this.onTap});

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
              onTap: openContainer,
              child: this.child,
            );
          },
          openBuilder: (_, __) => this.onTap(),
        ),
      ),
    );
  }
}
