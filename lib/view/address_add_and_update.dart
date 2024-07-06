import 'package:bitirme_projesi/view/address_settings.dart';
import 'package:bitirme_projesi/viewmodel/address_view_model.dart';
import 'package:bitirme_projesi/viewmodel/get_userData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressAddAndUpdate extends StatelessWidget {
  const AddressAddAndUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green[200],
        title: const Text('Adreslerim'),
      ),
      body: _buildBody(),
      bottomNavigationBar: bottomNavigationBarModel(context),
    );
  }

  Widget _buildBody() {
    return Consumer<GetUserData>(
      builder: (context, value, child) {
        print(value.address[0]['address'] ?? '');
        return ListView.builder(
          itemCount: value.address.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    shadowColor: Colors.red,
                    child: ListTile(
                      leading: const Icon(Icons.home, color: Colors.green),
                      title: const Text('Ev'),
                      subtitle: Text(value.address[index]['address'] ?? ''),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget bottomNavigationBarModel(BuildContext context) {
    return Consumer<AddressSettingModel>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.grey[200]),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressSetting(),
                ),
              );
            },
            child: const Text(
              'Adres Ekle',
              style: TextStyle(color: Colors.purple, fontSize: 20),
            ),
          ),
        );
      },
    );
  }
}
