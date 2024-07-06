import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserData with ChangeNotifier {
  String? _name;
  String? _surname;
  int? _tc;
  String? _email;
  String? _password;
  List<Map<String, dynamic>>? _address;
  double? _latitude;
  double? _longitude;
  String? _imageUrl;
  String? _telNum;
  String? get telNum => _telNum;

  set telNum(String? value) {
    _telNum = value;
    notifyListeners();
  }

  String? get imageUrl => _imageUrl;

  set imageUrl(String? value) {
    _imageUrl = value;
    notifyListeners();
  }

  String? get name => _name;

  set name(String? value) => _name = value;
  get surname => _surname;
  set surname(value) {
    _surname = value;
    notifyListeners();
  }

  get tc => _tc;
  set tc(value) {
    _tc = value;
    notifyListeners();
  }

  get email => _email;
  set email(value) {
    _email = value;
    notifyListeners();
  }

  get password => _password;
  set password(value) {
    _password = value;
    notifyListeners();
  }

  get address => _address;
  set address(value) {
    _address = value;
    notifyListeners();
  }

  get latitude => _latitude;
  set latitude(value) {
    _latitude = value;
    notifyListeners();
  }

  get longitude => _longitude;
  set longitude(value) {
    _longitude = value;
    notifyListeners();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<DocumentSnapshot> getUserData(String email) async {
    return await _firestore.collection('users').doc(email).get();
  }

  void printUserData() {
    print('Name: $name');
    print('Surname: $surname');
    print('TC: $tc');
    print('Email: $email');
    print('Password: $password');
    print('Address: $address');
    print('Latitude: $latitude');
    print('Longitude: $longitude');
  }

  void fromMap(Map<String, dynamic> map) {
    name = map['name'];
    surname = map['surname'];
    tc = map['tc'];
    email = map['email'];
    password = map['password'];

    // Check if 'address' is a list of maps
    if (map['address'] is List) {
      _address = List<Map<String, dynamic>>.from(map['address']);
    } else {
      _address = null;
    }

    latitude = map['latitude'];
    longitude = map['longitude'];
    imageUrl = map['image'];
    telNum = map['telNum'];
  }
}
