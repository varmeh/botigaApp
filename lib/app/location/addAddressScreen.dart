import 'package:flutter/material.dart';

import 'modal/addHouseDetailModal.dart';
import 'searchApartmentScreen.dart';

class AddAddressScreen extends StatelessWidget {
  static final route = 'addAddress';

  @override
  Widget build(BuildContext context) {
    return SearchApartmentScreen(onSelection: (apartment) {
      AddHouseDetailModal().show(
        context: context,
        apartment: apartment,
        clearCart: true,
      );
    });
  }
}
