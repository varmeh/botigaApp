import 'dart:collection';
import 'package:flutter/material.dart';

import '../models/index.dart' show StoreModel;

class StoresProvider with ChangeNotifier {
  List<StoreModel> _storeList = new List<StoreModel>.generate(
    6,
    (index) => StoreModel(
      id: 'store_id$index',
      name: '24 Mantra ${index + 1}',
      moto: 'You, Farmers, Nature, Deserve the Best',
      segmentList: ['Grocery', 'Foods'],
      phone: '+919900099000',
      whatsapp: '+919900099000',
    ),
  );

  UnmodifiableListView<StoreModel> get storeList =>
      UnmodifiableListView(_storeList);

  // Future<StoreModel> fetchStores() {}

  void addStore(StoreModel newStore) {
    _storeList.add(newStore);
    notifyListeners();
  }
}
