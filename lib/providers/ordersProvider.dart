import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';

import '../models/index.dart' show OrderModel;
import '../util/index.dart' show Http;

class OrdersProvider with ChangeNotifier {
  int pages = 0;
  int currentPage = 0;
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
    if (currentPage + 1 < pages) {
      final json =
          await Http.get('/api/user/orders?limit=10&page=${currentPage + 1}');
      currentPage += 1;

      json['orders'].forEach((item) {
        _orders.add(OrderModel.fromJson(item));
      });
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      final json = await Http.post(
        '/api/user/orders/cancel',
        headers: {HttpHeaders.authorizationHeader: 'dummy-value'},
        body: {'orderId': '5f74502b2fff00721617b063'},
      );
    } catch (error) {}
  }
}
