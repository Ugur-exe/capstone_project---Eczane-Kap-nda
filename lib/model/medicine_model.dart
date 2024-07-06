class MedicineModel {
  String medicineId;
  String medicineName;
  double medicinePrice;
  String medicineContent;

  MedicineModel(
      {required this.medicineContent,
      required this.medicineId,
      required this.medicineName,
      required this.medicinePrice});

  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      medicineContent: map['medicineContent'],
      medicineId: map['medicineId'],
      medicineName: map['medicineName'],
      medicinePrice: map['medicinePrice'],
    );
  }
}
