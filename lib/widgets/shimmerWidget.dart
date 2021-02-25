import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/index.dart';

class ShimmerWidget extends StatelessWidget {
  final Widget child;

  ShimmerWidget({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.color05,
      highlightColor: AppTheme.color25,
      enabled: true,
      child: child,
    );
  }
}
