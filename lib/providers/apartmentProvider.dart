import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/index.dart' show SellerModel;
import '../util/index.dart' show Http;

class ApartmentProvider with ChangeNotifier {
  List<SellerModel> _sellerList = [];
  int availableSellers = 0;
  List<String> _bannerList = [];

  int get notAvailableSellers => _sellerList.length - availableSellers;
  bool get hasNotAvailableSellers => notAvailableSellers > 0;
  bool get hasAvailableSellers => availableSellers > 0;
  bool get hasBanners => _bannerList.length > 0;

  UnmodifiableListView<SellerModel> get sellerList =>
      UnmodifiableListView(_sellerList);

  UnmodifiableListView<String> get bannerList =>
      UnmodifiableListView(_bannerList);

  void empty() {
    _sellerList.clear();
    _bannerList.clear();
    availableSellers = 0;
  }

  Future<void> getSellers(String apartmentId) async {
    if (_sellerList.length > 0) {
      return;
    } else {
      final json = await Http.get('/api/user/apartments/$apartmentId');
      if (json['banners'].length > 0) {
        json['banners'].forEach((url) => _bannerList.add(url));
      }

      final _sellerIterable = json['sellers'].map((item) {
        final seller = SellerModel.fromJson(item);
        if (seller.live) {
          availableSellers++;
        }
        return seller;
      });

      // Iterable returned above is of type of dynamic
      // Below method is used to convert supertype list to subtype list
      _sellerList = List<SellerModel>.from(_sellerIterable);
    }
  }

  SellerModel seller(String sellerId) {
    for (final seller in _sellerList) {
      if (seller.id == sellerId) {
        return seller;
      }
    }
    return null;
  }
}
