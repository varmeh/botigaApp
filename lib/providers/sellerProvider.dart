import 'package:flutter/material.dart';

import '../models/index.dart' show CategoryModel;
import '../util/index.dart' show Http;

class SellerProvider with ChangeNotifier {
  Map<String, List<CategoryModel>> _sellerProducts = {};
  Map<String, List<String>> _sellerBanners = {};

  List<CategoryModel> products(String sellerId) {
    return _sellerProducts.containsKey(sellerId)
        ? _sellerProducts[sellerId]
        : [];
  }

  List<String> banners(String sellerId) {
    return _sellerBanners.containsKey(sellerId) ? _sellerBanners[sellerId] : [];
  }

  bool hasBanners(String sellerId) {
    final _banners = banners(sellerId);
    return _banners.length > 0;
  }

  Future<void> getProducts(String sellerId) async {
    if (_sellerProducts.containsKey(sellerId)) {
      return;
    } else {
      final json = await Http.get('/api/user/sellers/data/$sellerId');

      if (json['banners'].length > 0) {
        List<String> _banners = [];
        json['banners'].forEach((url) => _banners.add(url));
        _sellerBanners[sellerId] = _banners;
      }

      List<CategoryModel> _sellerCategories = json['categories']
          .map(
            (item) => CategoryModel.fromJson(item),
          )
          .cast<CategoryModel>()
          .toList();

      _sellerProducts[sellerId] = _sellerCategories;
    }
  }
}
