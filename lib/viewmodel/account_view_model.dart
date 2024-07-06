import 'dart:io';

import 'package:bitirme_projesi/viewmodel/get_userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountViewModel with ChangeNotifier {
  File? _image;
  File? get image => _image;
  set image(File? value) {
    _image = value;
    notifyListeners();
  }

  final ImagePicker picker = ImagePicker();
  late String _urlSetter;

  String get urlSetter => _urlSetter;

  set urlSetter(String value) {
    _urlSetter = value;
    notifyListeners();
  }

  Future<void> launchUrlAccount(String url) async {
    final Uri url0 = Uri.parse(url);
    if (!await launchUrl(url0)) {
      throw Exception('Could not launch $url0');
    }
  }

  String _url = '';
  String get url => _url;

  set url(String value) {
    _url = value;
    notifyListeners();
  }

  

  UploadTask? uploadTask;
  Future<void> getLostData(
      BuildContext context, GetUserData getUserData) async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
      final path = 'files/${pickedImage.name}';
      final file = File(pickedImage.path);

      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      url = await ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection('users')
          .doc(getUserData.email)
          .set({
        'image': url,
      }, SetOptions(merge: true));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Uyarı'),
            content: const Text('Resim seçilmedi'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
