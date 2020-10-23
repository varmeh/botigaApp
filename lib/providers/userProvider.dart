import 'package:flutter/material.dart';

import '../models/addressModel.dart';
import '../util/index.dart' show Http;

class UserProvider with ChangeNotifier {
  String firstName;
  String lastName;
  String whatsapp;
  String email;
  AddressModel address;

  void _fillProvider(final json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    whatsapp = json['whatsapp'];
    email = json['email'];

    address = AddressModel.fromJson(json['address']);
  }

  Future<void> getProfile() async {
    if (firstName != null) {
      return;
    }
    final json = await Http.get('/api/user/auth/profile');
    _fillProvider(json);
    return this;
  }

  Future<void> logout() async {
    await Http.post('/api/user/auth/signout');
  }

  Future<void> otpAuth(String phone, String sessionId, String otp) async {
    final json = await Http.postAuth('/api/user/auth/otp/verify', body: {
      'phone': phone,
      'sessionId': sessionId,
      'otpVal': otp,
    });

    if (json['message'] == 'createUser') {
    } else {
      // Existing user
      _fillProvider(json);
    }
  }
}
