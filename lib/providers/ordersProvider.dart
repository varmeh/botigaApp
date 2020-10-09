import 'dart:collection';
import 'package:flutter/material.dart';

import '../models/index.dart' show OrderModel;
import '../util/index.dart' show HttpService;

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
      final json = await HttpService()
          .get('/api/user/orders?limit=10&page=$currentPage');

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
      final json = await HttpService()
          .get('/api/user/orders?limit=10&page=${currentPage + 1}');

      currentPage += 1;

      json['orders'].forEach((item) {
        _orders.add(OrderModel.fromJson(item));
      });
    }
  }
}
