import 'package:bitirme_projesi/model/orders_model.dart';
import 'package:bitirme_projesi/model/past_order_model.dart';
import 'package:bitirme_projesi/model/pharmacy_model.dart';
import 'package:bitirme_projesi/model/products_details_model.dart';
import 'package:bitirme_projesi/service/base/database_service.dart';
import 'package:bitirme_projesi/viewmodel/cart_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FirebaseDatabaseService implements DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var uuid = const Uuid();
  @override
  Future createOrder(OrderModel order, context) {
    var cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    return _firestore.collection('orders').add({
      'orderId': order.orderId,
      'orderDate': order.orderDate,
      'orderStatus': order.orderStatus,
      'orderTotal': order.orderTotal,
      'orderPrescriptionNumber': order.orderPrescriptionNumber,
      'orderPaymentMethod': order.orderPaymentMethod,
      'orderPaymentStatus': order.orderPaymentStatus,
      'pharmacyName': order.pharmacyName,
      'pharmacyAddress': order.pharmacyAddress,
      'pharmacyId': order.pharmacyId,
      'orderItems': cartViewModel.cartListItems.map((product) {
        return {
          'id': product.id,
          'productName': product.productName,
          'productDescription': product.productDescription,
          'productPrice': product.productPrice,
          'productImage': product.productImage,
        };
      }).toList(),
    });
  }

  @override
  Future<OrderModel> createPrescriptionOrder(
      OrderModel order, BuildContext context) async {
    await _firestore.collection('order-by-prescription').add({
      'orderId': uuid.v1(),
      'orderDate': order.orderDate,
      'orderStatus': order.orderStatus,
      'orderPrescriptionNumber': order.orderPrescriptionNumber,
      'orderPaymentStatus': order.orderPaymentStatus,
      'pharmacyName': order.pharmacyName,
      'pharmacyAddress': order.pharmacyAddress,
      'pharmacyId': order.pharmacyId,
    });
    return order;
  }

  @override
  Future<List<PharmacyModel>> getAllPharmacy() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('pharmacy').get();
      List<PharmacyModel> pharmacies = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id;
        PharmacyModel pharmacy = PharmacyModel.fromMap(data);
        pharmacies.add(pharmacy);
      }
      return pharmacies;
    } catch (e) {
      print('Hata Çıktısı: $e');
      return []; // Hata durumunda boş bir liste döndür
    }
  }

  @override
  Future<List<OrderModel>> getPrescriptionOrders() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('order-by-prescription').get();
      List<OrderModel> orderPrescription = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        OrderModel order = OrderModel(
          orderId: data['orderId'] ?? '',
          orderDate: data['orderDate'] ?? '',
          orderStatus: data['orderStatus'] ?? '',
          orderTotal: 0,
          orderPrescriptionNumber: data['orderPrescriptionNumber'] ?? '',
          orderPaymentMethod: 'kredi',
          orderPaymentStatus: data['orderPaymentStatus'] ?? '',
          pharmacyName: data['pharmacyName'] ?? '',
          pharmacyAddress: data['pharmacyAddress'] ?? '',
          pharmacyId: data['pharmacyId'] ?? '',
        );
        orderPrescription.add(order);
      }
      return orderPrescription;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PastOrdersModel>> getPastOrders(context) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('orders').get();
      List<PastOrdersModel> pastOrders = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        PastOrdersModel pastOrder = PastOrdersModel(
          orderId: data['orderId'],
          orderDate: data['orderDate'],
          orderStatus: data['orderStatus'],
          orderTotal: (data['orderTotal'] as double).toDouble(),
          orderItems: (data['orderItems'] as List)
              .map((item) => ProductsModelDetails.fromMap(item))
              .toList(),
          orderAddress: data['orderAddress'],
          orderPaymentMethod: data['orderPaymentMethod'],
          orderPharmacyName: data['pharmacyName'],
        );
        pastOrders.add(pastOrder);
      }
      return pastOrders;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  @override
  Future updateOrder(OrderModel order) {
    // TODO: implement updateOrder
    throw UnimplementedError();
  }
}
