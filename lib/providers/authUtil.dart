import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/index.dart' show AddressModel;
import '../util/index.dart' show StringExtensions, KeyStore;
import 'cartProvider.dart';
import 'sellersProvider.dart';
import 'userProvider.dart';

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
    final sellerProvider =
        Provider.of<ApartmentProvider>(context, listen: false);
    if (cartProvider.isEmpty) {
      final addresses = userProvider.addresses;
      final lastUsedAddressId = userProvider.lastUsedAddressId;
      if (addresses.isNotEmpty) {
        if (lastUsedAddressId.isNotNullAndEmpty) {
          // Set selected address to lastSelectedAddress
          for (AddressModel address in addresses) {
            if (lastUsedAddressId == address.id) {
              userProvider.selectedAddress = address;
              break;
            }
          }
        }

        // In case lastUsedAddressId is not available or not added
        if (userProvider.selectedAddress == null) {
          userProvider.selectedAddress = addresses.first;
        }

        sellerProvider.empty(); //reset sellers list to selected apartment
        cartProvider.loadCartFromServer(); // Now load cart from server
      }
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
