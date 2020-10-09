import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      final response = await http.get(
        HttpService.url('/api/user/orders?limit=10&page=$currentPage'),
      );

      final json = HttpService.parse(response);

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
      final response = await http.get(
        HttpService.url('/api/user/orders?limit=10&page=${currentPage + 1}'),
      );

      final json = HttpService.parse(response);

      currentPage += 1;

      json['orders'].forEach((item) {
        _orders.add(OrderModel.fromJson(item));
      });
    }
  }

  Future<void> cancelOrder(String orderId) async {
    final response = await http.post(
      HttpService.url('/api/user/orders/cancel'),
      headers: {HttpHeaders.authorizationHeader: 'dummy-value'},
      body: {'orderId': '5f74502b2fff00721617b063'},
    );

    if (response.statusCode == 200) {
      // Update order information
      // for (int i = 0; i < _orders.length; i++) {
      //   if (_orders[i].id == orderId) {
      //     _orders[i].status = 'cancelled';
      //   }
      // }
    }
  }
}
