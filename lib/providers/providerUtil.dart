import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/index.dart' show AddressModel;
import 'userProvider.dart';
import 'sellersProvider.dart';
import 'cartProvider.dart';

class ProviderUtil {
  static void setAddress(BuildContext context, AddressModel address) {
    Provider.of<UserProvider>(context, listen: false).selectedAddress = address;
    Provider.of<SellersProvider>(context, listen: false).empty();

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.resetCart();
    cartProvider.loadCartFromServer();
  }
}
