import 'package:flutter/material.dart';

import '../theme/appTheme.dart';

class LoaderOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  LoaderOverlay({
    @required this.isLoading,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(child);

    if (isLoading) {
      final modal = Positioned.fill(
        child: ModalBarrier(
          dismissible: false,
          color: Colors.transparent,
        ),
      );

      final progressIndicator = Positioned.fill(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        ),
      );

      widgets.add(modal);
      widgets.add(progressIndicator);
    }
    return Stack(children: widgets);
  }
}
