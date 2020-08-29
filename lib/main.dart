import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './util/index.dart' show Flavor;
import 'theme/appTheme.dart';
import 'app/tabbar.dart';

import 'app/products/productListScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restricting Orientation to Portrait Mode only
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  await Flavor.shared.init();
  runApp(BotigaApp());
}

class BotigaApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      title: 'Botiga',
      theme: AppTheme.light,
      initialRoute: Tabbar.route,
      routes: {
        Tabbar.route: (context) => Tabbar(),
        ProductListScreen.route: (context) => ProductListScreen(),
      },
    );
  }
}
