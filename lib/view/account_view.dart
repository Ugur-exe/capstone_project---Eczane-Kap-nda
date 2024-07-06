import 'dart:io';

import 'package:bitirme_projesi/core/media_size.dart';
import 'package:bitirme_projesi/service/secure_storage/secure_storage.dart';
import 'package:bitirme_projesi/viewmodel/account_view_model.dart';
import 'package:bitirme_projesi/viewmodel/get_userData.dart';
import 'package:bitirme_projesi/widget_model/bottom_navigationvar_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final getUserData = Provider.of<GetUserData>(context, listen: false);
    ScreenSize size = ScreenSize(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF8F8FB),
      body: _buildBody(size, getUserData),
    );
  }

  Widget _buildBody(ScreenSize size, GetUserData getUserData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: size.screenHeight * 0.05),
        _buildAccountImage(getUserData),
        SizedBox(height: size.screenHeight * 0.02),
        _buildAccountInfo(getUserData.name ?? ''),
        SizedBox(height: size.screenHeight * 0.008),
        _buildPhoneNumber('0506 251 57 57'),
        SizedBox(height: size.screenHeight * 0.04),
        _buildCircleAvatarRow(size),
        SizedBox(height: size.screenHeight * 0.04),
        _buildGeneralInfo(size),
      ],
    );
  }

  Widget _buildCircleAvatarRow(ScreenSize size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCircleAvatar(
            Icons.personal_injury_outlined, 'Hastalıklarım', size),
        _buildCircleAvatar(Icons.receipt_long, 'Reçetelerim', size),
        _buildCircleAvatar(
            Icons.favorite_border_rounded, 'Sağlık Bilgilerim', size),
      ],
    );
  }

  Widget _buildCircleAvatar(
    IconData icon,
    String text,
    ScreenSize size,
  ) {
    return Consumer<AccountViewModel>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () {
            if (text == 'Hastalıklarım') {
              value.urlSetter = 'https://enabiz.gov.tr/';
            } else if (text == 'Reçetelerim') {
              value.urlSetter = 'https://enabiz.gov.tr/';
            } else if (text == 'Sağlık Bilgilerim') {
              value.urlSetter = 'https://enabiz.gov.tr/';
            }
            value.launchUrlAccount(value.urlSetter);
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                width: size.screenWidth * 0.18,
                height: size.screenHeight * 0.08,
                child: Icon(icon, size: size.screenWidth * 0.13),
              ),
              SizedBox(height: size.screenHeight * 0.005),
              Text(
                overflow: TextOverflow.clip,
                softWrap: true,
                text,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccountImage(GetUserData getUserData) {
    return Consumer<AccountViewModel>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () {
            value.getLostData(context, getUserData);
          },
          child: CircleAvatar(
            backgroundImage: value.image == null
                ? NetworkImage(getUserData.imageUrl!) as ImageProvider<Object>?
                : FileImage(File(value.image!.path)) as ImageProvider<Object>?,
            radius: 50,
          ),
        );
      },
    );
  }

  Widget _buildAccountInfo(String name) {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPhoneNumber(String phoneNumber) {
    return Text(phoneNumber);
  }

  Widget _buildGeneralInfo(ScreenSize size) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Consumer<AccountViewModel>(
          builder: (context, viewmodel, child) {
            return Column(
              children: [
                _buildGeneralInfoListTile('Adresi Ayarları', Icons.home_filled,
                    () {
                  Navigator.pushNamed(context, '/addressAddAndUpdate');
                }, size),
                const Divider(),
                _buildGeneralInfoListTile('Geçmiş Siparişler', Icons.history,
                    () {
                  Navigator.of(context).pushNamed('/pastOrders');
                }, size),
                const Divider(),
                _buildGeneralInfoListTile('Çıkış Yap', Icons.logout, () {
                  Provider.of<BottomNavigationBarModel>(context, listen: false)
                      .setCurrentPageIndex(0);
                  SecureStorage().deleteSecureStorage('email');
                  SecureStorage().deleteSecureStorage('password');
                  viewmodel.logout();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (route) => false);
                }, size),
              ],
            );
          },
        ));
  }

  Widget _buildGeneralInfoListTile(
      String text, IconData icon, VoidCallback onTap, ScreenSize size) {
    return Container(
      width: size.screenWidth * 0.9,
      height: size.screenHeight * 0.11,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.green,
          ),
          trailing: IconButton(
              onPressed: onTap, icon: const Icon(Icons.arrow_forward_ios)),
          title: Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
