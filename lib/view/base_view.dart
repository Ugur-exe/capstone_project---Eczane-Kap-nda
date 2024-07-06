
import 'package:bitirme_projesi/view/account_view.dart';
import 'package:bitirme_projesi/view/cart_view.dart';
import 'package:bitirme_projesi/view/home_view.dart';
import 'package:bitirme_projesi/view/orders_view.dart';
import 'package:bitirme_projesi/widget/base_view_widget/app_bar_widget.dart';
import 'package:bitirme_projesi/widget/base_view_widget/bottom_navigationbar_widget.dart';
import 'package:bitirme_projesi/widget/base_view_widget/draver_widget.dart';
import 'package:bitirme_projesi/widget_model/bottom_navigationvar_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseView extends StatefulWidget {
  const BaseView({super.key});

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  final _pages = [
    const HomeView(),
    const CartView(),
    const AccountView(),
    const OrdersView()
  ];
 
  @override
  Widget build(BuildContext context) {
    
    final viewModel = Provider.of<BottomNavigationBarModel>(context);
    return Scaffold(
      drawer:  const MyDraverWidget(),
      appBar: viewModel.getCurrentPageIndex == 1
          ? const MyAppBar(
              title: 'Sepetim',
            )
          : viewModel.getCurrentPageIndex == 3
              ? const MyAppBar(
                  title: 'Siparişlerim',
                )
              : const MyAppBar(),
      body: _pages[viewModel.getCurrentPageIndex],
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
