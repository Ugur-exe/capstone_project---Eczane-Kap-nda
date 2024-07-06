import 'package:bitirme_projesi/core/media_size.dart';
import 'package:bitirme_projesi/model/products_details_model.dart';
import 'package:bitirme_projesi/viewmodel/cart_view_model.dart';
import 'package:bitirme_projesi/viewmodel/payment_view_model.dart';
import 'package:bitirme_projesi/viewmodel/pharmacy_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize reSize = ScreenSize(context);
    return Scaffold(
      body: _buildBody(reSize),
    );
  }

  Widget _buildBody(ScreenSize reSize) {
    return Consumer<PharmacyViewDetailsViewModel>(
      builder: (context, value, child) {
        return value.cartItemCount > 0
            ? Column(
                children: [
                  _buildHeader(reSize),
                  _buildCartList(),
                  _buildPayContiuneButton(context)
                ],
              )
            : Center(
                child: Text(
                  'Sepetiniz Boş ',
                  style: TextStyle(
                    fontSize: reSize.screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
      },
    );
  }

  Widget _buildPayContiuneButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Consumer<PharmacyViewDetailsViewModel>(
        builder: (context, value, child) {
          return ElevatedButton(
            child: const Text('Ödemeye Devam Et',style: TextStyle(fontSize: 20),),
            onPressed: () {
              Provider.of<PaymentViewModel>(context, listen: false).totalPrice =
                  value.total;
              var cartViewModel =
                  Provider.of<CartViewModel>(context, listen: false);

              for (var item in value.cartItems) {
                cartViewModel.addToCart(item);
              }

              Navigator.of(context).pushNamed('/payment');
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(ScreenSize reSize) {
    return Consumer<PharmacyViewDetailsViewModel>(
      builder: (context, value, child) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: reSize.screenWidth * 0.09),
              Text(
                'Toplam: ₺ ${value.total.toString()}',
                style: TextStyle(
                  fontSize: reSize.screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Visibility(
                visible: value.cartItemCount > 0 ? true : false,
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                              'Sepeti Temizlemek İstediğinize Emin Misiniz?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                value.clearCart();

                                Navigator.pop(context);
                              },
                              child: const Text('Evet'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Hayır'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ]);
      },
    );
  }

  Widget _buildCartList() {
    return Consumer<PharmacyViewDetailsViewModel>(
      builder: (context, value, child) {
        final uniqueCartItems = value.cartItems.toSet().toList();
        return Expanded(
          child: ListView.builder(
            itemCount: uniqueCartItems.length,
            itemBuilder: (context, index) {
              return _buildCartItem(context, uniqueCartItems[index], value);
            },
          ),
        );
      },
    );
  }

  Widget _buildCartItem(BuildContext context, ProductsModelDetails cartItem,
      PharmacyViewDetailsViewModel value) {
    return Card(
      child: ListTile(
        leading: Text(
          '₺ ${cartItem.productPrice != null ? cartItem.productPrice.toString() : '0'}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        title: Text(
          cartItem.productName != null ? cartItem.productName! : '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          cartItem.productDescription != null
              ? cartItem.productDescription!
              : '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFFABAFB3),
          ),
        ),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Provider.of<PharmacyViewDetailsViewModel>(context,
                        listen: false)
                    .removeFromCart(cartItem);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
            Text(
              'Adet: ${value.cartItems.where((element) => element.productName == cartItem.productName).length.toString()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                Provider.of<PharmacyViewDetailsViewModel>(context,
                        listen: false)
                    .addToCart(cartItem);
              },
              icon: const Icon(
                Icons.add_shopping_cart,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
