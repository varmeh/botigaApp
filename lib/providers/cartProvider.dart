import 'dart:async';
import 'package:flutter/material.dart';

import '../providers/index.dart' show SellersProvider, ProductsProvider;
import '../util/index.dart' show Http;
import '../models/index.dart' show SellerModel, ProductModel;

class CartProvider with ChangeNotifier {
  // Cart Data
  SellerModel cartSeller;
  double totalPrice = 0.0;
  int numberOfItemsInCart = 0;
  Map<ProductModel, int> products = {};

  // Providers to load cart at the beginning
  SellersProvider _sellersProvider;
  ProductsProvider _productsProvider;

  // Method to initialize providers. Setter DI.
  void update(SellersProvider provider, ProductsProvider productsProvider) {
    _sellersProvider = provider;
    _productsProvider = productsProvider;
  }

  bool get isEmpty => products.isEmpty;

  // Methods to manage cart - resetCart, addProduct & removeProduct
  void resetCart() {
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

  // List to remove products not available during cart validation
  List<String> _notAvailableProducts = [];
  bool get cartUpdateRequired => _notAvailableProducts.length > 0;

  // Validate products in cart. Used in cart screen
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

    if (json['totalAmount'] != totalPrice) {
      json['products'].forEach((product) {
        if (!product['available']) {
          _notAvailableProducts.add(product['productId']);
        }
      });
    }
  }

  // Remove Products from cart not available. Relies on allProductsAvailable()
  void updateCart() {
    final _products = [...products.keys];

    // Remove products in _notAvailableProducts list
    for (ProductModel product in _products) {
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

  // Save Cart to server
  bool _saveToServerInProgress = false;

  void _saveCartToServer() {
    print('save to cart called');
    if (!_saveToServerInProgress) {
      _saveToServerInProgress = true;
      Timer(Duration(seconds: 5), () async {
        print('cart triggered');
        List<Map<String, dynamic>> _productList = [];
        products.forEach((product, quantity) =>
            _productList.add({'productId': product.id, 'quantity': quantity}));

        print(_productList);
        try {
          await Http.patch('/api/user/cart', body: {
            'sellerId': cartSeller.id,
            'totalAmount': totalPrice,
            'products': _productList,
          });
          print('success');
        } catch (error) {
          print(error);
        } finally {
          _saveToServerInProgress = false;
        }
      });
    }
  }

  // Load cart at init from server
  Future<void> loadCartFromServer() async {
    try {
      // Get cart from database
      final json = await Http.get('/api/user/cart');
      if (json['products'].length > 0) {
        // Get Seller from sellersList
        cartSeller = _sellersProvider.seller(json['sellerId']);
        if (cartSeller != null) {
          // Seller exists. Fetch products for this seller to populate cart
          await _productsProvider.getProducts(cartSeller.id);

          // create a map of product ids
          Map<String, int> _productQuantityMap = {};
          json['products'].forEach(((product) =>
              _productQuantityMap[product['productId']] = product['quantity']));

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
          notifyListeners();
        }
      }
    } catch (_) {}
  }
}
