import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/index.dart';
import '../../util/index.dart' show DateExtension;
import '../../widgets/index.dart' show BotigaAppBar, BotigaTextFieldForm;
import '../../models/index.dart' show CouponModel;
import '../../providers/index.dart' show CartProvider;

class CouponScreen extends StatefulWidget {
  final List<CouponModel> coupons;

  CouponScreen(this.coupons);

  @override
  _CouponScreenState createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  FocusNode _textCouponFocusNode;

  @override
  void initState() {
    super.initState();
    _textCouponFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textCouponFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CartProvider>(context, listen: false);

    List<CouponModel> _sortedCoupons = [];
    widget.coupons.forEach((coupon) {
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2),
                BotigaTextFieldForm(
                  focusNode: _textCouponFocusNode,
                  labelText: 'Enter Coupon Code',
                  onSave: (_) {},
                  validator: (_) => null,
                  onFieldSubmitted: (value) => _checkTextCoupon(value),
                ),
                SizedBox(height: 24),
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
                            onTap: () => _applyCoupon(coupon),
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

  void _checkTextCoupon(String couponText) {
    CouponModel _coupon;

    final provider = Provider.of<CartProvider>(context, listen: false);
    // Search if coupon exits
    for (CouponModel coupon in widget.coupons) {
      if (coupon.couponCode.toUpperCase() == couponText.trim().toUpperCase()) {
        _coupon = coupon;
        break;
      }
    }

    if (_coupon == null) {
      _couponAlert(
        title: 'Invalid Coupon',
        subtitle: 'No such coupon exists',
      );
    } else if (!_coupon.isNotExpired) {
      _couponAlert(
        title: 'Expired Coupon',
        subtitle: 'Coupon has expired',
      );
    } else if (!_coupon.isApplicable(provider.totalAmount)) {
      _couponAlert(
        title: 'Buy More',
        subtitle:
            'This Coupon is applicable on a min. purchase of ${_coupon.minimumOrderValue}',
      );
    } else {
      _applyCoupon(_coupon);
    }
  }

  void _couponAlert({String title, String subtitle}) {
    Future.delayed(Duration(milliseconds: 100), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            title,
            style: AppTheme.textStyle.w500.color100,
          ),
          content: Text(
            subtitle,
            style: AppTheme.textStyle.w400.color100,
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: AppTheme.textStyle.w600.colored(AppTheme.errorColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
  }

  void _applyCoupon(CouponModel coupon) {
    Provider.of<CartProvider>(context, listen: false).applyCoupon(coupon);
    Navigator.pop(context);
  }
}
