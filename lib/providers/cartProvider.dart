import 'package:flutter/material.dart';

import '../models/index.dart' show StoreModel, ProductModel;

class CartProvider with ChangeNotifier {
  StoreModel cartStore;
  double totalPrice = 0.0;
  int numberOfItemsInCart = 0;
  Map<ProductModel, int> products = {};

  void clearCart() {
    totalPrice = 0.0;
    numberOfItemsInCart = 0;
    products.clear();
    cartStore = null;
  }

  void addProduct(StoreModel store, ProductModel product) {
    if (cartStore == store) {
      products[product] =
          products.containsKey(product) ? products[product] + 1 : 1;
      totalPrice += product.price;
      numberOfItemsInCart++;
    } else {
      clearCart();
      cartStore = store;
      products[product] = 1;
      totalPrice = product.price;
      numberOfItemsInCart = 1;
    }
    notifyListeners();
  }

  void removeProduct(ProductModel product) {
    if (products[product] > 0) {
      products[product]--;
			
      totalPrice -= product.price;
      numberOfItemsInCart--;
    }

    if (products[product] == 0) {
      products.remove(product);
    }
    notifyListeners();
  }

  int quantityInCart(ProductModel product) {
    return products.containsKey(product) ? products[product] : 0;
  }
}
