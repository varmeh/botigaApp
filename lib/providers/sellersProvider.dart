import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/index.dart' show SellerModel;
import '../util/index.dart' show HttpService;

class SellersProvider with ChangeNotifier {
  List<SellerModel> _sellerList = [];

  UnmodifiableListView<SellerModel> get sellerList =>
      UnmodifiableListView(_sellerList);

  Future<void> getSellers() async {
    if (_sellerList.length > 0) {
      return;
    } else {
      final response = await http.get(
        HttpService.url('/api/user/sellers/5f5a35d281710e963e530a5b'),
      );

      final json = HttpService.parse(response);

      final _sellerIterable = json.map(
        (item) => SellerModel.fromJson(item),
      );

      // Iterable returned above is of type of dynamic
      // Below method is used to convert supertype list to subtype list
      _sellerList = List<SellerModel>.from(_sellerIterable);
    }
  }
}
