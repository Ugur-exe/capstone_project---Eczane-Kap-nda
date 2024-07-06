import 'package:bitirme_projesi/model/products_details_model.dart';

class PastOrdersModel {
  String? orderId;
  String? orderDate;
  String? orderStatus;
  double? orderTotal;
  List<ProductsModelDetails>? orderItems;
  String? orderAddress;
  String? orderPaymentMethod;
  String? orderPharmacyName;
  // List<ProductsModelDetails> products;

  PastOrdersModel({
    this.orderId,
    this.orderDate,
    this.orderStatus,
    this.orderTotal,
    this.orderItems,
    this.orderAddress,
    this.orderPaymentMethod,
    this.orderPharmacyName,
    // required this.products,
  });
}
