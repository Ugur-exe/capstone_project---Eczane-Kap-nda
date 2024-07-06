import 'package:bitirme_projesi/model/medicine_model.dart';
import 'package:bitirme_projesi/model/orders_model.dart';
import 'package:bitirme_projesi/service/firebase/firebase_service.dart';
import 'package:bitirme_projesi/tools/locator.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class OrdersViewDetailsModel with ChangeNotifier {
  var uuid = const Uuid();
  final FirebaseDatabaseService _service = locator<FirebaseDatabaseService>();
  final List<OrderModel> _ordersDetails = [];
  List<OrderModel> get ordersDetails => _ordersDetails;

  final List<MedicineModel> _medicines = [];
  List<MedicineModel> get medicines => _medicines;

  void addMedicines(MedicineModel medicine) {
    _medicines.add(medicine);
    notifyListeners();
  }

  void addOrderDetails(OrderModel order) {
    _ordersDetails.add(order);
    notifyListeners();
  }

  void clearOrderDetails() {
    _ordersDetails.clear();
    notifyListeners();
  }

  void saveOrderToFirebase(OrderModel order, BuildContext context) async {
    order = await _service.createPrescriptionOrder(order, context);
    addOrderDetails(order);
  }
}
