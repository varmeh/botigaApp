import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'stores/storeListScreen.dart';
import 'orders/orderListScreen.dart';
import 'profile/profileListScreen.dart';

import '../util/index.dart' show FlavorBanner;
import './cart/cartBottomModal.dart';
import '../theme/index.dart' show BotigaIcons;

class Tabbar extends StatefulWidget {
  static String route = 'tabbar';

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _selectedIndex = 0;

  static List<Widget> _selectedTab = [
    StoreListScreen(),
    OrderListScreen(),
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
          //TODO: upload the push notification token to database
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
    return FlavorBanner(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Botiga'),
        ),
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
          items: const [
            BottomNavigationBarItem(
              icon: const Icon(BotigaIcons.store),
              title: const Text('Botiga'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(BotigaIcons.orders),
              title: const Text('Orders'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(BotigaIcons.profile),
              title: const Text('Profile'),
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
