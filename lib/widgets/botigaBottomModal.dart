import 'package:flutter/material.dart';

import '../theme/index.dart';
import 'loaderOverlay.dart';

/*
 *  
 * Call show(context) method to display bottomModalSheet 
 */
class BotigaBottomModal {
  final Column child;
  final bool isDismissible;
  final Color color;

  BotigaBottomModal({
    @required this.child,
    this.isDismissible = true,
    this.color,
  });

  bool _isLoading = false;
  Function(bool) _animation;

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: isDismissible,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            _animation = (value) => setState(() => _isLoading = value);
            return LoaderOverlay(
              isLoading: _isLoading,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                  color: color ?? AppTheme.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16.0),
                    topRight: const Radius.circular(16.0),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 22.0,
                  right: 22.0,
                  top: 42.0,
                  bottom: 32.0,
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      mainAxisAlignment: child.mainAxisAlignment,
                      crossAxisAlignment: child.crossAxisAlignment,
                      mainAxisSize: MainAxisSize.min,
                      children: [...child.children],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // This method used to control animation
  void animation(bool value) => _animation != null ? _animation(value) : null;
}
