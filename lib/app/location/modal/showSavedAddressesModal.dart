import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/index.dart' show UserProvider, ProviderUtil;
import '../../../models/index.dart' show AddressModel;
import '../../../theme/index.dart';
import '../addAddressScreen.dart';
import '../../tabbar.dart';

class ShowSavedAddressesModal {
  final sizedBox16 = SizedBox(height: 16);
  final divider = Divider(
    thickness: 1.0,
    color: AppTheme.dividerColor,
  );

  void show(BuildContext context) {
    final addresses =
        Provider.of<UserProvider>(context, listen: false).addresses;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: double.infinity / 2,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 22.0,
            right: 22.0,
            top: 42.0,
            bottom: 32.0,
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saved Address',
                        style: AppTheme.textStyle.w700.color100
                            .size(20.0)
                            .lineHeight(1.25),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, AddAddressScreen.route),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: AppTheme.primaryColor,
                              size: 20.0,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              'New',
                              style: AppTheme.textStyle.w600
                                  .size(17.0)
                                  .lineHeight(1.3)
                                  .colored(AppTheme.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  sizedBox16,
                  divider,
                  ...addresses.map((address) => _addressTile(context, address)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _addressTile(BuildContext context, AddressModel address) {
    return GestureDetector(
      onTap: () {
        ProviderUtil.setAddress(context, address);
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Tabbar(index: 0),
            transitionDuration: Duration.zero,
          ),
          (route) => false,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizedBox16,
          Text(
            '${address.house}, ${address.apartment}',
            style: AppTheme.textStyle.w600.color100.size(15.0).lineHeight(1.3),
          ),
          SizedBox(height: 8.0),
          Text(
            '${address.area}, ${address.city}, ${address.state} - ${address.pincode}',
            style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
          ),
          sizedBox16,
          divider,
        ],
      ),
    );
  }
}
