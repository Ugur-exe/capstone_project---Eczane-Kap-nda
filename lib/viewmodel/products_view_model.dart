import 'package:bitirme_projesi/model/products_details_model.dart';
import 'package:bitirme_projesi/model/products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsDetailsViewModel with ChangeNotifier {
  List<ProductsModel> _listProducts = [];
  List<ProductsModel> get listProducts => _listProducts;
  String _prescriptionsNumber = '';
  get prescriptionsNumber => _prescriptionsNumber;

  set prescriptionsNumber(value) => _prescriptionsNumber = value;
  String selectedProductName = '';
  String selectedProductId = '';

  List<ProductsModelDetails> _listProductsFace = [];
  List<ProductsModelDetails> get listProductsFace => _listProductsFace;

  ///pharmacy/wVc2dJWjxGwTlswaHbrX/products/MUxiLzmtuTdyWltR7463/productsDetails
  Future<void> fetchProductDetails(String pharmacyId, String productsID) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection(
              'pharmacy/$pharmacyId/products/$productsID/productsDetails')
          .get();

      _listProductsFace = result.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ProductsModelDetails(
          id: data['id'],
          productName: data['productName'],
          productDescription: data['productDescription'],
          productPrice: double.parse(data['productPrice'].toString()),
          productImage: data['productImage'],
        );
      }).toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchProducts(String s) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('pharmacy')
          .doc(s)
          .collection('products')
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      _listProducts = documents.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id;
        return ProductsModel.fromJson(data);
      }).toList();
    } catch (error) {
      rethrow;
    }
  }
}
