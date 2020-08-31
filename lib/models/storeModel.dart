import 'package:flutter/foundation.dart';

class StoreModel {
  final String id;
  final String name;
  final String moto;
  final List<String> segmentList;
  final String phone;
  final String whatsapp;

  StoreModel({
    @required this.id,
    @required this.name,
    @required this.segmentList,
    this.moto,
    @required this.phone,
    @required this.whatsapp,
  });

  String get segments {
    return segmentList.join(' - ');
  }
}
