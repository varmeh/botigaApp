import 'dart:collection';
import 'package:flutter/material.dart';

import '../models/index.dart' show StoreModel;

class StoresProvider with ChangeNotifier {
  List<StoreModel> _storeList;

  UnmodifiableListView<StoreModel> get storeList =>
      UnmodifiableListView(_storeList);

  set storeList(List<StoreModel> stores) {
    _storeList = stores;
  }
  // Future<StoreModel> fetchStores() {}

  void addStore(StoreModel newStore) {
    _storeList.add(newStore);
    notifyListeners();
  }
}
