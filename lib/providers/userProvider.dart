import 'package:flutter/material.dart';

import '../models/index.dart' show AddressModel, ApartmentModel;
import '../util/index.dart' show Http, Token;

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

    if (json['address'] != null) {
      address = AddressModel.fromJson(json['address']);
    }
  }

  String get apartmentId => address != null ? address.id : '';

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
    await Token.delete();
  }

  Future<void> login({@required String phone, @required String pin}) async {
    final json = await Http.postAuth('/api/user/auth/signin/pin', body: {
      'phone': phone,
      'pin': pin,
    });

    _fillProvider(json);
  }

  Future<void> otpAuth({String phone, String sessionId, String otp}) async {
    final json = await Http.postAuth('/api/user/auth/otp/verify', body: {
      'phone': phone,
      'sessionId': sessionId,
      'otpVal': otp,
    });

    if (json['message'] != 'createUser') {
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
      'whatsapp': whatsapp,
    };

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

  Future<void> updateApartment({
    @required String house,
    @required ApartmentModel apartment,
  }) async {
    await Http.patch('/api/user/auth/address', body: {
      'apartmentId': apartment.id,
      'house': house,
    });

    // If successful, update apartment information in provider
    address = AddressModel(
      id: apartment.id,
      house: house,
      apartment: apartment.name,
      area: apartment.area,
      city: apartment.city,
      state: apartment.state,
      pincode: apartment.pincode,
    );

    notifyListeners();
  }
}
