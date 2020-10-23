import 'package:flutter/material.dart';

import '../models/addressModel.dart';
import '../util/index.dart' show Http;

class UserProvider with ChangeNotifier {
  String firstName;
  String lastName;
  String whatsapp;
  String email;
  AddressModel address;

  Future<void> getProfile() async {
    if (firstName != null) {
      return;
    }
    final json = await Http.get('/api/user/auth/profile');
    firstName = json['firstName'];
    lastName = json['lastName'];
    whatsapp = json['whatsapp'];
    email = json['email'];

    address = AddressModel.fromJson(json['address']);
    return this;
  }

  Future<void> logout() async {
    await Http.post('/api/user/auth/signout');
  }
}
