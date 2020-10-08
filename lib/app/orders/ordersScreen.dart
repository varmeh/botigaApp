import 'package:flutter/material.dart';

class OrderListScreen extends StatefulWidget {
  OrderListScreen({Key key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Container();
      },
    );
  }
}
