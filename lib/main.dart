import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app/auth/index.dart';
import 'app/home/products/productListScreen.dart';
import 'app/location/index.dart';
import 'app/onboarding/index.dart';
import 'app/profile/index.dart';
import 'app/tabbar.dart';
import 'providers/index.dart'
    show
        ApartmentProvider,
        SellerProvider,
        CartProvider,
        OrdersProvider,
        UserProvider;
import 'util/index.dart' show Flavor, Http, KeyStore;

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

  // Pass all uncaught errors to Crashlytics.
  if (kReleaseMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    // Enable crashlytics only in release mode
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };
  }

  await Flavor.shared.init();
  await KeyStore.initialize();
  await Http.fetchToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ApartmentProvider()),
        ChangeNotifierProvider(create: (context) => SellerProvider()),
        ChangeNotifierProxyProvider3<UserProvider, ApartmentProvider,
            SellerProvider, CartProvider>(
          create: (context) => CartProvider(),
          update: (context, userProvider, sellersProvider, productsProvider,
                  cartProvider) =>
              cartProvider
                ..update(userProvider, sellersProvider, productsProvider),
        ),
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
      initialRoute: SplashScreen.route,
      routes: {
        // On boarding screen
        OnboardingScreen.route: (_) => OnboardingScreen(),
        SplashScreen.route: (_) => SplashScreen(),
        // Sign Up Screens
        SignupProfileScreen.route: (_) => SignupProfileScreen(),
        // Login Screens
        LoginScreen.route: (_) => LoginScreen(),
        // Location Screens
        AddAddressScreen.route: (_) => AddAddressScreen(),
        SelectApartmenWhenNoUserLoggedInScreen.route: (_) =>
            SelectApartmenWhenNoUserLoggedInScreen(),
        ManageAddressesScreen.route: (_) => ManageAddressesScreen(),
        // Product Listing Screens
        Tabbar.route: (_) => Tabbar(index: 0),
        ProductListScreen.route: (_) => ProductListScreen(),
        ProfileUpdateScreen.route: (_) => ProfileUpdateScreen(),
      },
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}
