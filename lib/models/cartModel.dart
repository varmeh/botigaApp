import 'package:botiga/models/index.dart';
import 'package:flutter/foundation.dart';
import 'dart:collection';

import 'storeModel.dart';

class CartItemModel {
  final String name;
  final String quantity;
  final double price;
  final int items;

  CartItemModel({
    @required this.name,
    @required this.quantity,
    @required this.price,
    @required this.items,
  });
}

class CartModel extends ChangeNotifier {
  StoreModel _store;
  final Map<String, CartItemModel> _items = {};

  void add(ProductModel product, int itemsAdded) {
    _items[product.id] = CartItemModel(
      name: product.name,
      quantity: product.quantity,
      price: product.price,
      items: itemsAdded,
    );
  }
}
