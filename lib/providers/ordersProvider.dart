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

      final _orderIterable = json['orders'].map(
        (item) => OrderModel.fromJson(item),
      );

      // Iterable returned above is of type of dynamic
      // Below method is used to convert supertype list to subtype list
      _orders = List<OrderModel>.from(_orderIterable);
    }
  }
}
