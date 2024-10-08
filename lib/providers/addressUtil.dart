import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/index.dart' show AddressModel;
import 'cartProvider.dart';
import 'apartmentProvider.dart';
import 'userProvider.dart';

class AddressUtil {
  static Future<void> setAddress(
      BuildContext context, AddressModel address) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.selectedAddress = address;

    // Empty Sellers List
    Provider.of<ApartmentProvider>(context, listen: false).empty();

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.clearCart();
    cartProvider.loadCartFromServer();
  }

  static Future<void> addAddress({
    BuildContext context,
    String house,
    String apartmentId,
    bool clearCart,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.createAddress(
      house: house,
      apartmentId: apartmentId,
    );
    await userProvider.getAddresses(); // Fetch latest addresses
    if (clearCart) {
      await setAddress(context, userProvider.addresses.last);
    } else {
      userProvider.selectedAddress = userProvider.addresses.last;
    }
  }

  static Future<void> deleteAddress(
      BuildContext context, String addressId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Delete destructs the context by removing address
    // So first set the address & then get the latest address list
    await setAddress(context, userProvider.addresses.first);

    await userProvider.deleteAddress(addressId);
    await userProvider.getAddresses(); // Fetch latest addresses
  }

  static Future<void> updateAddress({
    BuildContext context,
    String house,
    AddressModel address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.updateAddress(house: house, address: address);
    await userProvider.getAddresses(); // Fetch latest addresses
    // find address with this id
    AddressModel updatedAddress;
    for (AddressModel adr in userProvider.addresses) {
      if (adr.id == address.id) {
        updatedAddress = adr;
        break;
      }
    }
    await setAddress(context, updatedAddress);
  }
}
