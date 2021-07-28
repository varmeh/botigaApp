import 'dart:io';

import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/index.dart'
    show CartProvider, UserProvider, ApartmentProvider, OrdersProvider;
import '../theme/index.dart';
import '../widgets/index.dart' show Toast;
import '../util/index.dart' show FlavorBanner, Http, KeyStore;
import 'cart/cartScreen.dart';
import 'home/HomeScreen.dart';
import 'home/products/productListScreen.dart';
import 'orders/ordersScreen.dart';
import 'orders/orderDetailScreen.dart';
import 'profile/profileScreen.dart';

class Tabbar extends StatefulWidget {
  static String route = 'tabbar';

  final int index;

  Tabbar({@required this.index});

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> with WidgetsBindingObserver {
  int _selectedIndex;

  List<Widget> _selectedTab = [
    HomeScreen(),
    OrderListScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void changeTab(int index) {
    setState(() => _selectedIndex = index);
  }

  void setStatusBarBrightness() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _selectedIndex = widget.index;
    setStatusBarBrightness();

    if (Provider.of<UserProvider>(context, listen: false).isLoggedIn) {
      // Request for permission on notification on Apple Devices
      if (Platform.isIOS) {
        Future.delayed(
          Duration(seconds: 1),
          () async {
            // Show notification in app
            await FirebaseMessaging.instance
                .setForegroundNotificationPresentationOptions(
              alert: true, // Required to display a heads up notification
              sound: true,
            );

            await FirebaseMessaging.instance.requestPermission(
              alert: true,
              announcement: false,
              badge: true,
              carPlay: false,
              criticalAlert: false,
              provisional: false,
              sound: true,
            );

            _saveToken();
          }, //Delay request to ensure screen loading
        );
      } else {
        _saveToken();

        // Required to process onMessage & onMessageOpenedApp on Android
        FirebaseMessaging.instance.getInitialMessage().then((_) {});

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          Toast(message: message.notification.body).show(context);
        });
      }

      // Called if user taps the notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.data != null) {
          if (message.data['sellerId'] != null) {
            _navigateToSeller(message.data['sellerId']);
          } else if (message.data['orderId'] != null) {
            _navigateToOrder(message.data['orderId']);
          }
        }
      });
    }
  }

  void _navigateToSeller(String sellerId) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (_selectedIndex != 0) {
      userProvider.notificationSellerId = sellerId;
      changeTab(0);
    } else {
      // User already in home tab
      final seller = Provider.of<ApartmentProvider>(context, listen: false)
          .seller(sellerId);

      if (seller != null) {
        Future.delayed(
          Duration(seconds: 1),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductListScreen(seller)),
          ),
        );
      }
    }
  }

  void _navigateToOrder(String orderId) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (_selectedIndex != 1) {
      userProvider.notificationOrderId = orderId;
      changeTab(1);
    } else {
      // User already in Order tab
      final order = Provider.of<OrdersProvider>(context, listen: false)
          .getOrderWithId(orderId);

      if (order != null) {
        Future.delayed(
          Duration(seconds: 1),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderDetailScreen(order.id)),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _saveToken() async {
    final resetToken = await KeyStore.shared.resetToken();
    if (resetToken) {
      final token = await FirebaseMessaging.instance.getToken();
      try {
        await Http.patch('/api/user/auth/token', body: {'token': token});
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: _selectedTab.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppTheme.backgroundColor,
          selectedItemColor: AppTheme.primaryColor,
          selectedLabelStyle: AppTheme.textStyle.w500.size(12),
          unselectedLabelStyle: AppTheme.textStyle.w500.size(13),
          unselectedItemColor: AppTheme.navigationItemColor,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(BotigaIcons.building),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(BotigaIcons.orders),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (context, provider, child) {
                  return Badge(
                    showBadge:
                        provider.numberOfItemsInCart > 0 && _selectedIndex != 2,
                    padding: EdgeInsets.all(6),
                    animationDuration: Duration(milliseconds: 200),
                    badgeColor: AppTheme.primaryColor,
                    badgeContent: Text(
                      '${provider.numberOfItemsInCart}',
                      style: AppTheme.textStyle.w600
                          .size(12)
                          .colored(AppTheme.backgroundColor),
                    ),
                    animationType: BadgeAnimationType.fade,
                    child: Icon(BotigaIcons.basket),
                  );
                },
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: const Icon(BotigaIcons.profile),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: changeTab,
        ),
      ),
    );
  }
}
