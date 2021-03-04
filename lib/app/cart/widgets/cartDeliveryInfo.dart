import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/index.dart' show DateExtension, StringExtensions;
import '../../../models/index.dart' show SellerModel;
import '../../../providers/userProvider.dart';
import '../../../theme/index.dart';
import '../../../widgets/index.dart' show CircleNetworkAvatar, DottedTimeline;

const _avatarRadius = 24.0;

class CartDeliveryInfo extends StatelessWidget {
  final SellerModel seller;

  CartDeliveryInfo(this.seller);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final _divider = Divider(
      thickness: 1,
      color: AppTheme.dividerColor,
    );

    String house = userProvider.house;
    String apartment = userProvider.apartmentName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _info(seller.brandName, seller.tagline, seller.brandImageUrl, true),
          DottedTimeline(start: Point(_avatarRadius, 0), height: 30),
          _info(house, apartment, null, false),
          SizedBox(height: 24),
          _divider,
          _deliveryDate(seller),
          _divider,
        ],
      ),
    );
  }

  Widget _info(String title, String subTitle, String imageUrl, bool isSeller) {
    final placeholder = isSeller
        ? 'assets/images/avatar.png'
        : 'assets/images/buildingAvatar.png';

    return Row(
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
                        style: AppTheme.textStyle.w600.color100
                            .size(15)
                            .lineHeight(1.3),
                      ),
                    )
                  : Container(),
              subTitle != null
                  ? Text(
                      subTitle,
                      softWrap: true,
                      style: AppTheme.textStyle.w500.color50
                          .size(13)
                          .lineHeight(1.5),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _deliveryDate(SellerModel seller) {
    var _deliveryTime =
        'Delivery on ${seller.deliveryDate.toLocal().dateFormatDayDateMonth}';

    if (seller.deliverySlot.isNotNullAndEmpty) {
      _deliveryTime += '・${seller.deliverySlot}';
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 16, bottom: 16),
      child: Row(
        children: [
          Image.asset('assets/images/truck.png'),
          SizedBox(width: 26.0),
          Expanded(
            child: Text(
              seller.live ? _deliveryTime : 'Not Serving at the moment',
              style: AppTheme.textStyle.w500.color100.size(13).lineHeight(1.5),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
