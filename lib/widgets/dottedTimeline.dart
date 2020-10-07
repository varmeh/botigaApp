import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/appTheme.dart';

class DottedTimeline extends StatelessWidget {
  final Point<double> start;
  final double height;

  DottedTimeline({@required this.start, @required this.height});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TimelinePainter(start: this.start, height: this.height),
      child: SizedBox(
        height: this.height,
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final Point<double> start;
  final double height;

  _TimelinePainter({@required this.start, @required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    const dotGap = 4.0;

    final paint = Paint();
    paint.color = AppTheme.color100;

    for (double dy = 2.0; dy < height; dy += dotGap) {
      canvas.drawCircle(Offset(start.x, start.y + dy), 1.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
