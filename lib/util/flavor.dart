import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

enum _Flavor { dev, prod }

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

        default:
          _flavor = _Flavor.prod;
      }
    }
  }

  bool get isProduction => _flavor == _Flavor.prod;

  Color get bannerColor => isProduction ? Colors.transparent : Colors.brown;

  String get bannerName => isProduction ? 'PROD' : 'DEV';

  String get baseUrl =>
      isProduction ? 'https://prod.botiga.app' : 'https://dev.botiga.app';

  String get paytmMid =>
      isProduction ? 'BOTIGA19474156290102' : 'OJdkNI97902555723463';

  String get rpayId =>
      isProduction ? 'rzp_live_U6Hf0upRNgYgtc' : 'rzp_test_eB9RogNMlDSytd';

  String get paytmTransactionUrl => isProduction
      ? 'https://securegw.paytm.in'
      : 'https://securegw-stage.paytm.in';
}
