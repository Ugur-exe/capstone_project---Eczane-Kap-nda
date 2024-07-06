import 'package:bitirme_projesi/model/orders_model.dart';
import 'package:bitirme_projesi/repository/database_repository.dart';
import 'package:bitirme_projesi/tools/locator.dart';
import 'package:flutter/widgets.dart';

class PaymentViewModel extends ChangeNotifier {
  final DatabaseRepository _databaseRepository = locator<DatabaseRepository>();
  String? prescriptionsNumber;
  double? totalPrice;

  PaymentViewModel({
    this.prescriptionsNumber = '',
    this.totalPrice = 0,
  });

  void updatePrescriptionsNumber(String newNumber) {
    prescriptionsNumber = newNumber;
    notifyListeners();
  }

  void updateTotalPrice(double newPrice) {
    totalPrice = newPrice;
    notifyListeners();
  }

  void saveOrderToFirebase(OrderModel order, BuildContext context) {
    _databaseRepository.createOrder(order, context);
  }
}
