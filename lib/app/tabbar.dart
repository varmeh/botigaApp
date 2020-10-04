import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import 'home/HomeScreen.dart';
import 'orders/orderListScreen.dart';
import 'cart/cartScreen.dart';
import 'profile/profileListScreen.dart';

import '../providers/index.dart' show CartProvider;
import '../util/flavorBanner.dart';
import '../theme/botigaIcons.dart';
import '../theme/index.dart';

// import '../widgets/badge.dart';

class Tabbar extends StatefulWidget {
  static String route = 'tabbar';

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _selectedIndex = 0;

  static List<Widget> _selectedTab = [
    HomeScreen(),
    OrderListScreen(),
    CartScreen(),
    ProfileListScreen(),
  ];

  @override
  void initState() {
    super.initState();

    final fbm = FirebaseMessaging();

    // Request for permission on notification on Ios device
    if (Platform.isIOS) {
      fbm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });
      fbm.requestNotificationPermissions();
    }

    fbm.getToken().then((value) => {
          // TODO upload the push notification token to database
          print('Push Token: $value')
        });

    fbm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _navigationTextStyle = AppTheme.textStyle.w500.size(12);

    return FlavorBanner(
      child: Scaffold(
        body: SafeArea(
          child: _selectedTab.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppTheme.backgroundColor,
          selectedIconTheme: IconThemeData(size: 28),
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.navigationItemColor,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(BotigaIcons.building),
              title: Text(
                'Home',
                style: _navigationTextStyle,
              ),
            ),
            BottomNavigationBarItem(
              icon: const Icon(BotigaIcons.orders),
              title: Text(
                'Orders',
                style: _navigationTextStyle,
              ),
            ),
            BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (context, provider, child) {
                  return provider.numberOfItemsInCart > 0
                      ? Badge(
                          showBadge: _selectedIndex != 2,
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
                        )
                      : Icon(BotigaIcons.basket);
                },
              ),
              title: Text(
                'Cart',
                style: _navigationTextStyle,
              ),
            ),
            BottomNavigationBarItem(
              icon: const Icon(BotigaIcons.profile),
              title: Text(
                'Profile',
                style: _navigationTextStyle,
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
