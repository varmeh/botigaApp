import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

enum _Flavor { dev, prod }

class FlavorBanner extends StatelessWidget {
  final Widget child;

  FlavorBanner({@required this.child});

  Future<_Flavor> get _flavor async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    switch (packageInfo.packageName) {
      case "app.botiga.botiga.dev":
        return _Flavor.dev;
      default:
        return _Flavor.prod;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: _flavor,
      builder: (context, AsyncSnapshot<_Flavor> snapshot) {
        if (snapshot.hasData) {
          final _flavor = snapshot.data;
          return _flavor.isProduction
              ? child
              : Stack(
                  children: [child, _buildBanner(context, _flavor)],
                );
        } else {
          return child;
        }
      },
    );
  }

  Widget _buildBanner(BuildContext context, _Flavor _flavor) {
    return Container(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: BannerPainter(
          message: _flavor.bannerName,
          textDirection: Directionality.of(context),
          layoutDirection: Directionality.of(context),
          location: BannerLocation.topStart,
          color: _flavor.bannerColor,
        ),
      ),
    );
  }
}

extension _FlavorExtension on _Flavor {
  String get bannerName {
    switch (this) {
      case _Flavor.dev:
        return 'DEV';

      default:
        return 'PROD';
    }
  }

  bool get isProduction => this == _Flavor.prod;

  Color get bannerColor {
    switch (this) {
      case _Flavor.dev:
        return Colors.brown;

      default:
        return Colors.teal;
    }
  }
}
