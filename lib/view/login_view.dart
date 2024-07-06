import 'package:bitirme_projesi/service/secure_storage/secure_storage.dart';
import 'package:bitirme_projesi/view/register_view.dart';
import 'package:bitirme_projesi/viewmodel/get_userData.dart';
import 'package:bitirme_projesi/viewmodel/login_view_model.dart';
import 'package:bitirme_projesi/widget/login_view_widget/textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
  }

  late Color myColor;
  late Size mediaSize;

  bool rememberUser = false;

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/medical.png"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: mediaSize.height * 0.1),
              _buildTop(),
              SizedBox(height: mediaSize.height * 0.1),
              _buildBottom(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_sharp,
            size: 100,
            color: Colors.white,
          ),
          Text(
            "ECZANE KAPINDA",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
                letterSpacing: 2),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Consumer<LoginViewModel>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hoş Geldiniz",
              style: TextStyle(
                  color: myColor, fontSize: 32, fontWeight: FontWeight.w500),
            ),
            _buildGreyText("Giriş Yapmak için bilgilerinizi giriniz."),
            const SizedBox(height: 50),
            InputField(
                keyboardType: TextInputType.emailAddress,
                controller: value.emailController,
                label: "E-Mail",
                hint: "E- Mail Adresiniz",
                isPassword: false),
            const SizedBox(height: 20),
            InputField(
                keyboardType: TextInputType.visiblePassword,
                controller: value.passwordController,
                label: "Şifre",
                hint: "Şifrenizi Giriniz",
                isPassword: true),
            const SizedBox(height: 20),
            _buildRememberForgot(),
            const SizedBox(height: 20),
            _buildLoginButton(),
            const SizedBox(height: 20),
            _buildBottomRegister(),
          ],
        );
      },
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, String label, String hint,
      {isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        hintText: hint,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gapPadding: BorderSide.strokeAlignOutside,
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isPassword = !isPassword;
                    print(isPassword);
                  });
                },
                icon: const Icon(Icons.remove_red_eye))
            : const Icon(Icons.done),
      ),
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Consumer<LoginViewModel>(
              builder: (context, model, child) {
                return Checkbox(
                  value: rememberUser,
                  onChanged: (value) async {
                    setState(() {
                      rememberUser = value!;
                      print(rememberUser);
                    });
                    if (rememberUser) {
                      SecureStorage().writeSecureStorage(
                          'email', model.emailController.text);
                      SecureStorage().writeSecureStorage(
                          'password', model.passwordController.text);
                    }
                  },
                );
              },
            ),
            _buildGreyText("Beni Hatırla"),
          ],
        ),
        TextButton(onPressed: () {}, child: _buildGreyText("Şifremi Unuttum"))
      ],
    );
  }

  Widget _buildLoginButton() {
    return Consumer<LoginViewModel>(
      builder: (context, value, child) {
        return ElevatedButton(
          onPressed: () async {
            if (value.emailController.text.isNotEmpty &&
                value.passwordController.text.isNotEmpty) {
              final message = await value.signIn(value.emailController.text,
                  value.passwordController.text, context);
              if (message!.contains('Success')) {
                final GetUserData getUserData = GetUserData();
                DocumentSnapshot userData =
                    await getUserData.getUserData(value.emailController.text);
                Map<String, dynamic> userDataMap =
                    userData.data() as Map<String, dynamic>;
                Provider.of<GetUserData>(context, listen: false)
                    .fromMap(userDataMap);
                Navigator.of(context).pushNamed('/base');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                  duration: const Duration(seconds: 2),
                ));
              }
              print(message);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Lütfen tüm alanları doldurunuz"),
                duration: Duration(seconds: 2),
              ));
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            elevation: 20,
            shadowColor: myColor,
            minimumSize: const Size.fromHeight(60),
          ),
          child: const Text("GİRİŞ YAP"),
        );
      },
    );
  }

  Widget _buildBottomRegister() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const RegisterView()));
        },
        child: const Text("Hesabınız yok mu? Kayıt Olun"));
  }
}
