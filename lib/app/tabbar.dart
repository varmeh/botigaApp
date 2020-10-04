import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'home/HomeScreen.dart';
import 'orders/orderListScreen.dart';
import 'cart/cartScreen.dart';
import 'profile/profileListScreen.dart';

import '../util/flavorBanner.dart';
import './cart/cartBottomModal.dart';
import '../theme/botigaIcons.dart';
import '../theme/textTheme.dart';

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
    final _navigationTextStyle = TextStyles.montserrat.w500.size(12);
    return FlavorBanner(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _selectedTab.elementAt(_selectedIndex),
              CartBottomModal(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
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
              icon: const Icon(BotigaIcons.basket),
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
