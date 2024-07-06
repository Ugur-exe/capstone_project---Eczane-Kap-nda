import 'package:bitirme_projesi/service/auth.dart';
import 'package:bitirme_projesi/view/base_view.dart';
import 'package:bitirme_projesi/view/login_view.dart';
import 'package:bitirme_projesi/viewmodel/address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:bitirme_projesi/view/address_settings.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController tcController = TextEditingController();
  bool rememberUser = false;
  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    surnameController.dispose();
  }

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
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTop(),
              const SizedBox(height: 50),
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
      child: const SingleChildScrollView(
        child: Column(
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kayıt Ol",
            style: TextStyle(
                color: myColor, fontSize: 32, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          _buildFormValidate(),
          const SizedBox(height: 20),
          _buildLoginButton(),
          const SizedBox(height: 20),
          _buildBottomRegister(),
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      String hint, TextInputType type,
      {isPassword = false}) {
    return TextFormField(
      keyboardType: type,
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
            ? const Icon(Icons.remove_red_eye)
            : const Icon(Icons.done),
      ),
      obscureText: isPassword,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            _formKey.currentState!.validate();
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bu alan boş bırakılamaz';
        }
        return null;
      },
    );
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kullanıcı adı boş olamaz.';
    }
    final regex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!regex.hasMatch(value)) {
      return 'Kullanıcı adı sadece alfanümerik karakterler içerebilir.';
    }
    if (value.isNotEmpty) {
      return null;
    }
    return null;
  }

  Widget _buildLoginButton() {
    Map<String, dynamic> map = {};
    List address = [];
    return Consumer<AddressSettingModel>(
      builder: (context, value, child) {
        return ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              map = {
                'address': value.selectedAddress,
                'latitude': value.markerLocation.latitude,
                'longitude': value.markerLocation.longitude,
              };
              address.add(map);
              _authService
                  .createPerson(
                nameController.text,
                surnameController.text,
                int.parse(tcController.text),
                emailController.text,
                passwordController.text,
                address,
                value.markerLocation.latitude,
                value.markerLocation.longitude,
              )
                  .then((value) {
                return Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const BaseView()));
              });
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            elevation: 20,
            shadowColor: myColor,
            minimumSize: const Size.fromHeight(60),
          ),
          child: const Text("Kayıt Ol"),
        );
      },
    );
  }

  Widget _buildBottomRegister() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginView(),
          ));
        },
        child: const Text("Hesabım var mı? Giriş Yapın"));
  }

  Widget _buildFormValidate() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            _buildInputField(
                nameController, 'Ad', 'Adınızı Giriniz', TextInputType.name),
            const SizedBox(height: 10),
            _buildInputField(surnameController, 'Soyad', 'Soyadınızı Giriniz',
                TextInputType.name),
            const SizedBox(height: 10),
            _buildInputField(tcController, 'Tc Kimlik',
                'Tc Kimlik Numaranızı Giriniz', TextInputType.number),
            const SizedBox(height: 10),
            _buildInputField(emailController, "E-Posta", "E-Posta Adresiniz",
                TextInputType.emailAddress),
            const SizedBox(height: 10),
            _buildInputField(passwordController, "Şifre", "Şifrenizi Giriniz",
                TextInputType.multiline,
                isPassword: true),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  AddressSetting(mergeAddress: (){},),
                ));
              },
              child: const Text(
                "Adresi Giriniz",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ));
  }
}
