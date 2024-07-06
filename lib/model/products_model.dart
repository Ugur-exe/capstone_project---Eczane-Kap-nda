class ProductsModel {
  final int id;
  final String productsGroupName;
  final String image;
  final String documentId;

  ProductsModel({
    required this.id,
    required this.productsGroupName,
    required this.image,
    required this.documentId,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id'],
      productsGroupName: json['productsGroupName'],
      image: json['image'],
      documentId: json['documentId'],
    );
  }
}
