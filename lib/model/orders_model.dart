import 'package:bitirme_projesi/model/products_details_model.dart';

class OrderModel {
  String? orderId;
  String? orderDate;
  String? orderStatus;
  double? orderTotal;
  String? orderPrescriptionNumber;
  String? orderPaymentMethod;
  String? orderPaymentStatus = 'false';
  String pharmacyName;
  String pharmacyAddress;
  String pharmacyId;
  List<ProductsModelDetails>?
      orderItems=[]; // Changed from List<ProductsModelDetails>

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.orderStatus,
    required this.orderTotal,
    required this.orderPrescriptionNumber,
    required this.orderPaymentMethod,
    required this.orderPaymentStatus,
    required this.pharmacyName,
    required this.pharmacyAddress,
    required this.pharmacyId,
     this.orderItems, // Changed from List<ProductsModelDetails>
  });
}
