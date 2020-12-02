import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/index.dart' show SellerModel;
import '../../../providers/userProvider.dart';
import '../../../theme/index.dart';
import '../../../widgets/index.dart' show CircleNetworkAvatar, DottedTimeline;

const _horizontalPadding = 20.0;
const _avatarRadius = 24.0;

class CartDeliveryInfo extends StatelessWidget {
  final SellerModel seller;

  CartDeliveryInfo(this.seller);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    String house = userProvider.house;
    String apartment = userProvider.apartmentName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _info(
          seller.brandName,
          seller.tagline,
          seller.brandImageUrl,
          true,
        ),
        DottedTimeline(
          start: Point(_horizontalPadding + _avatarRadius, 0),
          height: 30,
        ),
        _info(
          house,
          apartment,
          null,
          false,
        ),
        SizedBox(height: 32),
        Divider(
          thickness: 8,
          color: AppTheme.dividerColor,
        ),
      ],
    );
  }

  Widget _info(String title, String subTitle, String imageUrl, bool isSeller) {
    final placeholder = isSeller
        ? 'assets/images/avatar.png'
        : 'assets/images/buildingAvatar.png';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Row(
        children: [
          CircleNetworkAvatar(
            imageUrl: imageUrl,
            imagePlaceholder: placeholder,
            radius: _avatarRadius,
            isColored: seller.live,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title != null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          title,
                          style: AppTheme.textStyle.w600.color100.size(15),
                        ),
                      )
                    : Container(),
                subTitle != null
                    ? Text(
                        subTitle,
                        softWrap: true,
                        style: AppTheme.textStyle.w500.color50.size(13),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
