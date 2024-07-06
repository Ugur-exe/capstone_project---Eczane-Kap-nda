import 'package:bitirme_projesi/core/media_size.dart';
import 'package:bitirme_projesi/viewmodel/get_userData.dart';
import 'package:bitirme_projesi/widget/home_view_widget/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDraverWidget extends StatelessWidget {
  const MyDraverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize(context);
    return Consumer<GetUserData>(
      builder: (context, value, child) {
        return Drawer(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: size.screenHeight * 0.047,
                      backgroundImage: NetworkImage(
                          value.imageUrl ?? 'https://via.placeholder.com/150'),
                    ),
                    Text(
                      value.name ?? '',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins'),
                    ),
                    Text(value.telNum ?? '')
                  ],
                ),
              ),
              MyListTileWidget(
                icon: const Icon(Icons.info_outline, color: Colors.green),
                type: 'Profil',
                function: () {},
              ),
              MyListTileWidget(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.green,
                ),
                type: 'Geçmiş Siparişlerim',
                function: () {
                  Navigator.pushNamed(context, '/pastOrders');
                },
              ),
              Column(
                children: [
                  SizedBox(height: size.screenHeight * 0.48),
                  const Divider(),
                  MyListTileWidget(
                    icon: const Icon(
                      Icons.share_outlined,
                      color: Colors.green,
                    ),
                    type: 'Arkadaşlarınla Paylaş',
                    function: () {},
                  ),
                  MyListTileWidget(
                    icon: const Icon(
                      Icons.medication,
                      color: Colors.green,
                    ),
                    type: 'Geri Bildirim & İletişim',
                    function: () {},
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
