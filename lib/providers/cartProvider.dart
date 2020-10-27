import 'package:flutter/material.dart';

import '../providers/index.dart' show SellersProvider, ProductsProvider;
import '../util/index.dart' show Http;
import '../models/index.dart' show SellerModel, ProductModel;

class CartProvider with ChangeNotifier {
  SellerModel cartSeller;
  double totalPrice = 0.0;
  int numberOfItemsInCart = 0;
  Map<ProductModel, int> products = {};
  List<String> _notAvailableProducts = [];
  SellersProvider _sellersProvider;
  ProductsProvider _productsProvider;

  void update(SellersProvider provider, ProductsProvider productsProvider) {
    _sellersProvider = provider;
    _productsProvider = productsProvider;
  }

  bool get cartUpdateRequired => _notAvailableProducts.length > 0;
  bool get isEmpty => products.isEmpty;

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

    if (json['totalAmount'] != totalPrice) {
      json['products'].forEach((product) {
        if (!product['available']) {
          _notAvailableProducts.add(product['productId']);
        }
      });
    }
  }

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

  void getCartAtInit() async {
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
