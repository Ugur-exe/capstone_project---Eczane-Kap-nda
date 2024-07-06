import 'package:bitirme_projesi/model/orders_model.dart';
import 'package:bitirme_projesi/viewmodel/cart_view_model.dart';
import 'package:bitirme_projesi/viewmodel/order_view_model.dart';
import 'package:bitirme_projesi/viewmodel/payment_view_model.dart';
import 'package:bitirme_projesi/viewmodel/pharmacy_details_view_model.dart';
import 'package:bitirme_projesi/widget_model/bottom_navigationvar_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<StatefulWidget> createState() => PaymentViewState();
}

class PaymentViewState extends State<PaymentView> {
  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Ödeme Sayfası',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _buildCardView(),
                _buildCardForm(),
                SizedBox(height: size.height * 0.1),
                const Divider(),
                _buildTotalPrice(),
                const Divider(),
                SizedBox(height: size.height * 0.01),
                _buildPayButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Widget _buildCardView() {
    return CreditCardWidget(
      enableFloatingCard: useFloatingAnimation,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvvCode: cvvCode,
      showBackView: isCvvFocused,
      obscureCardNumber: true,
      obscureCardCvv: true,
      isHolderNameVisible: true,
      onCreditCardWidgetChange: (p0) {},
    );
  }

  Widget _buildCardForm() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CreditCardForm(
            formKey: formKey,
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            onCreditCardModelChange: (CreditCardModel data) {
              onCreditCardModelChange(data);
            },
            obscureCvv: true,
            obscureNumber: false,
            isHolderNameVisible: true,
            isCardNumberVisible: true,
            isExpiryDateVisible: true,
            enableCvv: true,
            cvvValidationMessage: 'Please input a valid CVV',
            dateValidationMessage: 'Please input a valid date',
            numberValidationMessage: 'Please input a valid number',
            cardNumberValidator: (String? cardNumber) {
              return null;
            },
            expiryDateValidator: (String? expiryDate) {
              return null;
            },
            cvvValidator: (String? cvv) {
              return null;
            },
            cardHolderValidator: (String? cardHolderName) {
              return null;
            },
            onFormComplete: () {},
            autovalidateMode: AutovalidateMode.always,
            disableCardNumberAutoFillHints: false,
            inputConfiguration: const InputConfiguration(
              cardNumberDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: 'Kart Numarası',
                hintText: 'XXXX XXXX XXXX XXXX',
              ),
              expiryDateDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: ' (AA/YY)',
                hintText: 'XX/XX',
              ),
              cvvCodeDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: 'CVV',
                hintText: 'XXX',
              ),
              cardHolderDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: 'Kart Üzerindeki İsim',
              ),
              cardNumberTextStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              cardHolderTextStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              expiryDateTextStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              cvvCodeTextStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPrice() {
    return Consumer<PaymentViewModel>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Toplam Tutar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₺${value.totalPrice.toString()}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPayButton() {
    return Consumer<OrdersViewModel>(
      builder: (context, value, child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final paymentViewModel =
                      Provider.of<PaymentViewModel>(context, listen: false);
                  final pharmacyViewModel =
                      Provider.of<PharmacyViewDetailsViewModel>(context,
                          listen: false);
                  Provider.of<CartViewModel>(context, listen: false);

                  OrderModel order = OrderModel(
                    orderId: '5',
                    orderDate: DateTime.now().toString(),
                    orderStatus: 'true',
                    orderTotal: paymentViewModel.totalPrice,
                    orderPrescriptionNumber:
                        paymentViewModel.prescriptionsNumber,
                    orderPaymentMethod: 'Kredi Kartı',
                    orderPaymentStatus: 'true',
                    pharmacyName: pharmacyViewModel.selectedPharmacyName,
                    pharmacyAddress: pharmacyViewModel.selectedPharmacyAddress,
                    pharmacyId: pharmacyViewModel.selectedPharmacyId,
                  );
                  paymentViewModel.saveOrderToFirebase(order, context);
                  pharmacyViewModel.cartItems.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ödeme Başarılı'),
                    ),
                  );
                  Provider.of<BottomNavigationBarModel>(context, listen: false)
                      .setCurrentPageIndex(0);
                  Navigator.of(context).pushNamed('/base');
                }
              },
              child: const Text(
                'Ödeme Yap',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
