import 'package:bitirme_projesi/viewmodel/home_view_model.dart';
import 'package:bitirme_projesi/widget/base_view_widget/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmacyOnDuty extends StatefulWidget {
  const PharmacyOnDuty({super.key});

  @override
  State<PharmacyOnDuty> createState() => _PharmacyOnDutyState();
}

class _PharmacyOnDutyState extends State<PharmacyOnDuty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Nöbetçi Eczaneler',
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return _buildListViewBuilder();
  }

  Widget _buildListViewBuilder() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          itemCount: viewModel.list.length,
          itemBuilder: (context, index) {
            return _buildListItems(index, viewModel);
          },
        );
      },
    );
  }

  Widget _buildListItems(int index, HomeViewModel viewModel) {
    var value = viewModel.list[index];
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              size: 32,
              Icons.location_on,
              color: Colors.blue,
            ),
            title: Text(
              value.isim,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    value.ilce,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              value.adres,
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ),
          _buildRowCallandMap(value),
        ],
      ),
    );
  }

  Widget _buildRowCallandMap(value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          child: GestureDetector(
            onTap: () async {
              String phone = value.telefon;
              final phoneCall = Uri.parse('tel:$phone');
              if (await canLaunchUrl(phoneCall)) {
                await launchUrl(phoneCall);
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone,
                  color: Colors.green,
                  size: 32,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Ara',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
          child: GestureDetector(
            onTap: () async {
              String address = value.adresTarifi;
              final mapsAddres = Uri.parse(
                  'https://www.google.com/maps/search/?api=1&query=$address');

              if (await canLaunchUrl(mapsAddres)) {
                await launchUrl(mapsAddres);
              }
            },
            child: const Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 32,
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  'Yol Tarifi Al',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
