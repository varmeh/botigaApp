import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/index.dart' show SellerModel, BannerModel;
import '../util/index.dart' show Http;

class ApartmentProvider with ChangeNotifier {
  List<SellerModel> _sellerList = [];
  int availableSellers = 0;
  List<BannerModel> _banners = [];

  int get notAvailableSellers => _sellerList.length - availableSellers;
  bool get hasNotAvailableSellers => notAvailableSellers > 0;
  bool get hasAvailableSellers => availableSellers > 0;
  bool get hasBanners => _banners.length > 0;

  UnmodifiableListView<SellerModel> get sellerList =>
      UnmodifiableListView(_sellerList);

  UnmodifiableListView<BannerModel> get banners =>
      UnmodifiableListView(_banners);

  void empty() {
    _sellerList.clear();
    _banners.clear();
    availableSellers = 0;
  }

  Future<void> getApartmentData(String apartmentId) async {
    if (_sellerList.length > 0) {
      return;
    } else {
      final json = await Http.get('/api/user/apartments/$apartmentId');

      if (json['marketingBanners'] != null) {
        _banners = json['marketingBanners']
            .map(
              (item) => BannerModel.fromJson(item),
            )
            .cast<BannerModel>()
            .toList();
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
