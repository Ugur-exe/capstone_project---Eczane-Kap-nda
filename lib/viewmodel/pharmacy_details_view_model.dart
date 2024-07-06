import 'package:bitirme_projesi/model/products_details_model.dart';

import 'package:flutter/material.dart';

class PharmacyViewDetailsViewModel with ChangeNotifier {
  List<ProductsModelDetails> _cartItems = [];
  List<ProductsModelDetails> get cartItems => _cartItems;
  int get cartItemCount => _cartItems.length;
  double _total = 0;
  double get total => _total;

  String _prescriptionsNumber = '';
  String get prescriptionsNumber => _prescriptionsNumber;

  String selectedPharmacyName = '';
  String selectedPharmacyAddress = '';
  String selectedPharmacyPhoneNumber = '';
  String selectedPharmacyId = '';

  TextEditingController controller = TextEditingController();
  set prescriptionsNumber(String value) {
    _prescriptionsNumber = value;
    notifyListeners();
  }

  set cartItems(List<ProductsModelDetails> value) {
    _cartItems = value;
    calculateTotalPrice();
    notifyListeners();
  }

  void addToCart(ProductsModelDetails product) {
    _cartItems.add(product);
    calculateTotalPrice();
    notifyListeners();
  }

  void removeFromCart(ProductsModelDetails product) {
    _cartItems.remove(product);
    calculateTotalPrice();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    calculateTotalPrice();
    notifyListeners();
  }

  void calculateTotalPrice() {
    _total = 0;
    for (var item in _cartItems) {
      _total += item.productPrice != null ? item.productPrice! : 0;
    }
  }

  void addToCartJustPrescriptionNumber(ProductsModelDetails product) {
    _cartItems.add(product);
    calculateTotalPrice();
    notifyListeners();
  }
}
