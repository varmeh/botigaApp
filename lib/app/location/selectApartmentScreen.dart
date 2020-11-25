import 'package:flutter/material.dart';

import '../../util/index.dart' show KeyStore;
import '../../widgets/index.dart' show Toast;

import '../tabbar.dart';
import 'searchApartmentScreen.dart';

class SelectApartmentScreen extends StatelessWidget {
  static final route = 'selectApartment';

  @override
  Widget build(BuildContext context) {
    return SearchApartmentScreen(onSelection: (apartment) {
      KeyStore.shared
          .setApartment(
              apartmentId: apartment.id, apartmentName: apartment.name)
          .then(
            (_) => Navigator.pushNamedAndRemoveUntil(
              context,
              Tabbar.route,
              (route) => false,
            ),
          )
          .catchError(
            (_) => Toast(
              message: 'Something went wrong. Select again.',
            ).show(context),
          );
    });
  }
}
