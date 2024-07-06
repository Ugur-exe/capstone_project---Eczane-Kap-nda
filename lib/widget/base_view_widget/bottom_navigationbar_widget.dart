import 'package:bitirme_projesi/widget_model/bottom_navigationvar_model.dart';
import 'package:bitirme_projesi/viewmodel/pharmacy_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BottomNavigationBarModel>(context);
    final viewModelCart = Provider.of<PharmacyViewDetailsViewModel>(context);
    return NavigationBar(
      selectedIndex: viewModel.currentPageIndex,
      onDestinationSelected: (int index) {
        viewModel.setCurrentPageIndex(index);
      },
      destinations: <Widget>[
        const NavigationDestination(
          selectedIcon: Icon(Icons.home, color: Colors.green),
          icon: Icon(Icons.home_outlined),
          label: 'Anasayfa',
        ),
        NavigationDestination(
          selectedIcon: const Badge(
            child: Icon(Icons.shopping_cart, color: Colors.green),
          ),
          icon: Badge(
            label: Text('${viewModelCart.cartItemCount}'),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          label: 'Sepet',
        ),
        const NavigationDestination(
          selectedIcon: Icon(Icons.manage_accounts, color: Colors.green),
          icon: Icon(Icons.manage_accounts_outlined),
          label: 'Hesap Ayarları',
        ),
        const NavigationDestination(
          selectedIcon:
              Icon(Icons.hourglass_empty_outlined, color: Colors.green),
          icon: Icon(Icons.hourglass_empty),
          label: 'Siparişlerim',
        ),
      ],
    );
  }
}
