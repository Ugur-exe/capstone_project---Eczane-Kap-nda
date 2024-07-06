import 'package:bitirme_projesi/base/database_base.dart';
import 'package:bitirme_projesi/model/orders_model.dart';
import 'package:bitirme_projesi/model/past_order_model.dart';
import 'package:bitirme_projesi/model/pharmacy_model.dart';
import 'package:bitirme_projesi/service/base/database_service.dart';
import 'package:bitirme_projesi/service/firebase/firebase_service.dart';
import 'package:bitirme_projesi/tools/locator.dart';
import 'package:flutter/material.dart';

class DatabaseRepository implements DatabaseBase {
  final DatabaseService _databaseService = locator<FirebaseDatabaseService>();

  @override
  Future createOrder(OrderModel order, context) async {
    return await _databaseService.createOrder(order, context);
  }

  @override
  Future<OrderModel> createPrescriptionOrder(
      OrderModel order, BuildContext context) async {
    return await _databaseService.createPrescriptionOrder(order, context);
  }

  @override
  Future<List<PharmacyModel>> getAllPharmacy() async {
    return await _databaseService.getAllPharmacy();
  }

  @override
  Future<List<OrderModel>> getPrescriptionOrders() async {
    return await _databaseService.getPrescriptionOrders();
  }

  @override
  Future updateOrder(OrderModel order) async {
    return await _databaseService.updateOrder(order);
  }

  @override
  Future<List<PastOrdersModel>> getPastOrders(BuildContext context) async {
    return await _databaseService.getPastOrders(context);
  }
}
