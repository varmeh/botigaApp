import 'package:flutter/material.dart';

import '../models/index.dart' show AddressModel, ApartmentModel;
import '../util/index.dart' show Http, Token, KeyStore, StringExtensions;

class UserProvider with ChangeNotifier {
  String firstName;
  String lastName;
  String phone;
  String whatsapp;
  String email;
  String lastUsedAddressId;
  List<AddressModel> addresses = [];
  AddressModel _selectedAddress;
  String _createToken = '';

  AddressModel get selectedAddress => _selectedAddress;
  set selectedAddress(AddressModel address) {
    Future.delayed(
        Duration.zero,
        () => KeyStore.shared.setApartment(
              apartmentId: address.aptId,
              apartmentName: address.house,
              addressId: address.id,
            ));
    _selectedAddress = address;
  }

  // Expects list of addresses or empty json
  void _addAddresses(List<dynamic> json) {
    addresses.clear();
    if (json.isNotEmpty) {
      json.forEach((address) => addresses.add(AddressModel.fromJson(address)));
    }
  }

  void _fillProvider(final json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    whatsapp = json['whatsapp'];
    email = json['email'];
    lastUsedAddressId = json['lastUsedAddressId'];

    _addAddresses(json['addresses']);
    _selectFromUserAddresses();
  }

  void _selectFromUserAddresses() {
    if (KeyStore.shared.lastAddressId.isEmpty) {
      // This happens only when user browse from onboarding screen without logging in
      // Check if apartment selected already part of an address
      final apartmentId = KeyStore.shared.lastApartmentId;
      for (AddressModel address in addresses) {
        if (apartmentId == address.aptId) {
          _selectedAddress = address;
          return;
        }
      }
    } else {
      if (addresses.isNotEmpty && lastUsedAddressId.isNotNullAndEmpty) {
        for (AddressModel address in addresses) {
          if (lastUsedAddressId == address.id) {
            _selectedAddress = address;
            return;
          }
        }
      }
      // In case lastUsedAddressId is not available or not added
      _selectedAddress = addresses[0];
    }
  }

  bool get isLoggedIn => phone != null;

  String get apartmentId {
    if (_selectedAddress != null) {
      return _selectedAddress.aptId;
    }
    return KeyStore.shared.lastApartmentId;
  }

  String get apartmentName {
    if (_selectedAddress != null) {
      return _selectedAddress.house;
    }
    return KeyStore.shared.lastApartmentName;
  }

  Future<void> getProfile() async {
    if (phone != null) {
      return;
    }
    final json = await Http.get('/api/user/auth/profile');
    _fillProvider(json);
  }

  Future<void> logout() async {
    await Http.post('/api/user/auth/signout');
    phone = null;
    firstName = null;
    lastName = null;
    _selectedAddress = null;
    await Token.write('');
  }

  Future<void> otpAuth({String phone, String sessionId, String otp}) async {
    final json = await Http.postAuth('/api/user/auth/otp/verify', body: {
      'phone': phone,
      'sessionId': sessionId,
      'otpVal': otp,
    });

    if (json['message'] == 'createUser') {
      // Save create token
      _createToken = json['createToken'];
    } else {
      // Existing user
      _fillProvider(json);
    }
  }

  Future<void> signup({
    String firstName,
    String lastName,
    String phone,
    String whatsapp,
    String email,
  }) async {
    final body = {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'createToken': _createToken,
    };

    if (whatsapp.isNotEmpty) {
      body['whatsapp'] = whatsapp;
    }

    if (email.isNotEmpty) {
      body['email'] = email;
    }

    final json = await Http.postAuth('/api/user/auth/signup', body: body);

    _fillProvider(json);
  }

  Future<void> updateProfile({
    String firstName,
    String lastName,
    String whatsapp,
    String email,
  }) async {
    final body = {
      'firstName': firstName,
      'lastName': lastName,
      'whatsapp': whatsapp,
    };

    if (email.isNotEmpty) {
      body['email'] = email;
    }

    await Http.patch('/api/user/auth/profile', body: body);

    // Update values
    this.firstName = firstName;
    this.lastName = lastName;
    this.whatsapp = whatsapp;
    if (email.isNotEmpty) {
      this.email = email;
    }

    notifyListeners();
  }

  Future<ApartmentModel> getApartmentById(String id) async {
    final json = await Http.get('/api/services/apartments/$id');
    return ApartmentModel.fromJson(json);
  }

  /* Address APIs */
  Future<void> getAddresses() async {
    final json = await Http.get('/api/user/auth/addresses');
    _addAddresses(json);
    notifyListeners();
  }

  Future<void> deleteAddress(String addressId) async {
    await Http.delete('/api/user/auth/addresses/$addressId');
    await getAddresses();
    selectedAddress = addresses.first;
  }

  Future<void> createAddress({
    @required String house,
    @required String apartmentId,
  }) async {
    await Http.post('/api/user/auth/addresses', body: {
      'apartmentId': apartmentId,
      'house': house,
    });
    await getAddresses();
    selectedAddress = addresses.last;
  }

  Future<void> updateAddress({
    @required String house,
    @required AddressModel address,
  }) async {
    await Http.patch('/api/user/auth/addresses', body: {
      'id': address.id,
      'house': house,
    });
    await getAddresses();
    selectedAddress = address;
  }
}
