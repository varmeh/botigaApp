import 'package:flutter/material.dart';

import '../util/index.dart' show Http;
import '../models/index.dart' show SellerModel, ProductModel;

class CartProvider with ChangeNotifier {
  SellerModel cartSeller;
  double totalPrice = 0.0;
  int numberOfItemsInCart = 0;
  Map<ProductModel, int> products = {};
  List<String> _notAvailableProducts = [];

  bool get cartUpdateRequired => _notAvailableProducts.length > 0;

  void clearCart() {
    totalPrice = 0.0;
    numberOfItemsInCart = 0;
    products.clear();
    cartSeller = null;
  }

  void addProduct(SellerModel seller, ProductModel product) {
    if (cartSeller == seller) {
      products[product] =
          products.containsKey(product) ? products[product] + 1 : 1;
      totalPrice += product.price;
      numberOfItemsInCart++;
    } else {
      clearCart();
      cartSeller = seller;
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

  Future<void> allProductsAvailable() async {
    final _products = [];

    products.forEach((product, quantity) {
      _products.add({
        'productId': product.id,
        'quantity': quantity,
      });
    });

    final json = await Http.post('/api/user/orders/validate', body: {
      'sellerId': cartSeller.id,
      'products': _products,
    });

    // Reset list of not available products
    _notAvailableProducts.clear();

    if (json['totalAmount'] == totalPrice) {
      json['products'].forEach((product) {
        if (product['available']) {
          _notAvailableProducts.add(product['productId']);
        }
      });
    }
  }

  void updateCart() {
    // Product no longer available. Remove it
    for (ProductModel product in products.keys) {
      if (_notAvailableProducts.contains(product.id)) {
        totalPrice -= product.price * products[product];
        numberOfItemsInCart -= this.products[product];
        this.products.remove(product);
      }
    }
    // Empty _notAvailable products
    _notAvailableProducts.clear();
    if (totalPrice == 0) {
      cartSeller = null;
    }
    notifyListeners();
  }
}
