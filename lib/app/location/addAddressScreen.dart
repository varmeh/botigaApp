import 'package:flutter/material.dart';

import 'searchApartmentScreen.dart';
import 'modal/addHouseDetailModal.dart';

class AddAddressScreen extends StatelessWidget {
  static final route = 'addAddress';

  @override
  Widget build(BuildContext context) {
    return SearchApartmentScreen(onSelection: (apartment) {
      AddHouseDetailModal().show(context, apartment);
    });
  }
}
