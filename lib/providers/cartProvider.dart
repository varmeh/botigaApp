import 'dart:async';

import 'package:flutter/material.dart';

import '../providers/index.dart'
    show UserProvider, SellersProvider, ProductsProvider;
import '../util/index.dart' show Http;
import '../models/index.dart' show SellerModel, ProductModel;

class CartProvider with ChangeNotifier {
  // Cart Data
  SellerModel cartSeller;
  double totalPrice = 0.0;
  int numberOfItemsInCart = 0;
  Map<ProductModel, int> products = {};

  // Providers to load cart at the beginning
  UserProvider _userProvider;
  SellersProvider _sellersProvider;
  ProductsProvider _productsProvider;

  // Method to initialize providers. Setter DI.
  void update(UserProvider userProvider, SellersProvider sellerProvider,
      ProductsProvider productsProvider) {
    _userProvider = userProvider;
    _sellersProvider = sellerProvider;
    _productsProvider = productsProvider;
  }

  bool get isEmpty => products.isEmpty;
  bool get canCheckout => _userProvider.isLoggedIn;

  // Methods to manage cart - resetCart, addProduct & removeProduct
  void resetCart() {
    totalPrice = 0.0;
    numberOfItemsInCart = 0;
    products.clear();
    cartSeller = null;
    notifyListeners();
  }

  void addProduct(SellerModel seller, ProductModel product) {
    if (cartSeller == seller) {
      products[product] =
          products.containsKey(product) ? products[product] + 1 : 1;
      totalPrice += product.price;
      numberOfItemsInCart++;
    } else {
      resetCart();
      cartSeller = seller;
      products[product] = 1;
      totalPrice = product.price;
      numberOfItemsInCart = 1;
    }
    _saveCartToServer();
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

    if (products.length == 0) {
      // Cart is empty
      resetCart();
    }
    _saveCartToServer();
    notifyListeners();
  }

  int quantityInCart(ProductModel product) {
    return products.containsKey(product) ? products[product] : 0;
  }

  Future<dynamic> checkout({String apartmentId, String house}) async {
    if (_userProvider.isLoggedIn) {
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
      'apartmentId': apartmentId,
      'house': house,
      'totalAmount': totalPrice,
      'products': productList
    });

    final Map<String, String> data = {};
    data['paymentId'] = json['paymentId'];
    data['paymentToken'] = json['paymentToken'];

    // As order has been created, reset cart & update to cloud
    resetCart();
    _saveCartToServer();

    return data;
  }

/* 
* Cart Cloud Implementation
* 	- _saveCartToServer - Method to upload cart to server
*		
*		- loadCartFromServer 
*			- Method to download cart from server
*			- Called Once after login
*/

  bool _saveToServerInProgress =
      false; // variable to control upload cart calls on every user action

  void _saveCartToServer() {
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
            'totalAmount': totalPrice,
            'products': _productList,
          });
        } catch (_) {} finally {
          _saveToServerInProgress = false;
        }
      });
    }
  }

  void loadCartFromServer() {
    Future.delayed(Duration(seconds: 2), () async {
      try {
        // Get cart from database
        final json = await Http.get('/api/user/cart');
        if (json['products'].length > 0 && json['sellerId'] != null) {
          // Get Seller from sellersList
          cartSeller = _sellersProvider.seller(json['sellerId']);
          if (cartSeller != null) {
            // Seller exists. Fetch products for this seller to populate cart
            await _productsProvider.getProducts(cartSeller.id);

            // create a map of product ids
            Map<String, int> _productQuantityMap = {};
            json['products'].forEach(((product) =>
                _productQuantityMap[product['productId']] =
                    product['quantity']));

            // Look for products in each category & add to cart when found
            _productsProvider.products(cartSeller.id).forEach((category) {
              category.products.forEach((product) {
                if (_productQuantityMap[product.id] != null) {
                  products[product] = _productQuantityMap[product.id];
                  numberOfItemsInCart += products[product];
                  totalPrice += products[product] * product.price;
                  _productQuantityMap.remove(product.id);
                }
              });
            });
            await _validateProducts();
          }
        }
      } catch (_) {}
    });
  }

  // Validate products in cart
  Future<void> _validateProducts() async {
    final _products = [];

    products.forEach((product, quantity) {
      _products.add({
        'productId': product.id,
        'quantity': quantity,
      });
    });

    try {
      final json = await Http.post('/api/user/orders/validate', body: {
        'sellerId': cartSeller.id,
        'products': _products,
      });

      if (json['totalAmount'] != totalPrice) {
        List<String> _notAvailableProducts = [];

        json['products'].forEach((product) {
          if (!product['available']) {
            _notAvailableProducts.add(product['productId']);
          }
        });

        // Remove products in _notAvailableProducts list
        for (ProductModel product in products.keys) {
          if (_notAvailableProducts.contains(product.id)) {
            totalPrice -= product.price * products[product];
            numberOfItemsInCart -= this.products[product];
            this.products.remove(product);
          }
        }

        if (totalPrice == 0) {
          resetCart();
        }
        _saveCartToServer();
      }
    } catch (_) {} finally {
      notifyListeners();
    }
  }
}
