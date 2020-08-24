import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static String route = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Botiga'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text('Flutter Demo Home Page'),
          ),
        ),
      ),
    );
  }
}
