import 'package:bitirme_projesi/core/media_size.dart';
import 'package:bitirme_projesi/viewmodel/medicine_view_model.dart';
import 'package:bitirme_projesi/viewmodel/order_details_view_model.dart';
import 'package:bitirme_projesi/viewmodel/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersViewDetails extends StatefulWidget {
  const OrdersViewDetails({super.key});

  @override
  State<OrdersViewDetails> createState() => _OrdersViewDetailsState();
}

class _OrdersViewDetailsState extends State<OrdersViewDetails> {
  // ignore: prefer_typing_uninitialized_variables
  late final viewModel;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = Provider.of<MedicineViewModel>(context, listen: false);
    viewModel.totalPrice();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          'Siparişi Tamamla',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: _buildBody(size),
      bottomSheet: _buildPayOrder(size, context, viewModel),
    );
  }

  Widget _buildPayOrder(
      ScreenSize size, BuildContext context, MedicineViewModel viewModel) {
    return SizedBox(
        width: double.infinity,
        child: Consumer<PaymentViewModel>(
          builder: (context, value, child) {
            return ElevatedButton(
              child: const Text('Ödemeyi Tamamla'),
              onPressed: () {
                value.totalPrice = viewModel.total;
                Navigator.of(context).pushNamed('/payment');
              },
            );
          },
        ));
  }

  Widget _buildBody(ScreenSize size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPharmacyGroup(size),
        _buildOrderDetails(size),
      ],
    );
  }

  Widget _buildPharmacyGroup(ScreenSize size) {
    return Padding(
      padding: EdgeInsets.only(
        top: size.screenHeight * 0.02,
        left: size.screenWidth / 20,
        right: size.screenWidth / 20,
        bottom: size.screenHeight / 50,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        width: size.screenWidth * 0.9,
        height: size.screenHeight * 0.2,
        child: _buildPharmacyGroupContent(),
      ),
    );
  }

  Widget _buildPharmacyGroupContent() {
    return Consumer<OrdersViewDetailsModel>(
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
                    value.ordersDetails[0].pharmacyName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    value.ordersDetails[0].pharmacyAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFABAFB3),
                    ),
                  ),
                  Text(
                    value.ordersDetails[0].pharmacyName,
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

  Widget _buildOrderDetails(ScreenSize size) {
    return Column(
      children: [
        _buildOrderDetailsTitle(size),
        const SizedBox(
          height: 25,
        ),
        _buildOrderDetailsContent(size),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Widget _buildOrderDetailsTitle(ScreenSize size) {
    return const Text(
      'Sipariş Detayları',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildOrderDetailsContent(ScreenSize size) {
    return Column(
      children: [
        _buildExpansionTile(),
        const SizedBox(
          height: 10,
        ),
        _buildOrderPrescriptionDetails(size),
        _buildTotalPrice(size),
      ],
    );
  }

  Widget _buildExpansionTile() {
    return ExpansionTile(
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.blue[100],
      childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      title: const Text(
        'İçerik',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        _buildExpansionTileContent(),
      ],
    );
  }

  Widget _buildExpansionTileContent() {
    return Consumer<OrdersViewDetailsModel>(
      builder: (context, value, child) {
        return Column(
          children: [
            Text(
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              'Sipariş Tarihi : ${value.ordersDetails[0].orderDate!.substring(0, 16)}',
            ),
            const SizedBox(height: 10),
            Text(
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                'Reçete Numarası ${value.ordersDetails[0].orderPrescriptionNumber}'),
          ],
        );
      },
    );
  }

  Widget _buildTotalPrice(ScreenSize size) {
    return Padding(
      padding: EdgeInsets.only(
        top: size.screenHeight / 50,
        left: size.screenWidth / 20,
        right: size.screenWidth / 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Toplam Tutar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Consumer<MedicineViewModel>(
            builder: (context, value, child) {
              return Text(
                '${value.total} TL',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderPrescriptionDetails(ScreenSize size) {
    return Consumer<MedicineViewModel>(
      builder: (context, value, child) {
        return ExpansionTile(
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.blue[100],
          childrenPadding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          title: const Text(
            'İlaçlarım',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: value.medicines.length,
                itemBuilder: (context, index) {
                  return _buildOrderPrescriptionDetailsItem(index, value);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderPrescriptionDetailsItem(
      int index, MedicineViewModel value) {
    return Card(
      child: ListTile(
        title: Text(
          value.medicines[index].medicineName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(value.medicines[index].medicineContent),
        trailing: Text(
          '${value.medicines[index].medicinePrice} TL',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
