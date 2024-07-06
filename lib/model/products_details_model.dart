class ProductsModelDetails {
  int? id;
  String? productName;
  String? productDescription;
  double? productPrice;
  String? productImage;
  String? prescriptionsNumber;

  ProductsModelDetails({
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productImage,
  });
  ProductsModelDetails.justprescriptionsNumber(this.prescriptionsNumber);

  ProductsModelDetails.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    productName = map['productName'];
    productDescription = map['productDescription'];
    productPrice = map['productPrice'];
    productImage = map['productImage'];
  }
}
