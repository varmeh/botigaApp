import 'package:flutter/material.dart';

class ProfileListScreen extends StatefulWidget {
  ProfileListScreen({Key key}) : super(key: key);

  @override
  _ProfileListScreenState createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Center(
          child: Text('Profile'),
        ),
      ),
    );
  }
}
