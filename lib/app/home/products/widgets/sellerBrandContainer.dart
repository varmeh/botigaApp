import 'package:flutter/material.dart';

import '../../../../models/index.dart' show SellerModel;
import '../../../../theme/index.dart';
import '../../../../util/index.dart' show DateExtension, StringExtensions;
import '../../../../widgets/index.dart' show CircleNetworkAvatar;

class SellerBrandContainer extends StatelessWidget {
  final SellerModel seller;

  SellerBrandContainer(this.seller);

  @override
  Widget build(BuildContext context) {
    var _deliverySchedule = (seller.deliveryDate != null &&
            seller.deliveryDate.difference(DateTime.now()).inDays >= 1)
        ? 'Delivery by ${seller.deliveryDate.dateFormatDayDateMonth}'
        : 'Delivery Tomorrow';

    if (seller.deliverySlot.isNotNullAndEmpty) {
      _deliverySchedule += '・${seller.deliverySlot}';
    }

    const _sizedBox = const SizedBox(height: 12);

    return Container(
      padding: EdgeInsets.only(left: 20, top: 6, right: 20, bottom: 24),
      child: Column(
        children: [
          _brandInfo(context),
          _sizedBox,
          _iconInfo(context, 'assets/images/shop.png', seller.businessCategory),
          _sizedBox,
          _iconInfo(
            context,
            'assets/images/truck.png',
            seller.live ? _deliverySchedule : 'Not Serving at the moment',
          ),
          _sizedBox,
          _iconInfo(
            context,
            'assets/images/cart.png',
            seller.deliveryFee == 0
                ? 'Free Delivery'
                : 'Free Delivery above ${seller.deliveryMinOrder}',
          ),
        ],
      ),
    );
  }

  Widget _brandInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                seller.brandName,
                style:
                    AppTheme.textStyle.w700.color100.size(17).lineHeight(1.3),
              ),
              seller.tagline != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        seller.tagline,
                        style: AppTheme.textStyle.w500.color50
                            .size(13)
                            .lineHeight(1.5),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(width: 12),
        CircleNetworkAvatar(
          imageUrl: seller.brandImageUrl,
          radius: 28.0,
          isColored: seller.live,
        ),
      ],
    );
  }

  Widget _iconInfo(BuildContext context, String image, String info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          width: 18.0,
          height: 18.0,
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: Text(
            info,
            style: AppTheme.textStyle.w500.color100.size(13).lineHeight(1.5),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
