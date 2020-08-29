import 'package:flutter/material.dart';

import 'flavor.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;

  FlavorBanner({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Flavor.shared.isProduction
        ? child
        : Stack(
            children: [
              child,
              Container(
                width: 50,
                height: 50,
                child: CustomPaint(
                  painter: BannerPainter(
                    message: Flavor.shared.bannerName,
                    textDirection: Directionality.of(context),
                    layoutDirection: Directionality.of(context),
                    location: BannerLocation.topStart,
                    color: Flavor.shared.bannerColor,
                  ),
                ),
              ),
            ],
          );
  }
}
