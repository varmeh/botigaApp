import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/index.dart';
import '../../util/index.dart' show DateExtension;
import '../../widgets/index.dart' show BotigaAppBar;
import '../../models/index.dart' show CouponModel;
import '../../providers/index.dart' show CartProvider;

class CouponScreen extends StatelessWidget {
  final List<CouponModel> coupons;

  CouponScreen(this.coupons);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CartProvider>(context, listen: false);

    List<CouponModel> _sortedCoupons = [];
    coupons.forEach((coupon) {
      if (coupon.isApplicable(_provider.totalAmount)) {
        _sortedCoupons.insert(0, coupon);
      } else {
        _sortedCoupons.add(coupon);
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Apply Coupon'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SELECT AN OFFER',
                style: AppTheme.textStyle.w500.color50
                    .size(12)
                    .lineHeight(1.3)
                    .letterSpace(0.2),
              ),
              SizedBox(height: 8),
              ..._sortedCoupons
                  .map((coupon) => _couponTile(context, coupon, _provider))
            ],
          ),
        ),
      ),
    );
  }

  Widget _couponTile(
      BuildContext context, CouponModel coupon, CartProvider provider) {
    String title = coupon.minimumOrderValue > 0
        ? 'Get ${coupon.discountAmountString} off on min. purchase of ₹${coupon.minimumOrderValue}'
        : 'Get Flat ${coupon.discountAmountString} off';

    String subTitle = 'Expires: ${coupon.expiryDate.dateFormatDayMonthYear}';
    if (coupon.maxDiscountAmount != null && coupon.maxDiscountAmount > 0) {
      subTitle =
          'Max. Discount Amount: ₹${coupon.maxDiscountAmount} ・ $subTitle';
    }

    return coupon.isValidCoupon
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      AppTheme.textStyle.w600.color100.size(15).lineHeight(1.3),
                ),
                SizedBox(height: 8),
                Text(
                  subTitle,
                  style: AppTheme.textStyle.w500.color50
                      .size(12)
                      .lineHeight(1.3)
                      .letterSpace(0.2),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 16),
                      color: Color(0xfffeec7b),
                      child: Text(
                        coupon.couponCode.toUpperCase(),
                        style: AppTheme.textStyle.w600.color100
                            .size(12)
                            .lineHeight(1.3)
                            .letterSpace(0.2),
                      ),
                    ),
                    coupon.isApplicable(provider.totalAmount)
                        ? GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () =>
                                _applyCoupon(context, coupon, provider),
                            child: Text(
                              'APPLY',
                              style: AppTheme.textStyle.w700
                                  .size(13)
                                  .lineHeight(1.3)
                                  .letterSpace(0.2)
                                  .colored(AppTheme.primaryColor),
                            ),
                          )
                        : Container()
                  ],
                ),
                SizedBox(height: 16),
                Divider(
                  thickness: 1,
                  color: AppTheme.dividerColor,
                ),
              ],
            ),
          )
        : Container();
  }

  void _applyCoupon(
      BuildContext context, CouponModel coupon, CartProvider provider) {
    provider.applyCoupon(coupon);
    Navigator.pop(context);
  }
}
