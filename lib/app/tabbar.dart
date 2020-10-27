import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import 'home/HomeScreen.dart';
import 'orders/ordersScreen.dart';
import 'cart/cartScreen.dart';
import 'profile/profileScreen.dart';

import '../providers/index.dart' show CartProvider;
import '../util/index.dart' show FlavorBanner, Http;
import '../theme/index.dart';

class Tabbar extends StatefulWidget {
  static String route = 'tabbar';

  final int index;

  Tabbar({@required this.index});

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _selectedIndex;
  FirebaseMessaging _fbm;

  List<Widget> _selectedTab = [
    HomeScreen(),
    OrderListScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;

    // Configure Firebase Messaging
    _fbm = FirebaseMessaging();

    // Request for permission on notification on Ios device
    if (Platform.isIOS) {
      _fbm.onIosSettingsRegistered.listen((data) {
        _saveToken();
      });
      _fbm.requestNotificationPermissions();
    } else {
      _saveToken();
    }

    _fbm.configure(
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

  void _saveToken() async {
    final token = await _fbm.getToken();
    try {
      await Http.patch('/api/user/auth/token', body: {'token': token});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: _selectedTab.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppTheme.backgroundColor,
          selectedIconTheme: IconThemeData(size: 28),
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
