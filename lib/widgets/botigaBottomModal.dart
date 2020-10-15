import 'package:flutter/material.dart';

import '../theme/index.dart';

/*
 *  
 * Call show(context) method to display bottomModalSheet 
 */
class BotigaBottomModal {
  final Widget child;
  final bool isDismissible;
  final Color color;

  BotigaBottomModal({
    @required this.child,
    this.isDismissible = true,
    this.color,
  });

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: isDismissible,
      builder: (context) {
        return Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
            color: color ?? AppTheme.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0),
            ),
          ),
          padding: const EdgeInsets.only(left: 22, right: 22, top: 42),
          child: child,
        );
      },
    );
  }
}
