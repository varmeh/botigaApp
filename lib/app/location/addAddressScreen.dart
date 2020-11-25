import 'package:flutter/material.dart';

import 'searchApartmentScreen.dart';
import 'houseDetailModal.dart';

class AddAddressScreen extends StatelessWidget {
  static final route = 'addAddress';

  @override
  Widget build(BuildContext context) {
    return SearchApartmentScreen(onSelection: (apartment) {
      HouseDetailModal().show(
        context,
        apartment,
      );
    });
  }
}
