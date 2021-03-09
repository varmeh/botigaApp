import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bannerModel.g.dart';

@JsonSerializable()
class BannerModel {
  final String id;
  final String url;
  final String sellerId;

  BannerModel({
    @required this.id,
    @required this.url,
    @required this.sellerId,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}
