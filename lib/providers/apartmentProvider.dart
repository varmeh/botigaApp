import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/index.dart' show SellerModel, BannerModel, SellerFilterModel;
import '../util/index.dart' show Http;

class ApartmentProvider with ChangeNotifier {
  List<SellerModel> _sellerList = [];
  int availableSellers = 0;
  List<BannerModel> _banners = [];
  List<SellerFilterModel> _filters = [];

  final allFilter = SellerFilterModel(displayName: 'All', value: 'all');
  SellerFilterModel selectedFilter;

  bool get hasBanners => _banners.length > 0;
  bool get hasFilters => _filters.length > 0;
  bool get hasAvailableSellers => availableSellers > 0;
  bool get showAllSellers => selectedFilter == allFilter;

  int get notAvailableSellers => sellers.length - availableSellers;
  bool get hasNotAvailableSellers => notAvailableSellers > 0;

  UnmodifiableListView<SellerModel> get sellers {
    if (selectedFilter == allFilter) {
      return UnmodifiableListView(_sellerList);
    }
    List<SellerModel> _sellers = _sellerList
        .where((seller) => seller.filters.contains(selectedFilter.value))
        .toList();
    return UnmodifiableListView(_sellers);
  }

  UnmodifiableListView<BannerModel> get banners =>
      UnmodifiableListView(_banners);

  UnmodifiableListView<SellerFilterModel> get filters =>
      UnmodifiableListView(_filters);

  void selectFilter(SellerFilterModel filter) {
    selectedFilter = filter;
    availableSellers = 0;

    sellers.forEach((seller) {
      if (seller.live) {
        availableSellers++;
      }
    });
  }

  void empty() {
    _sellerList.clear();
    _banners.clear();
    _filters.clear();
    selectedFilter = allFilter;
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

      if (json['filters'] != null && json['filters'].length > 0) {
        _filters = json['filters']
            .map(
              (item) => SellerFilterModel.fromJson(item),
            )
            .cast<SellerFilterModel>()
            .toList();
        _filters.insert(0, allFilter);
        selectedFilter = allFilter;
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
