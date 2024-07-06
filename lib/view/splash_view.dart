import 'package:bitirme_projesi/viewmodel/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  LoginViewModel loginViewModel = LoginViewModel();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      loginViewModel.autoLogin(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/splash_json.json',
        ),
      ),
    );
  }
}
