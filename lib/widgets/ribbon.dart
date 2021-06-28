import 'package:skeleton_text/skeleton_text.dart';
import 'package:flutter/material.dart';

import '../theme/index.dart';

class Ribbon extends StatelessWidget {
  final String text;
  final Color ribbonColor;
  final Color ribbonBackColor;
  final double leftMargin;

  Ribbon({
    @required this.text,
    @required this.ribbonColor,
    @required this.ribbonBackColor,
    this.leftMargin = 7,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonAnimation(
          child: Container(
            color: ribbonColor,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: AppTheme.textStyle.w600
                    .size(10)
                    .letterSpace(0.5)
                    .colored(AppTheme.backgroundColor),
              ),
            ),
          ),
        ),
        ClipPath(
          clipper: LeftTriangleClipper(),
          child: Container(
            height: leftMargin + 0.5,
            width: leftMargin,
            color: ribbonBackColor,
          ),
        ),
      ],
    );
  }
}

class LeftTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(LeftTriangleClipper oldClipper) => false;
}
