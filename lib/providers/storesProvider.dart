import 'dart:collection';
import 'package:flutter/material.dart';

import '../models/index.dart' show SellerModel;
import '../util/index.dart' show HttpService;

class StoresProvider with ChangeNotifier {
  List<SellerModel> _storeList = [];

  UnmodifiableListView<SellerModel> get storeList =>
      UnmodifiableListView(_storeList);

  Future<void> getStores() async {
    if (_storeList.length > 0) {
      return;
    } else {
      final json =
          await HttpService().get('/api/user/sellers/5f5a35d281710e963e530a5b');
      final _storeIterable = json.map(
        (item) => SellerModel.fromJson(item),
      );

      // Iterable returned above is of type of dynamic
      // Below method is used to convert supertype list to subtype list
      _storeList = List<SellerModel>.from(_storeIterable);
    }
  }
}
