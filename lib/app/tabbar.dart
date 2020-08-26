import 'package:flutter/material.dart';

import 'stores/storeListScreen.dart';
import 'orders/orderListScreen.dart';

class Tabbar extends StatefulWidget {
  static String route = 'tabbar';

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _selectedIndex = 1;

  static List<Widget> _selectedTab = [
    StoreListScreen(),
    OrderListScreen(),
    Text(
      'Profile',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Botiga'),
      ),
      body: SafeArea(
        child: _selectedTab.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: const Icon(Icons.store),
            title: const Text('Stores'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt),
            title: const Text('Orders'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
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
    );
  }
}
