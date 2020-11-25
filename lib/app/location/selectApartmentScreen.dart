import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/index.dart' show KeyStore;
import '../../widgets/index.dart' show Toast;
import '../../providers/index.dart' show SellersProvider;

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
          .then((_) {
        Provider.of<SellersProvider>(context, listen: false).empty();
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Tabbar(index: 0),
            transitionDuration: Duration.zero,
          ),
          (route) => false,
        );
      }).catchError(
        (_) => Toast(
          message: 'Something went wrong. Select again.',
        ).show(context),
      );
    });
  }
}
