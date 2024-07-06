import 'package:bitirme_projesi/model/package_model.dart';
import 'package:bitirme_projesi/model/pharmacy_model.dart';
import 'package:bitirme_projesi/service/firebase/firebase_service.dart';
import 'package:bitirme_projesi/service/http/http_service.dart';
import 'package:bitirme_projesi/service/http/scrapper_service.dart';
import 'package:bitirme_projesi/tools/locator.dart';
import 'package:flutter/material.dart';
import 'dart:math' show cos, sqrt, asin;

class HomeViewModel with ChangeNotifier {
  // Firestore instance
  final FirebaseDatabaseService _firestore = locator<FirebaseDatabaseService>();
  final List<String> _list2 = List.generate(10, (index) => 'Item $index');
  get list2 => _list2;

  List<PharmacyModel> _pharmacyList = [];

  List<PharmacyModel> get pharmacyList => _pharmacyList;
  set pharmacyList(List<PharmacyModel> value) {
    _pharmacyList = value;
    notifyListeners();
  }

  Future<void> fetchAllPharmacies(double userLat, double userLon) async {
    if (_pharmacyList.isEmpty) {
      pharmacyList = await getNearbyPharmacies(userLat, userLon);
      notifyListeners();
    }
  }

  List<PackageModel> _list = [];
  List<PackageModel> get list {
    return _list;
  }

  set list(List<PackageModel> value) {
    _list = value;
  }

  Future<void> getPackages() async {
    list.clear();
    final html = await HttpService.get();
    if (html != null) {
      list = ScrapperService.run(html);
    }
    notifyListeners();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<List<PharmacyModel>> getNearbyPharmacies(
      double userLat, double userLon) async {
    List<PharmacyModel> allPharmacies = await _firestore.getAllPharmacy();
    List<PharmacyModel> nearbyPharmacies = [];

    for (var pharmacy in allPharmacies) {
      double distance = calculateDistance(
          userLat, userLon, pharmacy.latitude, pharmacy.longitude);
      if (distance <= 15) {
        nearbyPharmacies.add(pharmacy);
      }
    }

    return nearbyPharmacies;
  }
}
