import 'package:flutter/material.dart';

class Tabbar extends StatefulWidget {
  static String route = 'tabbar';

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: optionStyle,
    ),
    Text(
      'Orders',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Botiga'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(size: 40),
        unselectedIconTheme: IconThemeData(size: 30),
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
