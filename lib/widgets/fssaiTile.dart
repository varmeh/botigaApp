import 'package:flutter/material.dart';
import '../theme/index.dart';
import '../models/index.dart' show SellerModel;

class FssaiTile extends StatelessWidget {
  final SellerModel seller;

  FssaiTile(this.seller);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 16, bottom: 16, left: 20.0, right: 20),
      child: Container(
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(left: 0, right: 0),
              title: Text(
                seller.brandName,
                style: AppTheme.textStyle
                    .size(12)
                    .lineHeight(1.5)
                    .w700
                    .color50
                    .letterSpace(0.2),
              ),
              subtitle: Text(
                seller.address ?? 'Address will be updated soon',
                style: AppTheme.textStyle
                    .size(10)
                    .lineHeight(1.5)
                    .w500
                    .color50
                    .letterSpace(0.2),
              ),
              trailing: Image.asset(
                'assets/images/pin.png',
              ),
            ),
            seller.fssaiLicenseNumber != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 0),
                    child: Divider(
                      thickness: 1.0,
                      color: AppTheme.dividerColor,
                    ),
                  )
                : Container(),
            seller.fssaiLicenseNumber != null
                ? ListTile(
                    contentPadding: EdgeInsets.only(left: 0, right: 0),
                    title: Text('Registration No. ${seller.fssaiLicenseNumber}',
                        style: AppTheme.textStyle
                            .size(12)
                            .lineHeight(1.5)
                            .w500
                            .color50
                            .letterSpace(0.2)),
                    trailing: Image.asset(
                      'assets/images/fssai.png',
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
