import 'package:flutter/material.dart';

class AddressAddAndUpdateViewModel with ChangeNotifier{
  String? _address;
  String? get address => _address;

  void setAddress(String value){
    _address = value;
    notifyListeners();
  }
}