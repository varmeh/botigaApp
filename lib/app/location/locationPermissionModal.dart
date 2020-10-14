import 'package:flutter/material.dart';

import '../../theme/index.dart';

class LocationPermissionModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const sizedBox24 = SizedBox(height: 24);
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    );

    return Container(
      height: 400,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 22, right: 22, top: 42),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16.0),
          topRight: const Radius.circular(16.0),
        ),
      ),
      child: Container(
        child: Column(
          children: [
            Text(
              'Permission to location',
              style:
                  AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
            ),
            SizedBox(height: 32.0),
            Image.asset('assets/images/location.png'),
            sizedBox24,
            Text(
              'We require this information to check the service availability of your locations',
              style:
                  AppTheme.textStyle.w500.color50.size(15.0).lineHeight(1.35),
              textAlign: TextAlign.center,
            ),
            sizedBox24,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  minWidth: 150,
                  height: 50,
                  onPressed: () {},
                  color: AppTheme.color05,
                  child: Text(
                    'Deny',
                    style: AppTheme.textStyle.w600.color100
                        .size(15.0)
                        .lineHeight(1.5),
                  ),
                  shape: buttonShape,
                ),
                FlatButton(
                  minWidth: 150,
                  height: 50,
                  onPressed: () {},
                  color: AppTheme.primaryColor,
                  child: Text(
                    'Grant Access',
                    style: AppTheme.textStyle.w600
                        .size(15.0)
                        .lineHeight(1.5)
                        .colored(AppTheme.backgroundColor),
                  ),
                  shape: buttonShape,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
