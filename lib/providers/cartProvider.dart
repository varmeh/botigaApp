import 'dart:async';

import 'package:flutter/material.dart';

import '../models/index.dart' show SellerModel, ProductModel, OrderModel;
import '../providers/index.dart'
    show UserProvider, ApartmentProvider, SellerProvider;
import '../util/index.dart' show Http;

class CartProvider with ChangeNotifier {
  // Cart Data
  SellerModel cartSeller;
  double totalPrice = 0.0;
  Map<ProductModel, int> products = {};

  // Providers to load cart at the beginning
  UserProvider _userProvider;
  ApartmentProvider _apartmentProvider;
  SellerProvider _sellerProvider;

  // Method to initialize providers. Setter DI.
  void update(UserProvider userProvider, ApartmentProvider apartmentProvider,
      SellerProvider sellerProvider) {
    _userProvider = userProvider;
    _apartmentProvider = apartmentProvider;
    _sellerProvider = sellerProvider;
  }

  bool get isEmpty => products.isEmpty;
  bool get userLoggedIn => _userProvider.isLoggedIn;
  bool get hasAddress => _userProvider.selectedAddress != null;

  int get numberOfItemsInCart => products.length == 0
      ? 0
      : products.values.reduce((cur, next) => cur + next);

  // Methods to manage cart - clearCart, addProduct & removeProduct
  void clearCart() {
    totalPrice = 0.0;
    products.clear();
    cartSeller = null;
    notifyListeners();
  }

  void addProduct(SellerModel seller, ProductModel product) {
    if (cartSeller == seller) {
      products[product] =
          products.containsKey(product) ? products[product] + 1 : 1;
      totalPrice += product.price;
    } else {
      clearCart();
      cartSeller = seller;
      products[product] = 1;
      totalPrice = product.price;
    }
    saveCartToServer();
    notifyListeners();
  }

  void removeProduct(ProductModel product) {
    if (products[product] > 0) {
      products[product]--;

      totalPrice -= product.price;
    }

    if (products[product] == 0) {
      products.remove(product);
    }

    if (products.length == 0) {
      // Cart is empty
      clearCart();
    }
    saveCartToServer();
    notifyListeners();
  }

  int quantityInCart(ProductModel product) {
    return products.containsKey(product) ? products[product] : 0;
  }

  // Checkout works only when - userLoggedIn && has a valid saved address
  Future<dynamic> checkout() async {
    if (!userLoggedIn) {
      throw new FormatException('Login to proceed with checkout');
    }

    final productList = [];
    products.forEach((product, quantity) {
      productList.add({
        'name': product.name,
        'price': product.price,
        'quantity': quantity,
        'unitInfo': product.size
      });
    });

    final json = await Http.post('/api/user/orders', body: {
      'sellerId': cartSeller.id,
      'addressId': _userProvider.selectedAddress.id,
      'totalAmount': totalPrice,
      'products': productList
    });

    final order = OrderModel.fromJson(json);
    // As order has been created, reset cart & update to cloud
    return order;
  }

  Future<Map<String, String>> orderPayment(String orderId) async {
    final json = await Http.post('/api/user/orders/transaction',
        body: {'orderId': orderId});

    final Map<String, String> data = {};
    data['id'] = json['id'];

    return data;
  }

  Future<void> paymentCancelled(String orderId) async {
    await Http.post('/api/user/orders/transaction/cancelled',
        body: {'orderId': orderId});
  }

  bool _saveToServerInProgress =
      false; // variable to control upload cart calls on every user action

// Upload User cart to server
// Cart is saved specific to each address
  void saveCartToServer() {
    if (!_userProvider.isLoggedIn) return;
    if (!_saveToServerInProgress) {
      _saveToServerInProgress = true;
      Timer(Duration(seconds: 2), () async {
        List<Map<String, dynamic>> _productList = [];
        products.forEach((product, quantity) =>
            _productList.add({'productId': product.id, 'quantity': quantity}));

        try {
          await Http.patch('/api/user/cart', body: {
            'sellerId': cartSeller?.id,
            'addressId': _userProvider.selectedAddress.id,
            'products': _productList,
          });
        } catch (_) {} finally {
          _saveToServerInProgress = false;
        }
      });
    }
  }

// Fetch cart for selected address
  void loadCartFromServer() {
    Future.delayed(Duration(seconds: 2), () async {
      try {
        // Get cart from database
        final json = await Http.get(
            '/api/user/cart/${_userProvider.selectedAddress.id}');

        // Check if cart has products
        if (json['products'].length > 0 && json['sellerId'] != null) {
          // Get Seller from sellersList
          cartSeller = _apartmentProvider.seller(json['sellerId']);
          if (cartSeller != null) {
            // Seller exists. Fetch products for this seller to populate cart
            await _sellerProvider.getProducts(cartSeller.id);

            // create a map of product ids
            Map<String, int> _productQuantityMap = {};
            json['products'].forEach(((product) =>
                _productQuantityMap[product['productId']] =
                    product['quantity']));

            // Look for products in each category & add to cart when found
            _sellerProvider.products(cartSeller.id).forEach((category) {
              category.products.forEach((product) {
                if (_productQuantityMap[product.id] != null &&
                    product.available) {
                  // add only available products
                  products[product] = _productQuantityMap[product.id];
                  totalPrice += products[product] * product.price;
                }
              });
            });
            notifyListeners();
          }
        }
      } catch (_) {}
    });
  }
}
