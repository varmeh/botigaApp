import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

enum _Flavor { dev, prod, qa }

class Flavor {
  static final Flavor _singleton = Flavor._internal();
  static Flavor get shared => _singleton;

  _Flavor _flavor;

  factory Flavor() => _singleton;

  Flavor._internal();

  Future<void> init() async {
    if (_flavor == null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      switch (packageInfo.packageName) {
        case "app.botiga.botiga.dev":
          _flavor = _Flavor.dev;
          break;

        case "app.botiga.botiga.qa":
          _flavor = _Flavor.qa;
          break;

        default:
          _flavor = _Flavor.prod;
      }
    }
  }

  bool get isProduction => _flavor == _Flavor.prod;
  bool get isQa => _flavor == _Flavor.qa;

  Color get bannerColor {
    if (isProduction) {
      return Colors.transparent;
    } else if (isQa) {
      return Colors.brown;
    } else {
      return Colors.red;
    }
  }

  String get bannerName {
    if (isProduction) {
      return 'PROD';
    } else if (isQa) {
      return 'QA';
    } else {
      return 'DEV';
    }
  }

  String get baseUrl {
    if (isProduction) {
      return 'https://prod.botiga.app';
    } else if (isQa) {
      return 'https://qa.botiga.app';
    } else {
      return 'https://dev.botiga.app';
    }
  }

  String get rpayId {
    if (isProduction) {
      return 'rzp_live_U6Hf0upRNgYgtc';
    } else if (isQa) {
      return 'rzp_live_U6Hf0upRNgYgtc';
    } else {
      return 'rzp_test_eB9RogNMlDSytd';
    }
  }
}
