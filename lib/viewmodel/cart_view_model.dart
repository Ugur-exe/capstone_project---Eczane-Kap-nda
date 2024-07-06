import 'package:bitirme_projesi/model/products_details_model.dart';

import 'package:flutter/material.dart';

class CartViewModel extends ChangeNotifier {
  final List<ProductsModelDetails> _cartListItems = [];
  List<ProductsModelDetails> get cartListItems => _cartListItems;

  void addToCart(ProductsModelDetails item) {
    _cartListItems.add(item);
    notifyListeners();
  }

  void removeFromCart(ProductsModelDetails item) {
    _cartListItems.remove(item);
    notifyListeners();
  }


}
