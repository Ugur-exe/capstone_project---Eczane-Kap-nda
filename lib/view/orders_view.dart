import 'package:bitirme_projesi/viewmodel/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrdersViewModel>(context, listen: false).getOrders();
  }

  @override
  void deactivate() {
    super.deactivate();
    Provider.of<OrdersViewModel>(context, listen: false).orders.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildListOrder(),
      ],
    );
  }

  Widget _buildListOrder() {
    return Consumer<OrdersViewModel>(
      builder: (context, value, child) {
        return Expanded(
          child: value.orders.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: value.orders.length,
                  itemBuilder: (context, index) {
                    if (value.orders.isEmpty ||
                        value.orders[index].orderStatus == 'false') {
                      return const Center(
                          child: Text('Siparişiniz bulunmamaktadır.'));
                    } else {
                      return _buildListOrderItem(context, index, value);
                    }
                  },
                ),
        );
      },
    );
  }

  Widget? _buildListOrderItem(
      BuildContext context, int index, OrdersViewModel value) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 1),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Image.asset('assets/images/eczane.jpg'),
            title: Text(
              '${value.orders[index].pharmacyName} (${value.orders[index].pharmacyAddress})',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Tarih: ${value.orders[index].orderDate!.substring(0, 16)}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Reçete No: ${value.orders[index].orderPrescriptionNumber}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Flexible(
                fit: FlexFit.loose,
                child: Text(
                  'Sipariş Durumu: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: value.orders[index].orderPaymentStatus == 'false'
                    ? const Text(
                        'Eczaneden onay bekleniyor',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      )
                    : const Text(
                        textAlign: TextAlign.center,
                        'Siparişiniz hazır ',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            ],
          ),
          Visibility(
            visible: value.orders[index].orderPaymentStatus == 'false'
                ? false
                : true,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/orderDetails');
              },
              child: const Text(
                'Ödeme Yap',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
