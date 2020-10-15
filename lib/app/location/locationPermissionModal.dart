import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../theme/index.dart';
import '../../widgets/index.dart' show BotigaBottomModal;
import 'selectCityScreen.dart';

class LocationPermissionModal {
  void show(BuildContext context) {
    const sizedBox24 = SizedBox(height: 24);

    BotigaBottomModal(
      child: Column(
        children: [
          Text(
            'Permission to location',
            style: AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
          ),
          SizedBox(height: 32.0),
          Image.asset('assets/images/location.png'),
          sizedBox24,
          Text(
            'We require this information to check the service availability of your locations',
            style: AppTheme.textStyle.w500.color50.size(15.0).lineHeight(1.35),
            textAlign: TextAlign.center,
          ),
          sizedBox24,
          _buttonRow(context),
          sizedBox24,
        ],
      ),
    ).show(context);
  }

  Widget _buttonRow(BuildContext context) {
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlatButton(
          minWidth: 150,
          height: 50,
          onPressed: () {
            Navigator.pushNamed(context, SelectCityScreen.route);
          },
          color: AppTheme.color05,
          child: Text(
            'Deny',
            style: AppTheme.textStyle.w600.color100.size(15.0).lineHeight(1.5),
          ),
          shape: buttonShape,
        ),
        FlatButton(
          minWidth: 150,
          height: 50,
          onPressed: () {
            _accessLocation();
          },
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
    );
  }

  void _accessLocation() {
    requestPermission().then((permission) {
      if (permission == LocationPermission.whileInUse) {
        getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ).then((position) {
          print(position);
        }).catchError((error) {
          print(error);
        });
      }
    });
  }
}
