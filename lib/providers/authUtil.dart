import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/index.dart' show AddressModel;
import '../util/index.dart' show StringExtensions, KeyStore;
import 'userProvider.dart';
import 'cartProvider.dart';

class AuthUtil {
  static Future<void> verifyOtp({
    BuildContext context,
    String phone,
    String sessionId,
    String otp,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.otpAuth(phone: phone, sessionId: sessionId, otp: otp);

    if (userProvider.isLoggedIn) {
      selectUserAddress(context);
    }
  }

  static Future<void> getProfile(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.getProfile();

    selectUserAddress(context);
  }

  static void selectUserAddress(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (cartProvider.isEmpty) {
      final addresses = userProvider.addresses;
      final lastUsedAddressId = userProvider.lastUsedAddressId;
      if (addresses.isNotEmpty && lastUsedAddressId.isNotNullAndEmpty) {
        for (AddressModel address in addresses) {
          if (lastUsedAddressId == address.id) {
            userProvider.selectedAddress = address;
            return;
          }
        }
      }
      // In case lastUsedAddressId is not available or not added
      userProvider.selectedAddress = addresses[0];
      cartProvider.loadCartFromServer(); // Now load cart from server
    } else {
      // Cart has products
      // ApartmentId & ApartmentName are saved in Keystore when not logged in.
      // Use that to see if apartmentId in cart matches user existing address
      final apartmentId = KeyStore.shared.lastApartmentId;
      for (AddressModel address in userProvider.addresses) {
        if (apartmentId == address.aptId) {
          userProvider.selectedAddress = address;
          return;
        }
      }
    }
  }
}
