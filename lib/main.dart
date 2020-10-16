import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'providers/index.dart'
    show SellersProvider, ProductsProvider, CartProvider, OrdersProvider;
import 'util/index.dart' show Flavor;
import 'app/tabbar.dart';
import 'app/auth/index.dart';
import 'app/location/index.dart';

import 'app/home/products/productListScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restricting Orientation to Portrait Mode only
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  await Firebase.initializeApp();

  await Flavor.shared.init();

  // Pass all uncaught errors to Crashlytics.
  if (kReleaseMode) {
    // Enable crashlytics only in release mode
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SellersProvider()),
        ChangeNotifierProvider(create: (context) => ProductsProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrdersProvider()),
      ],
      child: BotigaApp(),
    ),
  );
}

class BotigaApp extends StatelessWidget {
  // This widget is the root of your application.
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      title: 'Botiga',
      initialRoute: SignupProfileScreen.route,
      routes: {
        // Sign Up Screens
        WelcomeScreen.route: (context) => WelcomeScreen(),
        SignupOtpScreen.route: (context) => SignupOtpScreen(),
        SignupProfileScreen.route: (context) => SignupProfileScreen(),
        // Login Screens
        LoginScreen.route: (context) => LoginScreen(),
        LoginOtpScreen.route: (context) => LoginOtpScreen(),
        LoginPinScreen.route: (context) => LoginPinScreen(),
        SetPinScreen.route: (context) => SetPinScreen(),
        // Product Listing Screens
        Tabbar.route: (context) => Tabbar(index: 0),
        ProductListScreen.route: (context) => ProductListScreen(),
        SelectCityScreen.route: (context) => SelectCityScreen(),
        SearchApartmentScreen.route: (context) => SearchApartmentScreen(),
      },
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}
