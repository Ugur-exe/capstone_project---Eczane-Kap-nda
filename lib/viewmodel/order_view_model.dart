import 'package:bitirme_projesi/model/orders_model.dart';
import 'package:bitirme_projesi/service/firebase/firebase_service.dart';
import 'package:bitirme_projesi/tools/locator.dart';
import 'package:flutter/material.dart';

class OrdersViewModel with ChangeNotifier {
  final FirebaseDatabaseService _service = locator<FirebaseDatabaseService>();
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  void addOrder(OrderModel order) {
    _orders.add(order);
    notifyListeners();
  }

  void removeOrder(OrderModel order) {
    _orders.remove(order);
    notifyListeners();
  }

  void getOrders() async {
    final orders = await _service.getPrescriptionOrders();
    for (var order in orders) {
      _orders.add(order);
    }
    notifyListeners();
  }
}
