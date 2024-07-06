import 'package:bitirme_projesi/service/secure_storage/secure_storage.dart';
import 'package:bitirme_projesi/viewmodel/get_userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  LoginViewModel() {
    user = _auth.currentUser;
  }
  TextEditingController? _emailController = TextEditingController();
  TextEditingController get emailController => _emailController!;

  set emailController(TextEditingController emailController) {
    _emailController = emailController;
    notifyListeners();
  }

  TextEditingController? _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController!;

  set passwordController(TextEditingController passwordController) =>
      _passwordController = passwordController;

  Future<String?> signIn(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        print(e.code);
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print(e.code);
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  void autoLogin(BuildContext context) async {
    String? email =await  SecureStorage().readSecureStorage('email');
    String? password =await  SecureStorage().readSecureStorage('password');
    if (email != null && password != null) {
      // ignore: use_build_context_synchronously
      final login = await signIn(email, password, context);
      if (login.toString().contains('Success')) {
        final GetUserData getUserData = GetUserData();
        DocumentSnapshot userData = await getUserData.getUserData(email);
        Map<String, dynamic> userDataMap =
            userData.data() as Map<String, dynamic>;
        Provider.of<GetUserData>(context, listen: false).fromMap(userDataMap);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed('/base');
      } else {
        print(login);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(login.toString()),
          duration: const Duration(seconds: 2),
        ));
        Navigator.of(context).pushNamed('/login');
      }
    } else {
      Navigator.of(context).pushNamed('/login');
    }
  }
}
