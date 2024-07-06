import 'package:bitirme_projesi/model/past_order_model.dart';
import 'package:bitirme_projesi/service/firebase/firebase_service.dart';
import 'package:bitirme_projesi/tools/locator.dart';
import 'package:flutter/material.dart';

class PastOrdersViewModel with ChangeNotifier {
  final FirebaseDatabaseService _firestore = locator<FirebaseDatabaseService>();
  final List<PastOrdersModel> _pastOrdersList = [];

  List<PastOrdersModel> get pastOrdersList => _pastOrdersList;

  void addPastOrders(PastOrdersModel pastOrdersModel) {
    _pastOrdersList.add(pastOrdersModel);
    notifyListeners();
  }

  Future fetchPastOrders(BuildContext context) async {
    final orders = await _firestore.getPastOrders(context);
    for (var order in orders) {
      addPastOrders(order);
    }
  }
}
