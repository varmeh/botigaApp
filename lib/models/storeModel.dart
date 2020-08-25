import 'package:flutter/material.dart';

class StoreModel {
  final String name;
  final String id;
  final String moto;
  final List<String> categories;
  final List<String> tags;
  final String imageUrl;
  final List<String> contactNumbers;

  StoreModel({
    @required this.name,
    @required this.categories,
    this.moto,
    this.tags,
    this.id,
    this.imageUrl,
    this.contactNumbers,
  });

  String get combinedCategory => categories.join(' - ');

  String get combinedTag => tags.join(' - ');
}
