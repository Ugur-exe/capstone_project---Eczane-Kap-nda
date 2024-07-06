import 'package:bitirme_projesi/model/products_details_model.dart';
import 'package:bitirme_projesi/viewmodel/past_orders_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PastOrdersView extends StatefulWidget {
  const PastOrdersView({super.key});

  @override
  State<PastOrdersView> createState() => _PastOrdersViewState();
}

class _PastOrdersViewState extends State<PastOrdersView> {
  late Future<void> _fetchPastOrders;
  @override
  void initState() {
    super.initState();
    _fetchPastOrders = Provider.of<PastOrdersViewModel>(context, listen: false)
        .fetchPastOrders(context);
  }

  @override
  void deactivate() {
    super.deactivate();
    Provider.of<PastOrdersViewModel>(context, listen: false)
        .pastOrdersList
        .clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        shadowColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Geçmiş Siparişlerim',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Consumer<PastOrdersViewModel>(
      builder: (context, model, child) {
        return FutureBuilder(
          future: _fetchPastOrders,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: model.pastOrdersList.length,
                itemBuilder: (context, index) {
                  return _buildListItem(context, index, model);
                },
              );
            }
          },
        );
      },
    );
  }

  Widget _buildListItem(
      BuildContext context, int index, PastOrdersViewModel model) {
    List<ProductsModelDetails> items = model.pastOrdersList[index].orderItems!
        .map((element) => ProductsModelDetails(
              id: element.id,
              productDescription: element.productDescription,
              productImage: element.productImage,
              productName: element.productName,
              productPrice: element.productPrice,
            ))
        .toList();
    return Card(
      margin: const EdgeInsets.all(10),
      borderOnForeground: true,
      shadowColor: Colors.green,
      elevation: 4,
      shape: ShapeBorder.lerp(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        10,
      ),
      color: Colors.blueGrey[100],
      surfaceTintColor: Colors.red,
      child: ExpansionTile(
        initiallyExpanded: false,
        maintainState: false,
        title: Text(
          model.pastOrdersList[index].orderPharmacyName!,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sipariş Tarihi: ${model.pastOrdersList[index].orderDate!.substring(0, 16)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '₺ ${model.pastOrdersList[index].orderTotal}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.asset(
                  'assets/images/medical.png',
                  width: 100,
                  height: 100,
                ),
                title: Text(
                  items[index].productName!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${items[index].productPrice} ₺',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
