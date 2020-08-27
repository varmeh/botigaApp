import 'package:flutter/foundation.dart';

class StoreModel {
  final String name;
  final String id;
  final String moto;
  final String category;
  final List<String> tagList;
  final String phoneNumber;
  final String whatsappNumber;

  StoreModel({
    @required this.name,
    @required this.category,
    this.moto,
    this.tagList,
    this.id,
    this.phoneNumber,
    this.whatsappNumber,
  });

  String get combinedTag => tagList.join(' - ');
}
