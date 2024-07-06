import 'package:bitirme_projesi/model/orders_model.dart';
import 'package:bitirme_projesi/model/past_order_model.dart';
import 'package:bitirme_projesi/model/pharmacy_model.dart';
import 'package:flutter/material.dart';

abstract class DatabaseBase {
  Future<dynamic> createOrder(OrderModel order, BuildContext context);

  Future<OrderModel> createPrescriptionOrder(OrderModel order,BuildContext context);

  Future<List<PharmacyModel>> getAllPharmacy();

  Future<List<OrderModel>> getPrescriptionOrders();

  Future<dynamic> updateOrder(OrderModel order);

  Future<List<PastOrdersModel>> getPastOrders(BuildContext context);
}
