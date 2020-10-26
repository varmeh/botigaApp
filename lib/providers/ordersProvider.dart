import 'dart:collection';
import 'package:flutter/material.dart';

import '../models/index.dart' show OrderModel;
import '../util/index.dart' show Http;

class OrdersProvider with ChangeNotifier {
  int pages = 1;
  int currentPage = 1; //starting page is 1
  int totalOrders = 0;
  List<OrderModel> _orders = [];

  UnmodifiableListView<OrderModel> get orders => UnmodifiableListView(_orders);

  Future<void> getOrders() async {
    if (_orders.length > 0) {
      return;
    } else {
      final json =
          await Http.get('/api/user/orders?limit=10&page=$currentPage');

      pages = json['pages'];
      currentPage = json['currentPage'];
      totalOrders = json['totalOrders'];

      json['orders'].forEach((item) {
        _orders.add(OrderModel.fromJson(item));
      });
    }
  }

  Future<void> nextOrders() async {
    if (currentPage <= pages) {
      final json =
          await Http.get('/api/user/orders?limit=10&page=${currentPage + 1}');
      currentPage += 1;

      json['orders'].forEach((item) {
        _orders.add(OrderModel.fromJson(item));
      });
    }
  }

  Future<void> cancelOrder(String orderId) async {
    await Http.post(
      '/api/user/orders/cancel',
      body: {'orderId': '5f74502b2fff00721617b063'},
    );
  }
}
