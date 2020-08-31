import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'productCategoryModel.dart';

class StoreModel {
  final String id;
  final String name;
  final String moto;
  final List<String> segmentList;
  final String phone;
  final String whatsapp;
  List<ProductCategoryModel> _productCategory = [];

  StoreModel({
    @required this.id,
    @required this.name,
    @required this.segmentList,
    this.moto,
    @required this.phone,
    @required this.whatsapp,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as String,
      name: json['name'] as String,
      segmentList: json['categoryList'] as List<String>,
      moto: '',
      phone: json['phone'] as String,
      whatsapp: json['whatsapp'] as String,
    );
  }

  String get segments {
    return segmentList.join(' - ');
  }

  UnmodifiableListView<ProductCategoryModel> get category =>
      UnmodifiableListView(_productCategory);
}
