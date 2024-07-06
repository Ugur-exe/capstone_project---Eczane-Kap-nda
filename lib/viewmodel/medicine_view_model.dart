import 'package:bitirme_projesi/model/medicine_model.dart';
import 'package:flutter/material.dart';

class MedicineViewModel with ChangeNotifier {
  final List<MedicineModel> _medicines = [
    MedicineModel(
        medicineContent: 'Uçuklara,yaralara izlere iyi gelir.',
        medicineId: '1',
        medicineName: 'Merhem',
        medicinePrice: 150),
    MedicineModel(
        medicineContent:
            'Enfesiyonlu hastalıklarda belli aralıklarla kullanılır',
        medicineId: '2',
        medicineName: 'AntiBiyotik',
        medicinePrice: 72),
    MedicineModel(
        medicineContent: 'Göz kuruluğunda gece ve gündüz 1 damla kullanılır.',
        medicineId: '3',
        medicineName: 'Göz Damlası',
        medicinePrice: 150),
    MedicineModel(
        medicineContent: 'Göz kuruluğunda gece ve gündüz 1 damla kullanılır.',
        medicineId: '4',
        medicineName: 'Göz Damlası',
        medicinePrice: 150),
    MedicineModel(
        medicineContent: 'Göz kuruluğunda gece ve gündüz 1 damla kullanılır.',
        medicineId: '5',
        medicineName: 'Göz Damlası',
        medicinePrice: 150),
    MedicineModel(
        medicineContent: 'Göz kuruluğunda gece ve gündüz 1 damla kullanılır.',
        medicineId: '6',
        medicineName: 'Göz Damlası',
        medicinePrice: 150),
  ];
  List<MedicineModel> get medicines => _medicines;
  double _total = 0;
  double get total => _total;

  void totalPriceDelete() {
    _total = 0;
  }

  void totalPrice() {
    totalPriceDelete();
    for (var i = 0; i < _medicines.length; i++) {
      _total += _medicines[i].medicinePrice;
    }
  }
}
