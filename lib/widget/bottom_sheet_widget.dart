import 'package:bitirme_projesi/viewmodel/address_view_model.dart';
import 'package:bitirme_projesi/viewmodel/get_userData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BottomSheetCustom extends StatelessWidget {
  Function mergeAddress;
  BottomSheetCustom({required this.mergeAddress, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<AddressSettingModel>(
            builder: (context, value, child) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 30,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  value.bottomSheetTextAddress,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  value.isBottomSheetShown = false;
                                  Navigator.pop(context);
                                },
                                child: const Text('Konum Değiştir'),
                              ),
                            ],
                          ),
                          Text(
                            'Kurye siparişinizi seçili konuma getirecek.Adres detaylarını girerek daha da hızlı teslimat yapmamıza yardımcı olabilirsin.',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Adres Başlığı',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: value.addressController,
                      decoration: InputDecoration(
                        labelText: 'Mahalle / Cadde / Sokak',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: value.floor,
                            decoration: InputDecoration(
                              labelText: 'Bina No',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Kat',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Daire No',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Adres Tarifi(Örn: Taksi Durağı Karşısı)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          GetUserData userData =
                              Provider.of<GetUserData>(context, listen: false);
                          List list = [];
                          Map<String, dynamic> map = {
                            'address': value.selectedAddress,
                            'latitude': value.markerLocation.latitude,
                            'longitude': value.markerLocation.longitude,
                          };
                          list.add(map);
                          print(userData.email);
                          Navigator.pop(context);
                          Provider.of<AddressSettingModel>(context,
                                  listen: false)
                              .addAddressToFirebase(userData.email, list);

                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Kaydet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
