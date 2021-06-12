import 'package:flutter/material.dart';

import '../models/index.dart' show CategoryModel, CouponModel, ProductModel;
import '../util/index.dart' show Http;

class SellerProvider with ChangeNotifier {
  Map<String, List<CategoryModel>> _sellerProducts = {};
  Map<String, List<String>> _sellerBanners = {};
  Map<String, List<CouponModel>> _sellerCoupons = {};
  Map<String, List<ProductModel>> _sellerRecommended = {};

  List<CategoryModel> products(String sellerId) =>
      _sellerProducts.containsKey(sellerId) ? _sellerProducts[sellerId] : [];

  List<String> banners(String sellerId) =>
      _sellerBanners.containsKey(sellerId) ? _sellerBanners[sellerId] : [];

  List<CouponModel> coupons(String sellerId) =>
      _sellerCoupons.containsKey(sellerId) ? _sellerCoupons[sellerId] : [];

  List<ProductModel> recommendedProducts(String sellerId) =>
      _sellerRecommended.containsKey(sellerId)
          ? _sellerRecommended[sellerId]
          : [];

  bool hasBanners(String sellerId) => banners(sellerId).length > 0;
  bool hasCoupons(String sellerId) => coupons(sellerId).length > 0;
  bool hasRecommendedProducts(String sellerId) =>
      recommendedProducts(sellerId).length > 0;

  Future<void> getProducts(String sellerId) async {
    if (_sellerProducts.containsKey(sellerId)) {
      return;
    } else {
      final json = await Http.get('/api/user/sellers/data/$sellerId');

      _sellerBanners[sellerId] =
          json['banners'].map((item) => item as String).cast<String>().toList();

      _sellerCoupons[sellerId] = json['coupons']
          .map(
            (item) => CouponModel.fromJson(item),
          )
          .cast<CouponModel>()
          .toList();

      _sellerProducts[sellerId] = json['categories']
          .map(
            (item) => CategoryModel.fromJson(item),
          )
          .cast<CategoryModel>()
          .toList();

      bool hasRecommendedProducts = json['hasRecommendedProducts'] as bool;
      int numberOfRecommendedProducts =
          json['numberOfRecommendedProducts'] as int;

      if (hasRecommendedProducts && numberOfRecommendedProducts > 0) {
        _sellerRecommended[sellerId] = [];

        for (CategoryModel category in products(sellerId)) {
          if (category.showCategory) {
            for (ProductModel product in category.products) {
              if (product.recommended) {
                _sellerRecommended[sellerId].add(product);
                numberOfRecommendedProducts--;

                if (numberOfRecommendedProducts == 0) {
                  return;
                }
              }
            }
          }
        }
      }
    }
  }
}
