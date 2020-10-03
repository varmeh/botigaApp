import 'dart:collection';
import 'package:flutter/material.dart';

import '../models/index.dart' show StoreModel;
import '../util/index.dart' show HttpService;

class StoresProvider with ChangeNotifier {
  List<StoreModel> _storeList = [];

  UnmodifiableListView<StoreModel> get storeList =>
      UnmodifiableListView(_storeList);

  Future<void> getStores() async {
    if (_storeList.length > 0) {
      return;
    } else {
      final json = await HttpService().get('/api/user/stores');
      final _storeIterable = json['stores'].map(
        (item) => StoreModel.fromJson(item),
      );

      // Iterable returned above is of type of dynamic
      // Below method is used to convert supertype list to subtype list
      _storeList = List<StoreModel>.from(_storeIterable);
    }
  }
}
