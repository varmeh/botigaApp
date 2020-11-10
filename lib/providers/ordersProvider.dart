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

  void resetOrders() {
    pages = 1;
    currentPage = 1;
    totalOrders = 1;
    _orders.clear();
  }

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

  OrderModel getOrderWithId(String orderId) {
    var _order;

    for (var order in _orders) {
      if (order.id == orderId) {
        _order = order;
        break;
      }
    }
    return _order;
  }

  Future<void> cancelOrder(String orderId) async {
    await Http.post(
      '/api/user/orders/cancel',
      body: {'orderId': orderId},
    );

    _orders.clear(); // clear to re-fetch data
    await getOrders(); //refetch data
    notifyListeners();
  }

  Future<Map<String, String>> retryPayment(String orderId) async {
    final json = await Http.post('/api/user/orders/transaction/retry',
        body: {'orderId': orderId});

    final Map<String, String> data = {};
    data['paymentId'] = json['paymentId'];
    data['paymentToken'] = json['paymentToken'];

    return data;
  }
}
