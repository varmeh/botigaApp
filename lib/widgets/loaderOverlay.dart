import 'package:botiga/widgets/index.dart';
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
      final modal = ModalBarrier(
        dismissible: false,
        color: Colors.transparent,
      );

      final progressIndicator = Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
      );

      widgets.add(modal);
      widgets.add(progressIndicator);
    }
    return Stack(children: widgets);
  }
}
