import 'package:flutter/material.dart';

import 'searchApartmentScreen.dart';
import 'addHouseDetailModal.dart';

class AddAddressScreen extends StatelessWidget {
  static final route = 'addAddress';

  @override
  Widget build(BuildContext context) {
    RoutePredicate popUntil =
        ModalRoute.of(context).settings.arguments ?? (route) => route.isFirst;

    return SearchApartmentScreen(onSelection: (apartment) {
      AddHouseDetailModal().show(context, apartment, popUntil);
    });
  }
}
