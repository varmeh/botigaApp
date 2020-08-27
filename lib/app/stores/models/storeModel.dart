import 'package:flutter/foundation.dart';

class StoreModel {
  final String name;
  final String id;
  final String moto;
  final List<String> categoryList;
  final String phoneNumber;
  final String whatsappNumber;

  StoreModel({
    @required this.name,
    @required this.categoryList,
    this.moto,
    this.id,
    this.phoneNumber,
    this.whatsappNumber,
  });

  String get category {
    return categoryList.join(' - ');
  }
}
