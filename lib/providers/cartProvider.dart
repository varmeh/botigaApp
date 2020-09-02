import 'package:flutter/material.dart';

import '../models/index.dart' show StoreModel, ProductModel;

class CartProvider with ChangeNotifier {
  StoreModel
      selectedProductListStore; // Store which is now visible in product list screen
  StoreModel
      cartStore; // Store from which current product list has been selected
  double totalPrice = 0;
  int numberOfItemsInCart = 0;
  Map<ProductModel, int> products = {};

  void addProduct(ProductModel product) {
    if (cartStore == selectedProductListStore) {
      products[product] =
          products.containsKey(product) ? products[product] + 1 : 1;
      totalPrice += product.price;
      numberOfItemsInCart++;
    } else {
      cartStore = selectedProductListStore;
      products[product] = 1;
      totalPrice = product.price;
      numberOfItemsInCart = 1;
    }
    notifyListeners();
  }

  void removeProduct(ProductModel product) {
    products[product]--;
    totalPrice -= product.price;
    numberOfItemsInCart--;
    notifyListeners();
  }

  int quantityInCart(ProductModel product) {
    return products.containsKey(product) ? products[product] : 0;
  }
}
