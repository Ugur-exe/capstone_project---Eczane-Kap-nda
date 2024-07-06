import 'dart:async';
import 'package:bitirme_projesi/firebase_options.dart';
import 'package:bitirme_projesi/notification/push_notifitacions.dart';
import 'package:bitirme_projesi/tools/locator.dart';
import 'package:bitirme_projesi/view/account_view.dart';
import 'package:bitirme_projesi/view/address_add_and_update.dart';
import 'package:bitirme_projesi/view/address_settings.dart';
import 'package:bitirme_projesi/view/base_view.dart';
import 'package:bitirme_projesi/view/cart_view.dart';
import 'package:bitirme_projesi/view/home_view.dart';
import 'package:bitirme_projesi/view/login_view.dart';
import 'package:bitirme_projesi/view/orders_view.dart';
import 'package:bitirme_projesi/view/orders_view_details.dart';
import 'package:bitirme_projesi/view/past_orders_view.dart';
import 'package:bitirme_projesi/view/payment_view.dart';
import 'package:bitirme_projesi/view/pharmacy_details_view.dart';
import 'package:bitirme_projesi/view/pharmacy_on_duty.dart';
import 'package:bitirme_projesi/view/products_details.dart';
import 'package:bitirme_projesi/view/splash_view.dart';
import 'package:bitirme_projesi/viewmodel/account_view_model.dart';
import 'package:bitirme_projesi/viewmodel/address_view_model.dart';
import 'package:bitirme_projesi/viewmodel/cart_view_model.dart';
import 'package:bitirme_projesi/viewmodel/get_userData.dart';
import 'package:bitirme_projesi/viewmodel/home_view_model.dart';
import 'package:bitirme_projesi/viewmodel/login_view_model.dart';
import 'package:bitirme_projesi/viewmodel/medicine_view_model.dart';
import 'package:bitirme_projesi/viewmodel/order_details_view_model.dart';
import 'package:bitirme_projesi/viewmodel/order_view_model.dart';
import 'package:bitirme_projesi/viewmodel/past_orders_view_model.dart';
import 'package:bitirme_projesi/viewmodel/payment_view_model.dart';
import 'package:bitirme_projesi/viewmodel/products_view_model.dart';
import 'package:bitirme_projesi/widget_model/bottom_navigationvar_model.dart';
import 'package:bitirme_projesi/viewmodel/pharmacy_details_view_model.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> setupNotificationListeners() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print(token);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (message.notification?.title != null &&
        message.notification?.body != null) {
      await notificationService.showNotification(
          id: 0,
          title: message.notification!.title,
          body: message.notification!.body,
          payLoad: 'payload');
    }
  });
}

Future<void> _onMessageOpenApp() async {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    navigatorKey.currentState!.push(MaterialPageRoute(
      builder: (context) => const BaseView(),
    ));
  });
}

final notificationService = NotificationService();
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Arka plan mesajı alındı: ${message.notification?.title}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.debug);

  // Firebase bildirim arka plan işleyiciyi tanımla
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupNotificationListeners();
  NotificationService().initNotification();
  _onMessageOpenApp();


  // İzinlerin kontrolü
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await Permission.location.isDenied.then((value) {
    if (value) {
      Permission.location.request();
    }
  });
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  setupLocator();
  runApp(const EczaneKapinda());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class EczaneKapinda extends StatefulWidget {
  const EczaneKapinda({super.key});

  @override
  State<EczaneKapinda> createState() => _EczaneKapindaState();
}

class _EczaneKapindaState extends State<EczaneKapinda> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BottomNavigationBarModel()),
        ChangeNotifierProvider(
            create: (context) => PharmacyViewDetailsViewModel()),
        ChangeNotifierProvider(create: (context) => PaymentViewModel()),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => OrdersViewModel()),
        ChangeNotifierProvider(create: (context) => ProductsDetailsViewModel()),
        ChangeNotifierProvider(create: (context) => OrdersViewDetailsModel()),
        ChangeNotifierProvider(create: (context) => MedicineViewModel()),
        ChangeNotifierProvider(create: (context) => PastOrdersViewModel()),
        ChangeNotifierProvider(create: (context) => CartViewModel()),
        ChangeNotifierProvider(create: (context) => AccountViewModel()),
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => AddressSettingModel()),
        ChangeNotifierProvider(
          create: (context) => GetUserData(),
        )
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.hasData) {
                      return const Splash(); // The user is signed in, show the home page
                    } else {
                      return const Splash(); // The user is not signed in, show the login page
                    }
                  }
                },
              ),
          '/login': (context) => const LoginView(),
          '/base': (context) => const BaseView(),
          '/home': (context) => const HomeView(),
          '/account': (context) => const AccountView(),
          '/cart': (context) => const CartView(),
          '/products': (context) => const ProductsDetailsView(),
          '/order': (context) => const OrdersView(),
          '/payment': (context) => const PaymentView(),
          '/pharmacyDetails': (context) => const PharmacyViewDetailsView(),
          '/orderDetails': (context) => const OrdersViewDetails(),
          '/pastOrders': (context) => const PastOrdersView(),
          '/pharmacyOnDuty': (context) => const PharmacyOnDuty(),
          '/addressAddAndUpdate': (context) => const AddressAddAndUpdate(),
          '/addressSetting': (context) => AddressSetting(),
        },
      ),
    );
  }
}
