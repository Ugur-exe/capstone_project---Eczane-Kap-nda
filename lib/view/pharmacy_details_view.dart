import 'package:bitirme_projesi/model/orders_model.dart';
import 'package:bitirme_projesi/viewmodel/order_details_view_model.dart';
import 'package:bitirme_projesi/viewmodel/payment_view_model.dart';
import 'package:bitirme_projesi/viewmodel/products_view_model.dart';
import 'package:bitirme_projesi/widget/base_view_widget/app_bar_widget.dart';
import 'package:bitirme_projesi/viewmodel/pharmacy_details_view_model.dart';
import 'package:bitirme_projesi/widget_model/bottom_navigationvar_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PharmacyViewDetailsView extends StatefulWidget {
  const PharmacyViewDetailsView({super.key});

  @override
  State<PharmacyViewDetailsView> createState() =>
      _PharmacyViewDetailsViewState();
}

class _PharmacyViewDetailsViewState extends State<PharmacyViewDetailsView> {
  late Future<void> fetchProductDetails;
  @override
  void initState() {
    super.initState();
    final productsModel =
        Provider.of<ProductsDetailsViewModel>(context, listen: false);
    final pharmacyModel =
        Provider.of<PharmacyViewDetailsViewModel>(context, listen: false);
    fetchProductDetails =
        productsModel.fetchProducts(pharmacyModel.selectedPharmacyId);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final listProducts = Provider.of<ProductsDetailsViewModel>(context);
    final listPharmacyID =
        Provider.of<PharmacyViewDetailsViewModel>(context).selectedPharmacyId;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF8F8FB),
      appBar: const MyAppBar(),
      body: _buildBody(screenWidth, screenHeight, listProducts, listPharmacyID),
    );
  }

  Widget _buildBody(double screenWidth, double screenHeight,
      ProductsDetailsViewModel listProducts, String listPharmacyID) {
    listProducts.fetchProducts(listPharmacyID);
    return Column(
      children: [
        _buildPharmacyGroup(screenWidth, screenHeight),
        SizedBox(height: screenHeight * 0.01),
        _buildDirectionAndCall(screenWidth),
        const Divider(),
        SizedBox(height: screenHeight * 0.015),
        _buildPrescriptionsButton(screenWidth, screenHeight),
        SizedBox(height: screenHeight * 0.015),
        const Divider(),
        SizedBox(height: screenHeight * 0.025),
        _buildBodyProductstitle(screenWidth),
        const Divider(),
        SizedBox(height: screenHeight * 0.025),
        Expanded(
          child:
              _buildGridViewProducts(screenWidth, screenHeight, listProducts),
        ),
      ],
    );
  }

  Widget _buildPharmacyGroup(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenHeight * 0.02,
        left: screenWidth / 20,
        right: screenWidth / 20,
        bottom: screenHeight / 50,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        width: screenWidth * 0.9,
        height: screenHeight * 0.2,
        child: _buildPharmacyGroupContent(),
      ),
    );
  }

  Widget _buildDirectionAndCall(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDirectionButton(screenWidth),
        _buildCallButton(screenWidth),
      ],
    );
  }

  Widget _buildDirectionButton(double screenWidth) {
    return Container(
      width: screenWidth * 0.3, // Ekran genişliğinin %30'u
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.green),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.directions,
          ),
          Text(
            'Directions',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton(double screenWidth) {
    return Container(
      width: screenWidth * 0.2, // Ekran genişliğinin %20'si
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.green),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.call,
          ),
          Text(
            'Call',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsButton(screenWidth, screenHeight) {
    return Consumer<PharmacyViewDetailsViewModel>(
      builder: (context, value, child) {
        final paymentViewModel = Provider.of<PaymentViewModel>(context);
        final ordersDetailsViewModel =
            Provider.of<OrdersViewDetailsModel>(context, listen: false);
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Reçete Numarasını Girin'),
                  content: TextField(
                    controller: value.controller,
                    decoration: const InputDecoration(
                      hintText: 'Reçete Numarası',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Vazgeç'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        paymentViewModel.prescriptionsNumber =
                            value.controller.text;
                        paymentViewModel.totalPrice = value.total;
                        ordersDetailsViewModel.saveOrderToFirebase(
                          OrderModel(
                            orderId: '',
                            orderDate: DateTime.now().toString(),
                            orderStatus: 'true',
                            orderTotal: value.total,
                            orderPrescriptionNumber: value.controller.text,
                            orderPaymentMethod: 'Kredi Kartı',
                            orderPaymentStatus: 'false',
                            pharmacyName: value.selectedPharmacyName,
                            pharmacyAddress: value.selectedPharmacyAddress,
                            pharmacyId: value.selectedPharmacyId,
                          ),
                          context,
                        );
                        Navigator.pop(context);
                        Provider.of<BottomNavigationBarModel>(context,
                                listen: false)
                            .setCurrentPageIndex(3);
                      },
                      child: const Text('Tamam'),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            width: screenWidth * 0.6,
            height: screenHeight * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.green,
            ),
            child: const Center(
              child: Text(
                'Reçete Numarasını Girin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodyProductstitle(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: screenWidth * 0.05),
        const Text(
          'Products ',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPharmacyGroupContent() {
    return Consumer<PharmacyViewDetailsViewModel>(
      builder: (context, value, child) {
        return Row(
          children: [
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/eczane.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.selectedPharmacyName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    value.selectedPharmacyAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFABAFB3),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFFABAFB3),
                      ),
                      Text(
                        '45 Km Away',
                        style: TextStyle(
                          color: Color(0xFFABAFB3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridViewProducts(double screenWidth, double screenHeight,
      ProductsDetailsViewModel listProducts) {
    return FutureBuilder(
      future: fetchProductDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
            ),
            itemCount: listProducts.listProducts.length,
            itemBuilder: (context, index) {
              return _buildItemProducts(
                  context, index, screenWidth, screenHeight, listProducts);
            },
          );
        }
      },
    );
  }

  Widget _buildItemProducts(BuildContext context, int index, double screenWidth,
      double screenHeight, ProductsDetailsViewModel listProducts) {
    return Consumer<ProductsDetailsViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: () {
            viewModel.selectedProductName =
                listProducts.listProducts[index].productsGroupName;
            viewModel.selectedProductId =
                listProducts.listProducts[index].documentId;

            Navigator.of(context).pushNamed('/products');
          },
          child: SizedBox(
            width: screenWidth * 0.25,
            height: screenHeight * 0.2,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey,
                    ),
                    width: screenWidth * 0.25,
                    height: screenHeight * 0.09,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/ilac.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    listProducts.listProducts[index].productsGroupName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
