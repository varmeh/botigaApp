import 'package:flutter/material.dart';

import '../../../models/sellerModel.dart';
import '../../../theme/index.dart';
import '../../../widgets/circleNetworkAvatar.dart';

class CartDeliveryInfo extends StatelessWidget {
  final SellerModel seller;

  CartDeliveryInfo(this.seller);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _info(
          seller.brandName,
          seller.tagline,
          'https://www.spendwithpennies.com/wp-content/uploads/2015/10/Chocolate-Ganache-22.jpg',
          true,
        ),
        SizedBox(height: 32),
        _info('Deliver to', 'V503, T5, APR', null, false),
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          CircleNetworkAvatar(
            imageUrl: imageUrl,
            imagePlaceholder: placeholder,
            radius: 24.0,
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.textStyle.w600.color100.size(15),
              ),
              SizedBox(height: 5),
              Text(
                subTitle,
                style: AppTheme.textStyle.w500.color50.size(13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
