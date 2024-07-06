import 'package:bitirme_projesi/viewmodel/products_view_model.dart';
import 'package:bitirme_projesi/widget_model/bottom_navigationvar_model.dart';
import 'package:bitirme_projesi/viewmodel/pharmacy_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductsDetailsView extends StatefulWidget {
  const ProductsDetailsView({super.key});

  @override
  State<ProductsDetailsView> createState() => _ProductsDetailsViewState();
}

class _ProductsDetailsViewState extends State<ProductsDetailsView> {
  late Future<void> fetchProductDetails = _fetchProductDetails();

  Future<void> _fetchProductDetails() async {
    final productsViewModel =
        Provider.of<ProductsDetailsViewModel>(context, listen: false);
    final pharmacyModel =
        Provider.of<PharmacyViewDetailsViewModel>(context, listen: false);
    return productsViewModel.fetchProductDetails(
        pharmacyModel.selectedPharmacyId, productsViewModel.selectedProductId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchProductDetails = _fetchProductDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsViewModel =
        Provider.of<ProductsDetailsViewModel>(listen: false, context);
    final productsViewModel0 = Provider.of<ProductsDetailsViewModel>(context);
    final myString = productsViewModel.selectedProductName;
    final myPrescriptionNumber = productsViewModel.prescriptionsNumber;
    return Scaffold(
      appBar: _buildApppBar(myString),
      body: _buildBody(myString, myPrescriptionNumber, productsViewModel0),
    );
  }

  AppBar _buildApppBar(String args) {
    return AppBar(
      backgroundColor: Colors.greenAccent,
      title: Text(
        args,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        Consumer<PharmacyViewDetailsViewModel>(
          builder: (context, cart, child) {
            return Visibility(
              visible: cart.cartItemCount > 0,
              child: InkWell(
                onTap: () {
                  Provider.of<BottomNavigationBarModel>(context, listen: false)
                      .setCurrentPageIndex(1);
                  Navigator.pushNamed(context, '/base');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    label: Text(
                      'Total: ${cart.total.toString()}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(String agrs, String myPrescriptionNumber,
      ProductsDetailsViewModel productsViewModel) {
    return Column(
      children: [
        // _buildPharmacyName(),
        FutureBuilder(
            future: fetchProductDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Hata Oluştu'),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: productsViewModel.listProductsFace.length,
                  itemBuilder: (context, index) {
                    return _buildItemProducts(context, index,
                        myPrescriptionNumber, productsViewModel);
                  },
                ),
              );
            }),
      ],
    );
  }

  Widget _buildPharmacyName() {
    return Consumer<ProductsDetailsViewModel>(
      builder: (context, value, child) {
        // ignore: unnecessary_this
        final pharmacyViewModel =
            Provider.of<PharmacyViewDetailsViewModel>(listen: false, context);
        return Container(
          color: const Color.fromARGB(255, 149, 168, 159),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              pharmacyViewModel.selectedPharmacyName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemProducts(BuildContext context, int index,
      String myPrescriptionNumber, ProductsDetailsViewModel productsViewModel) {
    final pharmacyViewModel =
        Provider.of<PharmacyViewDetailsViewModel>(listen: false, context);
    return Card(
      child: ListTile(
        leading: Text(
          '₺ ${productsViewModel.listProductsFace[index].productPrice}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        title: Text(
          productsViewModel.listProductsFace[index].productName!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          productsViewModel.listProductsFace[index].productDescription!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFFABAFB3),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.greenAccent,
                    content: Text(
                      'Sepete ${productsViewModel.listProductsFace[index].productName!} eklendi.',
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    duration: const Duration(milliseconds: 500),
                  ),
                );
                pharmacyViewModel
                    .addToCart(productsViewModel.listProductsFace[index]);
              },
              icon: const Icon(
                Icons.add_shopping_cart_outlined,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.greenAccent,
                    content: Text(
                        'Sepetten ${productsViewModel.listProductsFace[index].productName!} çıkarıldı.'),
                    duration: const Duration(milliseconds: 500),
                  ),
                );

                pharmacyViewModel
                    .removeFromCart(productsViewModel.listProductsFace[index]);
              },
              icon: const Icon(
                Icons.remove_shopping_cart_outlined,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
