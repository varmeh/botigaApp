import 'package:flutter/foundation.dart';

class StoreModel {
  final String name;
  final String id;
  final String moto;
  final List<String> categoryList;
  final String phone;
  final String whatsapp;

  StoreModel({
    @required this.name,
    @required this.categoryList,
    this.moto,
    this.id,
    this.phone,
    this.whatsapp,
  });

  String get category {
    return categoryList.join(' - ');
  }
}
